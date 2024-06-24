import { HardhatUserConfig, vars } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-erc1820"; // ERC777 is interacting with ERC1820 registry
import dotenv from 'dotenv'
dotenv.config()

const { ALCHEMY_API_URL, PRIVATE_KEY } = process.env

module.exports = {
  solidity: "0.8.24",
  paths: {
    sources: "./hardhat-vultisig/contracts",
    tests: "./hardhat-vultisig/test",
  },
  networks: {
    sepolia: {
      url: ALCHEMY_API_URL,
      chainId: 11155111,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    mainnet: {
      url: ALCHEMY_API_URL,
      chainId: 1,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  typechain: {
    externalArtifacts: [
      "node_modules/@uniswap/v3-core/artifacts/contracts/UniswapV3Factory.sol/UniswapV3Factory.json",
      "node_modules/@uniswap/v3-periphery/artifacts/contracts/NonfungiblePositionManager.sol/NonfungiblePositionManager.json",
      "node_modules/@uniswap/v3-periphery/artifacts/contracts/SwapRouter.sol/SwapRouter.json",
    ],
  },
};

