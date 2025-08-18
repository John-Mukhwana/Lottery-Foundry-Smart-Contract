# Learning Log

## Key Concepts and Commands Learned

### Solidity
- NatSpec comments: Used for documentation (`@title`, `@author`, `@notice`)
- Constructor: Initializes contract state at deployment
- block.timestamp: Current block's timestamp for time-based logic

### Raffle Contract
- Structure: Errors, State Variables, Events, Constructor, Functions
- Example:

```solidity
contract Raffle {
	error Raffle_NotEnoughEthSent();
	uint256 private immutable i_entranceFee;
	uint256 private immutable i_interval;
	address payable[] private s_players;
	uint256 private s_lastTimeStamp;
	event RaffleEntered(address indexed player);
	constructor(uint256 entranceFee, uint256 interval) {
		i_entranceFee = entranceFee;
		i_interval = interval;
		s_lastTimeStamp = block.timestamp;
	}
	function enterRaffle() external payable {
		if (msg.value < i_entranceFee) revert Raffle_NotEnoughEthSent();
		s_players.push(payable(msg.sender));
		emit RaffleEntered(msg.sender);
	}
	function pickWinner() external {
		if (block.timestamp - s_lastTimeStamp < i_interval) revert();
	}
	function getEntranceFee() external view returns (uint256) {
		return i_entranceFee;
	}
}
```

### Foundry Commands
- forge build
- forge test
- forge fmt
- forge snapshot
- anvil
- forge script ...
- cast <subcommand>
- git remote add/set-url origin ...
- git add . && git commit -m "..."
- git push origin master

### Git Troubleshooting
- Error: remote origin already exists → use `git remote set-url origin <url>`
- Error: src refspec master does not match any → make a commit first

---

## Chronological Log

1. Initialized repository and set remote.
2. Learned about submodules and embedded repos.
3. Fixed git errors and pushed initial commit.
4. Explored contract structure and NatSpec comments.
5. Learned about constructors and block.timestamp.
6. Implemented basic Raffle contract.
7. Documented common Foundry and git commands.