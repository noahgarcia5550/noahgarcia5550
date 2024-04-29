// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Proposal {
        string description;
        uint256 voteCount;
    }

    mapping(address => bool) public hasVoted;
    mapping(bytes32 => Proposal) public proposals;
    bytes32[] public proposalIds;

    event ProposalCreated(bytes32 id, string description);
    event Voted(address indexed voter, bytes32 proposalId);

    function createProposal(bytes32 id, string memory description) external {
        require(proposals[id].voteCount == 0, "Proposal ID already exists");
        proposals[id] = Proposal(description, 0);
        proposalIds.push(id);
        emit ProposalCreated(id, description);
    }

    function listProposals() external view returns (bytes32[] memory) {
        return proposalIds;
    }

    function vote(bytes32 proposalId) external {
        require(!hasVoted[msg.sender], "Already voted");
        require(proposals[proposalId].voteCount > 0, "Invalid proposal ID");

        proposals[proposalId].voteCount++;
        hasVoted[msg.sender] = true;
        emit Voted(msg.sender, proposalId);
    }

    function getWinningProposal() external view returns (bytes32 winningProposal, uint256 winningVoteCount) {
        require(proposalIds.length > 0, "No proposals available");

        for (uint256 i = 0; i < proposalIds.length; i++) {
            bytes32 id = proposalIds[i];
            uint256 voteCount = proposals[id].voteCount;
            if (voteCount > winningVoteCount) {
                winningProposal = id;
                winningVoteCount = voteCount;
            }
        }
    }
}
