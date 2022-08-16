pragma solidity ^0.8.0;

contract Resources {
    enum ResourceType {
        WOOD,
        STONE,
        IRON,
        GOLD
    }

    uint256 woodPrice = 1; // Changed from 1 ether. Should match exchange rate now
    uint256 stonePrice = 1;
    uint256 ironPrice = 1;

    struct Resource {
        uint256 amount;
        uint256 replenishRate;
        uint256 lastUpdate;
        uint256 totWorkers;
        mapping(address => uint256) workersByPlayer;
    }

    Resource public wood;
    Resource public stone;
    Resource public iron;
    Resource public gold;
}
