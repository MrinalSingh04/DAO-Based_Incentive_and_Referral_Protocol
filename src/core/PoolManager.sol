// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "../interfaces/IUserRegistry.sol";
import "../interfaces/ITreasury.sol";
import "../libraries/Percentages.sol";
import "../errors/ProtocolErrors.sol";

/**
 * @title PoolManager
 * @dev Distributes company pool among DEED and Star holders
 * CORRECTED VERSION: 
 * - Star 3 gets Pools 2+3+4
 * - Star 2 gets Pools 2+3  
 * - Star 1 gets Pool 2 only
 * - All DEED holders get Pool 1
 */
contract PoolManager {
    IUserRegistry public immutable userRegistry;
    ITreasury public immutable treasury;

    constructor(address _userRegistry, address _treasury) {
        if (_userRegistry == address(0) || _treasury == address(0)) 
            revert ProtocolErrors.ZeroAddress();
        userRegistry = IUserRegistry(_userRegistry);
        treasury = ITreasury(_treasury);
    }

    /**
     * @dev Distribute 15% pools according to client requirements
     * @param totalAmount Total company inflow (100%)
     */
    function distributePools(
        uint256 totalAmount,
        address[] calldata deedHolders,
        address[] calldata star1Holders,
        address[] calldata star2Holders,
        address[] calldata star3Holders
    ) external {
        if (totalAmount == 0) return;

        // Calculate pool amounts (simplified to avoid stack too deep)
        uint256 pool1Amount = (totalAmount * Percentages.POOL_1) / Percentages.BPS_DENOMINATOR;
        uint256 pool2Amount = (totalAmount * Percentages.POOL_2) / Percentages.BPS_DENOMINATOR;
        uint256 pool3Amount = (totalAmount * Percentages.POOL_3) / Percentages.BPS_DENOMINATOR;
        uint256 pool4Amount = (totalAmount * Percentages.POOL_4) / Percentages.BPS_DENOMINATOR;

        // ===== POOL 1: All DEED holders (3%) =====
        _distributePool(deedHolders, pool1Amount);

        // ===== DISTRIBUTE POOLS 2, 3, 4 according to hierarchy =====
        
        // 1. STAR 3 gets: Pool 4 + Pool 3 + Pool 2 (4% + 4% + 4% = 12% total)
        if (star3Holders.length > 0) {
            uint256 star3PerUser = (pool4Amount + pool3Amount + pool2Amount) / star3Holders.length;
            _distributeToUsers(star3Holders, star3PerUser);
        }

        // 2. STAR 2 gets: Pool 3 + Pool 2 (only if not also STAR 3)
        if (star2Holders.length > 0) {
            uint256 star2PerUser = (pool3Amount + pool2Amount) / star2Holders.length;
            _distributeToStar2(star2Holders, star3Holders, star2PerUser);
        }

        // 3. STAR 1 gets: Pool 2 only (only if not also STAR 2 or STAR 3)
        if (star1Holders.length > 0) {
            uint256 star1PerUser = pool2Amount / star1Holders.length;
            _distributeToStar1(star1Holders, star2Holders, star3Holders, star1PerUser);
        }
    }

    // =========================
    // INTERNAL HELPERS (to avoid stack too deep)
    // =========================

    function _distributePool(address[] calldata users, uint256 totalAmount) internal {
        if (users.length == 0 || totalAmount == 0) return;
        uint256 perUser = totalAmount / users.length;
        for (uint256 i = 0; i < users.length; i++) {
            treasury.credit(users[i], perUser);
        }
    }

    function _distributeToUsers(address[] calldata users, uint256 amountPerUser) internal {
        if (users.length == 0 || amountPerUser == 0) return;
        for (uint256 i = 0; i < users.length; i++) {
            treasury.credit(users[i], amountPerUser);
        }
    }

    function _distributeToStar2(
        address[] calldata star2Holders,
        address[] calldata star3Holders,
        uint256 star2PerUser
    ) internal {
        for (uint256 i = 0; i < star2Holders.length; i++) {
            if (!_isInArray(star2Holders[i], star3Holders)) {
                treasury.credit(star2Holders[i], star2PerUser);
            }
        }
    }

    function _distributeToStar1(
        address[] calldata star1Holders,
        address[] calldata star2Holders,
        address[] calldata star3Holders,
        uint256 star1PerUser
    ) internal {
        for (uint256 i = 0; i < star1Holders.length; i++) {
            address user = star1Holders[i];
            if (!_isInArray(user, star3Holders) && !_isInArray(user, star2Holders)) {
                treasury.credit(user, star1PerUser);
            }
        }
    }

    function _isInArray(address user, address[] calldata arr) internal pure returns (bool) {
        for (uint256 j = 0; j < arr.length; j++) {
            if (user == arr[j]) {
                return true;
            }
        }
        return false;
    }
}