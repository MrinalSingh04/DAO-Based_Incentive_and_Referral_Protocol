// Direct commission logic (L1–L3)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "../interfaces/IUserRegistry.sol";
import "../interfaces/ITreasury.sol";
import "../libraries/UserTypes.sol";
import "../libraries/Percentages.sol";
import "../errors/ProtocolErrors.sol";

/**
 * @title CommissionEngine
 * @dev Computes direct commissions L1-L3 and credits DAO Treasury
 */
contract CommissionEngine {
    IUserRegistry public immutable userRegistry;
    ITreasury public immutable treasury;

   constructor(address userRegistryAddress, address treasuryAddress) {
    if (userRegistryAddress == address(0) || treasuryAddress == address(0)) {
        revert ProtocolErrors.ZeroAddress();
    }
    userRegistry = IUserRegistry(userRegistryAddress);
    treasury = ITreasury(treasuryAddress);
}

    /**
     * @dev Computes commission for a new sale
     * @param buyer The user who purchased
     * @param userType The buyer's NFT type
     * @param saleAmount Sale amount in wei
     */
    function distributeCommission(
        address buyer,
        UserTypes.UserType userType,
        uint256 saleAmount
    ) external {
        if (buyer == address(0)) revert ProtocolErrors.ZeroAddress();
        if (saleAmount == 0) return;

        address l1 = userRegistry.referrerOf(buyer);
        if (l1 == address(0)) return;

        // ====== L1 COMMISSION ======
        uint256 l1Pct = _getL1Percentage(userType);
        uint256 l1Amount = (saleAmount * l1Pct) / Percentages.BPS_DENOMINATOR;
        if (l1Amount > 0) treasury.credit(l1, l1Amount);

        // ====== L2 COMMISSION ======
        if (userType == UserTypes.UserType.DEED) {
            address l2 = userRegistry.referrerOf(l1);
            if (l2 != address(0)) {
                uint256 l2Amount = (saleAmount * Percentages.DEED_L2) / Percentages.BPS_DENOMINATOR;
                treasury.credit(l2, l2Amount);
            }

            // ====== L3 COMMISSION ======
            address l3 = userRegistry.referrerOf(l2);
            if (l3 != address(0)) {
                uint256 l3Amount = (saleAmount * Percentages.DEED_L3) / Percentages.BPS_DENOMINATOR;
                treasury.credit(l3, l3Amount);
            }
        }
    }

    // =========================
    // INTERNAL HELPERS
    // =========================

    function _getL1Percentage(UserTypes.UserType userType) internal pure returns (uint256) {
        if (userType == UserTypes.UserType.FREE) {
            return Percentages.FREE_L1;
        } else if (userType == UserTypes.UserType.SEED) {
            return Percentages.SEED_L1;
        } else if (userType == UserTypes.UserType.DEED) {
            return Percentages.DEED_L1;
        } else {
            return 0;
        }
    }
}
