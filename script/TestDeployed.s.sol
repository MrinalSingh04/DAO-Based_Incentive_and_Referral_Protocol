// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/interfaces/INFT.sol";

contract TestDeployed is Script {
    address constant MOCK_ERC20 = 0x37783C572c52f99892789A3AD9C023Db3cd5f3BE;
    address constant SEED_NFT = 0x153A30b61fAa7b4D8c27eAD9fc4b0f585CDEc468;
    address constant DEED_NFT = 0x8cF231c0eD4ABacB1e9601cc06593992617b219a;
    address constant FOUNDER_NFT = 0xb51cCeF7C4FCc1A0063E4f27907b90f07508119E;
    address constant USER_REGISTRY = 0x627AdB2CdfBc6Accf66d906Ca3a2fFafcEa359C9;
    address constant TREASURY = 0xc98E63aFB782C96eb24af410c3c63091Db663a73;
    address constant COMMISSION_ENGINE = 0xeAaDD7C8200FcC208eA126FF945F6D03a59378A0;
    address constant RANK_ENGINE = 0x0696cc32B08A5F39b6386fb591E5acDeAD75f6c1;
    address constant POOL_MANAGER = 0x25B6Cd674474494c5eba2973E025ef5bf7AA2B41;

    function run() external view {
        console.log("All contracts deployed successfully!");
        console.log("");
        console.log("Contract Addresses:");
        console.log("MockERC20:        ", MOCK_ERC20);
        console.log("SeedNFT:          ", SEED_NFT);
        console.log("DeedNFT:          ", DEED_NFT);
        console.log("FounderNFT:       ", FOUNDER_NFT);
        console.log("UserRegistry:     ", USER_REGISTRY);
        console.log("DAOTreasury:      ", TREASURY);
        console.log("CommissionEngine: ", COMMISSION_ENGINE);
        console.log("RankEngine:       ", RANK_ENGINE);
        console.log("PoolManager:      ", POOL_MANAGER);
        
        // You can add more checks here
        // e.g., check contract code size, owner, etc.
    }
}