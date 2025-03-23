// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {GoFundMe} from "./GoFundMe.sol";

contract FundTokenERC20 is ERC20 {
    GoFundMe private immutable i_fundMe;
    bool private _reentrancyLock;

    // Custom errors
    error FundTokenERC20__InvalidFundMeAddress();
    error FundTokenERC20__InvalidAmount();
    error FundTokenERC20__ExceedsContribution();
    error FundTokenERC20__FundingNotSuccessful();
    error FundTokenERC20__InsufficientBalance();
    error FundTokenERC20__ReentrantCall();

    // Events
    event TokensMinted(address indexed user, uint256 amount);
    event TokensClaimed(address indexed user, uint256 amount);

    modifier nonReentrant() {
        if (_reentrancyLock) {
            revert FundTokenERC20__ReentrantCall();
        }
        _reentrancyLock = true;
        _;
        _reentrancyLock = false;
    }

    constructor(address fundMeAddr) ERC20("FundTokenERC20", "FT") {
        if (fundMeAddr == address(0)) {
            revert FundTokenERC20__InvalidFundMeAddress();
        }
        i_fundMe = GoFundMe(fundMeAddr);
        _reentrancyLock = false;
    }

    function mint(uint256 amountToMint) external nonReentrant {
        // Input validation
        if (amountToMint == 0) {
            revert FundTokenERC20__InvalidAmount();
        }

        // Check funding status
        if (!i_fundMe.isFundingSuccessful()) {
            revert FundTokenERC20__FundingNotSuccessful();
        }

        // Get user's contribution
        uint256 userContribution = i_fundMe.getAddressToAmountFunded(
            msg.sender
        );

        // Check if user has enough contribution remaining
        uint256 currentTokens = balanceOf(msg.sender);
        if (currentTokens + amountToMint > userContribution) {
            revert FundTokenERC20__ExceedsContribution();
        }

        // Mint tokens
        _mint(msg.sender, amountToMint);

        emit TokensMinted(msg.sender, amountToMint);
    }

    function claim(uint256 amountToClaim) external nonReentrant {
        // Input validation
        if (amountToClaim == 0) {
            revert FundTokenERC20__InvalidAmount();
        }

        // Check balance
        if (balanceOf(msg.sender) < amountToClaim) {
            revert FundTokenERC20__InsufficientBalance();
        }

        // Burn tokens
        _burn(msg.sender, amountToClaim);

        emit TokensClaimed(msg.sender, amountToClaim);
    }

    function getFundMeContract() external view returns (address) {
        return address(i_fundMe);
    }
}
