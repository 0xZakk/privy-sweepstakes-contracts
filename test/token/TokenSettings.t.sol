// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../base/Base.t.sol";

contract TokenSettings is StrategyTestBase {
    // Token name matches tokenName
    function testTokenSettings__TokenNameSetOnDeploy() public {
        assertEq(
            token.name(),
            tokenName
        );
    }

    function testTokenSettings__TokenSymbolSetOnDeploy() public {
        assertEq(
            token.symbol(),
            tokenSymbol
        );
    }

    function testTokenSettings__TokenBatchAmountSetOnDeploy() public {
        // Test the basic token
        assertEq(
            token.batchAmount(),
            10
        );

        // Test the token with a different batch amount
        SweepstakesToken token2 = new SweepstakesToken(
            tokenName,
            tokenSymbol,
            owner,
            20
        );
        assertEq(
            token2.batchAmount(),
            20
        );
        SweepstakesToken token3 = new SweepstakesToken(
            tokenName,
            tokenSymbol,
            owner,
            1
        );
        assertEq(
            token3.batchAmount(),
            1
        );
    }

    function testTokenSettings__OwnerSetOnDeploy() public {
        assertEq(
            token.owner(),
            owner
        );
    }
}
