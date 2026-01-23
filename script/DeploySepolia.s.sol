// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";

// Mock ERC20 for testing
contract MockERC20 {
    string public name = "Test Token";
    string public symbol = "TEST";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor() {
        totalSupply = 1000000 * 10 ** decimals;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    function transfer(address to, uint256 value) external returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Insufficient allowance");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
}

// Import your contracts
import "../src/nft/SeedNFT.sol";
import "../src/nft/DeedNFT.sol";
import "../src/nft/FounderNFT.sol";
import "../src/core/UserRegistry.sol";
import "../src/core/DAOTreasury.sol";
import "../src/core/CommissionEngine.sol";
import "../src/core/RankEngine.sol";
import "../src/core/PoolManager.sol";

contract DeploySepolia is Script {
    function run() external {
        // Get deployer address from private key (passed via --private-key flag)
        address deployer = msg.sender;
        console.log("Deploying from:", deployer);
        
        vm.startBroadcast();
        
        // ========== 1. DEPLOY MOCK TOKEN ==========
        console.log("\n1. Deploying Mock ERC20 Token...");
        MockERC20 paymentToken = new MockERC20();
        console.log("   MockERC20:", address(paymentToken));
        
        // ========== 2. DEPLOY NFT CONTRACTS ==========
        console.log("\n2. Deploying NFT Contracts...");
        SeedNFT seedNFT = new SeedNFT();
        DeedNFT deedNFT = new DeedNFT();
        FounderNFT founderNFT = new FounderNFT();
        console.log("   SeedNFT:", address(seedNFT));
        console.log("   DeedNFT:", address(deedNFT));
        console.log("   FounderNFT:", address(founderNFT));
        
        // ========== 3. DEPLOY CORE CONTRACTS ==========
        console.log("\n3. Deploying Core Contracts...");
        
        // User Registry
        UserRegistry userRegistry = new UserRegistry(address(deedNFT), address(seedNFT));
        console.log("   UserRegistry:", address(userRegistry));
        
        // DAO Treasury
        DAOTreasury treasury = new DAOTreasury(address(founderNFT), address(paymentToken));
        console.log("   DAOTreasury:", address(treasury));
        
        // Commission Engine
        CommissionEngine commissionEngine = new CommissionEngine(address(userRegistry), address(treasury));
        console.log("   CommissionEngine:", address(commissionEngine));
        
        // Rank Engine
        RankEngine rankEngine = new RankEngine(address(userRegistry));
        console.log("   RankEngine:", address(rankEngine));
        
        // Pool Manager
        PoolManager poolManager = new PoolManager(address(userRegistry), address(treasury));
        console.log("   PoolManager:", address(poolManager));
        
        vm.stopBroadcast();
        
        // ========== 4. DEPLOYMENT SUMMARY ==========
        console.log("\n==================================================");
        console.log("MLM DAO PROTOCOL DEPLOYED SUCCESSFULLY!");
        console.log("==================================================");
        console.log("\nContract Addresses:");
        console.log("MockERC20:       ", address(paymentToken));
        console.log("SeedNFT:         ", address(seedNFT));
        console.log("DeedNFT:         ", address(deedNFT));
        console.log("FounderNFT:      ", address(founderNFT));
        console.log("UserRegistry:    ", address(userRegistry));
        console.log("DAOTreasury:     ", address(treasury));
        console.log("CommissionEngine:", address(commissionEngine));
        console.log("RankEngine:      ", address(rankEngine));
        console.log("PoolManager:     ", address(poolManager));
        
        // Save addresses to file (simplified)
        string memory json = string(
            abi.encodePacked(
                '{"mockERC20":"', vm.toString(address(paymentToken)), 
                '","seedNFT":"', vm.toString(address(seedNFT)),
                '","deedNFT":"', vm.toString(address(deedNFT)),
                '","founderNFT":"', vm.toString(address(founderNFT)),
                '","userRegistry":"', vm.toString(address(userRegistry)),
                '","treasury":"', vm.toString(address(treasury)),
                '","commissionEngine":"', vm.toString(address(commissionEngine)),
                '","rankEngine":"', vm.toString(address(rankEngine)),
                '","poolManager":"', vm.toString(address(poolManager)), '"}'
            )
        );
        
        vm.writeFile("deployed-addresses.json", json);
        console.log("\nAddresses saved to: deployed-addresses.json");
    }
}