
//SPDX-License-Identifier:MIT

pragma solidity 0.8.30;


/**
 * @title Raffle contract
 * @author cypherpulse.base.eth
 * @notice This contract implements a simple raffle system.
 * @dev implements Chainlink VRFv2.5
 */


contract Raffle{

    uint256 public i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }
    
    function enterRaffle() public payable{
        // Logic for entering the raffle

    }

    function pickWinner() public {}

   /*Getter Functions*/
   function getEntranceFee() external view returns (uint256) {
       return i_entranceFee;
   }

   
}