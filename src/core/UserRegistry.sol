// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "../interfaces/IUserRegistry.sol";
import "../interfaces/INFT.sol";
import "../libraries/UserTypes.sol";
import "../errors/ProtocolErrors.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title UserRegistry
 * @dev Handles referrals, directs, and direct DEED NFT count
 */
contract UserRegistry is IUserRegistry, Ownable {
    // =========================
    // STORAGE
    // =========================

    // user => referrer
    mapping(address => address) private _referrerOf;

    // user => number of direct referrals
    mapping(address => uint256) private _directCount;

    // user => number of direct DEED NFT holders
    mapping(address => uint256) private _directDeedCount;

    // user => user type
    mapping(address => UserTypes.UserType) private _userType;

    // DEED NFT reference
    INFT public immutable deedNFT;
    INFT public immutable seedNFT;

    // =========================
    // EVENTS
    // =========================

    event ReferrerSet(address indexed user, address indexed referrer, UserTypes.UserType userType);
    event DirectDeedIncremented(address indexed referrer, address indexed user);
    event UserTypeUpdated(address indexed user, UserTypes.UserType userType);

    // =========================
    // CONSTRUCTOR
    // =========================

    constructor(address deedNFTAddress, address seedNFTAddress) Ownable(msg.sender) {
        if (deedNFTAddress == address(0) || seedNFTAddress == address(0)) 
            revert ProtocolErrors.ZeroAddress();
        deedNFT = INFT(deedNFTAddress);
        seedNFT = INFT(seedNFTAddress);
    }

    // =========================
    // REFERRAL LOGIC
    // =========================

    /**
     * @dev Register referrer (one-time)
     * @param user The user being registered
     * @param referrer The referrer address
     * @param userType 0=FREE, 1=SEED, 2=DEED
     */
    function setReferrer(address user, address referrer, UserTypes.UserType userType) external onlyOwner {
        if (user == address(0) || referrer == address(0)) {
            revert ProtocolErrors.ZeroAddress();
        }

        if (_referrerOf[user] != address(0)) {
            revert ProtocolErrors.ReferrerAlreadySet();
        }

        _referrerOf[user] = referrer;
        _userType[user] = userType;
        
        // Update referrer's direct count
        if (referrer != address(0)) {
            _directCount[referrer] += 1;
        }

        emit ReferrerSet(user, referrer, userType);
        emit UserTypeUpdated(user, userType);
    }

    /**
     * @dev Called when user acquires DEED NFT
     */
    function notifyDeedAcquired(address user) external onlyOwner {
        address referrer = _referrerOf[user];
        if (referrer == address(0)) return;

        // Ensure user actually owns DEED NFT
        if (deedNFT.balanceOf(user) == 0) {
            revert ProtocolErrors.NotADeedHolder();
        }

        // Update user type to DEED
        _userType[user] = UserTypes.UserType.DEED;
        
        // Update referrer's direct DEED count
        _directDeedCount[referrer] += 1;

        emit DirectDeedIncremented(referrer, user);
        emit UserTypeUpdated(user, UserTypes.UserType.DEED);
    }

    /**
     * @dev Update user type (e.g., when acquiring SEED NFT)
     */
    function updateUserType(address user, UserTypes.UserType userType) external onlyOwner {
        _userType[user] = userType;
        emit UserTypeUpdated(user, userType);
    }

    // =========================
    // VIEW FUNCTIONS
    // =========================

    function referrerOf(address user) external view override returns (address) {
        return _referrerOf[user];
    }

    function directCount(address user) external view override returns (uint256) {
        return _directCount[user];
    }

    function directDeedCount(address user) external view override returns (uint256) {
        return _directDeedCount[user];
    }

    function getUserType(address user) external view returns (UserTypes.UserType) {
        return _userType[user];
    }

    function isDeedHolder(address user) external view returns (bool) {
        return deedNFT.balanceOf(user) > 0;
    }

    function isSeedHolder(address user) external view returns (bool) {
        return seedNFT.balanceOf(user) > 0;
    }
}