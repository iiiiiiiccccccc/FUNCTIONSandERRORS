# Error Handling Demo 
This Solidity program demonstrates various error handling mechanisms in Solidity, such as using require(), assert(), and revert(). The purpose of this program is to serve as an example for understanding how to handle errors and conditions in smart contracts.

# Description
This program is a simple contract written in Solidity, a programming language used for developing smart contracts on the Ethereum blockchain. The contract includes functions to deposit and withdraw ether, and it demonstrates error handling using require(), assert(), and revert(). This program serves as a practical introduction to error handling in Solidity, and can be used as a reference for more complex projects in the future.

# Getting Started
## Executing the Program
To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., ErrorHandlingDemo.sol). Copy and paste the following code into the file:

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

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.0" (or another compatible version), and then click on the "Compile ErrorHandlingDemo.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the ErrorHandlingDemo contract from the dropdown menu, and then click on the "Deploy" button.

Once the contract is deployed, you can interact with it by calling the functions provided in the contract. For example, you can deposit ether, withdraw ether, check the owner, and trigger a revert condition.

# Authors
Metacrafter Chris
@metacraftersio

# License
This project is licensed under the MIT License - see the LICENSE.md file for details.


