// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "./base/Base.t.sol";

contract PayoutTest is StrategyTestBase {
    function setUp() public override {
        super.setUp();
    }

    // Sets the round address properly, to the address of the round
    function testPayout__setRound() public {
        assertEq(
            payoutStrategy.roundAddress(),
            address(round)
        );

        assertEq(
            address( round.payoutStrategy() ),
            address( payoutStrategy )
        );
    }
}
