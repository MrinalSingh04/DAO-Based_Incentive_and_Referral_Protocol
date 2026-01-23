// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "../libraries/UserTypes.sol";

/**
 * @title IUserRegistry
 * @dev Referral and direct DEED tracking
 */
interface IUserRegistry {
    function referrerOf(address user) external view returns (address);
    function directCount(address user) external view returns (uint256);
    function directDeedCount(address user) external view returns (uint256);
    function getUserType(address user) external view returns (UserTypes.UserType);
    function setReferrer(address user, address referrer, UserTypes.UserType userType) external;
    function notifyDeedAcquired(address user) external;
}