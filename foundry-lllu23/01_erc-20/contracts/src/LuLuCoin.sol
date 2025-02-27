// SPDX-License-Identifier: MIT
// 兼容 OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

// 导入 OpenZeppelin 的 ERC20 合约
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// 导入 OpenZeppelin 的 Ownable 合约
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// 定义 LuLuCoin 合约，继承自 ERC20 和 Ownable
contract LuLuCoin is ERC20, Ownable {
    // 定义 Mint 事件，记录铸币数量
    event Mint(uint256 indexed amount);
    // 定义 Burn 事件，记录销毁数量
    event Burn(uint256 indexed amount);

    // 定义代币名称
    string public _name = "LuLuCoin";
    // 定义代币符号
    string public _symbol = "LLC";

    // 构造函数，初始化代币名称和符号，并设置初始所有者
    constructor(
        address initialOwner
    ) ERC20("LuLuCoin", "LLC") Ownable(initialOwner) {}

    // 仅所有者可以调用的铸币函数
    function mint(uint256 _amount) public onlyOwner {
        // 调用内部的 _mint 函数铸币
        _mint(owner(), _amount);
        // 触发 Mint 事件
        emit Mint(_amount);
    }

    // 仅所有者可以调用的销毁函数
    function burn(uint256 _amount) public onlyOwner {
        // 调用内部的 _burn 函数销毁代币
        _burn(owner(), _amount);
        // 触发 Burn 事件
        emit Burn(_amount);
    }
}
