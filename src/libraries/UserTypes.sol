// FREE / SEED / DEED + Rank enums

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title UserTypes
 * @dev Shared enums across protocol
 */
library UserTypes {
    enum UserType {
        FREE,   // No NFT
        SEED,   // Owns SEED NFT
        DEED    // Owns DEED NFT
    }

    enum Rank {
        NONE,   // Default
        STAR_1,
        STAR_2,
        STAR_3
    }
}
