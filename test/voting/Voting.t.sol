// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../base/Base.t.sol";

contract VotingTest is StrategyTestBase {

    function setUp() public override {
        super.setUp();
    }

    // Sets the round address properly, to the address of the round
    function testVoting__setRound() public {
        assertEq(
            votingStrategy.roundAddress(),
            address(round)
        );

        assertEq(
            address( round.votingStrategy() ),
            address( votingStrategy )
        );
    }

    // Cant vote for a non-grantee
    // Can only vote once

    // Voting updates total votes
    function testVoting__VotingUpdatesTotalVotes() public {
        vm.warp(initRoundTime.roundStartTime);

        bytes32 projectId = bytes32("projectId");

        bytes[] memory encodedVotes = new bytes[](1);
        encodedVotes[0] = abi.encode(projectId, uint256(0));

        round.vote(encodedVotes);

        assertEq(
            votingStrategy.totalVotes(),
            uint256(1)
        );
    }

    // Voting records that you have voted
    function testVoting__VotingRecordsThatYouHaveVoted() public {
        vm.warp(initRoundTime.roundStartTime);

        bytes32 projectId = bytes32("projectId");

        bytes[] memory encodedVotes = new bytes[](1);
        encodedVotes[0] = abi.encode(projectId, uint256(0));

        round.vote(encodedVotes);

        assertEq(
            votingStrategy.hasVoted(address(this)),
            true
        );
    }

    // Voting is tracked to the project
    function testVoting__VoteIsProperlyTracked() public {
        vm.warp(initRoundTime.roundStartTime);

        bytes32 projectId = bytes32("projectId");

        bytes[] memory encodedVotes = new bytes[](1);
        encodedVotes[0] = abi.encode(projectId, uint256(0));

        round.vote(encodedVotes);

        assertEq(
            votingStrategy.votes(projectId),
            1
        );
    }
}
