// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script,console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator; 
        createSubscription(vrfCoordinator);    
    }

    function createSubscription(address vrfCoordinator) public returns (uint64) {
        //create subscription
        console.log("Creating subscription on chain ID: ", block.chainid);
        vm.startBroadcast();
        
    }

    function run() external returns (uint64) {
        return createSubscriptionUsingConfig(); 
    }
}