// Star 1 / 2 / 3 calculation (derived)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "../interfaces/IUserRegistry.sol";
import "../libraries/UserTypes.sol";

/**
 * @title RankEngine
 * @dev Derives user rank from direct DEED NFT count
 */
contract RankEngine {
    IUserRegistry public immutable userRegistry;

    constructor(address userRegistryAddress) {
        require(userRegistryAddress != address(0), "Zero address");
        userRegistry = IUserRegistry(userRegistryAddress);
    }

    /**
     * @dev Returns derived rank based on direct DEED holders
     */
    function getRank(address user) external view returns (UserTypes.Rank) {
        uint256 deedCount = userRegistry.directDeedCount(user);

        if (deedCount >= 20) {
            return UserTypes.Rank.STAR_3;
        } else if (deedCount >= 10) {
            return UserTypes.Rank.STAR_2;
        } else if (deedCount >= 5) {
            return UserTypes.Rank.STAR_1;
        } else {
            return UserTypes.Rank.NONE;
        }
    }
}
