// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/AIAgentRegistry.sol";

contract DeployAIAgentRegistry is Script {
    function run() external {
        // Load environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        console.log("Deployer address:", deployerAddress);

        // Hardcode all values
        address ensAddress = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
        address resolverAddress = 0x8FADE66B79cC9f707aB26799354482EB93a5B7dD;

         // Calculate the correct namehash
        bytes32 ethNode = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
        bytes32 domainNode = keccak256(abi.encodePacked(ethNode, keccak256(bytes("aiagent"))));
    
        IENS ens = IENS(ensAddress);
        address currentOwner = ens.owner(domainNode);
        console.log("Current domain owner:", currentOwner);
        console.log("Domain node:", uint256(domainNode));
        console.log("ENS address:", ensAddress);
        console.log("Resolver address:", resolverAddress);      

        // Try checking the parent domain (.eth) owner
        address ethOwner = ens.owner(ethNode);
        console.log("ETH node owner:", ethOwner);   

        // Add this new section here
        bytes32 labelHash = keccak256(bytes("aiagent"));
        bytes32 calculatedNode = keccak256(abi.encodePacked(ethNode, labelHash));
        console.log("Calculated node:", uint256(calculatedNode));
        address calculatedOwner = ens.owner(calculatedNode);
        console.log("Calculated owner:", calculatedOwner);

        // Start broadcasting
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy contract
        AIAgentRegistry registry = new AIAgentRegistry(
            ensAddress,
            resolverAddress,
            domainNode
        );
        
        vm.stopBroadcast();

        console.log("AIAgentRegistry deployed at:", address(registry)); 
    }
}