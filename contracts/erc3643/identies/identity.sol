// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;
import "@onchain-id/solidity/contracts/Identity.sol";

contract identities is Identity {
    constructor(address initialManagementKey)
        Identity(initialManagementKey, false)
    {}

    function bytekey(string memory role) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(role));
    }

    function bytekey(address _address) external pure returns (bytes32) {
        return keccak256(abi.encode(_address));
    }
}
