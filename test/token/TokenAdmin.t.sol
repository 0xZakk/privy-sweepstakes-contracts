// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../base/Base.t.sol";

contract TokenAdmin is StrategyTestBase {
    bytes32 public minterRole;

    function setUp() public override {
        super.setUp();
        minterRole = token.MINTER_ROLE();
    }

    // - Add to whitelist (single)
    function testTokenAdmin__AddAddressToWhitelist() public {
        address receiver = makeAddr("receiver");

        vm.expectRevert();
        token.addWhitelist(receiver);

        vm.prank(owner);
        token.addWhitelist(receiver);

        assert(
            token.whitelist(receiver) == true
        );
    }
    // - Add to whitelist (batch)
    function testTokenAdmin__AddBatchAddressesToWhitelist() public {
        address[] memory receivers = new address[](2);
        receivers[0] = makeAddr("receiver0");
        receivers[1] = makeAddr("receiver1");

        vm.expectRevert();
        token.addWhitelist(receivers);

        vm.prank(owner);
        token.addWhitelist(receivers);

        assert(
            token.whitelist(receivers[0]) == true &&
            token.whitelist(receivers[1]) == true
        );
    }
    // - Remove from whitelist (single)
    function testTokenAdmin__RemoveAddressFromWhitelist() public {
        address receiver = makeAddr("receiver");

        vm.prank(owner);
        token.addWhitelist(receiver);

        vm.expectRevert();
        token.removeWhitelist(receiver);

        vm.prank(owner);
        token.removeWhitelist(receiver);

        assert(
            token.whitelist(receiver) == false
        );
    }
    // - Remove from whitelist (batch)
    function testTokenAdmin__RemoveBatchAddressesFromWhitelist() public {
        address[] memory receivers = new address[](2);
        receivers[0] = makeAddr("receiver0");
        receivers[1] = makeAddr("receiver1");

        vm.prank(owner);
        token.addWhitelist(receivers);

        vm.expectRevert();
        token.removeWhitelist(receivers);

        vm.prank(owner);
        token.removeWhitelist(receivers);

        assert(
            token.whitelist(receivers[0]) == false &&
            token.whitelist(receivers[1]) == false
        );
    }
    // - Grant MINTER_ROLE
    function testTokenAdmin__GrantMinterRole() public {
        address minter = makeAddr("minter");

        vm.expectRevert();
        token.grantRole(minterRole, minter);

        vm.prank(owner);
        token.grantRole(minterRole, minter);

        assert(
            token.hasRole(minterRole, minter) == true
        );
    }
    // - Revoke MINTER_ROLE
    function testTokenAdmin__RevokeMinterRole() public {
        address minter = makeAddr("minter");

        vm.prank(owner);
        token.grantRole(minterRole, minter);

        vm.expectRevert();
        token.revokeRole(minterRole, minter);

        vm.prank(owner);
        token.revokeRole(minterRole, minter);

        assert(
            token.hasRole(minterRole, minter) == false
        );
    }
    // - Minting without admin or minter role fails
    function testTokenAdmin__MintingWithoutAdminOrMinterRoleFails() public {
        address receiver = makeAddr("receiver");

        vm.expectRevert();
        token.mint(receiver);
    }
    // - Mint tokens (admin)
    function testTokenAdmin__AdminCanMintTokens() public {
        address receiver = makeAddr("receiver");

        vm.prank(owner);
        token.mint(receiver);

        assert(
            token.balanceOf(receiver) == token.batchAmount()
        );
    }
    // - Mint tokens (minter)
    function testTokenAdmin__MinterRoleCanMintTokens() public {
        address receiver = makeAddr("receiver");
        address minter = makeAddr("minter");

        vm.prank(owner);
        token.grantRole(minterRole, minter);

        vm.prank(minter);
        token.mint(receiver);

        assert(
            token.balanceOf(receiver) == token.batchAmount()
        );
    }
    // - Burn tokens (admin)
    function testTokenAdmin__AdminCanBurnTokens() public {
        address receiver = makeAddr("receiver");
        uint256 amount = token.batchAmount();

        vm.prank(owner);
        token.mint(receiver);

        vm.prank(owner);
        token.burn(receiver, amount);

        assert(
            token.balanceOf(receiver) == 0
        );
    }
    // - Minter cannot burn tokens
    function testTokenAdmin__MinterCannotBurnTokens() public {
        address receiver = makeAddr("receiver");
        address minter = makeAddr("minter");
        uint256 amount = token.batchAmount();

        vm.prank(owner);
        token.grantRole(minterRole, minter);

        vm.prank(minter);
        token.mint(receiver);

        vm.expectRevert();
        vm.prank(minter);
        token.burn(receiver, amount);
    }
}


