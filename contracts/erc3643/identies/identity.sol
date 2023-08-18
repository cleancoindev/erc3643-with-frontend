// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;
import "@onchain-id/solidity/contracts/Identity.sol";


contract identities is Identity {
    constructor(address initialManagementKey)
        Identity(initialManagementKey, false)
    {}

    function bytekey(address _address) external pure returns (bytes32)  {
        return keccak256(abi.encode(_address));
    }

    
}
//identity   
//0xBAb5cAb13c08D0F52d1dCb6e5e2E1fA1973b80Aa    hash=>>           0x2cdebae753d563ebc7863eaf369852325097a0203b615fa65aae9801832347b0
//0xF4554496D239CD6fB56F5590b061Fb2D2e02cF59           hash=>>        0x64119616448ebeba4e9babc2667f483befd698fa649f6b4faf57109770499789
//0x9e579689a662d1265032D3b0D91fbC10FC88087a          hash=>>           0x072ddf5a60b91b8ae8a4a485642b6c0d2e0a0198aa041e6fac09711cc9bf66a1
//0x8E40aBae70e38c475E8D76133B20a61E5A6E5996           hash=>>           0x098b9a6f54881737cdc0d968f5b4035206894a2b2662045140a3d3ea545f2195  


// 0x862e6d881A674185EbFF09D2864838Aabf293A84      identity registry