// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.29;

contract Wallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function deposit() public payable {}

    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(address(this).balance >= amount, "Insufficient balance");
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function checkBalance() public view returns (uint256) {
        return address(this).balance;
    }
}