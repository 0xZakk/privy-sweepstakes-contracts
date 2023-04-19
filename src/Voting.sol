// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IVotingStrategy} from "allo/votingStrategy/IVotingStrategy.sol";

contract SweepstakesVoting is IVotingStrategy {

  function vote(bytes[] calldata _encodedVotes, address _voterAddress) override external payable {

  }
}
