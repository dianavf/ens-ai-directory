// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@ensdomains/ens-contracts/contracts/registry/ENS.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/PublicResolver.sol";

contract AIAgentRegistry {
    ENS public immutable ens;
    PublicResolver public immutable resolver;
    bytes32 public immutable domain;  // Add this to store your domain's namehash

    // Events
    event AIAgentRegistered(
        address indexed owner,
        string name,
        bytes32 node,
        string metadata
    );

    // Custom errors
    error SubnameAlreadyRegistered(string name);
    error InvalidName();
    error UnauthorizedOperation();
    error NotDomainOwner();

    constructor(
        address ensAddress, 
        address resolverAddress,
        bytes32 _domain  // Add parameter for your domain's namehash
    ) {
        require(ensAddress != address(0), "Invalid ENS address");
        require(resolverAddress != address(0), "Invalid resolver address");
        
        ens = ENS(ensAddress);
        resolver = PublicResolver(resolverAddress);
        domain = _domain;

        // Make sure the deployer owns the domain
        if (ens.owner(domain) != msg.sender) {
            revert NotDomainOwner();
        }
    }

    /// @notice Register a new AI agent with associated metadata
    /// @param name The name to register (without .eth suffix)
    /// @param agentMetadata JSON string containing agent metadata
    /// @return node The ENS node hash for the registered name
    function registerAIAgent(
        string memory name,
        string memory agentMetadata
    ) public returns (bytes32) {
        // Input validation
        if (bytes(name).length == 0) {
            revert InvalidName();
        }

        // Generate the ENS node components
        bytes32 label = keccak256(bytes(name));
        bytes32 fullNode = keccak256(abi.encodePacked(domain, label));

        // Check availability
        if (ens.owner(fullNode) != address(0)) {
            revert SubnameAlreadyRegistered(name);
        }

        // Register the subname
        ens.setSubnodeOwner(domain, label, msg.sender);

        // Set metadata
        resolver.setText(fullNode, "agentMetadata", agentMetadata);

        // Emit event
        emit AIAgentRegistered(msg.sender, name, fullNode, agentMetadata);
        return fullNode;
    }

    // Rest of your code remains the same, but use 'domain' instead of 'rootNode'
    function updateAgentMetadata(
        string memory name,
        string memory newMetadata
    ) public {
        bytes32 label = keccak256(bytes(name));
        bytes32 fullNode = keccak256(abi.encodePacked(domain, label));

        // Verify ownership
        if (ens.owner(fullNode) != msg.sender) {
            revert UnauthorizedOperation();
        }

        // Update metadata
        resolver.setText(fullNode, "agentMetadata", newMetadata);
    }

    function isNameAvailable(string memory name) public view returns (bool) {
        bytes32 label = keccak256(bytes(name));
        bytes32 fullNode = keccak256(abi.encodePacked(domain, label));
        return ens.owner(fullNode) == address(0);
    }
}