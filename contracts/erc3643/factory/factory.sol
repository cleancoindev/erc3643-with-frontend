// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;
import "../identies/identity.sol";

contract factory{
    mapping (address=>address) usertoidentity;
    mapping(address=>bool) isregistered;

    function createidentity(address _useraddress) public returns(address){
        require(!isregistered[_useraddress],"you are already registered");
        address _address=address(new identities(_useraddress));
        usertoidentity[_useraddress]=_address;
         isregistered[_useraddress]=true;

        return _address;
    }

    function getidentity(address _useraddress) public view returns(address){
        return usertoidentity[_useraddress];
    }

}


//0x36ba7acC1340FedA8E63673678ABA986073ca6b4

//identity
//0xBAb5cAb13c08D0F52d1dCb6e5e2E1fA1973b80Aa
//0xF4554496D239CD6f B56F5590b061Fb2D2e02cF59
//0x9e579689a662d1265032D3b0D91fbC10FC88087a
//0x8E40aBae70e38c475E8D76133B20a61E5A6E5996