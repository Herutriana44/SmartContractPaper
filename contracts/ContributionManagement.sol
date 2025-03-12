// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContributionManagement {
    enum Status { Pending, Approved, Rejected }

    struct Contribution {
        uint256 id;
        address scientist;
        string contentHash;
        Status status;
        address reviewer;
        uint256 timestamp;
    }

    mapping(uint256 => Contribution) public contributions;
    uint256 public contributionCounter;

    event ContributionSubmitted(uint256 indexed contributionID, address scientist);
    event ReviewRequested(uint256 indexed contributionID, address reviewer);
    event ContributionApproved(uint256 indexed contributionID);
    event ContributionRejected(uint256 indexed contributionID);

    function submitContribution(string memory contentHash) public {
        contributionCounter++;
        contributions[contributionCounter] = Contribution(
            contributionCounter, msg.sender, contentHash, Status.Pending, address(0), block.timestamp
        );

        emit ContributionSubmitted(contributionCounter, msg.sender);
    }

    function requestReview(uint256 contributionID, address reviewer) public {
        require(contributions[contributionID].status == Status.Pending, "Invalid contribution ID");
        contributions[contributionID].reviewer = reviewer;

        emit ReviewRequested(contributionID, reviewer);
    }

    function approveContribution(uint256 contributionID, bool decision) public {
        require(msg.sender == contributions[contributionID].reviewer, "Unauthorized reviewer");

        if (decision) {
            contributions[contributionID].status = Status.Approved;
            emit ContributionApproved(contributionID);
        } else {
            contributions[contributionID].status = Status.Rejected;
            emit ContributionRejected(contributionID);
        }
    }
}