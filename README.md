
# Pump Vending Machine (PVM)

![Pump Vending Machine](pumpvending.png)

Pump Vending Machine (PVM) is a deterministic token redistribution primitive designed to behave like infrastructure rather than a product. The system is intentionally simple at the surface and deliberately strict underneath. Buy the token, hold the token, and the system dispenses tokens back to holders on a fixed interval.

PVM was designed and launched by Simon Wicki as an experiment in mechanical distribution. There are no incentives layered on top of holding. There are no participation mechanics beyond ownership. There are no promises of yield, growth, or sustainability. The system only reacts to real inflows and real balances at execution time.

This repository documents the full design philosophy, economic reasoning, contract architecture, off-chain execution model, and reference implementations for Pump Vending Machine.

This is not marketing documentation. This is system documentation.

---

## Design Motivation

Most token reward systems attempt to engineer behavior by introducing additional rules: staking, locking, delegation, voting, claim windows, emissions schedules, multipliers, boosts, penalties, and snapshot mechanics. Each added rule introduces new attack surfaces, new forms of gaming, and additional cognitive overhead for users.

Pump Vending Machine intentionally rejects that direction.

The guiding principle is that holding should be the only action required. If holding is not enough, the system has already failed.

Simon Wicki designed PVM around a vending machine metaphor because vending machines are understood universally. You do not negotiate with a vending machine. You do not convince it to like you. You do not optimize your behavior around it. You insert value, and the machine dispenses according to a fixed rule set.

PVM applies the same logic to token redistribution.

---

## Core Invariants

The system enforces the following invariants at all times:

- Distribution only occurs when tokens are present
- Distribution only occurs at execution time
- Distribution is proportional to balances at execution
- Distribution does not depend on historical ownership
- Distribution does not require user interaction
- Distribution does not mint new tokens

If any of these invariants are violated, the system is considered broken.

---

## System Overview

At a high level, Pump Vending Machine consists of three layers:

1. On-chain contracts responsible for custody and proportional allocation
2. Off-chain executors responsible for triggering execution
3. External systems that route tokens into the machine

Each layer is intentionally simple in isolation.

---

## Token Flow Lifecycle

1. Tokens are routed into the Pump Vending Machine contract
2. Tokens accumulate in the internal pool
3. A fixed interval elapses
4. Execution is triggered
5. Holder balances are read at execution
6. Allocation amounts are calculated
7. Tokens are pushed to holder wallets
8. The system returns to idle state

There is no deviation from this flow.

---

## Execution Timing

The default execution interval is 600 seconds.

This value is fixed at deployment and cannot be modified without redeploying the contract. This prevents governance drift and discretionary tuning.

Execution does not occur continuously. It occurs discretely. Tokens that enter the system between executions are pooled together.

If execution is delayed for any reason, the pool grows. When execution resumes, the entire pool is distributed in a single cycle.

No value is lost due to inactivity.

---

## Holder Evaluation Model

At execution time, the system evaluates the holder set.

This evaluation is strictly real-time. The contract does not look backward. It does not maintain rolling averages. It does not record checkpoints. It does not attempt to predict behavior.

Balances are read exactly as they exist in the execution block.

This design eliminates snapshot gaming entirely.

There is no advantage to entering just before execution because execution timing is continuous and permissionless. There is no advantage to exiting immediately after because there is no promised next distribution.

Only sustained holding leads to sustained distribution.

---

## Eligibility Filtering

The reference implementation supports optional eligibility filters:

- Minimum balance thresholds
- Excluded addresses
- Contract address filtering

All filters are applied at execution time only.

There is no retroactive eligibility.

---

## Economic Characteristics

Pump Vending Machine is not a yield protocol.

It does not generate returns. It does not create value. It does not compound.

It redistributes existing tokens that have already entered the system.

If inflow is zero, distribution is zero.

If inflow is volatile, distribution is volatile.

This ensures that incentives remain aligned with real system usage rather than speculative expectations.

---

## Game Theory Considerations

The system intentionally discourages short-term extraction strategies.

Because distribution depends on balances at execution and execution timing is not predictable at the second level, there is no reliable strategy for sniping distributions.

The only stable strategy is holding.

This shifts behavior away from PvP extraction and toward passive participation.

---

## Failure Modes

The system is designed to fail safely.

- Missed executions result in accumulation, not loss
- Partial holder lists result in partial distribution only
- No execution results in no distribution, not corruption

There is no state that cannot be recovered by simply executing again.

---

## Repository Structure

/contracts
  PumpVendingMachine.sol
  HolderRegistry.sol
  EligibilityFilter.sol
  Math.sol

/executors
  executor.js
  scheduler.js
  watcher.js

/simulations
  simulate_basic.js
  simulate_volatility.js
  simulate_edge_cases.js

/scripts
  deploy.js
  seed.js
  run_cycle.js

/docs
  architecture.md
  economics.md
  security.md
  execution.md

---

## Disclaimer

This code is experimental.
This code is unaudited.
This system can lose money.

Simon Wicki provides this repository for transparency and research purposes only.

Use at your own risk.
