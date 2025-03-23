# GoFundMe DApp
[![English](https://img.shields.io/badge/Language-English-brightgreen)](https://github.com/QuantumCipherMaster/GoFundMe/blob/main/README_EN.md)

一个基于以太坊的去中心化众筹平台，支持 ETH 募资和代币奖励机制。

## 项目简介

这是一个运行在以太坊网络上的去中心化众筹应用，允许项目创建者发起众筹活动，支持者可以使用ETH进行投资，并获得相应的代币奖励。项目利用智能合约确保资金的透明度和安全性。

## 技术栈

- Solidity: 智能合约开发
- Hardhat: 开发、测试和部署框架
- Chainlink: 价格预言机集成
- OpenZeppelin: 安全合约标准
- Ethers.js: 前端区块链交互库

## 主要功能

### GoFundMe 合约
- 支持 ETH 众筹，使用 Chainlink 预言机进行 USD 价格转换
- 最低募资金额: 1 USD
- 目标金额: 1000 USD
- 募资期限: 30天
- 支持紧急暂停
- 募资失败可退款

### FundTokenERC20 合约
- 为贡献者提供 ERC20 代币奖励
- 代币数量与贡献金额挂钩
- 支持代币销毁机制

## 安装指南

1. 克隆仓库
```bash
git clone https://github.com/QuantumCipherMaster/GoFundMe.git
cd GoFundMe
```

2. 安装依赖
```bash
npm install
```

3. 编译合约
```bash
npx hardhat compile
```

## 使用方法

1. 部署 GoFundMe 合约:
```solidity
constructor(address priceFeedAddress)
```
- `priceFeedAddress`: Chainlink ETH/USD 价格预言机地址
  - Sepolia: 0x694AA1769357215DE4FAC081bf1f309aDC325306
  - Mainnet: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419

2. 部署 FundTokenERC20 合约:
```solidity
constructor(address fundMeAddr)
```
- `fundMeAddr`: 已部署的 GoFundMe 合约地址

3. 参与众筹:
```solidity
function fund() external payable
```

4. 查询众筹状态:
```solidity
function isFundingSuccessful() external view returns (bool)
```

5. 铸造奖励代币:
```solidity
function mint(uint256 amountToMint) external
```

## 测试

运行测试套件:
```bash
npx hardhat test
```

测试特定合约:
```bash
npx hardhat test test/GoFundMe.test.js
```

## 部署到测试网

1. 配置环境变量（创建 `.env` 文件）:
```
PRIVATE_KEY=your_private_key
SEPOLIA_RPC_URL=your_sepolia_rpc_url
ETHERSCAN_API_KEY=your_etherscan_api_key
```

2. 执行部署脚本:
```bash
npx hardhat run scripts/deploy.js --network sepolia
```

## 安全特性

- 重入攻击防护
- 价格预言机集成
- 紧急暂停机制
- 事件日志记录
- 精确的错误处理

## 贡献指南

1. Fork 该仓库
2. 创建您的功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交您的更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 打开一个 Pull Request

## 许可证

该项目采用 MIT 许可证 - 详情请查看 [LICENSE](LICENSE) 文件
