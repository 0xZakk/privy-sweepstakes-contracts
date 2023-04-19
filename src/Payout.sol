// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IPayoutStrategy} from "allo/payoutStrategy/IPayoutStrategy.sol";

contract SweepstakesPayout is IPayoutStrategy {

  function isDistributionSet() override public view returns (bool) {
    return true;
  }

  function updateDistribution(bytes calldata _encodedDistribution) override external {}
}

