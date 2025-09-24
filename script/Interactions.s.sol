// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script,console} from "forge-std/Script.sol";
import {HelperConfig, CodeConstants} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint256,address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator; 
        (uint256 subId,) = createSubscription(vrfCoordinator);
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

    function run() public returns (uint256, address) {
        return createSubscriptionUsingConfig(); 
    }
}

contract FundSubscription is Script,CodeConstants{
    uint256 public constant FUND_AMOUNT = 3 ether; //3 Link
    function fundSubscription() public{
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator; 
        uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
        address linkToken = helperConfig.getConfig().link;
        fundSubscription(vrfCoordinator,subscriptionId,linkToken);
    }
    function fundSubscription(address vrfCoordinator, uint256 subscriptionId, address linkToken) public{
        console.log("Funding subscription :",subscriptionId);
        console.log("Using VRF Coordinator :",vrfCoordinator);
        console.log("On chain ID :",block.chainid);

        if(block.chainid == LOCAL_CHAIN_ID){
            //fund using mock
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(
                subscriptionId,
                FUND_AMOUNT
            );
            vm.stopBroadcast();
            console.log("Funded with ", FUND_AMOUNT / 1e18, " LINK");
        }else{
            //fund using link token on sepolia
            vm.startBroadcast();
            LinkToken(linkToken).transferAndCall(
                vrfCoordinator,
                FUND_AMOUNT,
                abi.encode(subscriptionId)
            );
            vm.stopBroadcast();
            console.log("Funded with ", FUND_AMOUNT / 1e18, " LINK");
        }
        
    }
    function run()public{}
}

contract AddCosumer is Script {
    
    function addConsumer(address raffle,address vrfCoordinator,uint256 subscriptionId) public {
        console.log("Adding consumer contract :",raffle);
        console.log("Using VRFCoordinator :",vrfCoordinator);
        console.log("On chain Id :",block.chainid);

        vm.startBroadcast();
        VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(subscriptionId,raffle);
        vm.stopBroadcast();
    }

    function addConsumerUsingConfig(address raffle) public {
        HelperConfig helperConfig = new HelperConfig();
        (,,address vrfCoordinator,uint256 subscriptionId,,)=helperConfig.getConfig();
        addConsumer(raffle,vrfCoordinator,subscriptionId);
    }
    function run() external {
        address raffle = D
    }
}