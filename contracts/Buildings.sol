pragma solidity ^0.8.0;

// import './Resources.sol';

contract Buildings {

    uint houseCapacity = 3;
    uint farmProdRate = 100 ether;
    uint barrackProdCost = 50 ether;
    uint barrackProdTime = 60 * 5;

    uint houseHP = 100;
    uint farmHP = 500;
    uint barrackHP = 2000;
    uint tradingPostHP = 1000;

    struct House {
        uint capacity;
        uint hp;
    }

    struct Farm {
        uint productionRate;
        bool inhabited;
        uint hp;
    }

    struct Barrack {
        uint productionCost;
        uint productionTime;
        uint hp;
    }

    struct TradingPost {
        uint hp;
    }

}