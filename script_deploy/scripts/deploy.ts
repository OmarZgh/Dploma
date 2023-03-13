import {ethers} from "hardhat";


async function main() {

  const factory = await ethers.getContractFactory("Dploma");
  const deploy = await factory.deploy();

  await deploy.deployed();

  console.log(
    `Dploma deployed to ${deploy.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
