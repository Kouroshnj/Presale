// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./ERC20.sol";
import "./Error.sol";

contract QST is Error, ERC20 {
    constructor() ERC20("Qustion", "QST") {
        _mint(msg.sender, 800000000000 * 10 ** decimals());
    }

    function changeOwner(
        string memory _password,
        address _newOwner
    ) public onlyOwner(_password) {
        owner = _newOwner;
    }

    function mint(
        address to,
        uint256 amount,
        string memory _password
    ) public onlyOwner(_password) {
        _mint(to, amount);
    }

    function burn(
        uint256 amount,
        address account,
        string memory _password
    ) public onlyOwner(_password) {
        _burn(account, amount);
    }
}
