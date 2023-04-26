// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "./base/Base.t.sol";

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

}
