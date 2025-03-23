require("@nomicfoundation/hardhat-toolbox");
require("@chainlink/env-enc").config();
require("@nomicfoundation/hardhat-verify");

const SEPOLIA_URL = process.env.SEPOLIA_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: SEPOLIA_URL,
      accounts: [PRIVATE_KEY],
      chianid: 11155111,
    },
  },
  etherscan: {
    apiKey: { sepolia: ETHERSCAN_API_KEY },
  },
};
