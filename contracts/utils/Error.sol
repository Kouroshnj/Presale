// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Error {
    address public owner;
    bytes32 private password =
        0x33c934dea30631fea2378aa7cfa82ce3f3fe928ce3396c5795fb81c0321169ba;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(string memory _password) {
        bytes32 Hash = keccak256(abi.encodePacked(_password));
        require(Hash == password, "Wrong Password!");
        if (msg.sender != owner) Error.WrongOwner(msg.sender);
        _;
    }

    error OwnerError(address givenAddress, address owner, string errText);

    function WrongOwner(address _givenAddress) internal view {
        revert OwnerError(_givenAddress, owner, "not owner!");
    }
}
