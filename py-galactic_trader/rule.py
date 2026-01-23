import random
import numpy as np

class Rule:
    def __init__(self, name, context, action, goal):
        self.name = name
        self.context = context
        self.action = action
        self.goal = goal
        self.alpha = 1
        self.beta = 1

    def __repr__(self):
        return f"{self.name} {self.context} & {self.action} => {self.goal}"

    def get_sample_value(self) -> float:
        return np.random.beta(self.alpha, self.beta)

    def update(self, reward: float):
        if reward > 0:
            self.alpha += reward
        elif reward < 0:
            self.beta += abs(reward)
        else:
            self.alpha += 1
            self.beta += 1
        

world_context = ['A', 'B', 'C']
item_context = ['FOOD', 'METAL', 'FUEL']

rule_collection = []

# Travel rules
for source in world_context:
    for dest in world_context:
        if source == dest: continue
        rule = Rule(
            name=f"TRAVEL_{source}_TO_{dest}",
            context={"planet": source},
            action="travel",
            goal={"planet": dest}
        )
        rule_collection.append(rule)

# Sell rules
for planet in world_context:
    for item in item_context:
        rule_collection.append(
            Rule(
                name=f"SELL_{item}_AT_{planet}",
                context={"planet": planet, "item": item},
                action="sell",
                goal={"planet": planet}
            )
        )

# Buy rules
for planet in world_context:
    for item in item_context:
        rule_collection.append(
            Rule(
            name=f"BUY_{item}_AT_{planet}",
            context={"planet": planet},
            action="buy",
            goal={"planet": planet, "item": item}
        )
    )


random.shuffle(rule_collection)

mid = len(rule_collection) // 2
starting_rules = rule_collection[:mid]
reasoned_rules = rule_collection[mid:]
