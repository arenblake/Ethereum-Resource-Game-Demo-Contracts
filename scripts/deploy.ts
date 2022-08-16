import { ethers } from "hardhat";

async function main() {
  // We get the contract to deploy
  const Game = await ethers.getContractFactory("Game");
  let game = await Game.deploy();
  await game.deployed();

  console.log("Game deployed to:", game.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
