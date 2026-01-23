// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library ProtocolErrors {
    error ZeroAddress();
    error ReferrerAlreadySet();
    error NotADeedHolder();
    error InsufficientBalance();
    error StillLocked();
    error NotAuthorized();
    error InvalidAmount();
    error NoLockedFunds();
}