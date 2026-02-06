PRICE_TABLE = {
    "A": {"FOOD": 8, "METAL": 15, "FUEL": 25},
    "B": {"FOOD": 20, "METAL": 8, "FUEL": 18},
    "C": {"FOOD": 18, "METAL": 22, "FUEL": 5},
}

AVERAGE_COST = {
    "FOOD": 15.33,
    "METAL": 15,
    "FUEL": 16,
}

TRAVEL_COST = {
    ("A", "B"): 1,
    ("A", "C"): 1,
    ("B", "C"): 1,
    ("B", "A"): 1,
    ("C", "A"): 1,
    ("C", "B"): 1,
}

def is_valid_rule(rule, state):
    current_context = state.context
    rule_context = rule.context
    rule_action = rule.action

    # Planet check
    if rule_context['planet'] != current_context['planet']:
        return False
    
    # Money check
    if rule_action == "buy":
        item = rule.goal['item']
        item_price = get_price(rule_context['planet'], item)
        if state.money < item_price:
            return False
    
    elif rule_action == "travel":
        travel_cost = get_travel_cost(rule_context['planet'], rule.goal['planet'])
        if state.money < travel_cost:
            return False

    elif rule_action == "sell":
        item = rule.context.get('item', None)
        state_item = state.context.get('item', None)
        if item != state_item:
            return False
    
    return True  

def execute_rule(chosen_rule, state):
    rule_action = chosen_rule.action
    if rule_action == 'travel':
        source = chosen_rule.context['planet']
        destination = chosen_rule.goal['planet']
        travel_cost = get_travel_cost(source, destination)
        state.money -= travel_cost
        state.context['planet'] = destination

    elif rule_action == 'buy':
        item = chosen_rule.goal['item']
        item_price = get_price(state.context['planet'], item)
        state.money -= item_price
        state.context = chosen_rule.goal.copy()
    
    elif rule_action == 'sell':
        item = chosen_rule.context['item']
        item_price = get_price(state.context['planet'], item)
        state.money += item_price
        state.context = chosen_rule.goal.copy()
    return state

def evaluate_state(new_state, state):
    old_state_value = state.money + AVERAGE_COST.get(state.context.get('item') or None, 0)
    new_state_value = new_state.money + AVERAGE_COST.get(new_state.context.get('item') or None, 0)
    return new_state_value - old_state_value

def get_price(planet: str, good: str) -> int:
    return PRICE_TABLE[planet][good]

def get_travel_cost(from_planet: str, to_planet: str) -> int:
    return TRAVEL_COST[(from_planet, to_planet)]
