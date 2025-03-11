// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// 1. Create a collection function
// 2. Record the donation to the function
// 3. Reach the goal in locktime time (30 days), the productor can withdraw the money
// 4. If the goal is not reached in locktime time, the donators can withdraw the money

contract FundMe {
    mapping(address => uint256) public fundersToAmound;
    address public owner;
    uint256 public immutable deadline;
    uint256 public constant MINIMUM_VALUE = 1 * 10 ** 18; // wei
    uint256 public constant TARGET = 1000 * 10 ** 18;

    AggregatorV3Interface internal dataFeed;

    address _dataFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(address _dataFeed) {
        dataFeed = AggregatorV3Interface(_dataFeed);
        owner = msg.sender;
        deadline = block.timestamp + 30 days;
    }

    function fund() external payable {
        require(
            convertEthToUsd((msg.value)) >= MINIMUM_VALUE,
            "Insufficient funds! Please donate more than 1 Ether"
        );
        fundersToAmound[msg.sender] += msg.value;
    }

    function getChainlinkDataFeedLastestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /* uint startedAt */,
            /* uint timeStamp */,
            /* uint80 answeredInRound */
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function convertEthToUsd(
        uint256 ethAmount
    ) internal view returns (uint256) {
        uint256 ethPrice = uint256(getChainlinkDataFeedLastestAnswer());
        return (ethAmount * ethPrice) / (10 ** 8);
    }

    function withdraw() external onlyOwner {
        require(
            convertEthToUsd(address(this).balance) >= TARGET,
            "Target is not reached yet."
        );
        require(block.timestamp > deadline, "Campaign has not ended");
        payable(msg.sender).transfer(address(this).balance);
    }

    function refund() external {
        require(block.timestamp > deadline, "Campaign is still active");
        require(
            convertEthToUsd(fundersToAmound[msg.sender]) > 0,
            "You didn't fund anything"
        );
        require(
            convertEthToUsd(address(this).balance) < TARGET,
            "Target was reached, cannot refund"
        );
        require(fundersToAmound[msg.sender] > 0, "You didn't fund anything");

        uint256 amount = fundersToAmound[msg.sender];
        fundersToAmound[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
