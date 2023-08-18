// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

import "@onchain-id/solidity/contracts/interface/IClaimIssuer.sol";

interface IClaimIssuersRegistry {
  
    event ClaimIssuerAdded(
        IClaimIssuer indexed claimIssuer,
        uint256[] claimTopics
    );

    event ClaimIssuerRemoved(IClaimIssuer indexed claimIssuer);

    
    event ClaimTopicsUpdated(
        IClaimIssuer indexed claimIssuer,
        uint256[] claimTopics
    );

    
    function addClaimIssuer(
        IClaimIssuer _claimIssuer,
        uint256[] calldata _claimTopics
    ) external;

    
    function removeClaimIssuer(IClaimIssuer _claimIssuer) external;

    
    function updateIssuerClaimTopics(
        IClaimIssuer _claimIssuer,
        uint256[] calldata _claimTopics
    ) external;

    
    function getClaimIssuers() external view returns (IClaimIssuer[] memory);

    
    function getClaimIssuersForClaimTopic(
        uint256 claimTopic
    ) external view returns (IClaimIssuer[] memory);

   
    function isClaimIssuer(IClaimIssuer _issuer) external view returns (bool);

    
    function getClaimIssuerClaimTopics(
        IClaimIssuer _claimIssuer
    ) external view returns (uint256[] memory);

    
    function hasClaimTopic(
        IClaimIssuer _issuer,
        uint256 _claimTopic
    ) external view returns (bool);
}