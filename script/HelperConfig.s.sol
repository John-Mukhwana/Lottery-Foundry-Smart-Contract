// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct NetworkConfig{
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint32 callbackGasLimit;
        uint256 subscriptionId;
    }
    
    NetworkConfig public localNetworkConfig;
    mapping(uint256 => NetworkConfig) public networkConfigs;
    
    constructor() {
        function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
            return NetworkConfig({
                entranceFee: 0.01 ether,//1e16
                interval: 30,// 30 seconds
                vrfCoordinator: 0x5C210eF41CD1a72de73bF76eC39637bB0d3d7BEE,
                gasLane: 0x9e1344a1247c8a1785d0a4681a27152bffdb43666ae5bf7d14d24a5efd44bf71,
                callbackGasLimit: 500000,
                subscriptionId: 0
            });
        }
    }

    function getLocalConfig() public pure returns(NetworkConfig memory){
        return NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30, //30 seconds
            vrfCoordinator: address(0),
            gasLane: "",
            callbackGasLimit: 500000,
            subscriptionId: 0
        });
    }
}