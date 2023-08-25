// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@onchain-id/solidity/contracts/interface/IClaimIssuer.sol";
import "@onchain-id/solidity/contracts/interface/IIdentity.sol";
import "./interface/IClaimTopicsRegistry.sol";
import "./interface/IClaimIssuersRegistry.sol";
import "./interface/IIdentityRegistry.sol";
import "./interface/IIdentityRegistryStorage.sol";

// 0x2849644766c3bf8120d7f73954ac79cf0c758b29 is missing role 0xcab5a0bfe0b79d2c4b1c2e02599fa044d115b7511f9659307cb4276950967709
contract IdentityRegistry is IIdentityRegistry, AccessControl {
    IClaimTopicsRegistry private _tokenTopicsRegistry;

    IClaimIssuersRegistry private _tokenIssuersRegistry;

    IIdentityRegistryStorage private _tokenIdentityStorage;

    bytes32 public constant AGENT_ROLE =
        0xcab5a0bfe0b79d2c4b1c2e02599fa044d115b7511f9659307cb4276950967709;

    bytes32 public constant OWNER_ROLE =
        0xb19546dff01e856fb3f010c267a7b1c60363cf8a4664e21cc89c26224620214e;

    constructor(
        IClaimIssuersRegistry _claimIssuersRegistry,
        IClaimTopicsRegistry _claimTopicsRegistry,
        IIdentityRegistryStorage _identityStorage
    ) {
        require(
            address(_claimIssuersRegistry) != address(0) &&
                address(_claimTopicsRegistry) != address(0) &&
                address(_identityStorage) != address(0),
            "ERC-3643: Invalid zero address"
        );
        _grantRole(bytes32(0), _msgSender());
        _grantRole(OWNER_ROLE, _msgSender());

        _tokenTopicsRegistry = _claimTopicsRegistry;
        _tokenIssuersRegistry = _claimIssuersRegistry;
        _tokenIdentityStorage = _identityStorage;
        emit ClaimTopicsRegistrySet(_claimTopicsRegistry);
        emit ClaimIssuersRegistrySet(_claimIssuersRegistry);
        emit IdentityStorageSet(_identityStorage);
    }

    function registerIdentity(
        address _userAddress,
        IIdentity _identity,
        uint16 _country
    ) external onlyRole(AGENT_ROLE) {
        _registerIdentity(_userAddress, _identity, _country);
    }

    function batchRegisterIdentity(
        address[] calldata _userAddresses,
        IIdentity[] calldata _identities,
        uint16[] calldata _countries
    ) external onlyRole(AGENT_ROLE) {
        uint256 length = _userAddresses.length;
        require(length == _identities.length, "ERC-3643: Array size mismatch");
        require(length == _countries.length, "ERC-3643: Array size mismatch");
        for (uint256 i = 0; i < length; ) {
            _registerIdentity(_userAddresses[i], _identities[i], _countries[i]);
            unchecked {
                ++i;
            }
        }
    }

    function updateIdentity(address _userAddress, IIdentity _identity)
        external
        onlyRole(AGENT_ROLE)
    {
        IIdentity oldIdentity = _getIdentity(_userAddress);
        _tokenIdentityStorage.modifyStoredIdentity(_userAddress, _identity);
        emit IdentityUpdated(oldIdentity, _identity);
    }

    function updateCountry(address _userAddress, uint16 _country)
        external
        onlyRole(AGENT_ROLE)
    {
        _tokenIdentityStorage.modifyStoredInvestorCountry(
            _userAddress,
            _country
        );
        emit CountryUpdated(_userAddress, _country);
    }

    function deleteIdentity(address _userAddress)
        external
        onlyRole(AGENT_ROLE)
    {
        IIdentity oldIdentity = _getIdentity(_userAddress);
        _tokenIdentityStorage.removeIdentityFromStorage(_userAddress);
        emit IdentityRemoved(_userAddress, oldIdentity);
    }

    function setIdentityRegistryStorage(
        IIdentityRegistryStorage _identityRegistryStorage
    ) external onlyRole(OWNER_ROLE) {
        _tokenIdentityStorage = _identityRegistryStorage;
        emit IdentityStorageSet(_identityRegistryStorage);
    }

    function setClaimTopicsRegistry(IClaimTopicsRegistry _claimTopicsRegistry)
        external
        onlyRole(OWNER_ROLE)
    {
        _tokenTopicsRegistry = _claimTopicsRegistry;
        emit ClaimTopicsRegistrySet(_claimTopicsRegistry);
    }

    function setClaimIssuersRegistry(
        IClaimIssuersRegistry _claimIssuersRegistry
    ) external onlyRole(OWNER_ROLE) {
        _tokenIssuersRegistry = _claimIssuersRegistry;
        emit ClaimIssuersRegistrySet(_claimIssuersRegistry);
    }

    function isVerified(address _userAddress) external view returns (bool) {
        // Get the identity of the user from the given address
        IIdentity userIdentity = _getIdentity(_userAddress);

        // If the user identity is not set (address is 0), return false
        if (address(userIdentity) == address(0)) return false;

        // Get the required claim topics for the token
        uint256[] memory claimTopics = _tokenTopicsRegistry.getClaimTopics();
        uint256 claimTopicsLength = claimTopics.length;

        // If there are no required claim topics, return true
        if (claimTopicsLength == 0) return true;

        // Loop over all required claim topics
        for (uint256 i = 0; i < claimTopicsLength; i++) {
            if (!_isClaimValid(userIdentity, claimTopics[i])) {
                return false;
            }
        }
        // If all checks pass, return true
        return true;
    }

    function investorCountry(address _userAddress)
        external
        view
        returns (uint16)
    {
        return _tokenIdentityStorage.storedInvestorCountry(_userAddress);
    }

    function issuersRegistry() external view returns (IClaimIssuersRegistry) {
        return _tokenIssuersRegistry;
    }

    /// @notice Get the topics registry.
    /// @return The current topics registry.
    function topicsRegistry() external view returns (IClaimTopicsRegistry) {
        return _tokenTopicsRegistry;
    }

    /// @notice Get the identity storage.
    /// @return The current identity storage.
    function identityStorage()
        external
        view
        returns (IIdentityRegistryStorage)
    {
        return _tokenIdentityStorage;
    }

    /// @notice Check if an address is contained in the registry.
    /// @param _userAddress The address to check.
    /// @return A boolean indicating if the address is in the registry.
    function contains(address _userAddress) external view returns (bool) {
        return address(identity(_userAddress)) == address(0) ? false : true;
    }

    /// @notice Get the identity of a user.
    /// @param _userAddress The address of the user.
    /// @return The identity of the user.
    function identity(address _userAddress) public view returns (IIdentity) {
        return _tokenIdentityStorage.storedIdentity(_userAddress);
    }

    /// @notice Register a new identity.
    /// @param _userAddress The address of the user.
    /// @param _identity The identity of the user.
    /// @param _country The country of the user.
    function _registerIdentity(
        address _userAddress,
        IIdentity _identity,
        uint16 _country
    ) private {
        _tokenIdentityStorage.addIdentityToStorage(
            _userAddress,
            _identity,
            _country
        );
        emit IdentityRegistered(_userAddress, _identity);
    }

    /// @notice Get the identity of a user.
    /// @param _userAddress The address of the user.
    /// @return The identity of the user.
    function _getIdentity(address _userAddress)
        private
        view
        returns (IIdentity)
    {
        return _tokenIdentityStorage.storedIdentity(_userAddress);
    }

    function _isClaimValid(IIdentity userIdentity, uint256 claimTopic)
        private
        view
        returns (bool)
    {
        IClaimIssuer[] memory claimIssuers = _tokenIssuersRegistry
            .getClaimIssuersForClaimTopic(claimTopic);
        uint256 claimIssuersLength = claimIssuers.length;

        if (claimIssuersLength == 0) {
            return false;
        }

        bytes32[] memory claimIds = new bytes32[](claimIssuersLength);

        for (uint256 i = 0; i < claimIssuersLength; i++) {
            claimIds[i] = keccak256(abi.encode(claimIssuers[i], claimTopic));
        }

        for (uint256 j = 0; j < claimIds.length; j++) {
            (
                uint256 foundClaimTopic,
                ,
                address issuer,
                bytes memory sig,
                bytes memory data,

            ) = userIdentity.getClaim(claimIds[j]);

            if (foundClaimTopic == claimTopic) {
                if (
                    _isIssuerClaimValid(
                        userIdentity,
                        issuer,
                        claimTopic,
                        sig,
                        data
                    )
                ) {
                    return true;
                }
            } else if (j == claimIds.length - 1) {
                return false;
            }
        }

        return false;
    }

    /// @param userIdentity The identity contract related to the claim.
    /// @param issuer The address of the claim issuer.
    /// @param claimTopic The claim topic of the claim.
    /// @param sig The signature of the claim.
    /// @param data The data field of the claim.
    /// @return claimValid True if the claim is valid, false otherwise.
    function _isIssuerClaimValid(
        IIdentity userIdentity,
        address issuer,
        uint256 claimTopic,
        bytes memory sig,
        bytes memory data
    ) private view returns (bool) {
        try
            IClaimIssuer(issuer).isClaimValid(
                userIdentity,
                claimTopic,
                sig,
                data
            )
        returns (bool _validity) {
            return _validity;
        } catch {
            return false;
        }
    }
}
