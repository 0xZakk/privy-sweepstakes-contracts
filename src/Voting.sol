// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IVotingStrategy} from "allo/votingStrategy/IVotingStrategy.sol";
import {RoundImplementation} from "allo/round/RoundImplementation.sol";

contract SweepstakesVoting is IVotingStrategy {
  // Map projectId to number of votes
  mapping(bytes32 => uint256) public votes;
  mapping(address => bool) public hasVoted;

  // Track project Ids
  bytes32[] public projectIds;

  // Track total votes
  uint256 public totalVotes;

  // RoundImplementation public override roundAddress;

  function vote(bytes[] calldata _encodedVotes, address _voterAddress) override external payable {
    (
      bytes32 _projectId,
      uint256 _applicationIndex
    ) = abi.decode(_encodedVotes[0], (
      bytes32,
      uint256
    ));

    // @TODO: check to ensure the project id is for an approved application
    // @NOTE: This doesn't seem to actually be possible without some gymnastics
    // uint256 applicationStatus = getApplicationStatus(
    //   getApplicationIndexesByProjectId(_projectId)
    // );

    if (votes[_projectId] == 0) {
      projectIds.push(_projectId);
    }

    votes[_projectId] += 1;
    totalVotes += 1;

    hasVoted[_voterAddress] = true;
  }
}
