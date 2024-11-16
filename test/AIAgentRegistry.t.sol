// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/AIAgentRegistry.sol";
import "./mocks/mockENS.sol";
import "./mocks/mockResolver.sol";

contract AIAgentRegistryTest is Test {
    AIAgentRegistry public registry;
    mockENS public ens;
    mockResolver public resolver;
    address public owner = 0x6F841f1e580B40C1f716a2d3f7b7A38c3f2684d6;
    address public user1 = address(0x1);
    bytes32 public constant TEST_DOMAIN = 0x5a1a1c7f17cd18a9c96fc3e4ab5b3bcfbaf2c079c1c0355ff0c4b24838d65e59;

    function setUp() public {
        // for local testing, deploy mock contracts
        ens = new mockENS();
        resolver = new mockResolver();
        
        // Set test domain owner
        ens.setOwner(TEST_DOMAIN, owner);
        
        // Deploy the registry
        registry = new AIAgentRegistry(
            address(ens), 
            address(resolver),
            TEST_DOMAIN
        );
        
        // Label addresses for better trace output
        vm.label(owner, "Owner");
        vm.label(user1, "User1");
        vm.label(address(registry), "Registry");
    }

    function testRegisterAIAgent() public {
        string memory name = "myagent";
        string memory metadata = '{"description":"AI assistant"}';
        
        vm.startPrank(owner);
        registry.registerAIAgent(name, metadata);
        vm.stopPrank();
        
        assertFalse(registry.isNameAvailable(name), "Name should be registered");
    }

    function testCannotRegisterDuplicateName() public {
        string memory name = "myagent";
        string memory metadata = '{"description":"AI assistant"}';
        
        vm.startPrank(owner);
        // First registration should succeed
        registry.registerAIAgent(name, metadata);
        
        // Second registration should fail
        vm.expectRevert(abi.encodeWithSelector(AIAgentRegistry.SubnameAlreadyRegistered.selector, name));
        registry.registerAIAgent(name, metadata);
        vm.stopPrank();
    }

    function testUpdateMetadata() public {
        string memory name = "myagent";
        string memory metadata = '{"description":"AI assistant"}';
        string memory newMetadata = '{"description":"Updated AI assistant"}';
        
        vm.startPrank(owner);
        registry.registerAIAgent(name, metadata);
        registry.updateAgentMetadata(name, newMetadata);
        vm.stopPrank();
    }

    function testUnauthorizedUpdate() public {
        string memory name = "myagent";
        string memory metadata = '{"description":"AI assistant"}';
        
        // Register as owner
        vm.startPrank(owner);
        registry.registerAIAgent(name, metadata);
        vm.stopPrank();
        
        // Try to update as different user
        vm.startPrank(user1);
        vm.expectRevert(abi.encodeWithSelector(AIAgentRegistry.UnauthorizedOperation.selector));
        registry.updateAgentMetadata(name, '{"description":"Hack attempt"}');
        vm.stopPrank();
    }

    function testRegisterWithFullMetadata() public {
        string memory name = "assistant";
        string memory metadata = '{'
            '"name": "AI Assistant",'
            '"description": "Multipurpose AI assistant",'
            '"capabilities": ["chat", "code", "image"],'
            '"endpoint": "https://api.myai.com/assistant",'
            '"version": "1.0.0",'
            '"modelType": "GPT-4"'
        '}';
        
        vm.startPrank(owner);
        registry.registerAIAgent(name, metadata);
        vm.stopPrank();
        
        assertFalse(registry.isNameAvailable(name), "Name should be registered");
    }

    function testRegisterMultipleAgents() public {
        vm.startPrank(owner);
        // Register a code assistant
        registry.registerAIAgent("coder", '{'
            '"name": "Code Assistant",'
            '"capabilities": ["code", "debug", "test"],'
            '"endpoint": "https://api.myai.com/coder"'
        '}');

        // Register an art generator
        registry.registerAIAgent("artist", '{'
            '"name": "Art Generator",'
            '"capabilities": ["image", "style", "edit"],'
            '"endpoint": "https://api.myai.com/artist"'
        '}');
        vm.stopPrank();

        // Verify both registrations
        assertFalse(registry.isNameAvailable("coder"), "Coder should be registered");
        assertFalse(registry.isNameAvailable("artist"), "Artist should be registered");
    }

    function testEmptyNameReverts() public {
        string memory metadata = '{"description":"AI assistant"}';
        
        vm.startPrank(owner);
        // Try to register with empty name
        vm.expectRevert(AIAgentRegistry.InvalidName.selector);
        registry.registerAIAgent("", metadata);
        vm.stopPrank();
    }

    function testUpdateAsOwner() public {
        string memory name = "myagent";
        string memory metadata = '{"description":"AI assistant"}';
        
        vm.startPrank(owner);
        // Register as owner
        registry.registerAIAgent(name, metadata);
        
        // Update as owner should succeed
        string memory newMetadata = '{"description":"Updated description"}';
        registry.updateAgentMetadata(name, newMetadata);
        vm.stopPrank();
    }

    function testCannotUpdateNonexistentAgent() public {
        string memory name = "nonexistent";
        string memory metadata = '{"description":"Should fail"}';
        
        vm.startPrank(owner);
        // Try to update non-existent agent
        vm.expectRevert();
        registry.updateAgentMetadata(name, metadata);
        vm.stopPrank();
    }
}