// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/AIAgentRegistry.sol";

contract DeployAIAgentRegistry is Script {
    function run() external {
        // Load environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address ensAddress = vm.envAddress("ENS_ADDRESS");
        address resolverAddress = vm.envAddress("RESOLVER_ADDRESS");
        
        // Start broadcasting
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy contract
        AIAgentRegistry registry = new AIAgentRegistry(
            ensAddress,
            resolverAddress,
            bytes32(0)
        );
        
        console.log("AIAgentRegistry deployed at:", address(registry));

        vm.stopBroadcast();
    }
}