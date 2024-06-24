// SPDX-License-Identifier: MIT

pragma solidity =0.7.6;
pragma abicoder v2;

import "./IntegrationTestBase.sol";
import "../src/interfaces/IILOPool.sol";
import "../src/interfaces/IILOWhitelist.sol";
import "../src/interfaces/IILOVest.sol";
import "../src/interfaces/IILOPoolImmutableState.sol";

import "../src/libraries/PositionKey.sol";

//import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);

    function exactOutputSingle(ExactOutputSingleParams calldata params) external payable returns (uint256 amountIn);
}

contract ILOPoolTest is IntegrationTestBase {
    address iloPool;

    function setUp() external {
        _setupBase();
        iloPool = _initPool(PROJECT_OWNER, _getInitPoolParams());
    }

    function testBuyNoWhitelist() external {
        vm.prank(DUMMY_ADDRESS);
        IERC20(USDC).approve(iloPool, 1000000000 ether);
        vm.warp(SALE_START + 1);
        _writeTokenBalance(USDC, DUMMY_ADDRESS, 10 ether);

        vm.prank(DUMMY_ADDRESS);
        vm.expectRevert(bytes("UA"));
        IILOPool(iloPool).buy(0.1 ether, DUMMY_ADDRESS);
    }

    function testBuyOpenToAll() external {
        vm.prank(PROJECT_OWNER);
        IILOWhitelist(iloPool).setOpenToAll(true);
        assertEq(IILOWhitelist(iloPool).isOpenToAll(), true);

        vm.prank(DUMMY_ADDRESS);
        IERC20(USDC).approve(iloPool, 1000000000 ether);

        _writeTokenBalance(USDC, DUMMY_ADDRESS, 10 ether);

        vm.prank(DUMMY_ADDRESS);
        vm.warp(SALE_START + 1);
        IILOPool(iloPool).buy(0.1 ether, DUMMY_ADDRESS);
    }

    function testWhiltelist() external {
        vm.startPrank(PROJECT_OWNER);

        IILOWhitelist(iloPool).batchWhitelist(_getListAddress());
        assertEq(IILOWhitelist(iloPool).isWhitelisted(INVESTOR), true);
        assertEq(IILOWhitelist(iloPool).isWhitelisted(INVESTOR_2), true);
        assertEq(IILOWhitelist(iloPool).isWhitelisted(DUMMY_ADDRESS), true);

        IILOWhitelist(iloPool).batchRemoveWhitelist(_getListAddress());
        assertEq(IILOWhitelist(iloPool).isWhitelisted(DUMMY_ADDRESS), false);
        assertEq(IILOWhitelist(iloPool).isWhitelisted(INVESTOR), false);
        assertEq(IILOWhitelist(iloPool).isWhitelisted(INVESTOR_2), false);
    }

    function _getListAddress() internal pure returns (address[] memory addresses) {
        addresses = new address[](3);
        addresses[0] = INVESTOR;
        addresses[1] = INVESTOR_2;
        addresses[2] = DUMMY_ADDRESS;
    }

    function _getListAddressFromAddress(address addr) internal pure returns (address[] memory addresses) {
        addresses = new address[](1);
        addresses[0] = addr;
    }

    function testSetWhiltelistNotProjectOwner() external {
        vm.expectRevert(bytes("UA"));
        vm.prank(DUMMY_ADDRESS);
        IILOWhitelist(iloPool).batchWhitelist(_getListAddress());
    }

    function testBuyZero() external {
        _prepareBuy();
        vm.expectRevert(bytes("ZA"));
        _buyFor(INVESTOR, SALE_START + 1, 0);
    }

    function testBuyTooMuch() external {
        _prepareBuy();
        vm.expectRevert(bytes("UC"));
        _buyFor(INVESTOR, SALE_START + 1, 70000 ether);
    }

    function testBuyBeforeSale() external {
        _prepareBuy();
        vm.expectRevert(bytes("ST"));
        _buy(SALE_START - 1, 0.1 ether);
    }

    function testBuyAfterSale() external {
        _prepareBuy();
        vm.expectRevert(bytes("ST"));
        _buy(SALE_END + 1, 0.1 ether);
    }

    function testBuy() external {
        _prepareBuy();
        uint256 balanceBefore = IERC20(USDC).balanceOf(iloPool);

        (uint256 tokenId, uint128 liquidity) = _buy(SALE_START + 1, 0.1 ether);

        uint256 balanceAfter = IERC20(USDC).balanceOf(iloPool);

        assertGt(tokenId, 0);
        assertEq(uint256(liquidity), 40000000000000000);
        assertEq(balanceAfter - balanceBefore, 0.1 ether);

        (uint128 _liquidity, , , ) = IILOPool(iloPool).positions(tokenId);
        assertEq(uint256(_liquidity), 40000000000000000);
    }

    function testLaunchFromNonManager() external {
        vm.expectRevert(bytes("UA"));
        IILOPool(iloPool).launch();
    }

    function testLaunchWhenSoftCapFailed() external {
        vm.warp(SALE_END + 1);
        vm.prank(address(iloManager));
        vm.expectRevert(bytes("SC"));
        IILOPool(iloPool).launch();
    }

    function _launch() internal {
        _prepareBuyFor(INVESTOR);
        _buyFor(INVESTOR, SALE_START + 1, 49000 ether);
        _prepareBuyFor(INVESTOR_2);
        _buyFor(INVESTOR_2, SALE_START + 1, 40000 ether);
        _buyFor(INVESTOR, SALE_START + 1, 1000 ether);
        _writeTokenBalance(SALE_TOKEN, iloPool, 95000 * 4 ether);

        assertEq(IILOPool(iloPool).totalSold(), 360000000000000000029277); // # SALE_TOKEN sent to unipool

        uint256 balanceBefore = IERC20(SALE_TOKEN).balanceOf(PROJECT_OWNER);
        vm.warp(SALE_END + 1);
        vm.prank(address(iloManager));
        IILOPool(iloPool).launch();
        uint256 balanceAfter = IERC20(SALE_TOKEN).balanceOf(PROJECT_OWNER);
        assertEq(balanceAfter - balanceBefore, 19999999999999999970723); //initially we had 95k * 4 tokens => we sent 90k * 4 to uni => we have 20k left

        //assertEq(IILOPool(iloPool).balanceOf(DEV_RECIPIENT), 1);
        //assertEq(IILOPool(iloPool).balanceOf(TREASURY_RECIPIENT), 1);
        //assertEq(IILOPool(iloPool).balanceOf(LIQUIDITY_RECIPIENT), 1);
    }

    function testRefundAfterLaunch() external {
        _launch();
        uint256 tokenId = IILOPool(iloPool).tokenOfOwnerByIndex(INVESTOR, 0);
        vm.expectRevert(bytes("PL"));
        vm.warp(LAUNCH_START + 86400 * 7 + 1);
        vm.prank(INVESTOR);
        IILOPool(iloPool).claimRefund(tokenId);
    }

    function testLaunchAfterRefund() external {
        _prepareBuyFor(INVESTOR);
        _buyFor(INVESTOR, SALE_START + 1, 50000 ether);
        _prepareBuyFor(INVESTOR_2);
        _buyFor(INVESTOR_2, SALE_START + 1, 40000 ether);
        _writeTokenBalance(SALE_TOKEN, iloPool, 95000 * 4 ether);

        vm.startPrank(INVESTOR);
        //project has not been launched => we can ask for refund after deadline
        vm.warp(LAUNCH_START + 86400 * 7 + 1);
        IILOPool(iloPool).claimRefund(IILOPool(iloPool).tokenOfOwnerByIndex(INVESTOR, 0));
        vm.stopPrank();

        vm.warp(LAUNCH_START + 86400 * 7 + 1);
        vm.prank(address(iloManager));
        vm.expectRevert(bytes("IRF"));
        IILOPool(iloPool).launch();
    }

    function testRefundBeforeRefundDeadline() external {
        _prepareBuy();
        (uint256 tokenId, ) = _buy(SALE_START + 1, 0.1 ether);

        vm.prank(INVESTOR);
        vm.warp(LAUNCH_START + 86400 * 7 - 1);
        vm.expectRevert(bytes("RFT"));
        IILOPool(iloPool).claimRefund(tokenId);
    }

    function testRefund() external {
        _prepareBuy();
        (uint256 tokenId, ) = _buy(SALE_START + 1, 0.1 ether);

        uint256 balanceBefore = IERC20(USDC).balanceOf(INVESTOR);

        vm.prank(INVESTOR);
        vm.warp(LAUNCH_START + 86400 * 7 + 1);
        IILOPool(iloPool).claimRefund(tokenId);

        uint256 balanceAfter = IERC20(USDC).balanceOf(INVESTOR);
        assertEq(balanceAfter - balanceBefore, 0.1 ether);
    }

    function testRefundTwice() external {
        _prepareBuy();
        (uint256 tokenId, ) = _buy(SALE_START + 1, 0.1 ether);
        //console.logUint(tokenId);
        vm.prank(INVESTOR);
        vm.warp(LAUNCH_START + 86400 * 7 + 1);
        IILOPool(iloPool).claimRefund(tokenId);

        vm.prank(INVESTOR);
        vm.expectRevert(bytes("ERC721: operator query for nonexistent token"));
        IILOPool(iloPool).claimRefund(tokenId);
    }

    function _buy(uint64 buyTime, uint256 buyAmount) internal returns (uint256 tokenId, uint128 liquidity) {
        return _buyFor(INVESTOR, buyTime, buyAmount);
    }

    function _prepareBuy() internal {
        _prepareBuyFor(INVESTOR);
    }

    function _prepareBuyFor(address investor) internal {
        vm.prank(PROJECT_OWNER);
        IILOWhitelist(iloPool).batchWhitelist(_getListAddressFromAddress(investor));

        vm.prank(investor);
        IERC20(USDC).approve(iloPool, 1000000000 ether);

        _writeTokenBalance(USDC, investor, 1000000000 ether);
    }

    function _buyFor(address investor, uint64 buyTime, uint256 buyAmount) internal returns (uint256 tokenId, uint128 liquidity) {
        vm.warp(buyTime);
        vm.prank(investor);
        return IILOPool(iloPool).buy(buyAmount, investor);
    }

    function simulateTrade1() internal {
        address contr = address(this);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: USDC,
            tokenOut: SALE_TOKEN,
            fee: 500,
            recipient: address(this), //DUMMY_ADDRESS,
            deadline: block.timestamp + 1500,
            amountIn: 10 * 10 ** 18,
            amountOutMinimum: 1,
            sqrtPriceLimitX96: 0
        });

        _writeTokenBalance(USDC, contr, 1000000000 ether);
        _writeTokenBalance(SALE_TOKEN, contr, 1000000000 ether);
        //console.log("Bal2: ", IERC20(USDC).balanceOf(contr));
        IERC20(USDC).approve(iloPool, 1000000000 ether);
        IERC20(SALE_TOKEN).approve(iloPool, 1000000000 ether);
        IERC20(USDC).approve(UNIV3_ROUTER, 1000000000 ether);
        IERC20(SALE_TOKEN).approve(UNIV3_ROUTER, 1000000000 ether);
        //console.log("All US: ", IERC20(USDC).allowance(contr, iloPool));

        //console.log("Bal1: ", IERC20(USDC).balanceOf(DUMMY_ADDRESS));
        //_writeTokenBalance(USDC, DUMMY_ADDRESS, 1000000000 ether);
        //console.log("Bal2: ", IERC20(USDC).balanceOf(DUMMY_ADDRESS));
        // vm.prank(DUMMY_ADDRESS);
        // IERC20(USDC).approve(iloPool, 1000000000 ether);
        // vm.prank(DUMMY_ADDRESS);
        // IERC20(SALE_TOKEN).approve(iloPool, 1000000000 ether);

        // console.log("All ST: ", IERC20(SALE_TOKEN).allowance(DUMMY_ADDRESS, iloPool));
        // console.log("All US: ", IERC20(USDC).allowance(DUMMY_ADDRESS, iloPool));

        // console.log("Bal1: ", IERC20(SALE_TOKEN).balanceOf(DUMMY_ADDRESS));
        // _writeTokenBalance(SALE_TOKEN, DUMMY_ADDRESS, 1000000000 ether);
        // console.log("Bal2: ", IERC20(SALE_TOKEN).balanceOf(DUMMY_ADDRESS));

        ISwapRouter swapRouter = ISwapRouter(UNIV3_ROUTER);

        //(int256 amount0, int256 amount1)
        address uniPool = IILOPoolImmutableState(iloPool)._cachedUniV3PoolAddress();
        //console.log("UNI Pool", uniPool);
        // console.log("UNI-USDC: ", IERC20(USDC).balanceOf(uniPool));
        // console.log("UNI-SALE: ", IERC20(SALE_TOKEN).balanceOf(uniPool));

        uint160 sqrt = 158456325028528675187087900472; //158456325028528675187087900672

        bytes32 positionKey = 0x0ac5acd9d696440b9a5a59b1d95207c05ba18f608e781d428c6ac919f6427262;
        // PositionKey.compute(address(this), TICK_LOWER, TICK_UPPER);
        //(, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, , ) = IUniswapV3Pool(uniPool).positions(positionKey);
        (uint256 fees0, uint256 fees1) = _getAccumulatedFees(uniPool);
        //console.log("Fee0: %s , Fee1: %s", fees0, fees1);

        //vm.prank(contr);
        //vm.prank(DUMMY_ADDRESS);
        //try IUniswapV3Pool(uniPool).swap(contr, true, 10 ether, sqrt, "") returns (int256 amount0, int256 amount1) {
        try swapRouter.exactInputSingle(params) returns (uint256 amountOut) {
            // Successful execution
            // You can handle the returned amountOut if needed
            console.log("Trade OK");
            // console.logInt(amount0);
            // console.logInt(amount1);
        } catch Error(string memory reason) {
            // This is executed in case of a revert with a reason string
            //emit LogError(reason);
            console.log("Reason: ", reason);
        } catch (bytes memory lowLevelData) {
            // This is executed in case of a revert without a reason string
            //emit LogLowLevelError(lowLevelData);
            console.logBytes(lowLevelData);
        }

        //(, feeGrowthInside0LastX128, feeGrowthInside1LastX128, , ) = IUniswapV3Pool(uniPool).positions(positionKey);
        (fees0, fees1) = _getAccumulatedFees(uniPool);
        //console.log("Fee0: %s , Fee1: %s", fees0, fees1);
    }

    function simulateTrade2() internal {
        address contr = address(this);
        ISwapRouter swapRouter = ISwapRouter(UNIV3_ROUTER);
        address uniPool = IILOPoolImmutableState(iloPool)._cachedUniV3PoolAddress();

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: USDC,
            tokenOut: SALE_TOKEN,
            fee: 500,
            recipient: address(this), //DUMMY_ADDRESS,
            deadline: block.timestamp + 1500,
            amountIn: 10 * 10 ** 18,
            amountOutMinimum: 1,
            sqrtPriceLimitX96: 0
        });

        _writeTokenBalance(USDC, contr, 1000000000 ether);
        _writeTokenBalance(SALE_TOKEN, contr, 1000000000 ether);
        IERC20(USDC).approve(UNIV3_ROUTER, 1000000000 ether);
        IERC20(SALE_TOKEN).approve(UNIV3_ROUTER, 1000000000 ether);

        uint160 sqrt = 158456325028528675187087900472; //158456325028528675187087900672
        bytes32 positionKey = 0x0ac5acd9d696440b9a5a59b1d95207c05ba18f608e781d428c6ac919f6427262;
        (uint256 fees0, uint256 fees1) = _getAccumulatedFees(uniPool);
        //console.log("Fee0: %s , Fee1: %s", fees0, fees1);

        try swapRouter.exactInputSingle(params) returns (uint256 amountOut) {
            console.log("Trade OK");
            // console.logInt(amount0);
            // console.logInt(amount1);
        } catch Error(string memory reason) {
            console.log("Reason: ", reason);
        } catch (bytes memory lowLevelData) {
            console.logBytes(lowLevelData);
        }

        (fees0, fees1) = _getAccumulatedFees(uniPool);
        //console.log("Fee0: %s , Fee1: %s", fees0, fees1);
    }

    function _prepareTradeFor(address trader) internal {
        uint256 approveAmount = 1000000000 ether;
        _writeTokenBalance(USDC, trader, approveAmount);
        _writeTokenBalance(SALE_TOKEN, trader, approveAmount);
        vm.startPrank(trader);
        IERC20(USDC).approve(UNIV3_ROUTER, approveAmount);
        IERC20(SALE_TOKEN).approve(UNIV3_ROUTER, approveAmount);
        vm.stopPrank();
    }

    function simulateTrade(bool fromUSDC, uint256 amount) internal {
        address contr = address(this);
        ISwapRouter swapRouter = ISwapRouter(UNIV3_ROUTER);
        address uniPool = IILOPoolImmutableState(iloPool)._cachedUniV3PoolAddress();

        ISwapRouter.ExactInputSingleParams memory exactInputParams = ISwapRouter.ExactInputSingleParams({
            tokenIn: USDC,
            tokenOut: SALE_TOKEN,
            fee: 500,
            recipient: address(this),
            deadline: block.timestamp + 1500,
            amountIn: amount,
            amountOutMinimum: 1,
            sqrtPriceLimitX96: 0
        });

        ISwapRouter.ExactOutputSingleParams memory exactOutputParams = ISwapRouter.ExactOutputSingleParams({
            tokenIn: SALE_TOKEN,
            tokenOut: USDC,
            fee: 500,
            recipient: address(this),
            deadline: block.timestamp + 1500,
            amountOut: amount,
            amountInMaximum: type(uint256).max,
            sqrtPriceLimitX96: 0
        });

        (uint256 fees0, uint256 fees1) = _getAccumulatedFees(uniPool);
        //console.log("Fee0: %s , Fee1: %s", fees0, fees1);

        uint256 amount;
        if (fromUSDC) amount = swapRouter.exactInputSingle(exactInputParams);
        else amount = swapRouter.exactOutputSingle(exactOutputParams);

        (fees0, fees1) = _getAccumulatedFees(uniPool);
        //console.log("Fee0: %s , Fee1: %s", fees0, fees1);
    }

    function _getPricePrec3() internal view returns (uint256) {
        uint160 sqrtPriceX96 = _getSqrtPriceX96();
        uint256 priceX192 = uint256(sqrtPriceX96) * uint256(sqrtPriceX96) * 1e3;
        uint256 price = priceX192 >> 192;
        return price;
    }

    function _getSqrtPriceX96() internal view returns (uint160) {
        address uniPool = IILOPoolImmutableState(iloPool)._cachedUniV3PoolAddress();
        IUniswapV3Pool pool = IUniswapV3Pool(uniPool);
        (uint160 sqrtPriceX96, , , , , , ) = pool.slot0();
        return sqrtPriceX96;
    }

    function _getAccumulatedFees(address uniPool) internal view returns (uint256 fees0, uint256 fees1) {
        bytes32 positionKey = 0x0ac5acd9d696440b9a5a59b1d95207c05ba18f608e781d428c6ac919f6427262;
        IUniswapV3Pool pool = IUniswapV3Pool(uniPool);
        int24 tickLower = -887270;
        int24 tickUpper = 887270;

        (uint128 liquidity, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, , ) = pool.positions(positionKey);
        //console.log("feeGrowthInside0LastX128-TEST: ", feeGrowthInside0LastX128);

        (, , uint256 feeGrowthOutside0LowerX128, uint256 feeGrowthOutside1LowerX128, , , , ) = pool.ticks(tickLower);
        (, , uint256 feeGrowthOutside0UpperX128, uint256 feeGrowthOutside1UpperX128, , , , ) = pool.ticks(tickUpper);

        uint256 feeGrowthInside0X128 = pool.feeGrowthGlobal0X128() - feeGrowthOutside0LowerX128 - feeGrowthOutside0UpperX128;
        uint256 feeGrowthInside1X128 = pool.feeGrowthGlobal1X128() - feeGrowthOutside1LowerX128 - feeGrowthOutside1UpperX128;
        //console.log("feeGrowthInside0X128-TEST: ", feeGrowthInside1X128);
        //console.log("liquidity-Total-TEST: ", uint256(liquidity));

        fees0 = (uint256(liquidity) * (feeGrowthInside0X128 - feeGrowthInside0LastX128)) / (1 << 128);
        //console.log("TEST ::: ", uint256(liquidity), feeGrowthInside0X128, feeGrowthInside0LastX128);
        fees1 = (uint256(liquidity) * (feeGrowthInside1X128 - feeGrowthInside1LastX128)) / (1 << 128);
    }

    function uniswapV3SwapCallback(int256 amount0, int256 amount1, bytes calldata data) external {
        // console.logInt(amount0); //2
        // console.logInt(amount1); //0
        //console.log("T0: %s , T1: %s", address);

        //require(msg.sender == address(pool), "Invalid callback caller");
        //console.log("Pool: ", msg.sender);

        if (amount0 > 0) {
            IERC20(USDC).transfer(msg.sender, uint256(amount0));
        } else if (amount1 > 0) {
            IERC20(SALE_TOKEN).transfer(msg.sender, uint256(amount1));
        }
    }

    function testClaimFailsOnTransfer() external {
        _launch();

        uint256 tokenIdInvestor = IILOPool(iloPool).tokenOfOwnerByIndex(INVESTOR, 0);
        uint256 tokenIdInvestor2 = IILOPool(iloPool).tokenOfOwnerByIndex(INVESTOR_2, 0);

        _prepareTradeFor(address(this));
        // to accumulate some Uniswap pool fees, we execute 100 trades of 10k each
        // the pool fee is 0.05% => this generates 5 * 100 in fees
        // total liq = 90k => fee = 0.05% = 5/trade => Inv1 fee = 11.11% of that amount (10k claimable from 90k) = 0.55 ...
        for (uint i = 0; i < 100; ++i) {
            //trade from USDC to VULT
            simulateTrade(true, 10000 ether);
            //trade from VULT to USDC
            simulateTrade(false, 10000 ether);
        }

        //unlocked the entire liquidity
        vm.warp(VEST_START_0 + (86400 * 2));

        console.log("******************************CLAIM FOR INVESTOR ************************************************");

        vm.prank(INVESTOR);
        try IILOPool(iloPool).claimNew(tokenIdInvestor) returns (uint256 amount0, uint256 amount1) {} catch Error(string memory reason) {
            console.log("Claim failed: ", reason);
        }

        console.log("******************************CLAIM FOR INVESTOR_2 ************************************************");

        uint256 inv2BalBefore = IERC20(USDC).balanceOf(INVESTOR_2) / 1 ether;
        console.log("INVESTOR_2 Balance USDC before claim: ", inv2BalBefore);

        vm.prank(INVESTOR_2);
        try IILOPool(iloPool).claimNew(tokenIdInvestor2) returns (uint256 amount0, uint256 amount1) {} catch Error(string memory reason) {
            //The ILOPool doesn't hold enough funds to execute the transfer to Investor_2
            console.log("! Claim failed: ", reason);
        }

        uint256 inv2BalAfter = IERC20(USDC).balanceOf(INVESTOR_2) / 1 ether;
        console.log("INVESTOR_2 Balance USDC after claim: ", inv2BalAfter);

        //The claim fails for Investor_2 => the balance before is the same as the balance after the claim call !!!
        assertEq(inv2BalAfter, inv2BalAfter);
    }

    function testClaim() external {
        _launch();
        //vm.warp(VEST_START_0 + 86400);
        uint256 tokenId = IILOPool(iloPool).tokenOfOwnerByIndex(INVESTOR, 0);
        //console.log("Token2: ", IILOPool(iloPool).tokenOfOwnerByIndex(INVESTOR, 1));

        (uint128 unlockedLiquidity, uint128 claimedLiquidity) = IILOVest(iloPool).vestingStatus(tokenId);
        //assertEq(uint256(unlockedLiquidity), 694444444444444444);
        //assertEq(uint256(claimedLiquidity), 0);

        uint256 balance0Before = IERC20(USDC).balanceOf(INVESTOR);
        uint256 balance1Before = IERC20(SALE_TOKEN).balanceOf(INVESTOR);

        //console.log("Price 1: ", _getPricePrec3()); //4000 == 4

        _prepareTradeFor(address(this));
        // 100 trades = 55.5 USDC collected in fees
        for (uint i = 0; i < 100; ++i) {
            simulateTrade(true, 10000 ether); // total liq = 90k => fee = 0.05% = 5 => Inv1 fee = 11.11% of that amount (10k claimable from 90k) = 0.55
            //console.log("Price 2: ", _getPricePrec3()); //3912 == 3.912
            simulateTrade(false, 10000 ether);
            //console.log("Price 3: ", _getPricePrec3()); //4
        }
        console.log("Price 3: ", _getPricePrec3()); //4

        //all liquidity unlocked
        vm.warp(VEST_START_0 + (86400 * 2));

        uint256 usdcBefore = IERC20(USDC).balanceOf(INVESTOR) / 1 ether;
        uint256 vultBefore = IERC20(SALE_TOKEN).balanceOf(INVESTOR) / 1 ether;
        // console.log("Balance USDC before claim: ", usdcBefore);
        // console.log("Balance VULT before claim: ", vultBefore);

        //console.log("Claim for INVESTOR - Id: 1");
        console.log("INVESTOR Balance USDC before claim: ", IERC20(USDC).balanceOf(INVESTOR) / 1 ether);
        vm.prank(INVESTOR);
        //IILOPool(iloPool).claim(tokenId);
        //IILOPool(iloPool).claimOriginal(tokenId);
        try IILOPool(iloPool).claim(tokenId) returns (uint256 amount0, uint256 amount1) {} catch Error(string memory reason) {
            console.log("Reason: ", reason);
        }
        console.log("INVESTOR Balance USDC after claim: ", IERC20(USDC).balanceOf(INVESTOR) / 1 ether);

        console.log("******************************************************************************");

        console.log("INVESTOR_2 Balance USDC before claim: ", IERC20(USDC).balanceOf(INVESTOR_2) / 1 ether);
        uint256 tokenIdInv2 = IILOPool(iloPool).tokenOfOwnerByIndex(INVESTOR_2, 0);
        vm.prank(INVESTOR_2);
        //IILOPool(iloPool).claim(tokenIdInv2);
        try IILOPool(iloPool).claim(tokenIdInv2) returns (uint256 amount0, uint256 amount1) {} catch Error(string memory reason) {
            console.log("Reason: ", reason);
        }

        console.log("INVESTOR_2 Balance USDC before claim: ", IERC20(USDC).balanceOf(INVESTOR_2) / 1 ether);

        uint256 usdcAfter = IERC20(USDC).balanceOf(INVESTOR) / 1 ether;
        uint256 vultAfter = IERC20(SALE_TOKEN).balanceOf(INVESTOR) / 1 ether;
        // console.log("Balance USDC after claim: ", usdcAfter - usdcBefore); // should be 10000 + fees
        // console.log("Balance VULT after claim: ", vultAfter - vultBefore);

        //console.log("Claim for INVESTOR - Id: 3");
        //vm.prank(INVESTOR);
        //IILOPool(iloPool).claim(3);

        //console.log("Claim for INVESTOR - Id: 4");
        //vm.prank(DEV_RECIPIENT);
        //IILOPool(iloPool).claim(4);

        uint256 balance0After = IERC20(USDC).balanceOf(INVESTOR);
        uint256 balance1After = IERC20(SALE_TOKEN).balanceOf(INVESTOR);

        // int(50000*0.2*0.3*10/86400*10**18)
        //assertEq(balance0After - balance0Before, 346874999999999999);

        vm.warp(VEST_START_1 + 100);

        (unlockedLiquidity, claimedLiquidity) = IILOVest(iloPool).vestingStatus(tokenId);

        //assertEq(uint256(unlockedLiquidity), 6016203703703703704355);
        //assertEq(uint256(claimedLiquidity), 694444444444444444);
    }
}
