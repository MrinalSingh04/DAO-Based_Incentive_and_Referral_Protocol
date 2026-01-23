// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface ITreasury {
    function credit(address user, uint256 amount) external;
    function unlock(address user) external;  // ADD THIS LINE
    function getLockedBalance(address user) external view returns (uint256);
    function getUnlockTime(address user) external view returns (uint256);
}