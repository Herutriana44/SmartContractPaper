// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReputationSystem {
    struct Reputation {
        address scientist;
        uint256 score;
        uint256[] contributions;
    }

    mapping(address => Reputation) public reputations;
    mapping(string => uint256) public reputationRules;

    event ReputationUpdated(address indexed scientist, uint256 newScore);
    event ReputationRuleUpdated(string ruleName, uint256 newValue);

    constructor() {
        reputationRules["base_score"] = 10;
        reputationRules["approval_bonus"] = 5;
        reputationRules["rejection_penalty"] = 3;
    }

    function calculateReputation(address scientist, bool approved) public {
        if (approved) {
            reputations[scientist].score += reputationRules["approval_bonus"];
        } else {
            reputations[scientist].score -= reputationRules["rejection_penalty"];
        }

        emit ReputationUpdated(scientist, reputations[scientist].score);
    }

    function updateReputationRules(string memory ruleName, uint256 newValue) public {
        reputationRules[ruleName] = newValue;
        emit ReputationRuleUpdated(ruleName, newValue);
    }
}