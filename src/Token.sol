// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "solmate/src/tokens/ERC20.sol";
import "solmate/src/auth/Owned.sol";

/// @title SweepstakeToken
/// @author 0xZakk (https://twitter.com/0xZakk)
/// @notice This is a single-use token meant solely for the Privy Public Goods Sweepstakes. When users sign up, they will receive 10 tokens, which they can use to vote on who should win the sweepstakes.
/// @dev This contract is based on Solmate's ERC20 and Owned contracts. Most actions are limited to just the owner (like mint and burn). Furthermore, most transfers are blocked, unless they are to a whitelisted recipient. That is to prevent sybil attacks where someone accumulates a lot of tokens and to prevent someone setting up a liquidity pool.
contract SweepstakeToken is ERC20, Owned {
    constructor(
      string memory _name,
      string memory _symbol,
      address _owner)
    ERC20(_name, _symbol, 0) {}

    /// @notice Mint 10 tokens to a new Privy user
    /// @dev This function is only callable by the owner. A user should only ever receive 10 tokens once.
    /// @param _to The address of the user to mint tokens to
    function mint(address _to) public onlyOwner {
        require(balanceOf(_to) == 0, "Already minted")
        _mint(_to, 10);
    }

    /// @notice Burn tokens from a user
    /// @dev This function is only callable by the owner.
    /// @param _from The address of the user to burn tokens from
    /// @param _amount The amount of tokens to burn
    function burn(address _from, uint256 _amount) public onlyOwner {
        _burn(_from, _amount);
    }

    /// @notice Add an address that can receive tokens
    /// @dev This function is only callable by the owner. Only whitelisted addresses can receive tokens, otherwise the call should revert. This is how we prevent users from transferring tokens outside the context of voting.
    /// @param _address The address to add to the whitelist
    function addWhitelist(address _address) public onlyOwner {
        whitelist[_address] = true;
    }

    /// @notice Add multiple addresses to the whitelist at once
    /// @dev This function is only callable by the owner. It loops through an array of addresses and adds each one to the whitelist.
    /// @param _addresses The addresses to add to the whitelist
    function addWhitelist(address[] memory _addresses) public onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = true;
        }
    }

    /// @notice Remove an address from the whitelist
    /// @dev This function is only callable by the owner. Remove a token from the whitelist to receive tokens.
    /// @param _address The address to remove from the whitelist
    function removeWhitelist(address _address) public onlyOwner {
        whitelist[_address] = false;
    }

    /// @notice Remove multiple addresses from the whitelist at once
    /// @dev This function is only callable by the owner. It loops through an array of addresses and removes each one from the whitelist.
    /// @param _addresses The addresses to remove from the whitelist
    function removeWhitelist(address[] memory _addresses) public onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = false;
        }
    }

    /// @notice Transfer tokens to a recipient
    /// @dev We override the transfer function to ensure that only whitelisted addresses can receive tokens. This prevents users from accumulating tokens to a single address, setting up a liquidity pool, or doing anything other than voting in the sweepstakes.
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to transfer
    function transfer(address _to, uint256 _amount) public override returns (bool) {
        require(whitelist[_recipient], "Transfer not allowed");
        return super.transfer(_recipient, _amount);
    }

    /// @notice Transfer tokens from one address to another
    /// @dev We override the transferFrom function to ensure that only whitelisted addresses can receive tokens. This prevents users from accumulating tokens to a single address, setting up a liquidity pool, or doing anything other than voting in the sweepstakes.
    /// @param Documents a parameter just like in doxygen (must be followed by parameter name)
    function transferFrom(address _from, address _to, uint256 _amount) public override returns (bool) {
        require(whitelist[_recipient], "Transfer not allowed");
        return super.transferFrom(_from, _to, _amount);
    }
}

