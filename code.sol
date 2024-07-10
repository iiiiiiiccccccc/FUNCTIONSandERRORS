// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ErrorHandlingDemo {
    address public user; // Variable to store the address of the contract owner
    uint256 public balance; // Variable to store the contract's balance

    // Constructor sets the contract deployer as the owner
    constructor() {
        user = msg.sender; // msg.sender is the address that deploys the contract
    }

    // Function to deposit ether into the contract
    function deposit() public payable {
        // Check that the deposit amount is greater than zero
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balance += msg.value; // Increase the contract balance by the deposited amount
    }

    // Function to withdraw ether from the contract
    function withdraw(uint256 amount) public {
        // Ensure the requested amount is not more than the contract balance
        require(amount <= balance, "Insufficient balance");
        // Ensure only the contract owner can withdraw
        require(msg.sender == user, "Only the owner can withdraw");
        payable(msg.sender).transfer(amount); // Transfer the amount to the sender
        balance -= amount; // Decrease the contract balance by the withdrawn amount
    }

    // Function to demonstrate assert()
    function checkOwner() public view {
        // Assert that the caller is the contract owner
        assert(user == msg.sender);
    }

    // Function to demonstrate revert()
    function triggerRevert() public view {
        // Revert if the caller is not the contract owner
        if (msg.sender != user) {
            revert("Caller is not the owner");
        }
    }
}
