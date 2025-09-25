// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script,console} from "forge-std/Script.sol";
import {HelperConfig, CodeConstants} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint256,address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator; 
        address account = helperConfig.getConfig().account;
        (uint256 subId,) = createSubscription(vrfCoordinator,account);
        return (subId,vrfCoordinator);  
    }

    function createSubscription(address vrfCoordinator,address account) public returns (uint256,address) {
        //create subscription
        console.log("Creating subscription on chain ID: ", block.chainid);
        vm.startBroadcast(account);
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
    function fundSubscriptionUingConfig() public{
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator; 
        uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
        address linkToken = helperConfig.getConfig().link;
        address account = helperConfig.getConfig().account;
        fundSubscription(vrfCoordinator,subscriptionId,linkToken,accoun);
    }
    function fundSubscription(address vrfCoordinator, uint256 subscriptionId, address linkToken, address account) public{
        console.log("Funding subscription :",subscriptionId);
        console.log("Using VRF Coordinator :",vrfCoordinator);
        console.log("On chain ID :",block.chainid);

        if(block.chainid == LOCAL_CHAIN_ID){
            //fund using mock
            vm.startBroadcast(co);
            VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(
                subscriptionId,
                FUND_AMOUNT*100
            );
            vm.stopBroadcast();
            console.log("Funded with ", FUND_AMOUNT / 1e18, " LINK");
        }else{
            //fund using link token on sepolia
            vm.startBroadcast(account);
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
contract AddConsumer is Script {
    function addConsumer(address contractToAddToVrf, address vrfCoordinator, uint256 subId, address account) public {
        console.log("Adding consumer contract: ", contractToAddToVrf);
        console.log("Using vrfCoordinator: ", vrfCoordinator);
        console.log("On ChainID: ", block.chainid);
        vm.startBroadcast(account);
        VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(subId, contractToAddToVrf);
        vm.stopBroadcast();
    }

    function addConsumerUsingConfig(address mostRecentlyDeployed) public {
        HelperConfig helperConfig = new HelperConfig();
        uint256 subId = helperConfig.getConfig().subscriptionId;
        address vrfCoordinatorV2_5 = helperConfig.getConfig().vrfCoordinatorV2_5;
        address account = helperConfig.getConfig().account;
        addConsumer(mostRecentlyDeployed, vrfCoordinatorV2_5, subId, account);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("Raffle", block.chainid);
        addConsumerUsingConfig(mostRecentlyDeployed);
    }
}