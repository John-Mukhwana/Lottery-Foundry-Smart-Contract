// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;

        //create subscription
    }
    
    function createSubscription(address vrfCoordinator) public returns (uint64) {
        //create subscription
    }

    function run() external returns (uint64) {
        return createSubscriptionUsingConfig(); 
    }
}