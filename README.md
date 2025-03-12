# GoFundMe DApp

一个基于以太坊的去中心化众筹平台，支持 ETH 募资和代币奖励机制。

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

## 安全特性

- 重入攻击防护
- 价格预言机集成
- 紧急暂停机制
- 事件日志记录
- 精确的错误处理