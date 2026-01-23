# MLM DAO Protocol - Commission, Rank & Pool System

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.26-blue.svg)](https://soliditylang.org)
[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FF694B.svg)](https://getfoundry.sh)
[![Test Status](https://img.shields.io/badge/tests-passing-brightgreen.svg)](https://github.com)
[![Sepolia Deployed](https://img.shields.io/badge/Sepolia-Deployed-6c8ee6.svg)](https://sepolia.etherscan.io)

A complete Multi-Level Marketing (MLM) protocol with DAO treasury, commission structure, rank system, and pool distribution built on Ethereum.

## 📋 Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Contract Architecture](#contract-architecture)
- [Deployment](#deployment)
- [Testing](#testing)
- [Technical Specifications](#technical-specifications)
- [Usage Guide](#usage-guide)
- [Development](#development)
- [Security](#security)
- [License](#license)

## 📖 Overview

The MLM DAO Protocol implements a sophisticated referral and reward system with three user tiers (FREE, SEED, DEED), multi-level commissions, rank progression based on team building, and a pooled reward distribution mechanism. The protocol includes a 12-month DAO lock period for earnings, after which Founder NFTs are minted to users.

## ✨ Features

### 🎯 Core Features
- **Three User Tiers**: FREE, SEED NFT holders, DEED NFT holders
- **Multi-Level Commissions**: L1-L3 commission structure
- **Rank System**: Star 1, Star 2, Star 3 based on team DEED holders
- **Pool Distribution**: 15% of total inflow distributed hierarchically
- **DAO Treasury**: 12-month lock with Founder NFT rewards
- **Gas Optimized**: Efficient contract design with custom errors

### 📊 Commission Structure
| User Type | L1 Commission | L2 Commission | L3 Commission |
|-----------|---------------|---------------|---------------|
| FREE      | 5%            | -             | -             |
| SEED NFT  | 10%           | -             | -             |
| DEED NFT  | 20%           | 10%           | 5%            |

### 🏆 Rank Qualification
| Rank | Required DEED Holders | Pool Benefits |
|------|-----------------------|---------------|
| Star 1 | 5+ | Pool 2 (4%) |
| Star 2 | 10+ | Pools 2+3 (8%) |
| Star 3 | 20+ | Pools 2+3+4 (12%) |

### 💰 Pool Distribution (15% of total inflow)
| Pool | Allocation | Recipients |
|------|------------|------------|
| Pool 1 | 3% | All DEED NFT holders |
| Pool 2 | 4% | Star 1+ holders |
| Pool 3 | 4% | Star 2+ holders |
| Pool 4 | 4% | Star 3 holders only |

**Hierarchical Sharing:**
- Star 3: Pools 2 + 3 + 4 = 12%
- Star 2: Pools 2 + 3 = 8%
- Star 1: Pool 2 only = 4%

## 🏗️ Contract Architecture

### 📁 Project Structure
\`\`\`
src/
├── nft/
│   ├── SeedNFT.sol        # SEED NFT (10% L1 commission)
│   ├── DeedNFT.sol        # DEED NFT (multi-level commissions)
│   └── FounderNFT.sol     # Minted after 12-month DAO lock
├── core/
│   ├── UserRegistry.sol   # Referral tracking & user management
│   ├── CommissionEngine.sol # Direct commission distribution
│   ├── RankEngine.sol     # Star rank calculation
│   ├── PoolManager.sol    # Pool distribution (hierarchical)
│   └── DAOTreasury.sol    # 12-month lock + Founder NFT
├── interfaces/
│   ├── INFT.sol           # NFT interface
│   ├── IUserRegistry.sol  # User registry interface
│   └── ITreasury.sol      # Treasury interface
├── libraries/
│   ├── UserTypes.sol      # FREE/SEED/DEED enums
│   └── Percentages.sol    # All commission & pool constants
└── errors/
    └── ProtocolErrors.sol # Custom errors (gas optimized)
\`\`\`

### 🔗 Contract Relationships
\`\`\`mermaid
graph TD
    A[UserRegistry] --> B[CommissionEngine]
    A --> C[RankEngine]
    A --> D[PoolManager]
    E[DAOTreasury] --> F[FounderNFT]
    B --> E
    D --> E
    G[SeedNFT] --> A
    H[DeedNFT] --> A
\`\`\`

## 🚀 Deployment

### Sepolia Testnet Deployment
All contracts are deployed and verified on Sepolia testnet:

| Contract | Address | Etherscan |
|----------|---------|-----------|
| **MockERC20** | \`0x37783C572c52f99892789A3AD9C023Db3cd5f3BE\` | [View](https://sepolia.etherscan.io/address/0x37783C572c52f99892789A3AD9C023Db3cd5f3BE) |
| **SeedNFT** | \`0x153A30b61fAa7b4D8c27eAD9fc4b0f585CDEc468\` | [View](https://sepolia.etherscan.io/address/0x153A30b61fAa7b4D8c27eAD9fc4b0f585CDEc468) |
| **DeedNFT** | \`0x8cF231c0eD4ABacB1e9601cc06593992617b219a\` | [View](https://sepolia.etherscan.io/address/0x8cF231c0eD4ABacB1e9601cc06593992617b219a) |
| **FounderNFT** | \`0xb51cCeF7C4FCc1A0063E4f27907b90f07508119E\` | [View](https://sepolia.etherscan.io/address/0xb51cCeF7C4FCc1A0063E4f27907b90f07508119E) |
| **UserRegistry** | \`0x627AdB2CdfBc6Accf66d906Ca3a2fFafcEa359C9\` | [View](https://sepolia.etherscan.io/address/0x627AdB2CdfBc6Accf66d906Ca3a2fFafcEa359C9) |
| **DAOTreasury** | \`0xc98E63aFB782C96eb24af410c3c63091Db663a73\` | [View](https://sepolia.etherscan.io/address/0xc98E63aFB782C96eb24af410c3c63091Db663a73) |
| **CommissionEngine** | \`0xeAaDD7C8200FcC208eA126FF945F6D03a59378A0\` | [View](https://sepolia.etherscan.io/address/0xeAaDD7C8200FcC208eA126FF945F6D03a59378A0) |
| **RankEngine** | \`0x0696cc32B08A5F39b6386fb591E5acDeAD75f6c1\` | [View](https://sepolia.etherscan.io/address/0x0696cc32B08A5F39b6386fb591E5acDeAD75f6c1) |
| **PoolManager** | \`0x25B6Cd674474494c5eba2973E025ef5bf7AA2B41\` | [View](https://sepolia.etherscan.io/address/0x25B6Cd674474494c5eba2973E025ef5bf7AA2B41) |

### Deployment Script
\`\`\`bash
# Deploy to Sepolia
forge script script/DeploySepolia.s.sol:DeploySepolia \\
  --rpc-url $SEPOLIA_RPC_URL \\
  --private-key $PRIVATE_KEY \\
  --broadcast \\
  --verify \\
  --etherscan-api-key $ETHERSCAN_API_KEY \\
  -vvvv
\`\`\`

## 🧪 Testing

### Test Coverage
- ✅ **Unit Tests**: All contract functions
- ✅ **Integration Tests**: End-to-end protocol flow
- ✅ **Validation Tests**: Mathematical correctness verification
- ✅ **Edge Cases**: Zero addresses, overflow protection

### Run Tests
\`\`\`bash
# Run all tests
forge test

# Run specific test suite
forge test --match-contract ProtocolTest -vvv

# Run validation tests (critical math verification)
forge test --match-contract ValidationTest -vvv

# Generate gas report
forge test --gas-report

# Run with coverage
forge coverage
\`\`\`

### Test Results
\`\`\`
Running 3 tests for test/ValidationTest.t.sol:ValidationTest
[PASS] test_AllPercentagesMatchRequirements() (gas: 272)
[PASS] test_PoolSharingMath() (gas: 269)
[PASS] test_UserTypesCorrect() (gas: 360)
Suite result: ok. 3 passed; 0 failed; 0 skipped
\`\`\`

## 📊 Technical Specifications

### Smart Contract Details
- **Solidity Version**: 0.8.26
- **License**: MIT
- **Framework**: Foundry
- **Optimizer**: Enabled (200 runs)
- **Gas Optimization**: Custom errors, minimal storage

### Constants & Percentages
All values are in basis points (1% = 100 bps):

\`\`\`solidity
// Direct Commissions
FREE_L1 = 500    // 5%
SEED_L1 = 1000   // 10%
DEED_L1 = 2000   // 20%
DEED_L2 = 1000   // 10%
DEED_L3 = 500    // 5%

// Pool Allocation (15% total)
TOTAL_POOL = 1500 // 15%
POOL_1 = 300      // 3%
POOL_2 = 400      // 4%
POOL_3 = 400      // 4%
POOL_4 = 400      // 4%

// Rank Requirements
STAR_1_DEEDS = 5
STAR_2_DEEDS = 10
STAR_3_DEEDS = 20
\`\`\`

### Security Features
- ✅ **Access Control**: OnlyOwner modifiers on critical functions
- ✅ **Input Validation**: Zero address checks, amount validation
- ✅ **Reentrancy Protection**: No external calls in state-changing functions
- ✅ **Math Safety**: Safe math with Solidity 0.8.x overflow protection
- ✅ **Error Handling**: Custom errors for gas efficiency

## 📖 Usage Guide

### User Flow
1. **Registration**: User joins with referrer address
2. **NFT Acquisition**: User purchases SEED or DEED NFT
3. **Commission Earnings**: Referral purchases generate commissions
4. **Rank Progression**: Acquire 5/10/20 DEED referrals for Star ranks
5. **Pool Distribution**: Monthly pool distribution based on ranks
6. **DAO Lock**: Earnings locked for 12 months
7. **Founder NFT**: Minted after lock period with amount metadata

### Contract Interactions
\`\`\`solidity
// 1. Register user
userRegistry.setReferrer(user, referrer, userType);

// 2. Notify DEED acquisition
userRegistry.notifyDeedAcquired(user);

// 3. Distribute commission
commissionEngine.distributeCommission(buyer, userType, amount);

// 4. Check rank
rankEngine.getRank(user);

// 5. Distribute pools
poolManager.distributePools(totalAmount, deedHolders, star1Holders, star2Holders, star3Holders);

// 6. Unlock DAO funds
treasury.unlock(user);
\`\`\`

## 🛠️ Development

### Prerequisites
- [Foundry](https://getfoundry.sh)
- [Node.js](https://nodejs.org/) (optional for scripts)
- [Git](https://git-scm.com/)

### Setup
\`\`\`bash
# Clone repository
git clone <repository-url>
cd mlm-dao-protocol

# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install OpenZeppelin/openzeppelin-contracts
forge install foundry-rs/forge-std

# Build contracts
forge build

# Run tests
forge test
\`\`\`

### Environment Setup
\`\`\`bash
# Create .env file
cp .env.example .env

# Edit .env with your values
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_KEY
PRIVATE_KEY=0xYOUR_PRIVATE_KEY
ETHERSCAN_API_KEY=YOUR_KEY
\`\`\`

### Scripts
\`\`\`bash
# Build
forge build

# Test
forge test
forge test --gas-report

# Format code
forge fmt

# Deploy locally
anvil
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast

# Deploy to Sepolia
forge script script/DeploySepolia.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify
\`\`\`

## 🔒 Security

### Audit Considerations
- Contracts have been tested but not professionally audited
- Recommended audit checks:
  - Pool distribution logic correctness
  - Commission calculation accuracy
  - DAO lock period enforcement
  - Access control verification

### Known Limitations
- Pool distribution gas costs for large holder lists
- Off-chain holder enumeration required for pools
- MockERC20 used for testing (replace with production token)

### Upgradeability
- Current implementation is not upgradeable
- Consider proxy pattern for future upgrades
- Immutable variables ensure contract integrity

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Foundry](https://getfoundry.sh)
- OpenZeppelin contracts for security patterns
- Ethereum community for best practices

## 📞 Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Contact the development team
- Refer to contract documentation

---

**Disclaimer**: This is a technical implementation for educational purposes. Consult legal and financial advisors before deploying in production environments.
' > README.md``
           

