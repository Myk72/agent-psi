from rule import starting_rules, reasoned_rules
from world import *

class State:
    def __init__(self, context, money):
        self.context = context
        self.money = money

rules = starting_rules
state = State(context={"planet": "A"}, money=100)

for i in range(50):
    # Add a newly reasoned rule
    if reasoned_rules:
        rules.append(reasoned_rules.pop())

    applicable_rules = []
    for rule in rules:
        if not is_valid_rule(rule, state):
            continue
        
        sampled_value = rule.get_sample_value()
        applicable_rules.append((rule, sampled_value))

    if not applicable_rules:
        print("INFO: Couldn't find any applicable rules")
        continue
    
    chosen_rule = sorted(applicable_rules, key= lambda x: x[1], reverse=True)[0][0]
    new_state = execute_rule(chosen_rule, state)
    reward = evaluate_state(new_state, state)
    chosen_rule.update(reward)
    state = new_state
    print(f"Step {i}: {chosen_rule.name} -> {reward}")

    print(state.money)