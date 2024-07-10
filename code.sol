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
