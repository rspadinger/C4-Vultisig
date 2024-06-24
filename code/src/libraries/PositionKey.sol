// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

//https://github.com/Uniswap/v3-periphery/blob/main/contracts/libraries/PositionKey.sol

library PositionKey {
    /// @dev Returns the key of the position in the core library
    function compute(address owner, int24 tickLower, int24 tickUpper) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(owner, tickLower, tickUpper));
    }
}
