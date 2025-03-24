// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; // 声明Solidity版本 / Declare Solidity version

// 导入 Chainlink 价格预言机接口 / Import Chainlink price feed interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// 导入价格转换库 / Import price conversion library
import {PriceConverter} from "./PriceConverter.sol";

// 定义非所有者错误 / Define not owner error
error NotOwner();

contract FundMe {
    // 使用 PriceConverter 库处理 uint256 类型 / Use PriceConverter library for uint256
    using PriceConverter for uint256;

    // 记录每个地址捐赠的金额 / Map to track amount funded by each address
    mapping(address => uint256) private s_addressToAmountFunded;
    // 捐赠者地址数组 / Array of funder addresses
    address[] private s_funders;

    // 合约所有者地址（不可变） / Contract owner address (immutable)
    address private immutable i_owner;
    // 最小捐赠金额（美元，常量） / Minimum donation amount in USD (constant)
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    AggregatorV3Interface private s_priceFeed;
    // 构造函数，设置合约所有者 / Constructor, sets contract owner
    constructor(address priceFeed) {
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    // 资金募集函数 / Function to accept funds
    function fund() public payable {
        // 检查捐赠金额是否达到最小要求 / Check if donation meets minimum requirement
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "You need to spend more ETH!"
        );
        // 更新捐赠记录 / Update funding records
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    // 获取预言机版本 / Get price feed version
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    // 只有所有者才能调用的修饰器 / Modifier to restrict function access to owner only
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    // 提取合约中的资金 / Withdraw funds from contract
    function withdraw() public onlyOwner {
        // 重置所有捐赠记录 / Reset all funding records
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // 清空捐赠者数组 / Clear funders array
        s_funders = new address[](0);

        // 使用 call 方法发送以太币 / Send ETH using call method
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    // 回退函数 / Fallback function
    fallback() external payable {
        fund();
    }

    // 接收函数 / Receive function
    receive() external payable {
        fund();
    }

    /**getter function */
    function getAddressToAmountFunded(
        address fundingAddress
    ) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }
}
