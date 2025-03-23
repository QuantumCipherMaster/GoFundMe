# GoFundMe DApp
[![中文](https://img.shields.io/badge/Language-中文-brightgreen)](https://github.com/QuantumCipherMaster/GoFundMe/blob/main/README.md)

A decentralized crowdfunding platform based on Ethereum, supporting ETH fundraising and token reward mechanisms.

## Project Overview

This decentralized crowdfunding application runs on the Ethereum network. It allows project creators to launch fundraising campaigns, enabling supporters to invest using ETH and receive token rewards. The platform uses smart contracts to ensure transparency and security of funds.

## Tech Stack

- Solidity: Smart contract development
- Hardhat: Development, testing, and deployment framework
- Chainlink: Price oracle integration
- OpenZeppelin: Secure contract standards
- Ethers.js: Frontend blockchain interaction library

## Main Features

### GoFundMe Contract
- Supports ETH crowdfunding with USD price conversion via Chainlink oracle
- Minimum funding amount: 1 USD
- Funding goal: 1000 USD
- Funding duration: 30 days
- Supports emergency pause
- Refundable if funding goal is not met

### FundTokenERC20 Contract
- Provides ERC20 token rewards to contributors
- Token amount proportional to contribution
- Supports token burning mechanism

## Installation Guide

1. Clone the repository
```bash
git clone https://github.com/QuantumCipherMaster/GoFundMe.git
cd GoFundMe
```

2. Install dependencies
```bash
npm install
```

3. Compile contracts
```bash
npx hardhat compile
```

## Usage

1. Deploy GoFundMe contract:
```solidity
constructor(address priceFeedAddress)
```
- `priceFeedAddress`: Chainlink ETH/USD price oracle address
  - Sepolia: 0x694AA1769357215DE4FAC081bf1f309aDC325306
  - Mainnet: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419

2. Deploy FundTokenERC20 contract:
```solidity
constructor(address fundMeAddr)
```
- `fundMeAddr`: Deployed GoFundMe contract address

3. Participate in crowdfunding:
```solidity
function fund() external payable
```

4. Check funding status:
```solidity
function isFundingSuccessful() external view returns (bool)
```

5. Mint reward tokens:
```solidity
function mint(uint256 amountToMint) external
```

## Testing

Run the test suite:
```bash
npx hardhat test
```

Test specific contract:
```bash
npx hardhat test test/GoFundMe.test.js
```

## Deployment to Testnet

1. Configure environment variables (create `.env` file):
```
PRIVATE_KEY=your_private_key
SEPOLIA_RPC_URL=your_sepolia_rpc_url
ETHERSCAN_API_KEY=your_etherscan_api_key
```

2. Execute deployment script:
```bash
npx hardhat run scripts/deploy.js --network sepolia
```

## Security Features

- Protection against reentrancy attacks
- Price oracle integration
- Emergency pause mechanism
- Event logging
- Precise error handling

## Contribution Guidelines

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

