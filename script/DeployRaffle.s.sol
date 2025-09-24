
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "./Interactions.s.sol";

contract DeployRaffle is Script {
    function run() public{
        deployContract();
    }

    function deployContract() public returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        //local -> deploy mocks,get local config
        //sepolia -> get sepolia config
        HelperConfig.NetworkConfig memory config=helperConfig.getConfig();
        
        if (config.subscriptionId == 0) {
            // create subscription
            CreateSubscription createSubscription = new CreateSubscription();
            (config.subscriptionId,config.vrfCoordinator) = createSubscription.createSubscription(
                config.vrfCoordinator
            );
            // fund subscription
            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription(
                config.vrfCoordinator,
                config.subscriptionId,
                config.link
            );
            // config.subscriptionId = subscriptionId;

        }

        vm.startBroadcast();

        Raffle raffle = new Raffle(
            config.entranceFee,
            config.interval,
            config.vrfCoordinator,
            config.subscriptionId,
            config.gasLane,
            config.callbackGasLimit
        );
        vm.stopBroadcast();
        
        // add consumer
        AddConsumer addConsumer = new AddConsumer();
        addConsumer.addConsumer(
            config.vrfCoordinator,
            config.subscriptionId,
            address(raffle)
        );
        return (raffle, helperConfig);
    }
}