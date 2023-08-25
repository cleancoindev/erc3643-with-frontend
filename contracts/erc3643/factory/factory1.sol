// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;
import "../registry/ClaimIssuersRegistry.sol";
import "../registry/ClaimTopicRegistry.sol";
import "../registry/IdentityRegistry.sol";
import "../registry/IdentityRegistryStorage.sol";
//import "../token/token.sol";
import "../compliance/DefaultCompilance.sol";

contract factory2 {
    function _deploy(uint256 _salt, bytes memory bytecode)
        private
        returns (address)
    {
        bytes32 saltBytes = bytes32(keccak256(abi.encodePacked(_salt)));
        address addr;

        assembly {
            let encoded_data := add(0x20, bytecode) // load initialization code.
            let encoded_size := mload(bytecode) // load init code's length.
            addr := create2(0, encoded_data, encoded_size, saltBytes)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }

        return addr;
    }

    function claimtopicregistry(uint256 _salt) public returns (address) {
        bytes memory _code = type(ClaimTopicsRegistry).creationCode;
        return _deploy(_salt, _code);
    }

    function claimissuersregistry(uint256 _salt) public returns (address) {
        bytes memory _code = type(ClaimIssuersRegistry).creationCode;
        return _deploy(_salt, _code);
    }

    function identityregistrystorage(uint256 _salt) public returns (address) {
        bytes memory _code = type(IdentityRegistryStorage).creationCode;
        return _deploy(_salt, _code);
    }

    function identityregistry(
        uint256 _salt,
        address _cir,
        address _ctr,
        address _irs
    ) public returns (address) {
        bytes memory _code = type(IdentityRegistry).creationCode;
        bytes memory _constructData = abi.encode(_cir, _ctr, _irs);
        bytes memory bytecode = abi.encodePacked(_code, _constructData);
        return _deploy(_salt, bytecode);
    }

    function modularcompliance(uint256 _salt) public returns (address) {
        bytes memory _code = type(DefaultCompliance).creationCode;
        return _deploy(_salt, _code);
    }

    function grant_role(
        address ir,
        address irs,
        address ctr,address cir,
        address _addrress
    ) external {
        IdentityRegistry(ir).grantRole(
            0x0000000000000000000000000000000000000000000000000000000000000000,
            _addrress
        );
        IdentityRegistryStorage(irs).grantRole(
            0x0000000000000000000000000000000000000000000000000000000000000000,
            _addrress
        );
        IdentityRegistryStorage(irs).grantRole(
            0xb19546dff01e856fb3f010c267a7b1c60363cf8a4664e21cc89c26224620214e,
            _addrress
        );
        Ownable(ctr).transferOwnership(_addrress);
         Ownable(cir).transferOwnership(_addrress);

    }
}
