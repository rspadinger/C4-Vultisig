// SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.7.6;
pragma abicoder v2;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/libraries/FixedPoint128.sol";
import "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import "@uniswap/v3-core/contracts/libraries/Tick.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./interfaces/IILOPool.sol";
import "./interfaces/IILOManager.sol";
import "./libraries/PositionKey.sol";
import "./libraries/SqrtPriceMathPartial.sol";
import "./base/ILOVest.sol";
import "./base/LiquidityManagement.sol";
import "./base/ILOPoolImmutableState.sol";
import "./base/Initializable.sol";
import "./base/Multicall.sol";
import "./base/ILOWhitelist.sol";

import "forge-std/console.sol";

/// @title NFT positions
/// @notice Wraps Uniswap V3 positions in the ERC721 non-fungible token interface
contract ILOPool is ERC721, IILOPool, ILOWhitelist, ILOVest, Initializable, Multicall, ILOPoolImmutableState, LiquidityManagement {
    SaleInfo saleInfo;

    /// @dev when lauch successfully we can not refund anymore
    bool private _launchSucceeded;

    /// @dev when refund triggered, we can not launch anymore
    bool private _refundTriggered;

    /// @dev The token ID position data
    mapping(uint256 => Position) private _positions;
    VestingConfig[] private _vestingConfigs;

    /// @dev The ID of the next token that will be minted. Skips 0
    uint256 private _nextId;
    uint256 totalRaised;

    constructor() ERC721("", "") {
        //console.log("******** CONSTR **********");
        //@audit-ok whats the point
        _disableInitialize(); // => _initialized = true
    }

    function name() public pure override(ERC721, IERC721Metadata) returns (string memory) {
        return "KRYSTAL ILOPool V1";
    }

    function symbol() public pure override(ERC721, IERC721Metadata) returns (string memory) {
        return "KRYSTAL-ILO-V1";
    }

    //@audit-ok how can this be called, when we set _disableInitialize in the constr => called by: ILOManager.initILOPool
    function initialize(InitPoolParams calldata params) external override whenNotInitialized {
        //console.log("******** initialize **********");
        _nextId = 1;
        // initialize imutable state
        MANAGER = msg.sender; //ILOManager
        IILOManager.Project memory _project = IILOManager(MANAGER).project(params.uniV3Pool);

        WETH9 = IILOManager(MANAGER).WETH9();
        RAISE_TOKEN = _project.raiseToken;
        SALE_TOKEN = _project.saleToken;
        _cachedUniV3PoolAddress = params.uniV3Pool; //defined in ILOPoolImmutableState
        _cachedPoolKey = _project._cachedPoolKey;
        TICK_LOWER = params.tickLower;
        TICK_UPPER = params.tickUpper;
        SQRT_RATIO_LOWER_X96 = params.sqrtRatioLowerX96;
        SQRT_RATIO_UPPER_X96 = params.sqrtRatioUpperX96;
        SQRT_RATIO_X96 = _project.initialPoolPriceX96;

        // console.logInt(TICK_LOWER); //-887270
        // console.logInt(TICK_UPPER); //887270

        // rounding up to make sure that the number of sale token is enough for sale
        (uint256 maxSaleAmount, ) = _saleAmountNeeded(params.hardCap);
        // initialize sale
        saleInfo = SaleInfo({
            hardCap: params.hardCap,
            softCap: params.softCap,
            maxCapPerUser: params.maxCapPerUser,
            start: params.start,
            end: params.end,
            maxSaleAmount: maxSaleAmount
        });

        _validateSharesAndVests(_project.launchTime, params.vestingConfigs);
        // initialize vesting
        for (uint256 index = 0; index < params.vestingConfigs.length; index++) {
            _vestingConfigs.push(params.vestingConfigs[index]);
        }

        emit ILOPoolInitialized(params.uniV3Pool, TICK_LOWER, TICK_UPPER, saleInfo, params.vestingConfigs);
    }

    /// @inheritdoc IILOPool
    function positions(
        uint256 tokenId
    )
        external
        view
        override
        returns (uint128 liquidity, uint256 raiseAmount, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128)
    {
        return (
            _positions[tokenId].liquidity,
            _positions[tokenId].raiseAmount,
            _positions[tokenId].feeGrowthInside0LastX128,
            _positions[tokenId].feeGrowthInside1LastX128
        );
    }

    // @inheritdoc IILOSale : investor buying ILO
    function buy(uint256 raiseAmount, address recipient) external override returns (uint256 tokenId, uint128 liquidityDelta) {
        require(_isWhitelisted(recipient), "UA");
        require(block.timestamp > saleInfo.start && block.timestamp < saleInfo.end, "ST");
        // check if raise amount over capacity
        require(saleInfo.hardCap - totalRaised >= raiseAmount, "HC");
        totalRaised += raiseAmount;

        require(totalSold() <= saleInfo.maxSaleAmount, "SA");

        // if investor already have a position, just increase raise amount and liquidity
        // otherwise, mint new nft for investor and assign vesting schedules
        if (balanceOf(recipient) == 0) {
            _mint(recipient, (tokenId = _nextId++));
            //@audit-ok => add the schedule for the first vestingConfig
            _positionVests[tokenId].schedule = _vestingConfigs[0].schedule;
        } else {
            tokenId = tokenOfOwnerByIndex(recipient, 0);
        }

        Position storage _position = _positions[tokenId];
        require(raiseAmount <= saleInfo.maxCapPerUser - _position.raiseAmount, "UC");
        _position.raiseAmount += raiseAmount;

        // get amount of liquidity associated with raise amount
        if (RAISE_TOKEN == _cachedPoolKey.token0) {
            liquidityDelta = LiquidityAmounts.getLiquidityForAmount0(SQRT_RATIO_X96, SQRT_RATIO_UPPER_X96, raiseAmount);
        } else {
            liquidityDelta = LiquidityAmounts.getLiquidityForAmount1(SQRT_RATIO_LOWER_X96, SQRT_RATIO_X96, raiseAmount);
        }

        require(liquidityDelta > 0, "ZA");

        // calculate amount of share liquidity investor recieve by INVESTOR_SHARES config
        //@audit-ok
        liquidityDelta = uint128(FullMath.mulDiv(liquidityDelta, _vestingConfigs[0].shares, BPS));

        // increase investor's liquidity
        _position.liquidity += liquidityDelta;

        // update total liquidity locked for vest and assiging vesing schedules
        _positionVests[tokenId].totalLiquidity = _position.liquidity;

        // transfer fund into contract
        TransferHelper.safeTransferFrom(RAISE_TOKEN, msg.sender, address(this), raiseAmount);

        emit Buy(recipient, tokenId, raiseAmount, liquidityDelta);
    }

    modifier isAuthorizedForToken(uint256 tokenId) {
        require(_isApprovedOrOwner(msg.sender, tokenId), "UA");
        _;
    }

    // @inheritdoc IILOPool => Returns number of collected token
    function claimOLD(uint256 tokenId) external payable isAuthorizedForToken(tokenId) returns (uint256 amount0, uint256 amount1) {
        // only can claim if the launch is successfully
        require(_launchSucceeded, "PNL");

        //@audit-ok : there are no other criteria that prevent a claim ?

        // calculate amount of unlocked liquidity for the position
        uint128 liquidity2Claim = _claimableLiquidity(tokenId);
        IUniswapV3Pool pool = IUniswapV3Pool(_cachedUniV3PoolAddress); // == params.uniV3Pool
        Position storage position = _positions[tokenId];
        {
            IILOManager.Project memory _project = IILOManager(MANAGER).project(address(pool));
            bytes32 positionKey = PositionKey.compute(address(this), TICK_LOWER, TICK_UPPER);
            //console.logBytes32(positionKey);

            uint128 positionLiquidity = position.liquidity;
            require(positionLiquidity >= liquidity2Claim);

            console.log("*** BEFORE BURN ***");

            (, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, , ) = pool.positions(positionKey);
            //console.log("Total Liq: %s , Liq2Claim: %s , Position Liq: %s", uint256(liq), uint(liquidity2Claim), uint(positionLiquidity));

            getAccumulatedFees(positionLiquidity);

            // get amount of token0 and token1 that pool will return for us
            //burl LP token => get T0 & T1
            // Burn liquidity from the sender and account tokens owed for the liquidity to the position
            // Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
            // Fees must be collected separately via a call to #collect
            // amount0 The amount of token0 sent to the recipient
            (amount0, amount1) = pool.burn(TICK_LOWER, TICK_UPPER, liquidity2Claim);
            console.log("UniBurn0: %s , UniBurn1: %s , Liq Claim: %s", amount0, amount1, uint(liquidity2Claim));

            console.log("*** AFTER BURN ***");
            getAccumulatedFees(positionLiquidity);

            //uint256 amount0FromUniswap = amount0;

            // get amount of token0 and token1 after deduct platform fee
            // amounts - platform fees
            (amount0, amount1) = _deductFees(amount0, amount1, _project.platformFee);
            //console.log("MinusPF0: %s , MinusPF1: %s ", amount0, amount1);

            // calculate amount of fees that position generated
            (, feeGrowthInside0LastX128, feeGrowthInside1LastX128, , ) = pool.positions(positionKey);
            //console.log("Total Liq: %s , Liq2Claim: %s , Position Liq: %s", uint(liquidity2Claim), uint(positionLiquidity));

            //console.log("%s, %s", feeGrowthInside0LastX128, feeGrowthInside1LastX128);

            uint256 fees0 = FullMath.mulDiv(
                feeGrowthInside0LastX128 - position.feeGrowthInside0LastX128, //diff of current fee growth value & initial fee growth value => delta
                positionLiquidity,
                FixedPoint128.Q128
            );
            //console.log("Fee0: ", fees0);

            uint256 fees1 = FullMath.mulDiv(
                feeGrowthInside1LastX128 - position.feeGrowthInside1LastX128,
                positionLiquidity,
                FixedPoint128.Q128
            );
            //console.log("Fee1: ", fees1);

            // amount of fees after deduct performance fee
            (fees0, fees1) = _deductFees(fees0, fees1, _project.performanceFee);

            // fees is combined with liquidity token amount to return to the user
            amount0 += fees0;
            amount1 += fees1;
            //console.log("MinusPFPlusFee0: %s , MinusPFPlusFee1: %s ", amount0, amount1);

            //update position
            position.feeGrowthInside0LastX128 = feeGrowthInside0LastX128;
            position.feeGrowthInside1LastX128 = feeGrowthInside1LastX128;

            // subtraction is safe because we checked positionLiquidity is gte liquidity2Claim
            position.liquidity = positionLiquidity - liquidity2Claim;
            //emit DecreaseLiquidity(tokenId, liquidity2Claim, amount0, amount1);
        }

        //console.log("BAL-0: ", IERC20(_cachedPoolKey.token0).balanceOf(address(this)));
        (uint128 amountCollected0, uint128 amountCollected1) = pool.collect(
            address(this),
            TICK_LOWER,
            TICK_UPPER,
            type(uint128).max,
            type(uint128).max
        );
        //console.log("BAL-1: ", IERC20(_cachedPoolKey.token0).balanceOf(address(this)));
        //emit Collect(tokenId, address(this), amountCollected0, amountCollected1);
        console.log("AmountCollected0: %s , AmountCollected1: %s ", amountCollected0, amountCollected1);

        // transfer token for user
        TransferHelper.safeTransfer(_cachedPoolKey.token0, ownerOf(tokenId), amount0); //initial amount + earned from fees
        TransferHelper.safeTransfer(_cachedPoolKey.token1, ownerOf(tokenId), amount1);

        // emit Claim(
        //     ownerOf(tokenId),
        //     tokenId,
        //     liquidity2Claim,
        //     amount0,
        //     amount1,
        //     position.feeGrowthInside0LastX128,
        //     position.feeGrowthInside1LastX128
        // );

        address feeTaker = IILOManager(MANAGER).FEE_TAKER();
        // transfer fee to fee taker
        //@audit-issue amountCollected0 == collected fees && amount0 == burned liquidity (much higher than fees)
        //Total amount transferred from UNI = amount0FromUniswap + amountCollected0

        TransferHelper.safeTransfer(_cachedPoolKey.token0, feeTaker, amountCollected0 - amount0); //the remainingpart goes to fee taker
        TransferHelper.safeTransfer(_cachedPoolKey.token1, feeTaker, amountCollected1 - amount1);
    }

    function claim(uint256 tokenId) external payable override isAuthorizedForToken(tokenId) returns (uint256 amount0, uint256 amount1) {
        // only can claim if the launch is successfully
        require(_launchSucceeded, "PNL");

        // calculate amount of unlocked liquidity for the position
        uint128 liquidity2Claim = _claimableLiquidity(tokenId);
        IUniswapV3Pool pool = IUniswapV3Pool(_cachedUniV3PoolAddress);
        Position storage position = _positions[tokenId];
        {
            IILOManager.Project memory _project = IILOManager(MANAGER).project(address(pool));

            uint128 positionLiquidity = position.liquidity;
            require(positionLiquidity >= liquidity2Claim);

            console.log("Pos. Liquidity: %s , Liquidity to Claim: %s ", uint256(positionLiquidity), uint256(liquidity2Claim));

            // get amount of token0 and token1 that pool will return for us
            (amount0, amount1) = pool.burn(TICK_LOWER, TICK_UPPER, liquidity2Claim);
            console.log("UniBurn0: %s , UniBurn1: %s , Liq Claim: %s", amount0, amount1, uint(liquidity2Claim)); //9999444444444444444443 = 9999.44

            // get amount of token0 and token1 after deduct platform fee
            (amount0, amount1) = _deductFees(amount0, amount1, _project.platformFee);
            console.log("Burned0 - Platform Fee: %s , Burned1 - Platform Fee: %s ", amount0, amount1); //9989444999999999999999 = 9989.44

            bytes32 positionKey = PositionKey.compute(address(this), TICK_LOWER, TICK_UPPER);

            // calculate amount of fees that position generated
            (, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, , ) = pool.positions(positionKey);
            uint256 fees0 = FullMath.mulDiv(
                feeGrowthInside0LastX128 - position.feeGrowthInside0LastX128,
                positionLiquidity,
                FixedPoint128.Q128
            );

            uint256 fees1 = FullMath.mulDiv(
                feeGrowthInside1LastX128 - position.feeGrowthInside1LastX128,
                positionLiquidity,
                FixedPoint128.Q128
            );

            console.log("UniFee0: %s , UniFee1: %s ", fees0, fees1);
            //console.log("UniBurn+Fee0: %s , UniBurn+Fee1: %s ", fees0 + amount0, fees1 + amount1);

            // amount of fees after deduct performance fee
            (fees0, fees1) = _deductFees(fees0, fees1, _project.performanceFee);
            console.log("UniFee0 - Perf Fee: %s , UniFee1 - Perf Fee: %s ", fees0, fees1);

            // fees is combined with liquidity token amount to return to the user
            amount0 += fees0;
            amount1 += fees1;
            console.log("Amount0 for User: %s , Amount1 for User: %s ", amount0, amount1); //

            position.feeGrowthInside0LastX128 = feeGrowthInside0LastX128;
            position.feeGrowthInside1LastX128 = feeGrowthInside1LastX128;

            // subtraction is safe because we checked positionLiquidity is gte liquidity2Claim
            position.liquidity = positionLiquidity - liquidity2Claim;
            emit DecreaseLiquidity(tokenId, liquidity2Claim, amount0, amount1);
        }
        // real amount collected from uintswap pool
        (uint128 amountCollected0, uint128 amountCollected1) = pool.collect(
            address(this),
            TICK_LOWER,
            TICK_UPPER,
            type(uint128).max,
            type(uint128).max
        );
        //console.log("Balance after collect: %s", IERC20(_cachedPoolKey.token0).balanceOf(address(this))); //
        //console.log("Balance after collect: %s", IERC20(_cachedPoolKey.token1).balanceOf(address(this))); //
        emit Collect(tokenId, address(this), amountCollected0, amountCollected1);

        console.log("TotalUniAmountCollected0: %s , TotalUniAmountCollected1: %s ", amountCollected0, amountCollected1);

        console.log("Balance after collect T0: %s", IERC20(_cachedPoolKey.token0).balanceOf(address(this))); //
        console.log("Balance after collect T1: %s", IERC20(_cachedPoolKey.token1).balanceOf(address(this))); //

        // transfer token for user
        //@note this will fail at a certain stage => because below, we send ALL fees to the feeTaker
        //we shouls only send the proportional amount, so there remain fees available for other claiming users
        TransferHelper.safeTransfer(_cachedPoolKey.token0, ownerOf(tokenId), amount0);
        TransferHelper.safeTransfer(_cachedPoolKey.token1, ownerOf(tokenId), amount1);

        emit Claim(
            ownerOf(tokenId),
            tokenId,
            liquidity2Claim,
            amount0,
            amount1,
            position.feeGrowthInside0LastX128,
            position.feeGrowthInside1LastX128
        );

        address feeTaker = IILOManager(MANAGER).FEE_TAKER();
        // transfer fee to fee taker
        console.log("Fee Taker amount: ", amountCollected0 - amount0);
        TransferHelper.safeTransfer(_cachedPoolKey.token0, feeTaker, amountCollected0 - amount0);
        TransferHelper.safeTransfer(_cachedPoolKey.token1, feeTaker, amountCollected1 - amount1);
    }

    function claimNew(uint256 tokenId) external payable override isAuthorizedForToken(tokenId) returns (uint256 amount0, uint256 amount1) {
        // only can claim if the launch is successfully
        require(_launchSucceeded, "PNL");

        // calculate amount of unlocked liquidity for the position
        uint128 liquidity2Claim = _claimableLiquidity(tokenId);
        IUniswapV3Pool pool = IUniswapV3Pool(_cachedUniV3PoolAddress);

        //@note add vars
        uint256 amountFeeTaker0;
        uint256 amountFeeTaker1;

        Position storage position = _positions[tokenId];
        {
            IILOManager.Project memory _project = IILOManager(MANAGER).project(address(pool));

            uint128 positionLiquidity = position.liquidity;
            require(positionLiquidity >= liquidity2Claim);

            console.log("Pos. Liquidity: %s , Liquidity to Claim: %s ", uint256(positionLiquidity), uint256(liquidity2Claim));

            //@note we need to calculate the accumulated fees before we call burn on the pool
            (uint256 fees0, uint256 fees1, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128) = getAccumulatedFees(
                positionLiquidity
            );
            console.log("UniFee0: %s , UniFee1: %s ", fees0, fees1); // 555555555555555555 & 2001211733707539375 = 0.55

            //console.log("Balance before burn: %s", IERC20(_cachedPoolKey.token0).balanceOf(address(this))); // 0
            (amount0, amount1) = pool.burn(TICK_LOWER, TICK_UPPER, liquidity2Claim);
            //console.log("Balance after burn: %s", IERC20(_cachedPoolKey.token0).balanceOf(address(this))); // 0

            console.log("UniBurn0: %s , UniBurn1: %s , Liq Claim: %s", amount0, amount1, uint(liquidity2Claim)); //9999444444444444444443 = 9999.44
            console.log("UniBurn+Fee0: %s , UniBurn+Fee1: %s ", fees0 + amount0, fees1 + amount1); //9999999999999999999998 == 9999.99

            //@note modified
            //(amount0, amount1) = _deductFees(amount0, amount1, _project.platformFee);
            amountFeeTaker0 = FullMath.mulDiv(amount0, _project.platformFee, BPS);
            amountFeeTaker1 = FullMath.mulDiv(amount1, _project.platformFee, BPS);
            amount0 = amount0 - amountFeeTaker0;
            amount1 = amount1 - amountFeeTaker1;

            console.log("Burned0 - Platform Fee: %s , Burned1 - Platform Fee: %s ", amount0, amount1); //9989444999999999999999 = 9989.44

            //@note the following calculation is wrong
            // (, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, , ) = pool.positions(positionKey);
            // uint256 fees0 = FullMath.mulDiv(
            //     feeGrowthInside0LastX128 - position.feeGrowthInside0LastX128,
            //     positionLiquidity,
            //     FixedPoint128.Q128
            // );

            // uint256 fees1 = FullMath.mulDiv(
            //     feeGrowthInside1LastX128 - position.feeGrowthInside1LastX128,
            //     positionLiquidity,
            //     FixedPoint128.Q128
            // );

            //@note modified
            // amount of fees after deduct performance fee
            //(fees0, fees1) = _deductFees(fees0, fees1, _project.performanceFee);
            amountFeeTaker0 += FullMath.mulDiv(fees0, _project.performanceFee, BPS);
            amountFeeTaker1 += FullMath.mulDiv(fees1, _project.performanceFee, BPS);
            fees0 -= FullMath.mulDiv(fees0, _project.performanceFee, BPS);
            fees1 -= FullMath.mulDiv(fees1, _project.performanceFee, BPS);

            console.log("UniFee0 - Perf Fee: %s , UniFee1 - Perf Fee: %s ", fees0, fees1); //500000000000000000 = 0.5

            // fees is combined with liquidity token amount to return to the user
            amount0 += fees0;
            amount1 += fees1;
            console.log("Amount0 for User: %s , Amount1 for User: %s ", amount0, amount1); //9989944999999999999999 = 9989.94

            position.feeGrowthInside0LastX128 = feeGrowthInside0LastX128;
            position.feeGrowthInside1LastX128 = feeGrowthInside1LastX128;

            // subtraction is safe because we checked positionLiquidity is gte liquidity2Claim
            position.liquidity = positionLiquidity - liquidity2Claim;
            //emit DecreaseLiquidity(tokenId, liquidity2Claim, amount0, amount1);
        }

        //console.log("Balance before collect: %s", IERC20(_cachedPoolKey.token0).balanceOf(address(this))); // 0
        //console.log("Balance before collect: %s", IERC20(_cachedPoolKey.token1).balanceOf(address(this))); // 0
        // real amount collected from uintswap pool : burned liquidity + fees
        //@note here we collect all fees => we should only collect the proportion of the calling user
        //when the next user calls, there won't be any fees left => however, total fees need to be shared by all investors
        //here, the platform takes more fees than allowed
        (uint128 amountCollected0, uint128 amountCollected1) = pool.collect(
            address(this),
            TICK_LOWER,
            TICK_UPPER,
            type(uint128).max,
            type(uint128).max
        );
        console.log("Balance after collect: %s", IERC20(_cachedPoolKey.token0).balanceOf(address(this))); // 10004444444444444444443 = 10004.44
        console.log("Balance after collect: %s", IERC20(_cachedPoolKey.token1).balanceOf(address(this))); // 40020233251289239294935
        //emit Collect(tokenId, address(this), amountCollected0, amountCollected1);

        // 10004444444444444444443 && 40020233251289239294935
        console.log("TotalUniAmountCollected0: %s , TotalUniAmountCollected1: %s ", amountCollected0, amountCollected1);

        //TotalUniAmountCollected0 - UniBurn+Fee0 = 4444444444444444445 == 4.4

        //@note this will fail at a certain stage => because below, we send ALL fees to the feeTaker
        //we shouls only send the proportional amount, so there remain fees available for other claiming users
        TransferHelper.safeTransfer(_cachedPoolKey.token0, ownerOf(tokenId), amount0);
        TransferHelper.safeTransfer(_cachedPoolKey.token1, ownerOf(tokenId), amount1);

        // emit Claim(
        //     ownerOf(tokenId),
        //     tokenId,
        //     liquidity2Claim,
        //     amount0,
        //     amount1,
        //     position.feeGrowthInside0LastX128,
        //     position.feeGrowthInside1LastX128
        // );

        address feeTaker = IILOManager(MANAGER).FEE_TAKER();
        // transfer fee to fee taker
        //@note this is wrong => when we called collect, we =retrieved all fees that need to be shared amongst all investors
        //we cant just send the difference to the feeTaker
        console.log("Wrong Fee Taker amount 0: ", amountCollected0 - amount0);
        console.log("CorrectFee Taker amount 0: ", amountFeeTaker0);

        //amountFeeTaker0
        // TransferHelper.safeTransfer(_cachedPoolKey.token0, feeTaker, amountCollected0 - amount0);
        // TransferHelper.safeTransfer(_cachedPoolKey.token1, feeTaker, amountCollected1 - amount1);
        TransferHelper.safeTransfer(_cachedPoolKey.token0, feeTaker, amountFeeTaker0);
        TransferHelper.safeTransfer(_cachedPoolKey.token1, feeTaker, amountFeeTaker1);
    }

    function getAccumulatedFees(
        uint128 positionLiquidity
    ) internal view returns (uint256 fees0, uint256 fees1, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128) {
        IUniswapV3Pool pool = IUniswapV3Pool(_cachedUniV3PoolAddress);
        bytes32 positionKey = PositionKey.compute(address(this), TICK_LOWER, TICK_UPPER);
        (, feeGrowthInside0LastX128, feeGrowthInside1LastX128, , ) = pool.positions(positionKey);
        (, , uint256 feeGrowthOutside0LowerX128, uint256 feeGrowthOutside1LowerX128, , , , ) = pool.ticks(TICK_LOWER);
        (, , uint256 feeGrowthOutside0UpperX128, uint256 feeGrowthOutside1UpperX128, , , , ) = pool.ticks(TICK_UPPER);
        uint256 feeGrowthInside0X128 = pool.feeGrowthGlobal0X128() - feeGrowthOutside0LowerX128 - feeGrowthOutside0UpperX128;
        uint256 feeGrowthInside1X128 = pool.feeGrowthGlobal1X128() - feeGrowthOutside1LowerX128 - feeGrowthOutside1UpperX128;

        fees0 = FullMath.mulDiv(feeGrowthInside0X128 - feeGrowthInside0LastX128, uint256(positionLiquidity), FixedPoint128.Q128);
        //console.log("Fee0 Pool: ", fees0);
        //console.log("ILOPool ::: ", uint256(positionLiquidity), feeGrowthInside0X128, feeGrowthInside0LastX128);

        fees1 = FullMath.mulDiv(feeGrowthInside1X128 - feeGrowthInside1LastX128, uint256(positionLiquidity), FixedPoint128.Q128);
        //console.log("Fee1 Pool: ", fees1);
    }

    function getAccumulatedFeesOLD(uint128 positionLiquidity) internal view returns (uint256 fees0, uint256 fees1) {
        bytes32 positionKey = PositionKey.compute(address(this), TICK_LOWER, TICK_UPPER);
        IUniswapV3Pool pool = IUniswapV3Pool(_cachedUniV3PoolAddress);

        (, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, , ) = pool.positions(positionKey);
        //console.log("feeGrowthInside0LastX128: ", feeGrowthInside0LastX128);

        //console.log("LIQ Entire Pos: %s ", uint(liquidity)); // 180000000000000000019518
        // console.logInt(TICK_LOWER);

        //int24 tickLower = -887270;
        //int24 tickUpper = 887270;

        (, , uint256 feeGrowthOutside0LowerX128, uint256 feeGrowthOutside1LowerX128, , , , ) = pool.ticks(TICK_LOWER);
        (, , uint256 feeGrowthOutside0UpperX128, uint256 feeGrowthOutside1UpperX128, , , , ) = pool.ticks(TICK_UPPER);

        uint256 feeGrowthInside0X128 = pool.feeGrowthGlobal0X128() - feeGrowthOutside0LowerX128 - feeGrowthOutside0UpperX128;
        uint256 feeGrowthInside1X128 = pool.feeGrowthGlobal1X128() - feeGrowthOutside1LowerX128 - feeGrowthOutside1UpperX128;
        //console.log("feeGrowthInside0X128: ", feeGrowthInside1X128);

        //160000000000000000017351 => for entire user position
        //liquidity = 180000000000000000019518;

        fees0 = FullMath.mulDiv(feeGrowthInside0X128 - feeGrowthInside0LastX128, uint256(positionLiquidity), FixedPoint128.Q128);
        console.log("Fee0: ", fees0);

        fees1 = FullMath.mulDiv(feeGrowthInside1X128 - feeGrowthInside1LastX128, uint256(positionLiquidity), FixedPoint128.Q128);
        console.log("Fee1: ", fees1);
    }

    modifier OnlyManager() {
        require(msg.sender == MANAGER, "UA");
        _;
    }

    function someTest() external override {
        IUniswapV3Pool pool = IUniswapV3Pool(_cachedUniV3PoolAddress);
        //console.log("Pool1: ", address(pool));

        bytes32 positionKey = PositionKey.compute(address(this), TICK_LOWER, TICK_UPPER);
        (, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, , ) = pool.positions(positionKey);

        console.log("FeePos0: %s , FeePos1: %s ", feeGrowthInside0LastX128, feeGrowthInside1LastX128);

        (, , uint256 lowerFeeGrowthOutside0X128, uint256 lowerFeeGrowthOutside1X128, , , , ) = pool.ticks(TICK_LOWER);
        (, , uint256 upperFeeGrowthOutside0X128, uint256 upperFeeGrowthOutside1X128, , , , ) = pool.ticks(TICK_UPPER);

        uint256 feeGrowthInside0X128 = upperFeeGrowthOutside0X128 - lowerFeeGrowthOutside0X128;
        uint256 feeGrowthInside1X128 = upperFeeGrowthOutside1X128 - lowerFeeGrowthOutside1X128;
        console.log("1: %s , 2: %s", feeGrowthInside0X128, feeGrowthInside1X128);
    }

    // @inheritdoc IILOPool => all liquidity is deployed
    function launch() external override OnlyManager {
        require(!_launchSucceeded, "PL");
        // when refund triggered, we can not launch pool anymore
        require(!_refundTriggered, "IRF");
        // make sure that soft cap requirement match
        require(totalRaised >= saleInfo.softCap, "SC");
        uint128 liquidity;
        address uniV3PoolAddress = _cachedUniV3PoolAddress;
        {
            uint256 amount0;
            uint256 amount1;
            uint256 amount0Min;
            uint256 amount1Min;
            address token0Addr = _cachedPoolKey.token0;

            // calculate sale amount of tokens needed for launching pool
            if (token0Addr == RAISE_TOKEN) {
                amount0 = totalRaised;
                amount0Min = totalRaised;
                (amount1, liquidity) = _saleAmountNeeded(totalRaised);
                //@audit-ok amount1Min = 0 => check, what happens when we call addLiquidity below
            } else {
                (amount0, liquidity) = _saleAmountNeeded(totalRaised);
                amount1 = totalRaised;
                amount1Min = totalRaised;
            }

            // actually deploy liquidity to uniswap pool
            (amount0, amount1) = addLiquidity(
                AddLiquidityParams({
                    pool: IUniswapV3Pool(uniV3PoolAddress),
                    liquidity: liquidity,
                    amount0Desired: amount0,
                    amount1Desired: amount1,
                    amount0Min: amount0Min,
                    amount1Min: amount1Min
                })
            );

            emit PoolLaunch(uniV3PoolAddress, liquidity, amount0, amount1);
        }

        IILOManager.Project memory _project = IILOManager(MANAGER).project(uniV3PoolAddress);

        // assigning vests for the project configuration => _vestingConfigs created in initialize
        //config for vests and shares. => first element is allways for investor => will mint nft when investor buy ilo
        //@audit-ok why we start at 1  => 0-element has recipient == address(0)
        for (uint256 index = 1; index < _vestingConfigs.length; index++) {
            uint256 tokenId;
            VestingConfig memory projectConfig = _vestingConfigs[index];
            // at launch , mint nft for recipient for each _vestingConfig
            _mint(projectConfig.recipient, (tokenId = _nextId++));
            //console.log("TokenId: %s , Rec: %s", tokenId, projectConfig.recipient);
            uint128 liquidityShares = uint128(FullMath.mulDiv(liquidity, projectConfig.shares, BPS));

            Position storage _position = _positions[tokenId]; //empty at this stage => set params below
            _position.liquidity = liquidityShares;
            _positionVests[tokenId].totalLiquidity = liquidityShares;

            // assign vesting schedule
            LinearVest[] storage schedule = _positionVests[tokenId].schedule;
            for (uint256 i = 0; i < projectConfig.schedule.length; i++) {
                schedule.push(projectConfig.schedule[i]);
            }

            emit Buy(projectConfig.recipient, tokenId, 0, liquidityShares);
        }

        // transfer back leftover sale token to project admin
        _refundProject(_project.admin);

        _launchSucceeded = true;
    }

    modifier refundable() {
        if (!_refundTriggered) {
            // if ilo pool is lauch sucessfully, we can not refund anymore
            require(!_launchSucceeded, "PL");
            IILOManager.Project memory _project = IILOManager(MANAGER).project(_cachedUniV3PoolAddress);
            //@audit-ok shouldnt this be < ?   refundDeadline = params.launchTime + DEFAULT_DEADLINE_OFFSET;
            //the refundDeadline is the latest date by which you can request a refund
            //refundDeadline = params.launchTime + DEFAULT_DEADLINE_OFFSET; => launch time + some offset => just in case the project hasn't launched yet
            require(block.timestamp >= _project.refundDeadline, "RFT");

            _refundTriggered = true;
        }
        _;
    }

    // @inheritdoc IILOPool => user claim refund
    function claimRefund(uint256 tokenId) external override refundable isAuthorizedForToken(tokenId) {
        uint256 refundAmount = _positions[tokenId].raiseAmount;
        address tokenOwner = ownerOf(tokenId);

        delete _positions[tokenId];
        delete _positionVests[tokenId];
        _burn(tokenId);

        //@audit-ok check if there are any other params to delete/reset/re-calculate => totalRaised...  => has no consequence

        TransferHelper.safeTransfer(RAISE_TOKEN, tokenOwner, refundAmount);
        emit UserRefund(tokenOwner, tokenId, refundAmount);
    }

    // @inheritdoc IILOPool =>  project admin claim refund sale token
    function claimProjectRefund(address projectAdmin) external override refundable OnlyManager returns (uint256 refundAmount) {
        return _refundProject(projectAdmin);
    }

    function _refundProject(address projectAdmin) internal returns (uint256 refundAmount) {
        refundAmount = IERC20(SALE_TOKEN).balanceOf(address(this)); //VULT token
        if (refundAmount > 0) {
            TransferHelper.safeTransfer(SALE_TOKEN, projectAdmin, refundAmount);
            emit ProjectRefund(projectAdmin, refundAmount);
        }
    }

    /// @inheritdoc IILOSale
    function totalSold() public view override returns (uint256 _totalSold) {
        (_totalSold, ) = _saleAmountNeeded(totalRaised);
    }

    /// @notice return sale token amount needed for the raiseAmount.
    /// @dev sale token amount is rounded up
    function _saleAmountNeeded(uint256 raiseAmount) internal view returns (uint256 saleAmountNeeded, uint128 liquidity) {
        if (raiseAmount == 0) return (0, 0);

        if (_cachedPoolKey.token0 == SALE_TOKEN) {
            // liquidity1 raised
            liquidity = LiquidityAmounts.getLiquidityForAmount1(SQRT_RATIO_LOWER_X96, SQRT_RATIO_X96, raiseAmount);
            //Amount of token0 required to cover a position of size liquidity between the two passed prices
            saleAmountNeeded = SqrtPriceMathPartial.getAmount0Delta(SQRT_RATIO_X96, SQRT_RATIO_UPPER_X96, liquidity, true);
        } else {
            // liquidity0 raised
            liquidity = LiquidityAmounts.getLiquidityForAmount0(SQRT_RATIO_X96, SQRT_RATIO_UPPER_X96, raiseAmount);
            saleAmountNeeded = SqrtPriceMathPartial.getAmount1Delta(SQRT_RATIO_LOWER_X96, SQRT_RATIO_X96, liquidity, true);
        }
    }

    /// @inheritdoc ILOVest
    function _unlockedLiquidity(uint256 tokenId) internal view override returns (uint128 liquidityUnlocked) {
        PositionVest storage _positionVest = _positionVests[tokenId];
        LinearVest[] storage vestingSchedule = _positionVest.schedule; // LinearVest : shares, start, end
        uint128 totalLiquidity = _positionVest.totalLiquidity;

        for (uint256 index = 0; index < vestingSchedule.length; index++) {
            LinearVest storage vest = vestingSchedule[index];

            // if vest is not started, skip this vest and all following vest
            if (block.timestamp < vest.start) {
                break;
            }

            // if vest already end, all the shares are unlocked
            // otherwise we calculate shares of unlocked times and get the unlocked share number
            // all vest after current unlocking vest is ignored
            if (vest.end < block.timestamp) {
                liquidityUnlocked += uint128(FullMath.mulDiv(vest.shares, totalLiquidity, BPS));
            } else {
                liquidityUnlocked += uint128(
                    FullMath.mulDiv(vest.shares * totalLiquidity, block.timestamp - vest.start, (vest.end - vest.start) * BPS)
                );
            }
        }
    }

    /// @notice calculate the amount left after deduct fee
    /// @param amount0 the amount of token0 before deduct fee
    /// @param amount1 the amount of token1 before deduct fee
    /// @return amount0Left the amount of token0 after deduct fee
    /// @return amount1Left the amount of token1 after deduct fee
    function _deductFees(uint256 amount0, uint256 amount1, uint16 feeBPS) internal pure returns (uint256 amount0Left, uint256 amount1Left) {
        amount0Left = amount0 - FullMath.mulDiv(amount0, feeBPS, BPS);
        amount1Left = amount1 - FullMath.mulDiv(amount1, feeBPS, BPS);
    }

    /// @inheritdoc IILOVest
    function vestingStatus(uint256 tokenId) external view override returns (uint128 unlockedLiquidity, uint128 claimedLiquidity) {
        unlockedLiquidity = _unlockedLiquidity(tokenId);
        claimedLiquidity = _positionVests[tokenId].totalLiquidity - _positions[tokenId].liquidity;
    }

    /// @inheritdoc ILOVest
    function _claimableLiquidity(uint256 tokenId) internal view override returns (uint128) {
        uint128 liquidityClaimed = _positionVests[tokenId].totalLiquidity - _positions[tokenId].liquidity;
        uint128 liquidityUnlocked = _unlockedLiquidity(tokenId);
        return liquidityClaimed < liquidityUnlocked ? liquidityUnlocked - liquidityClaimed : 0;
    }

    modifier onlyProjectAdmin() override {
        IILOManager.Project memory _project = IILOManager(MANAGER).project(_cachedUniV3PoolAddress);
        require(msg.sender == _project.admin, "UA");
        _;
    }
}
