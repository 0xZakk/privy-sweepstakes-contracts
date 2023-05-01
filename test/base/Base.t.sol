// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import { SweepstakesToken } from "../../src/Token.sol";
import { SweepstakesPayout } from "../../src/Payout.sol";
import { SweepstakesVoting } from "../../src/Voting.sol";

import { ERC20 } from "oz/token/ERC20/ERC20.sol";

import { MetaPtr } from "allo/utils/MetaPtr.sol";
import { RoundFactory } from "allo/round/RoundFactory.sol";
import { RoundImplementation } from "allo/round/RoundImplementation.sol";
import { ProgramFactory } from "allo/program/ProgramFactory.sol";
import { ProgramImplementation } from "allo/program/ProgramImplementation.sol";
import { IVotingStrategy } from "allo/votingStrategy/IVotingStrategy.sol";
import { IPayoutStrategy } from "allo/payoutStrategy/IPayoutStrategy.sol";

contract StrategyTestBase is Test {
    struct InitAddress {
        IVotingStrategy votingStrategy; // Deployed voting strategy contract
        IPayoutStrategy payoutStrategy; // Deployed payout strategy contract
    }

    struct InitRoundTime {
        uint256 applicationsStartTime; // Unix timestamp from when round can accept applications
        uint256 applicationsEndTime; // Unix timestamp from when round stops accepting applications
        uint256 roundStartTime; // Unix timestamp of the start of the round
        uint256 roundEndTime; // Unix timestamp of the end of the round
    }

    struct InitMetaPtr {
        MetaPtr roundMetaPtr; // MetaPtr to the round metadata
        MetaPtr applicationMetaPtr; // MetaPtr to the application form schema
    }

    struct InitRoles {
        address[] adminRoles; // Addresses to be granted DEFAULT_ADMIN_ROLE
        address[] roundOperators; // Addresses to be granted ROUND_OPERATOR_ROLE
    }
    RoundFactory roundFactory = RoundFactory(0x9Cb7f434aD3250d1656854A9eC7A71EceC6eE1EF);
    ProgramFactory programFactory = ProgramFactory(0x56296242CA408bA36393f3981879fF9692F193cC);

    RoundImplementation round;
    ProgramImplementation program;
    InitAddress initAddress;
    InitRoundTime initRoundTime;

    ERC20 usdc = ERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    address owner = makeAddr("owner");
    address minter1 = makeAddr("minter1");
    address minter2 = makeAddr("minter2");
    address[] minters = [minter1, minter2];

    address admin1 = makeAddr("admin1");
    address admin2 = makeAddr("admin2");
    address[] admins = [admin1, admin2];

    address programOperator1 = makeAddr("programOperator1");
    address programOperator2 = makeAddr("programOperator2");
    address[] programOperators = [programOperator1, programOperator2];

    address roundOperator1 = makeAddr("roundOperator1");
    address roundOperator2 = makeAddr("roundOperator2");
    address[] roundOperators = [roundOperator1, roundOperator2];

    SweepstakesToken token;
    IVotingStrategy votingStrategy;
    IPayoutStrategy payoutStrategy;

    string tokenName = "Privy Sweepstakes Token";
    string tokenSymbol = "PST";

    uint256 matchAmount = 10_000 * 10**6; // 10,000 USDC
    uint256 roundFeePercentage = 0; // 0%


    InitMetaPtr initMetaPtr = InitMetaPtr(
        MetaPtr(
            1,
            "QmPMERYmqZtbHmqd2UzRhX9F4cixnMQU2GFa2hYAsQ6J3D"
        ),
        MetaPtr(
            1,
            "QmPMERYmqZtbHmqd2UzRhX9F4cixnMQU2GFa2hYAsQ6J3D"
        )
    );

    InitRoles initRoles = InitRoles(
        admins,
        roundOperators
    );

    function createProgram() public returns (ProgramImplementation) {
        address programAddr = programFactory.create(
            abi.encode(
                MetaPtr(
                    1,
                    "QmPMERYmqZtbHmqd2UzRhX9F4cixnMQU2GFa2hYAsQ6J3D"
                ),
                admins,
                programOperators
            )
        );

        program = ProgramImplementation(programAddr);
        return program;
    }

    function setUp() public virtual {
        // Fork mainnet, so we can interact directly with the mainnet Allo
        // contracts
        vm.createSelectFork(vm.rpcUrl("mainnet"));

        vm.startPrank(owner);

        // program
        program = createProgram();

        // voting token
        token = new SweepstakesToken(tokenName, tokenSymbol, owner, 10);

        // voting strategy
        votingStrategy = new SweepstakesVoting();

        // payout strategy
        payoutStrategy = new SweepstakesPayout();

        // Round Parameters
        initAddress = InitAddress(
            votingStrategy,
            payoutStrategy
        );

        initRoundTime = InitRoundTime(
            block.timestamp + 100, // applicationsStartTime
            block.timestamp + 250, // applicationsEndTime
            block.timestamp + 500, // roundStartTime
            block.timestamp + 1000 // roundEndTime
        );

        // Create a new round
        address roundAddr = roundFactory.create(
            // encoded parameters
            abi.encode(
                initAddress,
                initRoundTime,
                matchAmount,
                usdc, // token
                0, // round fee percentage
                address(0), // round fee Addresses
                initMetaPtr,
                initRoles
            ),
            // program contract
            address( program )
        );
        round = RoundImplementation(payable( roundAddr ));

        vm.stopPrank();
    }
}

