// DEED NFT → ranks, pools, multi-level

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DeedNFT
 * @dev Ownership defines DEED user type
 * Rank & pool logic is derived externally
 */
contract DeedNFT is ERC721, Ownable {
    uint256 private _nextTokenId;

    constructor() ERC721("Deed NFT", "DEED") Ownable(msg.sender) {}

    /**
     * @dev Mint controlled by protocol
     */
    function mint(address to) external onlyOwner {
        _safeMint(to, _nextTokenId);
        _nextTokenId++;
    }
}
