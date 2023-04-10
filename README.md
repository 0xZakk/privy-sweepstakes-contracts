# Privy x Gitcoin Allo Sweepstakes

This repository implements a [Voting
Strategy](https://docs.allo.gitcoin.co/core-concepts/voting-strategy) and
[Payout Strategy](https://docs.allo.gitcoin.co/core-concepts/payout-strategy)
for the upcoming Privy Public Goods Sweepstakes.

### Usage

**Building & Testing**

You can build the smart contracts with the following command:

```sh
forge build
```

Use the following command to run the tests:

```sh
forge test
```

## Specification

The following outline the requirements for the custom sweepstakes voting and
payout strategy. The actual implementation can be found in the smart contracts
themselves. 

### [Sweepstake Voting Token](./src/Token.sol)

**Description:**

The voting token is a fairly standard ERC20 token (this one is based on
Solmate's implementation). It has a few unique constraints in that we don't want
people to be able to do anything other than vote with it. So transferring has
some limitations on it.

**Requirements:**

- Only the owner (admin) can mint new tokens
- Tokens can only be minted 10 to a user
- An address can only receive tokens once (i.e. one allotment of 10 tokens)
- The token should generally be non-transferable unless that transfer is voting
    in a round

### [Sweepstake Voting Strategy](./src/Voting.sol)

**Description:**

The voting strategy is how users will vote on which project should
win the sweepstake. Votes go through the round, so the voting strategy can't be
called directly itself. The voting strategy emits an event for each vote. It
also records and tallies votes, which are used by the Payout Strategy to payout
the sweepstakes at the end.

**Requirements:**

- Voting is limited to the three partners, selected by Privy.
- Only holders of the specific token can vote. All other votes are rejected. 
- The voting token is otherwise not transferable 

### [Sweepstake Payout Strategy](./src/Payout.sol)

**Description:**

The payout strategy looks at the three selected grantees and their distribution
of the voting token and pays out the matching pool according to that
distribution, by percentage. So if a grantee received 30% of the votes, they'll
receive 30% of the matching pool. Distribution should be on votes rather than
token supply because some people who sign up and receive tokens may not vote.

**Requirements:**

- Divides payments according to distribution of votes cast.
- Only sends out three payments (one for each of the accepted grantees)

### Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._

See [LICENSE](./LICENSE) for more details.
