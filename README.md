## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:


## Documentation

https://book.getfoundry.sh/

---

## Key Solidity Concepts Learned

- **NatSpec Comments**: Used for documentation in Solidity contracts.
- **Constructor**: Special function for initializing contract state at deployment.
- **block.timestamp**: Returns the current block's timestamp, used for time-based logic.

## Raffle Contract Structure

```solidity
contract Raffle {
	// Errors
	error Raffle_NotEnoughEthSent();

	// State Variables
	uint256 private immutable i_entranceFee;
	uint256 private immutable i_interval;
	address payable[] private s_players;
	uint256 private s_lastTimeStamp;

	// Events
	event RaffleEntered(address indexed player);

	// Constructor
	constructor(uint256 entranceFee, uint256 interval) {
		i_entranceFee = entranceFee;
		i_interval = interval;
		s_lastTimeStamp = block.timestamp;
	}

	// Enter Raffle
	function enterRaffle() external payable {
		if (msg.value < i_entranceFee) revert Raffle_NotEnoughEthSent();
		s_players.push(payable(msg.sender));
		emit RaffleEntered(msg.sender);
	}

	// Pick Winner
	function pickWinner() external {
		if (block.timestamp - s_lastTimeStamp < i_interval) revert();
	}

	// Getter
	function getEntranceFee() external view returns (uint256) {
		return i_entranceFee;
	}
}
```

---

## Common Foundry Commands

- Build: `forge build`
- Test: `forge test`
- Format: `forge fmt`
- Gas Snapshots: `forge snapshot`
- Local Node: `anvil`
- Deploy: `forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>`
- Cast: `cast <subcommand>`
- Help: `forge --help`, `anvil --help`, `cast --help`

---

## Git Tips

- To add a remote: `git remote add origin <url>`
- To change remote URL: `git remote set-url origin <url>`
- To commit all changes: `git add . && git commit -m "your message"`
- To push: `git push origin master`

---

See `learning.md` for a chronological log of concepts learned.

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
