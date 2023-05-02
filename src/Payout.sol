// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IPayoutStrategy} from "allo/payoutStrategy/IPayoutStrategy.sol";
import {RoundImplementation} from "allo/round/RoundImplementation.sol";
import {SweepstakesVoting} from "./Voting.sol";

contract SweepstakesPayout is IPayoutStrategy {

  function isDistributionSet() public override pure returns (bool) {
    return false;
  }
  function updateDistribution(bytes calldata _encodedDistribution) external
  override {}

  function payout() external roundHasEnded {
    RoundImplementation round = RoundImplementation(roundAddress);
    address _votingStrategy = address(round.votingStrategy());
    SweepstakesVoting voting = SweepstakesVoting(_votingStrategy);

    // Loop through project ids on voting votingStrategy
    // calculate percentage of total votes
    // get project's address somehow
    // transfer that percentage of the total prize pool to the project
    uint256 totalVotes = voting.totalVotes();
    for (uint i = 0; i < voting.projectIds.length; i++) {
      uint256 votes = voting.votes[voting.projectIds[i]];
      uint256 percentage = votes / totalVotes;
      uint256 prize = round.prizePool * percentage;

      // @TODO: transfer price amount of token (on round) to project
      // @NOTE: need to get the address from the project ID (somehow)
      // @NOTE: need to get the token from the round
    }
  }
}

