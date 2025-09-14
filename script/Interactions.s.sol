// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script,console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator; 
        createSubscription(vrfCoordinator);
        return (subId,vrfCoordinator);  
    }

    function createSubscription(address vrfCoordinator) public returns (uint256,address) {
        //create subscription
        console.log("Creating subscription on chain ID: ", block.chainid);
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordinator).createSubscription();
        vm.stopBroadcast();

        console.log("Your subscription ID is: ", subId);
        console.log("Please update the subscriptionId in the HelperConfig.s.sol file");
        return (subId,vrfCoordinator);
    }

    function run() external returns (uint64) {
        return createSubscriptionUsingConfig(); 
    }
}