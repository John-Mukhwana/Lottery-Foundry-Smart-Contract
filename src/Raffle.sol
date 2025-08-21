// Layout of the contract file:
// version
// imports
// errors
// interfaces, libraries, contract

// Inside Contract:
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title Raffle contract
 * @author cypherpulse.base.eth
 * @notice This contract implements a simple raffle system.
 * @dev implements Chainlink VRFv2.5
 */
contract Raffle is VRFConsumerBaseV2Plus {
    /*Errors*/
    error Raffle_NotEnoughEthSent();

    /*state Variaable*/
    uint256 private immutable i_entranceFee;
    //@dev Duration of the lottery in seconds
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /*Events*/
    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee, uint256 interval, address vrfCoordinator) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    /*External And Public Functions */
    function enterRaffle() external payable {
        // Logic for entering the raffle
        // require(msg.value >= i_entranceFee, "Not Enough ETH sent!");

        if (msg.value < i_entranceFee) revert Raffle_NotEnoughEthSent();
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

    //1. Get a random number
    //2. Use random number to pick a winner
    //3. Be automatically called after the interval
    /**
     * @dev This function can only be called after the interval has passed
     */
    function pickWinner() external {
        //check to see if enough time has passed
        if (block.timestamp - s_lastTimeStamp < i_interval) revert();

        //Get our random number 2.5
    }

    /**
     * Getter Functions
     * View and Pure Functions
     */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
