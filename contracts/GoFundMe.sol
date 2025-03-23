// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract GoFundMe {
    address private immutable i_owner;
    mapping(address => uint256) private s_addressToAmountFunded;
    uint256 public immutable i_deadline;
    uint256 public constant MINIMUM_USD = 1 * 10 ** 18; // 1 USD in Wei
    uint256 public constant TARGET_USD = 1000 * 10 ** 18; // 1000 USD in Wei
    bool private _paused;
    bool private _reentrancyLock;

    // Chainlink Price Feed
    AggregatorV3Interface private immutable i_priceFeed;

    // Events
    event FundReceived(
        address indexed funder,
        uint256 amount,
        uint256 usdAmount
    );
    event WithdrawalCompleted(address indexed owner, uint256 amount);
    event RefundCompleted(address indexed funder, uint256 amount);
    event Paused(address account);
    event Unpaused(address account);

    // Custom errors
    error GoFundMe__InsufficientFunds();
    error GoFundMe__TransferFailed();
    error GoFundMe__DeadlineNotReached();
    error GoFundMe__TargetNotReached();
    error GoFundMe__NoFundsToWithdraw();
    error GoFundMe__CampaignStillActive();
    error GoFundMe__TargetReached();
    error GoFundMe__NotOwner();
    error GoFundMe__Paused();
    error GoFundMe__ReentrantCall();
    error GoFundMe__InvalidPriceFeed();

    // Modifiers
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert GoFundMe__NotOwner();
        }
        _;
    }

    modifier whenNotPaused() {
        if (_paused) {
            revert GoFundMe__Paused();
        }
        _;
    }

    modifier nonReentrant() {
        if (_reentrancyLock) {
            revert GoFundMe__ReentrantCall();
        }
        _reentrancyLock = true;
        _;
        _reentrancyLock = false;
    }

    constructor(address priceFeedAddress) {
        if (priceFeedAddress == address(0)) {
            revert GoFundMe__InvalidPriceFeed();
        }
        i_owner = msg.sender;
        i_deadline = block.timestamp + 30 days;
        i_priceFeed = AggregatorV3Interface(priceFeedAddress);
        _paused = false;
        _reentrancyLock = false;
    }

    function getLatestPrice() public view returns (uint256) {
        (, int256 price, , , ) = i_priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(price) * 10 ** 10;
    }

    function getConversionRate(
        uint256 ethAmount
    ) public view returns (uint256) {
        uint256 ethPrice = getLatestPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 10 ** 18;
        return ethAmountInUsd;
    }

    function fund() external payable whenNotPaused nonReentrant {
        uint256 usdAmount = getConversionRate(msg.value);
        if (usdAmount < MINIMUM_USD) {
            revert GoFundMe__InsufficientFunds();
        }
        s_addressToAmountFunded[msg.sender] += msg.value;
        emit FundReceived(msg.sender, msg.value, usdAmount);
    }

    function withdraw() external onlyOwner nonReentrant {
        if (block.timestamp <= i_deadline) {
            revert GoFundMe__DeadlineNotReached();
        }
        if (getConversionRate(address(this).balance) < TARGET_USD) {
            revert GoFundMe__TargetNotReached();
        }

        uint256 balance = address(this).balance;
        if (balance == 0) {
            revert GoFundMe__NoFundsToWithdraw();
        }

        (bool success, ) = payable(i_owner).call{value: balance}("");
        if (!success) {
            revert GoFundMe__TransferFailed();
        }

        emit WithdrawalCompleted(i_owner, balance);
    }

    function refund() external nonReentrant {
        if (block.timestamp <= i_deadline) {
            revert GoFundMe__CampaignStillActive();
        }
        if (getConversionRate(address(this).balance) >= TARGET_USD) {
            revert GoFundMe__TargetReached();
        }

        uint256 amount = s_addressToAmountFunded[msg.sender];
        if (amount == 0) {
            revert GoFundMe__NoFundsToWithdraw();
        }

        s_addressToAmountFunded[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            revert GoFundMe__TransferFailed();
        }

        emit RefundCompleted(msg.sender, amount);
    }

    function pause() external onlyOwner {
        _paused = true;
        emit Paused(msg.sender);
    }

    function unpause() external onlyOwner {
        _paused = false;
        emit Unpaused(msg.sender);
    }

    // View/Pure functions
    function getAddressToAmountFunded(
        address funder
    ) external view returns (uint256) {
        return s_addressToAmountFunded[funder];
    }

    function isFundingSuccessful() external view returns (bool) {
        return getConversionRate(address(this).balance) >= TARGET_USD;
    }

    function getDeadline() external view returns (uint256) {
        return i_deadline;
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getPriceFeed() external view returns (AggregatorV3Interface) {
        return i_priceFeed;
    }

    function isPaused() external view returns (bool) {
        return _paused;
    }
}
