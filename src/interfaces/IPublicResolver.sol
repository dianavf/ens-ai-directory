// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IPublicResolver {
    event TextChanged(bytes32 indexed node, string indexed indexedKey, string key, string value);
    
    function setText(bytes32 node, string calldata key, string calldata value) external;
    function text(bytes32 node, string calldata key) external view returns (string memory);
}
