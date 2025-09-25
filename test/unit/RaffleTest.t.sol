// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {Vm} from "forge-std/Vm.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract RaffleTest is Test {
    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint32 callbackGasLimit;
    uint256 subscriptionId;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

    /*Events*/
    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        entranceFee = config.entranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gasLane = config.gasLane;
        callbackGasLimit = config.callbackGasLimit;
        subscriptionId = config.subscriptionId;

        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
    }

    function testRaffleInitializesInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    function testRaffleRevertsWhenYouDontPayEnough() public {
        // Arrange
        vm.prank(PLAYER);

        // Act / Accert
        vm.expectRevert(Raffle.Raffle__SendMoreToEnterRaffle.selector);
        raffle.enterRaffle();
    }

    function testRaffleRecordsPlayersWhenTheyEnter() public {
        // Arrange
        vm.prank(PLAYER);
        // Act
        raffle.enterRaffle{value: entranceFee}();
        // Assert
        address playerRecorded = raffle.getPlayer(0);
        assert(playerRecorded == PLAYER);
    }

    function testEmitsEventOnEntrance() public {
        // Arrange
        vm.prank(PLAYER);

        // Act / Assert
        vm.expectEmit(true, false, false, false, address(raffle));
        emit RaffleEntered(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
    }

    function testDontAllowPlayersToEnterWhileRaffleIsCalculating() public {
        // Arrange
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1); //time in seconds i.e interval seconds +1 second
        vm.roll(block.number + 1);
        raffle.performUpkeep("");
        // Act / Assert
        vm.expectRevert(Raffle.Raffle__RaffleNotOpen.selector);
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
    }

    //check upkeep //
    function testCheckUpkeepReturnsFalseIfNoBalance() public {
        // Arrange
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        // Act
        (bool upkeepNeeded, ) = raffle.checkUpkeep("");
        // Assert
        assert(!upkeepNeeded);
    }

    function testCheckUpkeepReturnsFalseIfRaffleNotOpen() public {
        // Arrange
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        raffle.performUpkeep("");
        // Act
        (bool upkeepNeeded, ) = raffle.checkUpkeep("");
        // Assert
        assert(!upkeepNeeded);
    }

    //PERFORM UPKEEP//

    function testPerformUpkeepCanOnlyRunIfCheckUpkeepIsTrue() public {
    // Arrange
    vm.prank(PLAYER);
    raffle.enterRaffle{value: entranceFee}();
    vm.warp(block.timestamp + interval + 1);
    vm.roll(block.number + 1);

    // Act / Assert
    // It doesnt revert
    raffle.performUpkeep("");
}

function testPerformUpkeepRevertsIfCheckUpkeepIsFalse() public {
    // Arrange
    uint256 currentBalance = 0;
    uint256 numPlayers = 0;
    Raffle.RaffleState rState = raffle.getRaffleState();
    // Act / Assert
    vm.expectRevert(
        abi.encodeWithSelector(
            Raffle.Raffle__UpkeepNotNeeded.selector,
            currentBalance,
            numPlayers,
            rState
        )
    );
    raffle.performUpkeep("");
}


modifier raffleEntred() {
    vm.prank(PLAYER);
    raffle.enterRaffle{value: entranceFee}();
    vm.warp(block.timestamp + interval + 1);
    vm.roll(block.number + 1);
    _;
}


function testPerformUpkeepUpdatesRaffleStateAndEmitsRequestId() public raffleEntred {
    // Arrange

    // Act
    vm.recordLogs();
    raffle.performUpkeep(""); // emits requestId
    Vm.Log[] memory entries = vm.getRecordedLogs();
    bytes32 requestId = entries[1].topics[1];

    // Assert
    Raffle.RaffleState raffleState = raffle.getRaffleState();
    // requestId = raffle.getLastRequestId();
    assert(uint256(requestId) > 0);
    assert(uint(raffleState) == 1); // 0 = open, 1 = calculating
}

      //FULFILLRANDOM WORDS//

    function testFulfillRandomWordsCanOnlyBeCalledAfterPerformUpkeep(uint256 randomRequestId)
    public
    RaffleEntered
{
    // Arrange
    // Act / Assert
    vm.expectRevert(VRFCoordinatorV2_5Mock.InvalidRequest.selector);
    // vm.mockCall could be used here...
    VRFCoordinatorV2_5Mock(vrfCoordinator).fulfillRandomWords(
        randomRequestId,
        address(raffle)
    );
}
function testFulfillRandomWordsPicksAWinnerResetsAndSendsMoney() public raffleEnteredAndTimePassed {
    // Arrange

    uint256 additionalEntrants = 3;
    uint256 startingIndex = 1;
    address expectedWinner = address(1);

    for (uint256 i = startingIndex; i < startingIndex + additionalEntrants; i++) {
        address player = address(uint160(i));
        hoax(player, 1 ether);
        raffle.enterRaffle{value: entranceFee}();
    }
    uint256 startingTimeStamp=raffle.getLastTimeStamp();
    uint256 WinnerStartingBalance = expectedWinner.balance;

    //Act
    vm.recordLogs();
    raffle.performUpkeep(""); // emits requestId
    Vm.Log[] memory entries = vm.getRecordedLogs();
    bytes32 requestId = entries[1].topics[1];

    // Pretend to be Chainlink VRF
    VRFCoordinatorV2_5Mock(vrfCoordinator).fulfillRandomWords(
        uint256(requestId),
        address(raffle)
    );

    //assert
        // Assert
    address recentWinner = raffle.getRecentWinner();
    Raffle.RaffleState raffleState = raffle.getRaffleState();
    uint256 winnerBalance = recentWinner.balance;
    uint256 endingTimeStamp = raffle.getLastTimeStamp();
    uint256 prize = entranceFee * (additionalEntrants + 1);

    assert(expectedWinner == recentWinner);
    assert(uint256(raffleState) == 0);
    assert(winnerBalance == winnerStartingBalance + prize);
    assert(endingTimeStamp > startingTimeStamp);
}
}
