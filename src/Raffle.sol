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

pragma solidity 0.8.30;


/**
 * @title Raffle contract
 * @author cypherpulse.base.eth
 * @notice This contract implements a simple raffle system.
 * @dev implements Chainlink VRFv2.5
 */


contract Raffle{
    
    /*state Variaable*/
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    /*External And Public Functions*/
    function enterRaffle() external payable{
        // Logic for entering the raffle
        // require(msg.value >= i_entranceFee, "Not Enough ETH sent!");
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