# Py Galactic Trader

A dynamic simulation where a trader learns which actions (buy, sell, travel) are most profitable across three planets with different prices. Rules are sampled using Thompson sampling and updated by reward, so the system gradually favors profitable trading patterns.

## How it works
- **State**: current planet, held item (optional), and money.
- **Rules**: generated actions for travel, buy, and sell with preconditions (context) and outcomes (goal).
- **Selection**: each step samples a value from each applicable rule’s Beta distribution and chooses the highest.
- **Reward**: change in money plus an average item value heuristic.
- **Learning**: rules update their Beta parameters based on reward.

## Files
- main.py: simple simulation loop.
- visual_main.py: detailed, human-readable simulation with summaries.
- rule.py: rule generation and Thompson sampling logic.
- world.py: prices, travel costs, validation, execution, reward functions.

## Run
From repository root:
- python py-galactic_trader/main.py
- python py-galactic_trader/visual_main.py

