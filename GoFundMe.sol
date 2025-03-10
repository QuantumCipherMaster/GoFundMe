// SPDX-License-Indetifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// 1. Create a collection function
// 2. Record the donation to the function
// 3. reach the goal in limitation time, the productor can withdraw the money
// 4. If the goal is not reached in limitation time, the donators can withdraw the money

contract FundMe {
    mapping(address => uint256) public fundersToAmound;

    uint256 MINIMUM_VALUE = 1 * 10 ** 18; // wei

    uint256 constant target = 1000 * 10 ** 18;

    AggregatorV3Interface internal dataFeed;

    address _dataFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    constructor(address _dataFeed) {
        dataFeed = AggregatorV3Interface(_dataFeed);
        owner = msg.sender;
    }

    function fund() external payable {
        require(
            converEthToUsd((msg.value)) >= MINIMUM_VALUE,
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

    function converEthToUsd(uint256 ethAmount) internal returns (uint256) {
        uint256 ethPrice = uint256(getChainlinkDataFeedLastestAnswer());
        return (ethAmount * ethPrice) / (10 ** 8);
    }

    function withdraw() public {
        require(
            fundersToAmound[msg.sender] > 0,
            "You have not donated any funds"
        );
        uint256 amount = fundersToAmound[msg.sender];
        fundersToAmound[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function getFunder() external view returns (uint256) {
        require(
            converEthToUsd(address(this).balance) >= target,
            "Target is not reached yet."
        );
        require(msg.sender == owner, "You are not the owner");
        return fundersToAmound[msg.sender];
    }

    function transferOwnership(address newOwner) public {
        require(
            msg.sender == owner,
            "You are not the owner, contact the owner to transfer the ownership"
        );
        owner = newOwner;
    }
}
