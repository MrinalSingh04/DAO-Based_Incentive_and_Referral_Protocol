// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title FounderNFT
 * @dev Minted after 12-month DAO lock. Records amount as token metadata.
 */
contract FounderNFT is ERC721, Ownable {
    uint256 private _nextTokenId;

    // tokenId => credited amount (records how much was locked)
    mapping(uint256 => uint256) public tokenAmount;

    event FounderMinted(address indexed to, uint256 tokenId, uint256 amount);

    constructor() ERC721("Founder NFT", "FND") Ownable(msg.sender) {}

    /**
     * @dev Mint Founder NFT with amount that was locked
     * @param to Recipient address
     * @param amount Amount that was locked for 12 months
     * @return tokenId The minted token ID
     */
    function mint(address to, uint256 amount) external onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId;
        _safeMint(to, tokenId);
        tokenAmount[tokenId] = amount;
        _nextTokenId++;
        
        emit FounderMinted(to, tokenId, amount);
        return tokenId;
    }
}