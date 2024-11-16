// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IBaseRegistrar {
    event ControllerAdded(address indexed controller);
    event ControllerRemoved(address indexed controller);
    event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
    event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
    event NameRenewed(uint256 indexed id, uint expires);

    // Get the name of a registered name
    function baseNode() external view returns (bytes32);

    // Get the address that owns a registration
    function ownerOf(uint256 id) external view returns (address owner);

    // Get the registration expiry date
    function nameExpires(uint256 id) external view returns (uint);

    // Reclaim ownership of a name in ENS, if you own it in the registrar
    function reclaim(uint256 id, address owner) external;

    // Transfer ownership of a name to a new address
    function transferFrom(address from, address to, uint256 tokenId) external;

    // Add a controller to the registrar
    function addController(address controller) external;

    // Remove a controller from the registrar
    function removeController(address controller) external;

    // Check if an address is a controller
    function isController(address controller) external view returns (bool);

    // Register a name
    function register(uint256 id, address owner, uint duration) external returns(uint);

    // Renew a name
    function renew(uint256 id, uint duration) external returns(uint);

    // Get the available time for a name
    function available(uint256 id) external view returns(bool);
}
