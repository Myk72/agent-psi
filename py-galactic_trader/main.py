import copy
from rule import starting_rules, reasoned_rules
from world import *

class State:
    def __init__(self, context, money):
        self.context = context
        self.money = money
    
    def __str__(self):
        return f"Context: {self.context}, Money: {self.money}"

if __name__ == "__main__":
    rules = starting_rules
    state = State(context={"planet": "A"}, money=100)

    for i in range(2000):
        # Add a newly reasoned rule
        if reasoned_rules:
            rules.append(reasoned_rules.pop())

        applicable_rules = []
        for rule in rules:
            if not is_valid_rule(rule, state):
                continue
            
            sampled_value = rule.get_sample_value()
            applicable_rules.append((rule, sampled_value))

        print(f"Current State: {state}")
        for rule in rules:
            print(rule.name, end=", ")
        print()
        if not applicable_rules:
            print("INFO: Couldn't find any applicable rules")
            continue
        
        sorted_rules = sorted(applicable_rules, key= lambda x: x[1], reverse=True)
        print(sorted_rules)
        chosen_rule = sorted_rules[0][0]
        print(f"Chosen Rule: {chosen_rule.name}")

        # new_state = execute_rule(chosen_rule, state)
        new_state = execute_rule(chosen_rule, copy.deepcopy(state))

        print(f"New State: {new_state}")
        reward = evaluate_state(new_state, state)
        chosen_rule.update(reward)
        state = new_state
        print(f"Step {i}: {chosen_rule.name} -> {reward}")

        print(state.money)
        if state.money <= 0:
            print('Ran out of money on iteration:', i)
            break