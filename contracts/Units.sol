pragma solidity ^0.8.0;

import './Resources.sol';

contract Units is Resources {

    uint workerSpawnTime = 60 * 1;

    struct Worker {
        bool isWorker;
        bool isAvail;
        uint timeDeployed;
        ResourceType resourceType;
        uint harvestRate;
    }
}