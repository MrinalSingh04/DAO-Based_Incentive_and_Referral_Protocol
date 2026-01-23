// SEED NFT → 10% L1 commission

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SeedNFT
 * @dev Ownership defines SEED user type
 * No commission or rank logic lives here
 */
contract SeedNFT is ERC721, Ownable {
    uint256 private _nextTokenId;

    constructor() ERC721("Seed NFT", "SEED") Ownable(msg.sender) {}

    /**
     * @dev Mint controlled by owner (admin / protocol)
     */
    function mint(address to) external onlyOwner {
        _safeMint(to, _nextTokenId);
        _nextTokenId++;
    }
}
