// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@ensdomains/ens-contracts/contracts/registry/ENS.sol";

contract mockENS is ENS {
    mapping(bytes32 => address) public owners;
    mapping(address => mapping(address => bool)) public operators;

    function owner(bytes32 node) public view override returns (address) {
        return owners[node];
    }

    function setSubnodeOwner(bytes32 node, bytes32 label, address owner_) public override returns(bytes32) {
        bytes32 subnode = keccak256(abi.encodePacked(node, label));
        owners[subnode] = owner_;
        return subnode;
    }

    function setResolver(bytes32 node, address resolverAddress) public override {
        // Mock implementation
    }

    function setOwner(bytes32 node, address owner_) public override {
        owners[node] = owner_;
    }

    function setTTL(bytes32 node, uint64 ttlValue) public override {
        // Mock implementation
    }

    function setRecord(
        bytes32 node,
        address owner_,
        address resolver_,
        uint64 ttlValue
    ) public override {
        owners[node] = owner_;
    }

    function setSubnodeRecord(
        bytes32 node,
        bytes32 label,
        address owner_,
        address resolver_,
        uint64 ttlValue
    ) public override {
        bytes32 subnode = keccak256(abi.encodePacked(node, label));
        owners[subnode] = owner_;
    }

    function setApprovalForAll(address operator, bool approved) public override {
        operators[msg.sender][operator] = approved;
    }

    function isApprovedForAll(address owner_, address operator) public view override returns (bool) {
        return operators[owner_][operator];
    }

    function ttl(bytes32 node) public view override returns(uint64) {
        return 0;
    }

    function resolver(bytes32 node) public view override returns(address) {
        return address(0);
    }

    function recordExists(bytes32 node) public pure override returns(bool) {
        return true;
    }
}