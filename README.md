# Smart Contract
This Solidity program demonstrates various error handling mechanisms in Solidity, such as using require(), assert(), and revert(). The purpose of this program is to serve as an example for understanding how to handle errors and conditions in smart contracts.

# Description
This program is a simple contract written in Solidity, a programming language used for developing smart contracts on the Ethereum blockchain. The contract includes functions to deposit and withdraw ether, and it demonstrates error handling using require(), assert(), and revert(). This program serves as a practical introduction to error handling in Solidity, and can be used as a reference for more complex projects in the future.

# Getting Started
## Executing the Program
To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., ErrorHandlingDemo.sol). Copy and paste the following code into the file:

    // SPDX-License-Identifier: UNLICENSED
    pragma solidity 0.8.26;

    contract Crowdfunding {
        address public projectBeneficiary; 
        // Address of the beneficiary who will receive funds if the campaign succeeds
    
        uint256 public totalRaised; 
        // Total amount of funds raised so far
    
        uint256 public goalAmount; 
        // Target amount of funds to be raised
    
        uint256 public campaignDeadline; 
        // Timestamp when the campaign ends
    
        bool public campaignOpen; 
        // Flag indicating if the campaign is still open
    
        mapping(address => uint256) public pledges; 
        // Mapping of addresses to pledged amounts
    
        event PledgeReceived(address contributor, uint256 amount); 
        // Event emitted when a pledge is received
    
        event CampaignFinalized(address beneficiary, uint256 totalAmountRaised); 
        // Event emitted when the campaign is finalized
    
        // Constructor to initialize the contract with beneficiary, goal amount, and campaign duration
        constructor(address _projectBeneficiary, uint256 _goalAmount, uint256 _campaignDurationInMinutes) {
            require(_projectBeneficiary != address(0), "Beneficiary address cannot be zero.");
            require(_goalAmount > 0, "Funding goal must be greater than zero.");
            require(_campaignDurationInMinutes > 0, "Duration must be greater than zero.");
    
            projectBeneficiary = _projectBeneficiary;
            goalAmount = _goalAmount;
            campaignDeadline = block.timestamp + (_campaignDurationInMinutes * 1 minutes); 
            // Set campaign deadline
    
            campaignOpen = true; 
            // Initialize campaign as open
        }
    
        // Function for contributors to make a pledge (send funds)
        function pledge() external payable {
            require(campaignOpen, "Campaign is closed.");
            require(block.timestamp <= campaignDeadline, "Campaign deadline has passed.");
            require(msg.value > 0, "Pledge must be greater than zero.");
    
            pledges[msg.sender] += msg.value; 
            // Record the pledge amount from the sender
    
            totalRaised += msg.value; 
            // Update the total amount raised
    
            emit PledgeReceived(msg.sender, msg.value); // Emit an event indicating a pledge was received
        }
    
        // Function to check if the funding goal has been met
        function checkGoalMet() public view returns (bool) {
            return totalRaised >= goalAmount;
        }
    
        // Function to finalize the campaign after the deadline
        function finalizeCampaign() external {
            require(block.timestamp >= campaignDeadline, "Campaign is still running.");
            require(campaignOpen, "Campaign has already ended.");
    
            campaignOpen = false; // Close the campaign
    
            if (totalRaised >= goalAmount) {
                // Transfer funds to the beneficiary if the goal is met
                bool success = false;
                (success, ) = projectBeneficiary.call{value: totalRaised}("");
                assert(success); 
                // Ensure transfer was successful
                emit CampaignFinalized(projectBeneficiary, totalRaised); 
                // Emit event for campaign finalization
            } else {
                revert("Funding goal not reached, pledges can be withdrawn by contributors.");
            }
        }
    
        // Function for contributors to withdraw their pledge if the campaign failed
        function withdrawPledge() external {
            require(!campaignOpen, "Campaign is still open.");
            require(totalRaised < goalAmount, "Funding goal was reached, cannot withdraw.");
    
            uint256 pledgedAmount = pledges[msg.sender]; // Get the amount pledged by the sender
            require(pledgedAmount > 0, "No pledges to withdraw.");
    
            pledges[msg.sender] = 0; // Clear the sender's pledge amount
            bool success = false;
            (success, ) = payable(msg.sender).call{value: pledgedAmount}(""); // Transfer funds back to the sender
            require(success, "Withdrawal failed."); // Ensure withdrawal was successful
        }
    }
    
            }
        }


To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.26" (or another compatible version), and then click on the "FUNCTIONS-AND-ERRORS.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the contract from the dropdown menu, and then click on the "Deploy" button.

Once the contract is deployed, you can interact with it by calling the functions provided in the contract. 

To deploy the contract, go to the "Deploy & Run Transactions" tab on the left sidebar. Select "VinceCrowdfunding" from the contract options, then click "Deploy". You'll need to enter three things: the beneficiary's address (_projectBeneficiary), the fundraising goal (_goalAmount), and how long the campaign will run in minutes (_campaignDurationInMinutes).

* INTERACTING WITH THE CONTRACT
The contract allows users to participate in a crowdfunding campaign by pledging funds using the pledge function. After the campaign deadline, the finalizeCampaign function is used to conclude the campaign, ensuring funds are distributed to the beneficiary if the goal is met; otherwise, contributors can withdraw their pledges using withdrawPledge. Other functions include campaignDeadline to check when the campaign ends, checkGoalMet to verify if the funding goal is reached, campaignOpen to check the campaign status, goalAmount to track the targeted fundraising goal, pledges to monitor individual contributions, projectBeneficiary to identify the recipient of funds, and totalRaised to track the total amount contributed throughout the campaign.



# Authors
Metacrafter Student Ivanne Cres Yabut \
https://x.com/ivanne_cres

# License
This project is licensed under the MIT License - see the LICENSE.md file for details.


