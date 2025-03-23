const { ethers } = require("hardhat");

async function main() {
  // create factory
  const fundMeFactory = await ethers.getContractFactory("GoFundMe");
  // deploy contract from factory with required constructor arguments
  const priceFeedAddress = "0x694AA1769357215DE4FAC081bf1f309aDC325306";
  const fundMe = await fundMeFactory.deploy(priceFeedAddress);

  console.log("Deploying contract...");
  await fundMe.waitForDeployment();
  console.log(
    "Contract has been deployed successfully, contract address is " +
      fundMe.target
  );
  // 等待5个区块确认
  console.log("Waiting for 5 block confirmations...");
  const deploymentTransaction = await fundMe.deploymentTransaction();
  await deploymentTransaction.wait(5);
  console.log("Contract deployment confirmed, proceeding with verification...");

  // 验证合约
  try {
    await hre.run("verify:verify", {
      address: fundMe.target,
      constructorArguments: [priceFeedAddress],
    });
    console.log("Contract verified successfully");
  } catch (error) {
    console.error("Verification failed:", error.message);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
