// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../base/Base.t.sol";

contract TestMinting is StrategyTestBase {
    // Mint:
    // - Minting increases balance
    function testTokenMinting__MintingWorksAndIncreasesBalance() public {
        address receiver = makeAddr("receiver");
        uint256 amount = token.batchAmount();

        uint256 balanceBefore = token.balanceOf(receiver);

        vm.prank(owner);
        token.mint(receiver);

        uint256 balanceAfter = token.balanceOf(receiver);

        assertEq(
            balanceAfter,
            balanceBefore + amount
        );
    }
    // - Minting increases totalSupply
    function testTokenMinting__MintingWorksAndIncreasesTotalSupply() public {
        address receiver = makeAddr("receiver");
        uint256 amount = token.batchAmount();

        uint256 totalSupplyBefore = token.totalSupply();

        vm.prank(owner);
        token.mint(receiver);

        uint256 totalSupplyAfter = token.totalSupply();

        assertEq(
            totalSupplyAfter,
            totalSupplyBefore + amount
        );
    }
    // - Cant mint to same address more than once
    function testTokenMinting__CantMintToSameAddressMoreThanOnce() public {
        address receiver = makeAddr("receiver");

        vm.prank(owner);
        token.mint(receiver);

        vm.expectRevert();
        vm.prank(owner);
        token.mint(receiver);
    }
}




