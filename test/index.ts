import { expect } from "chai";
import { Contract, Signer } from "ethers";
import { ethers } from "hardhat";

let accounts: Signer[];
let dev: Signer;
let testUsers: Signer[];
let game: Contract;

describe("Game", function () {
  before(async () => {
    // const TestCoin = await ethers.getContractFactory("Coin");
    // testCoin = await TestCoin.deploy();
    // await testCoin.deployed();
    accounts = await ethers.getSigners();
    [dev, ...testUsers] = accounts;
  });

  it("Should join game", async function () {
    const Game = await ethers.getContractFactory("Game");
    game = await Game.deploy();
    await game.deployed();

    await game.joinGame();
    let house = await game.getHouse(await dev.getAddress(), 0);
    expect(await house.capacity).to.equals("3");
  });

  it("Should gather resources", async function () {
    await game.gatherResource(0, [0]);
    let worker = await game.getWorker(await dev.getAddress(), 0);
    expect(worker.isAvail).to.equals(false);
  });

  it("Should harvest resources", async function () {
    let block = ethers.provider.getBlockNumber();
    let blockTS = ethers.provider.getBlock(block);
    let hour = 60 * 60;
    await ethers.provider.send("evm_mine", [(await blockTS).timestamp + hour]);
    await game.recallWorkers([0]);
    // console.log(game.filters.RecallWorkers());
    let playerResources = await game.playerResources(await dev.getAddress());
    console.log(ethers.utils.formatEther(playerResources.wood));
    let wood = await game.wood();
    console.log(ethers.utils.formatEther(wood.amount));
  });

  it("Should build a house", async function () {
    await game.gatherResource(1, [0]);
    let block = ethers.provider.getBlockNumber();
    let blockTS = ethers.provider.getBlock(block);
    let hour = 60 * 60;
    await ethers.provider.send("evm_mine", [(await blockTS).timestamp + hour]);
    await game.recallWorkers([0]);
    await game.buildHouse();
    let house = await game.getHouse(await dev.getAddress(), 1);
    expect(await house.capacity).to.equals("3");
  });
});
