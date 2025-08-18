# Learning Log

## Key Concepts and Commands Learned

### Solidity
- NatSpec comments: Used for documentation (`@title`, `@author`, `@notice`)
- Constructor: Initializes contract state at deployment
- block.timestamp: Current block's timestamp for time-based logic

### Raffle Contract
- Structure: Errors, State Variables, Events, Constructor, Functions
+- Example Structure:

```
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