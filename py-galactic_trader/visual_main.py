import copy
from rule import starting_rules, reasoned_rules
from world import *

class State:
    def __init__(self, context, money):
        self.context = context
        self.money = money
    
    def __str__(self):
        return f"Context: {self.context}, Money: {self.money}"


def get_top_rules(rules, n=5):
    """Get top N rules by expected value (alpha / (alpha + beta))."""
    rule_values = [(r, r.alpha / (r.alpha + r.beta)) for r in rules]
    return sorted(rule_values, key=lambda x: x[1], reverse=True)[:n]


def print_rule_stats(rule):
    """Print alpha/beta stats for a rule."""
    expected = rule.alpha / (rule.alpha + rule.beta)
    return f"α={rule.alpha:.1f}, β={rule.beta:.1f}, E={expected:.3f}"


def print_summary(step, rules, state, initial_money):
    """Print a learning summary every N steps."""
    profit = state.money - initial_money
    roi = (profit / initial_money) * 100
    
    print("\n" + "="*70)
    print(f"📊 SUMMARY AT STEP {step}")
    print("="*70)
    print(f"💰 Money: {state.money:,.0f} (Started: {initial_money:,.0f})")
    print(f"📈 Profit: {profit:+,.0f} ({roi:+.1f}% ROI)")
    print(f"📍 Location: Planet {state.context.get('planet', '?')}, Item: {state.context.get('item', 'None')}")
    
    # Top performing rules
    print("\n🏆 TOP 5 LEARNED RULES (by expected value):")
    for rule, expected in get_top_rules(rules, 5):
        print(f"   {rule.name:30s} → {print_rule_stats(rule)}")
    
    # Group by action type
    buy_rules = [r for r in rules if r.action == "buy"]
    sell_rules = [r for r in rules if r.action == "sell"]
    travel_rules = [r for r in rules if r.action == "travel"]
    
    print("\n📋 RULE CATEGORY STATS:")
    for name, rule_list in [("BUY", buy_rules), ("SELL", sell_rules), ("TRAVEL", travel_rules)]:
        if rule_list:
            avg_alpha = sum(r.alpha for r in rule_list) / len(rule_list)
            avg_beta = sum(r.beta for r in rule_list) / len(rule_list)
            avg_exp = avg_alpha / (avg_alpha + avg_beta)
            print(f"   {name:8s}: avg α={avg_alpha:.1f}, avg β={avg_beta:.1f}, avg E={avg_exp:.3f}")
    print("="*70 + "\n")


if __name__ == "__main__":
    rules = starting_rules
    initial_money = 1000
    state = State(context={"planet": "A"}, money=initial_money)
    
    # Tracking metrics
    action_counts = {"buy": 0, "sell": 0, "travel": 0}
    profitable_trades = 0
    total_trades = 0
    recent_rewards = []  # Rolling window of last 50 rewards
    
    print("🚀 Starting Galactic Trader Simulation")
    print(f"   Initial money: {initial_money}")
    print(f"   Starting rules: {len(rules)}")
    print(f"   Rules to discover: {len(reasoned_rules)}")
    print("-"*70)

    for i in range(5000):
        # Add a newly reasoned rule
        if reasoned_rules:
            new_rule = reasoned_rules.pop()
            rules.append(new_rule)
            if i < 100 or i % 100 == 0:  # Only show early discoveries
                print(f"   🔍 Discovered new rule: {new_rule.name}")

        applicable_rules = []
        for rule in rules:
            if not is_valid_rule(rule, state):
                continue
            sampled_value = rule.get_sample_value()
            applicable_rules.append((rule, sampled_value))

        if not applicable_rules:
            print(f"⚠️  Step {i}: No applicable rules! State: {state}")
            continue
        
        sorted_rules = sorted(applicable_rules, key=lambda x: x[1], reverse=True)
        chosen_rule = sorted_rules[0][0]
        
        # Execute rule
        new_state = execute_rule(chosen_rule, copy.deepcopy(state))
        
        # Calculate reward (skip for travel)
        reward = 0
        if chosen_rule.action != "travel":
            reward = evaluate_state(new_state, state)
            recent_rewards.append(reward)
            if len(recent_rewards) > 50:
                recent_rewards.pop(0)
            
            if chosen_rule.action == "sell":
                total_trades += 1
                if reward > 0:
                    profitable_trades += 1
        
        chosen_rule.update(reward)
        action_counts[chosen_rule.action] += 1
        
        # Compact step logging
        old_money = state.money
        state = new_state
        money_change = state.money - old_money
        
        # Show individual steps (every 50 or on significant events)
        if i % 50 == 0 or abs(money_change) > 10:
            item_str = state.context.get('item', '-')[:4] if state.context.get('item') else '-'
            planet = state.context.get('planet', '?')
            reward_str = f"{reward:+.1f}" if reward != 0 else "0"
            stats = print_rule_stats(chosen_rule)
            
            print(f"Step {i:4d} | {chosen_rule.action:6s} | {chosen_rule.name:25s} | "
                  f"💰{state.money:6.0f} ({money_change:+.0f}) | "
                  f"📍{planet}/{item_str:4s} | R:{reward_str:6s} | {stats}")
        
        # Print detailed summary periodically
        if (i + 1) % 500 == 0:
            print_summary(i + 1, rules, state, initial_money)
            if total_trades > 0:
                win_rate = (profitable_trades / total_trades) * 100
                print(f"   🎯 Trade Win Rate: {profitable_trades}/{total_trades} ({win_rate:.1f}%)")
            if recent_rewards:
                avg_reward = sum(recent_rewards) / len(recent_rewards)
                print(f"   📉 Avg Recent Reward (last 50): {avg_reward:.2f}")
        
        # Check for bankruptcy
        if state.money <= 0:
            print(f"\n💀 BANKRUPT at step {i}!")
            print_summary(i, rules, state, initial_money)
            break
    
    # Final summary
    print("\n" + "🏁"*35)
    print("FINAL RESULTS")
    print("🏁"*35)
    print_summary(i + 1, rules, state, initial_money)
    print(f"\n📊 ACTION DISTRIBUTION:")
    total_actions = sum(action_counts.values())
    for action, count in action_counts.items():
        pct = (count / total_actions) * 100 if total_actions > 0 else 0
        print(f"   {action:8s}: {count:5d} ({pct:.1f}%)")
    
    if total_trades > 0:
        win_rate = (profitable_trades / total_trades) * 100
        print(f"\n🎯 FINAL TRADE WIN RATE: {profitable_trades}/{total_trades} ({win_rate:.1f}%)")