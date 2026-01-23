// Commission & pool constants

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title Percentages
 * @dev All commission & pool constants (basis points)
 */
library Percentages {
    // =========================
    // BASIS POINTS
    // =========================
    uint256 internal constant BPS_DENOMINATOR = 10_000;

    // =========================
    // DIRECT COMMISSIONS
    // =========================

    // FREE user
    uint256 internal constant FREE_L1 = 500; // 5%

    // SEED NFT holder
    uint256 internal constant SEED_L1 = 1000; // 10%

    // DEED NFT holder
    uint256 internal constant DEED_L1 = 2000; // 20%
    uint256 internal constant DEED_L2 = 1000; // 10%
    uint256 internal constant DEED_L3 = 500;  // 5%

    // =========================
    // POOLS
    // =========================

    // Total pool allocation
    uint256 internal constant TOTAL_POOL = 1500; // 15%

    // Individual pools
    uint256 internal constant POOL_1 = 300;  // 3%
    uint256 internal constant POOL_2 = 400;  // 4%
    uint256 internal constant POOL_3 = 400;  // 4%
    uint256 internal constant POOL_4 = 400;  // 4%
}