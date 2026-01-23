// NFT balance abstraction (future-proof)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title INFT
 * @dev Minimal NFT interface for ownership checks
 */
interface INFT {
    function balanceOf(address owner) external view returns (uint256);
}
