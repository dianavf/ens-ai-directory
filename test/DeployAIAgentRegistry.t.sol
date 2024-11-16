// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/AIAgentRegistry.sol";

contract DeployAIAgentRegistry is Script {
    function run() external {
        // Sepolia ENS Registry address
        address ensAddress = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
        // Sepolia Public Resolver address
        address resolverAddress = 0x8FADE66B79cC9f707aB26799354482EB93a5B7dD;
        // domain's namehash
        bytes32 domainNode = 0x9062c0ac1a5e4ca0b3cb8e6d78ef8d5c7adb17300504a272f908a4c7aa73d666;
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        AIAgentRegistry registry = new AIAgentRegistry(ensAddress, resolverAddress, domainNode);
        vm.stopBroadcast();
        
        console.log("AIAgentRegistry deployed to:", address(registry));
    }
}
