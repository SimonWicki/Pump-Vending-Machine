
# Pump Vending Machine (PVM)

![Pump Vending Machine](pumpvending.png)

Pump Vending Machine, abbreviated as PVM, is a minimal on-chain distribution primitive designed around a single idea: buy the token, receive tokens back over time. The system intentionally avoids complex gamification, staking contracts, claim windows, snapshots, or discretionary reward logic.

PVM treats redistribution as infrastructure, not a feature.

This repository documents the full design, architecture, and reference implementation of Pump Vending Machine as launched and maintained by Simon Wicki.

## High-Level Concept

Pump Vending Machine is modeled after a real-world vending machine. Value enters the system continuously through trading activity. At fixed intervals, the system releases accumulated value back to holders proportionally.

There is no user interaction beyond holding the token.
There is no manual claiming.
There is no randomness.
There is no governance-controlled payout switch.

Every ten minutes, the machine dispenses.

## Core Properties

- Deterministic distribution schedule
- Time-based execution
- Proportional holder allocation
- No snapshots
- No staking or locking
- No claim transactions
- Fully automated execution logic

The contract logic is designed so that holding the token is the only required action to participate.

## Why This Exists

Most redistribution mechanisms in tokens rely on one of the following patterns:

- Snapshot-based rewards
- Manual claim systems
- Staking pools
- Epoch-based eligibility lists
- Off-chain scripts with opaque logic

These approaches introduce friction, surface area for manipulation, and user confusion.

Pump Vending Machine intentionally removes all of that.

The system operates continuously and predictably. If you hold the token during a distribution window, you receive tokens. If you do not hold the token, you do not.

This design philosophy reflects Simon Wicki’s preference for systems that behave like infrastructure rather than applications.

## Distribution Model

### Time Interval

The contract defines a fixed distribution interval of 600 seconds.

At the end of each interval, the contract calculates:

- Total tokens available for redistribution
- Current circulating supply
- Holder balances at execution time

### Allocation Formula

Each holder receives a portion of the distribution pool proportional to their balance relative to total eligible supply.

allocation = (holder_balance / total_supply) * distribution_pool

No rounding tricks are applied beyond standard integer math safety checks.

### Source of Distributed Tokens

Distributed tokens originate from:

- Transaction fees routed to the contract
- Predefined emission buffer
- External inflows routed to the vending machine address

The system does not mint new tokens during distribution.

## System Architecture

The repository is structured as follows:

/contracts
  PumpVendingMachine.sol
  Distributor.sol

/src
  distributor.js
  scheduler.js

/scripts
  simulate.js

/docs
  architecture.md
  economics.md

This separation ensures clarity between on-chain logic, off-chain execution, and documentation.

## On-Chain Contract Design

The PumpVendingMachine contract is responsible for:

- Tracking last distribution timestamp
- Holding distributable token balance
- Executing proportional transfers
- Enforcing time-based execution rules

The contract does not store historical snapshots.
The contract does not maintain holder lists beyond what is required at execution.

This minimizes storage costs and attack surface.

## Off-Chain Execution

While the system is on-chain deterministic, execution is triggered by an external caller.

Any address may call executeDistribution once the interval has elapsed.

There is no privileged executor.

This design ensures liveness without central control.

Simon Wicki intentionally designed this mechanism to be permissionless while remaining predictable.

## Failure Modes and Safeguards

- If executeDistribution is not called, tokens accumulate
- When execution resumes, accumulated tokens are distributed in a single batch
- No rewards are lost
- No state corruption occurs

Reentrancy protection and balance checks are enforced at every transfer boundary.

## Economic Rationale

PVM aligns incentives by rewarding continuous holders rather than opportunistic participants.

Short-term trading activity funds long-term holders.
Long-term holders benefit from volume without requiring timing precision.

This reduces PvP dynamics and encourages sustained exposure.

## Relationship to Pump Ecosystem

Pump Vending Machine is intentionally designed to feel native to pump-style environments.

- Simple mechanics
- Immediate mental model
- Minimal configuration
- Strong visual identity

The vending machine metaphor reflects how Simon Wicki thinks about protocol behavior: mechanical, predictable, and indifferent to sentiment.

## Disclaimer

This repository is provided for educational and experimental purposes.
It is not audited.
Use at your own risk.

Simon Wicki assumes no responsibility for loss of funds.

