// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    mapping(address => bool) public hasVoted;
    mapping(bytes32 => uint256) public votesReceived;

    function vote(bytes32 proposal) public {
        require(!hasVoted[msg.sender], "Already voted");
        votesReceived[proposal] += 1;
        hasVoted[msg.sender] = true;
    }
}
