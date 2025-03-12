// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FundToken {
    // 1. name of the token
    // 2. symbol of the token
    // 3. total supply of the token
    // 4. address of the owner
    string public tokenName;
    string public tokenSymbol;
    uint256 public totalSupply;
    address public owner;
    mapping(address => uint256) public balances;

    constructor(string memory _tokenName, string memory _tokenSymbol) {
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        totalSupply = 1000000;
        owner = msg.sender;
    }

    // mint function: get the amount to mint and add it to the total supply
    function mint(uint256 amountToMint) public {
        require(amountToMint > 0, "Mint amount must be greater than zero");
        require(
            balances[msg.sender] + amountToMint <= totalSupply,
            "Cannot mint more than total supply"
        );
        balances[msg.sender] += amountToMint;
        totalSupply += amountToMint;
    }

    function transfer(address payee, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(payee != address(0), "Invalid address");
        balances[msg.sender] -= amount;
        balances[payee] += amount;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }
}
