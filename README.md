# Foundry Fund Me

A smart contract project built with [Foundry](https://book.getfoundry.sh/) that allows users to fund the contract with ETH, and allows the contract owner to withdraw funds. Includes unit, integration, and forked tests using Chainlink price feeds and Foundry's testing framework.

---

## Features

- Accepts ETH from multiple users
- Enforces minimum funding in USD using Chainlink ETH/USD price feed
- Allows only the owner to withdraw
- Uses fallback/receive for direct ETH sends
- Chainlink AggregatorV3Interface for price conversion
- Written and tested using **Foundry**
- CI-ready structure with `script/`, `src/`, `test/`, `lib/`, and `.github/workflows/`

---

## Foundry Tests

- Unit tests for contract logic
- Integration tests using mock price feeds
- Forked network tests against Sepolia or Mainnet
- Gas snapshot and fuzzing support

---

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) (`forge`, `cast`)
- [Node.js](https://nodejs.org/) (optional for scripts)
- [Git](https://git-scm.com/)
- `.env` file with:
  ```env
  PRIVATE_KEY=your_private_key
  RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_ALCHEMY_KEY
  ETHERSCAN_API_KEY=your_etherscan_key
  ```

---

## Commands

### Compile Contracts

```bash
forge build
```

### Run Tests

```bash
forge test -vv
```

Run a specific test:

```bash
forge test --mt testFunctionName
```

### Run Forked Test (Sepolia)

```bash
forge test --fork-url $SEPOLIA_RPC_URL
```

### Deploy Locally

```bash
anvil
```

In a second terminal:

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://localhost:8545 --broadcast
```

### Deploy to Sepolia

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

---

## 📁 Project Structure

```
foundry-fund-me-f23/
├── lib/                    # Dependencies (Chainlink, forge-std)
├── script/                 # Deploy and interaction scripts
├── src/                    # Main smart contract(s)
├── test/                   # Test files (unit, forked, integration)
├── .env                    # Secrets (not committed)
├── foundry.toml            # Foundry config
└── README.md               # This file
```

---

## Security Note

**Do not commit your `.env` file**. Add it to `.gitignore`:

```
.env
```

Never share or push your private keys.

---

## Credits

- Based on a Solidity + Foundry smart contract course by [Cyfrin](https://github.com/Cyfrin)
- Chainlink Price Feed integration from official docs
- Build and tests structured for real-world DApp dev

---

## License

MIT License. Use freely with attribution.
