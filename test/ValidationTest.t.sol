// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/libraries/Percentages.sol";
import "../src/libraries/UserTypes.sol";

contract ValidationTest is Test {
    function test_AllPercentagesMatchRequirements() public view {
        // Direct Commissions
        assertEq(Percentages.FREE_L1, 500);    // 5%
        assertEq(Percentages.SEED_L1, 1000);   // 10%
        assertEq(Percentages.DEED_L1, 2000);   // 20%
        assertEq(Percentages.DEED_L2, 1000);   // 10%
        assertEq(Percentages.DEED_L3, 500);    // 5%
        
        // Pools
        assertEq(Percentages.TOTAL_POOL, 1500); // 15%
        assertEq(Percentages.POOL_1, 300);      // 3%
        assertEq(Percentages.POOL_2, 400);      // 4%
        assertEq(Percentages.POOL_3, 400);      // 4%
        assertEq(Percentages.POOL_4, 400);      // 4%
        
        // Verify total = 15% (3+4+4+4 = 15)
        uint256 totalPools = Percentages.POOL_1 + Percentages.POOL_2 + 
                           Percentages.POOL_3 + Percentages.POOL_4;
        assertEq(totalPools, Percentages.TOTAL_POOL);
    }
    
    function test_UserTypesCorrect() public pure {
        // Verify enum values
        assertEq(uint256(UserTypes.UserType.FREE), 0);
        assertEq(uint256(UserTypes.UserType.SEED), 1);
        assertEq(uint256(UserTypes.UserType.DEED), 2);
        
        assertEq(uint256(UserTypes.Rank.NONE), 0);
        assertEq(uint256(UserTypes.Rank.STAR_1), 1);
        assertEq(uint256(UserTypes.Rank.STAR_2), 2);
        assertEq(uint256(UserTypes.Rank.STAR_3), 3);
    }
    
    function test_PoolSharingMath() public pure {
        // Test pool sharing hierarchy
        uint256 totalAmount = 1000 ether;
        
        // Calculate 15% pool total
        uint256 poolTotal = (totalAmount * 1500) / 10000; // 150 ether
        
        // Individual pools
        uint256 pool1 = (totalAmount * 300) / 10000;  // 30 ether (3%)
        uint256 pool2 = (totalAmount * 400) / 10000;  // 40 ether (4%)
        uint256 pool3 = (totalAmount * 400) / 10000;  // 40 ether (4%)
        uint256 pool4 = (totalAmount * 400) / 10000;  // 40 ether (4%)
        
        // Verify math
        assertEq(pool1 + pool2 + pool3 + pool4, poolTotal);
        
        // Star 3 gets: Pool 4 + 3 + 2 = 40 + 40 + 40 = 120 ether
        uint256 star3Share = pool4 + pool3 + pool2;
        assertEq(star3Share, 120 ether);
        
        // Star 2 gets: Pool 3 + 2 = 40 + 40 = 80 ether
        uint256 star2Share = pool3 + pool2;
        assertEq(star2Share, 80 ether);
        
        // Star 1 gets: Pool 2 only = 40 ether
        uint256 star1Share = pool2;
        assertEq(star1Share, 40 ether);
        
        // DEED holders get: Pool 1 = 30 ether
        uint256 deedShare = pool1;
        assertEq(deedShare, 30 ether);
    }
}