// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;
import "@onchain-id/solidity/contracts/ClaimIssuer.sol";

contract ClaimIssuers is ClaimIssuer{
    constructor( address initialManagementKey ) ClaimIssuer(initialManagementKey){

    }
}

//0x52CE2a002Cb1f93AA0FD7e70f6A0d7c202c8115C acc5
//0xC5bc65EAB2845F5Fb29925F41EF1188810B5aA81 acc6