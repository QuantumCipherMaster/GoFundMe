require("@nomicfoundation/hardhat-toolbox");
require("@chainlink/env-enc").config();
require("@nomicfoundation/hardhat-verify");

const SEPOLIA_URL = process.env.SEPOLIA_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

console.log("SEPOLIA_URL:", SEPOLIA_URL ? "Unset" : "Set");
console.log("PRIVATE_KEY:", PRIVATE_KEY ? "Unset" : "Set");
console.log("ETHERSCAN_API_KEY:", ETHERSCAN_API_KEY ? "Unset" : "Set");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: SEPOLIA_URL,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: { sepolia: ETHERSCAN_API_KEY },
  },
};
