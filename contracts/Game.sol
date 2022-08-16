// TODO: Convert Resources to ERC-20 tokens

pragma solidity ^0.8.0;

import "./Buildings.sol";
import "./Units.sol";

contract Game is Buildings, Units {
    // event RecallWorkers(uint256[] indexed _workers);

    struct PlayerResources {
        bool isPlayer;
        uint256 wood;
        uint256 stone;
        uint256 iron;
        uint256 gold;
        uint256 lastSpawn;
        mapping(uint256 => Worker) workers;
        mapping(uint256 => House) houses;
        uint256 housingCapacity;
        mapping(uint256 => Farm) farms;
        mapping(uint256 => Barrack) barracks;
        mapping(uint256 => TradingPost) tradingPosts;
    }

    mapping(address => PlayerResources) public playerResources;

    constructor() {
        wood.amount = 1000 ether;
        wood.replenishRate = 100 ether;
        wood.lastUpdate = block.timestamp;

        stone.amount = 1000 ether;
        stone.replenishRate = 100 ether;
        stone.lastUpdate = block.timestamp;

        iron.amount = 1000 ether;
        iron.replenishRate = 100 ether;
        iron.lastUpdate = block.timestamp;
    }

    function joinGame() public {
        require(playerResources[msg.sender].isPlayer == false);
        playerResources[msg.sender].isPlayer = true;
        playerResources[msg.sender].lastSpawn = block.timestamp;
        playerResources[msg.sender].workers[0].isWorker = true;
        playerResources[msg.sender].workers[0].isAvail = true;
        playerResources[msg.sender].workers[0].harvestRate = 1 ether;
        playerResources[msg.sender].houses[0].capacity = houseCapacity;
        playerResources[msg.sender].housingCapacity = houseCapacity - 1;
        playerResources[msg.sender].gold = 100 ether;

        playerResources[msg.sender].tradingPosts[0].hp = tradingPostHP;
    }

    function gatherResource(ResourceType _resource, uint256[] memory _workers)
        public
    {
        for (uint256 i = 0; i < _workers.length; i++) {
            if (
                playerResources[msg.sender].workers[_workers[i]].isAvail == true
            ) {
                playerResources[msg.sender]
                    .workers[_workers[i]]
                    .isAvail = false;
                playerResources[msg.sender]
                    .workers[_workers[i]]
                    .timeDeployed = block.timestamp;
                playerResources[msg.sender]
                    .workers[_workers[i]]
                    .resourceType = _resource;
            }
        }
    }

    function recallWorkers(uint256[] memory _workers) public {
        updateResources();
        for (uint256 i = 0; i < _workers.length; i++) {
            harvest(playerResources[msg.sender].workers[_workers[i]]);
            playerResources[msg.sender].workers[_workers[i]].isAvail = true;
        }
        // emit RecallWorkers(_workers);
    }

    function buildHouse() public {
        require(
            playerResources[msg.sender].gold >= 100 ether,
            "Not enough gold"
        );
        require(
            playerResources[msg.sender].wood >= 1000 ether,
            "Not enough wood"
        );
        require(
            playerResources[msg.sender].stone >= 1000 ether,
            "Not enough stone"
        );
        playerResources[msg.sender].gold =
            playerResources[msg.sender].gold -
            100 ether;
        playerResources[msg.sender].wood =
            playerResources[msg.sender].wood -
            1000 ether;
        playerResources[msg.sender].stone =
            playerResources[msg.sender].stone -
            1000 ether;
        uint256 house = 0;
        while (playerResources[msg.sender].houses[house].capacity > 0) {
            house++;
        }
        playerResources[msg.sender].houses[house].capacity = houseCapacity;
        playerResources[msg.sender].houses[house].hp = houseHP;
        playerResources[msg.sender].housingCapacity =
            playerResources[msg.sender].housingCapacity +
            houseCapacity;
    }

    function buildFarm() public {
        require(
            playerResources[msg.sender].gold >= 500 ether,
            "Not enough gold"
        );
        require(
            playerResources[msg.sender].wood >= 2000 ether,
            "Not enough wood"
        );
        require(
            playerResources[msg.sender].stone >= 2000 ether,
            "Not enough stone"
        );
        require(
            playerResources[msg.sender].iron >= 500 ether,
            "Not enough iron"
        );
        playerResources[msg.sender].gold =
            playerResources[msg.sender].gold -
            500 ether;
        playerResources[msg.sender].wood =
            playerResources[msg.sender].wood -
            2000 ether;
        playerResources[msg.sender].stone =
            playerResources[msg.sender].stone -
            2000 ether;
        playerResources[msg.sender].iron =
            playerResources[msg.sender].iron -
            500 ether;
        uint256 farm = 0;
        while (playerResources[msg.sender].farms[farm].productionRate > 0) {
            farm++;
        }
        playerResources[msg.sender].farms[farm].productionRate = farmProdRate;
        playerResources[msg.sender].farms[farm].hp = farmHP;
    }

    function buildBarrak() public {
        require(
            playerResources[msg.sender].gold >= 2000 ether,
            "Not enough gold"
        );
        require(
            playerResources[msg.sender].wood >= 8000 ether,
            "Not enough wood"
        );
        require(
            playerResources[msg.sender].stone >= 10000 ether,
            "Not enough stone"
        );
        require(
            playerResources[msg.sender].iron >= 4000 ether,
            "Not enough iron"
        );
        playerResources[msg.sender].gold =
            playerResources[msg.sender].gold -
            2000 ether;
        playerResources[msg.sender].wood =
            playerResources[msg.sender].wood -
            8000 ether;
        playerResources[msg.sender].stone =
            playerResources[msg.sender].stone -
            10000 ether;
        playerResources[msg.sender].iron =
            playerResources[msg.sender].iron -
            4000 ether;
        uint256 barrack = 0;
        while (
            playerResources[msg.sender].barracks[barrack].productionTime > 0
        ) {
            barrack++;
        }
        playerResources[msg.sender]
            .barracks[barrack]
            .productionTime = barrackProdTime;
        playerResources[msg.sender]
            .barracks[barrack]
            .productionCost = barrackProdCost;
        playerResources[msg.sender].barracks[barrack].hp = barrackHP;
    }

    function trade(ResourceType _resource, uint256 _amount) public {
        require(playerResources[msg.sender].tradingPosts[0].hp > 0);
        if (_resource == ResourceType.WOOD) {
            require(playerResources[msg.sender].wood >= _amount);
            playerResources[msg.sender].wood =
                playerResources[msg.sender].wood -
                _amount;
            playerResources[msg.sender].gold =
                playerResources[msg.sender].gold +
                _amount *
                woodPrice;
        }
        if (_resource == ResourceType.STONE) {
            require(playerResources[msg.sender].stone >= _amount);
            playerResources[msg.sender].stone =
                playerResources[msg.sender].stone -
                _amount;
            playerResources[msg.sender].gold =
                playerResources[msg.sender].gold +
                _amount *
                stonePrice;
        }
        if (_resource == ResourceType.IRON) {
            require(playerResources[msg.sender].iron >= _amount);
            playerResources[msg.sender].iron =
                playerResources[msg.sender].iron -
                _amount;
            playerResources[msg.sender].gold =
                playerResources[msg.sender].gold +
                _amount *
                ironPrice;
        }
    }

    function spawnWorker() public {
        require(
            block.timestamp - playerResources[msg.sender].lastSpawn >=
                workerSpawnTime
        );
        require(playerResources[msg.sender].housingCapacity > 0);
        uint256 worker;
        while (playerResources[msg.sender].workers[worker].isWorker == true) {
            worker++;
        }
        playerResources[msg.sender].workers[worker].isWorker = true;
        playerResources[msg.sender].workers[worker].isAvail = true;
        playerResources[msg.sender].workers[worker].harvestRate = 1 ether;
        playerResources[msg.sender].housingCapacity--;
        playerResources[msg.sender].lastSpawn = block.timestamp;
    }

    function updateResources() internal {
        uint256 timefactor = block.timestamp - wood.lastUpdate;
        wood.amount = wood.amount + (wood.replenishRate * timefactor);
        stone.amount = stone.amount + (stone.replenishRate * timefactor);
        iron.amount = iron.amount + (iron.replenishRate * timefactor);
    }

    // TODO: Refactor this :(
    function harvest(Worker storage _worker) internal {
        uint256 timefactor = block.timestamp - _worker.timeDeployed;
        uint256 amtToHarvest = timefactor * _worker.harvestRate;

        if (_worker.resourceType == ResourceType.WOOD) {
            if (wood.amount < amtToHarvest) {
                amtToHarvest = wood.amount;
                wood.amount = 0;
                playerResources[msg.sender].wood =
                    playerResources[msg.sender].wood +
                    amtToHarvest;
            } else {
                wood.amount = wood.amount - amtToHarvest;
                playerResources[msg.sender].wood =
                    playerResources[msg.sender].wood +
                    amtToHarvest;
            }
        }

        if (_worker.resourceType == ResourceType.STONE) {
            if (stone.amount < amtToHarvest) {
                amtToHarvest = stone.amount;
                stone.amount = 0;
                playerResources[msg.sender].stone =
                    playerResources[msg.sender].stone +
                    amtToHarvest;
            } else {
                stone.amount = stone.amount - amtToHarvest;
                playerResources[msg.sender].stone =
                    playerResources[msg.sender].stone +
                    amtToHarvest;
            }
        }

        if (_worker.resourceType == ResourceType.IRON) {
            if (iron.amount < amtToHarvest) {
                amtToHarvest = iron.amount;
                iron.amount = 0;
                playerResources[msg.sender].iron =
                    playerResources[msg.sender].iron +
                    amtToHarvest;
            } else {
                iron.amount = iron.amount - amtToHarvest;
                playerResources[msg.sender].iron =
                    playerResources[msg.sender].iron +
                    amtToHarvest;
            }
        }
    }

    function getWorker(address _player, uint256 _worker)
        public
        view
        returns (Worker memory)
    {
        return playerResources[_player].workers[_worker];
    }

    function getHouse(address _player, uint256 _house)
        public
        view
        returns (House memory)
    {
        return playerResources[_player].houses[_house];
    }
}
