// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

import "./IClaimIssuersRegistry.sol";
import "./IClaimTopicsRegistry.sol";
import "./IIdentityRegistryStorage.sol";

import "@onchain-id/solidity/contracts/interface/IClaimIssuer.sol";
import "@onchain-id/solidity/contracts/interface/IIdentity.sol";

interface IIdentityRegistry {
   
    event ClaimTopicsRegistrySet(
        IClaimTopicsRegistry indexed claimTopicsRegistry
    );

   
    event IdentityStorageSet(IIdentityRegistryStorage indexed identityStorage);

  
    event ClaimIssuersRegistrySet(
        IClaimIssuersRegistry indexed claimIssuersRegistry
    );

   
    event IdentityRegistered(
        address indexed investorAddress,
        IIdentity indexed identity
    );

   
    event IdentityRemoved(
        address indexed investorAddress,
        IIdentity indexed identity
    );

    
    event IdentityUpdated(
        IIdentity indexed oldIdentity,
        IIdentity indexed newIdentity
    );

    event CountryUpdated(
        address indexed investorAddress,
        uint16 indexed country
    );

    
    function registerIdentity(
        address _userAddress,
        IIdentity _identity,
        uint16 _country
    ) external;

    
    function deleteIdentity(address _userAddress) external;

    
    function setIdentityRegistryStorage(
        IIdentityRegistryStorage _identityRegistryStorage
    ) external;

   
    function setClaimTopicsRegistry(
        IClaimTopicsRegistry _claimTopicsRegistry
    ) external;

    
    function setClaimIssuersRegistry(
        IClaimIssuersRegistry _claimIssuersRegistry
    ) external;

    
    function updateCountry(address _userAddress, uint16 _country) external;

    
    function updateIdentity(address _userAddress, IIdentity _identity) external;

   
    function batchRegisterIdentity(
        address[] calldata _userAddresses,
        IIdentity[] calldata _identities,
        uint16[] calldata _countries
    ) external;

    function contains(address _userAddress) external view returns (bool);

   
    function isVerified(address _userAddress) external view returns (bool);

    function identity(address _userAddress) external view returns (IIdentity);

    
    function investorCountry(
        address _userAddress
    ) external view returns (uint16);

    function identityStorage() external view returns (IIdentityRegistryStorage);

    
    function issuersRegistry() external view returns (IClaimIssuersRegistry);

   
    function topicsRegistry() external view returns (IClaimTopicsRegistry);
}
