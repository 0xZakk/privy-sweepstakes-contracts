// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../base/Base.t.sol";

contract TestTransfer is StrategyTestBase {
    address receiver = makeAddr("receiver");
    address whitelisted = makeAddr("whitelisted");

    function setUp() public override {
        super.setUp();

        vm.startPrank(owner);
        token.mint(receiver);
        token.addWhitelist(whitelisted);

        vm.stopPrank();
    }
    // Transfer:
    // - Transfer fails if address is not whitelisted
    function testTokenTransfer__TransferFailsIfNotToWhitelistedAddress() public {
        address unacceptableTo = makeAddr("unacceptableTo");

        vm.expectRevert("Transfer not allowed");
        vm.prank(receiver);
        token.transfer(unacceptableTo, 1);
    }

    // Transfer works is address is whitelisted
    function testTokenTransfer__TransferWorksIfToWhitelistedAddress() public {
        address acceptableTo = makeAddr("acceptableTo");

        vm.prank(owner);
        token.addWhitelist(acceptableTo);

        vm.prank(receiver);
        token.transfer(acceptableTo, 1);

        assertEq(token.balanceOf(acceptableTo), 1);
        assertEq(token.balanceOf(receiver), 9);
    }

    // approve fails if address is not whitelisted
    function testTokenTransfer__ApproveFailsIfNotToWhitelistedAddress() public {
        address to = makeAddr("unacceptableTo");

        vm.expectRevert("Transfer not allowed");
        vm.prank(receiver);
        token.approve(to, 1);
    }

    // approval works if address is whitelisted
    function testTokenTransfer__ApproveWorksIfToWhitelistedAddress() public {
        vm.prank(receiver);
        token.approve(whitelisted, 1);

        assertEq(token.allowance(receiver, whitelisted), 1);
    }

    // TransferFrom fails if address is not whitelisted
    function testTokenTransfer__TransferFromFailsIfNotToWhitelistedAddress() public {
        address to = makeAddr("unacceptableTo");

        vm.expectRevert("Transfer not allowed");
        vm.prank(receiver);
        token.transferFrom(receiver, to, 1);
    }

    // transferFrom works if address is whitelisted
    function testTokenTransfer__TransferFromWorksIfWhitelisted() public {
        vm.prank(receiver);
        token.approve(whitelisted, 5);

        console.log(token.allowance(receiver, whitelisted));

        vm.prank(whitelisted);
        token.transferFrom(receiver, whitelisted, 1);

        assertEq(token.balanceOf(whitelisted), 1);
        assertEq(token.balanceOf(receiver), 9);
    }

    // increase allowance fails if address is not whitelisted
    function testTokenTransfer__IncreaseAllowanceFailsIfNotToWhitelistedAddress() public {
        address to = makeAddr("unacceptableTo");

        vm.expectRevert("Transfer not allowed");
        vm.prank(receiver);
        token.increaseAllowance(to, 1);
    }

    // increase allowance works if address is whitelisted
    function testTokenTransfer__IncreaseAllowanceWorksIfWhitelisted() public {
        vm.prank(receiver);
        token.increaseAllowance(whitelisted, 1);

        assertEq(token.allowance(receiver, whitelisted), 1);

        vm.prank(receiver);
        token.increaseAllowance(whitelisted, 1);

        assertEq(token.allowance(receiver, whitelisted), 2);
    }

    // decrease allowance fails if address is not whitelisted
    function testTokenTransfer__DecreaseAllowanceFailsIfNotToWhitelistedAddress() public {
        address to = makeAddr("unacceptableTo");

        vm.expectRevert("Transfer not allowed");
        vm.prank(receiver);
        token.decreaseAllowance(to, 1);
    }

    // decrease allowance works if address is whitelisted
    function testTokenTransfer__DecreaseAllowanceWorksIfWhitelisted() public {
        vm.prank(receiver);
        token.approve(whitelisted, 10);

        vm.prank(receiver);
        token.decreaseAllowance(whitelisted, 1); 

        // allowance: 9
        assertEq(token.allowance(receiver, whitelisted), 9);

        vm.prank(receiver);
        token.decreaseAllowance(whitelisted, 4);

        // allowance: 5
        assertEq(token.allowance(receiver, whitelisted), 5);
    }
}
