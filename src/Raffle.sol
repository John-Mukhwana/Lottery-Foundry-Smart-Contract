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


/**
 * @title Raffle contract
 * @author cypherpulse.base.eth
 * @notice This contract implements a simple raffle system.
 * @dev implements Chainlink VRFv2.5
 */


contract Raffle{

    /*Errors*/
    error Raffle_NotEnoughEthSent();

    /*state Variaable*/
    uint256 private immutable i_entranceFee;

    address payable[] private s_players;

    /*Events*/
    event EnteredRaffle(address indexed player);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    /*External And Public Functions*/
    function enterRaffle() external payable{
        // Logic for entering the raffle
        // require(msg.value >= i_entranceFee, "Not Enough ETH sent!");
        
        if(msg.value < i_entranceFee) revert Raffle_NotEnoughEthSent();
        s_players.push(payable(msg.sender));
    }

    function pickWinner() public {}

   /**
    * Getter Functions
    * View and Pure Functions
    */
   function getEntranceFee() external view returns (uint256) {
       return i_entranceFee;
   }


}