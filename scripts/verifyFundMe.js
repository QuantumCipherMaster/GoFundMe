const { ethers } = require("hardhat");

async function main() {
  // 替换为您已部署的合约地址
  const contractAddress = process.argv[2];

  if (!contractAddress) {
    console.error("请提供合约地址作为参数");
    process.exit(1);
  }

  console.log(`正在验证地址为 ${contractAddress} 的合约...`);

  // 验证合约
  try {
    await hre.run("verify:verify", {
      address: contractAddress,
      constructorArguments: ["0x694AA1769357215DE4FAC081bf1f309aDC325306"],
    });
    console.log("合约验证成功！");
  } catch (error) {
    console.error("验证失败:", error.message);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
