// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IClaimTopicsRegistry.sol";

/// @title ERC-3643 - ClaimTopicsRegistry
/// @dev A registry for managing claim topics.
contract ClaimTopicsRegistry is IClaimTopicsRegistry, Ownable {
    /// @dev An array to hold all required claim topics.
    uint256[] private _claimTopics;

    /// @notice Adds a claim topic to the registry.
    /// @dev Can only be called by the owner of the contract.
    /// Emits a ClaimTopicAdded event.
    /// @param _claimTopic The claim topic to add.
    function addClaimTopic(uint256 _claimTopic) external onlyOwner {
        require(_isClaimTopicUnique(_claimTopic), "ERC-3643: Topic exists");

        _claimTopics.push(_claimTopic);
        emit ClaimTopicAdded(_claimTopic);
    }

    /// @notice Removes a claim topic from the registry.
    /// @dev Can only be called by the owner of the contract.
    /// Emits a ClaimTopicRemoved event.
    /// @param _claimTopic The claim topic to remove.
    function removeClaimTopic(uint256 _claimTopic) external onlyOwner {
        uint256 length = _claimTopics.length;
        for (uint256 i = 0; i < length; i++) {
            if (_claimTopics[i] == _claimTopic) {
                _claimTopics[i] = _claimTopics[length - 1];
                _claimTopics.pop();
                emit ClaimTopicRemoved(_claimTopic);
                break;
            }
        }
    }

    /// @notice Retrieves all claim topics from the registry.
    /// @return uint256[] An array of claim topics.
    function getClaimTopics() external view returns (uint256[] memory) {
        return _claimTopics;
    }

    /// @notice Checks if a claim topic is unique in the registry.
    /// @dev Private function to check the uniqueness of a claim topic.
    /// @param claimTopic The claim topic to check.
    /// @return bool True if the claim topic is unique, false otherwise.
    function _isClaimTopicUnique(
        uint256 claimTopic
    ) private view returns (bool) {
        uint256[] memory claimTopics = _claimTopics;
        uint256 length = _claimTopics.length;
        for (uint256 i = 0; i < length; ) {
            if (claimTopics[i] == claimTopic) {
                return false;
            }
            unchecked {
                ++i;
            }
        }
        return true;
    }
}


//0x36ba7acC1340FedA8E63673678ABA986073ca6b4     factory
//0x52CE2a002Cb1f93AA0FD7e70f6A0d7c202c8115C   claimissuer acc5
//0xC5bc65EAB2845F5Fb29925F41EF1188810B5aA81    claimissuer acc6 
//0x98A5B1E62C1039E2043bc58b9Da628e9d4987AF8    claimIssuerResgistry
//0xb2a28d95B754EE34ea3359862Ff11095a142ad5d     claimtopic registry