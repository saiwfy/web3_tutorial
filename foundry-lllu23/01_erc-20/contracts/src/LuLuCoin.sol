// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract LuLuCoin is ERC20, Ownable {
    event Mint(uint256 indexed amount);
    event Burn(uint256 indexed amount);

    string public _name = "LuLuCoin";
    string public _symbol = "LLC";

    constructor(
        address initialOwner
    ) ERC20("LuLuCoin", "LLC") Ownable(initialOwner) {}

    function mint(uint256 _amount) public onlyOwner {
        _mint(owner(), _amount);
        emit Mint(_amount);
    }

    function burn(uint256 _amount) public onlyOwner {
        _burn(owner(), _amount);
        emit Burn(_amount);
    }
}
