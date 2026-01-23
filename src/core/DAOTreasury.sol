// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/ITreasury.sol";
import "../nft/FounderNFT.sol";
import "../errors/ProtocolErrors.sol";

/**
 * @title DAOTreasury
 * @dev Lock funds for 12 months + Founder NFT minting
 */
contract DAOTreasury is ITreasury, Ownable {
    FounderNFT public immutable founderNFT;
    IERC20 public immutable paymentToken;
    
    uint256 public constant LOCK_DURATION = 365 days; // 12 months
    
    struct LockInfo {
        uint256 amount;
        uint256 unlockTime;
        bool unlocked;
    }
    
    mapping(address => LockInfo[]) public userLocks;
    
    event FundsCredited(address indexed user, uint256 amount, uint256 unlockTime);
    event FundsUnlocked(address indexed user, uint256 amount, uint256 founderTokenId);
    
    constructor(address _founderNFT, address _paymentToken) Ownable(msg.sender) {
        if (_founderNFT == address(0) || _paymentToken == address(0)) {
            revert ProtocolErrors.ZeroAddress();
        }
        founderNFT = FounderNFT(_founderNFT);
        paymentToken = IERC20(_paymentToken);
    }
    
    function credit(address user, uint256 amount) external override {
        if (user == address(0)) revert ProtocolErrors.ZeroAddress();
        if (amount == 0) revert ProtocolErrors.InvalidAmount();
        
        // Transfer tokens from caller to treasury
        require(
            paymentToken.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        
        uint256 unlockTime = block.timestamp + LOCK_DURATION;
        userLocks[user].push(LockInfo({
            amount: amount,
            unlockTime: unlockTime,
            unlocked: false
        }));
        
        emit FundsCredited(user, amount, unlockTime);
    }
    
    function unlock(address user) external override onlyOwner {
        uint256 totalUnlockable = 0;
        
        for (uint256 i = 0; i < userLocks[user].length; i++) {
            LockInfo storage lock = userLocks[user][i];
            
            if (!lock.unlocked && block.timestamp >= lock.unlockTime) {
                totalUnlockable += lock.amount;
                lock.unlocked = true;
            }
        }
        
        if (totalUnlockable == 0) revert ProtocolErrors.NoLockedFunds();
        
        // Mint Founder NFT with locked amount
        uint256 founderTokenId = founderNFT.mint(user, totalUnlockable);
        
        // Transfer unlocked tokens to user
        require(
            paymentToken.transfer(user, totalUnlockable),
            "Transfer failed"
        );
        
        emit FundsUnlocked(user, totalUnlockable, founderTokenId);
    }
    
    function getLockedBalance(address user) external view override returns (uint256) {
        uint256 total = 0;
        
        for (uint256 i = 0; i < userLocks[user].length; i++) {
            LockInfo memory lock = userLocks[user][i];
            if (!lock.unlocked) {
                total += lock.amount;
            }
        }
        
        return total;
    }
    
    function getUnlockTime(address user) external view override returns (uint256) {
        uint256 earliestUnlock = type(uint256).max;
        bool hasActiveLocks = false;
        
        for (uint256 i = 0; i < userLocks[user].length; i++) {
            LockInfo memory lock = userLocks[user][i];
            if (!lock.unlocked) {
                hasActiveLocks = true;
                if (lock.unlockTime < earliestUnlock) {
                    earliestUnlock = lock.unlockTime;
                }
            }
        }
        
        return hasActiveLocks ? earliestUnlock : 0;
    }
}