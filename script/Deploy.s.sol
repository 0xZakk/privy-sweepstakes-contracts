// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from 'forge-std/Script.sol';

import { SweepstakesToken } from "src/Token.sol";
import { SweepstakesPayout } from "src/Payout.sol";
import { SweepstakesVoting } from "src/Voting.sol";

/// @notice A very simple deployment script
contract Deploy is Script {

  /// @notice The main script entrypoint
  function run() external {
    vm.startBroadcast();

    // @TODO: Deploy Token
    // @TODO: Deploy Voting Strategy
    // @TODO: Deploy Payout Strategy

    vm.stopBroadcast();
  }
}
