"""
Tests for the Galactic Trader simulation.
Uses functions from world.py - no duplicate definitions.
"""
from world import is_valid_rule, execute_rule, get_price, get_travel_cost
from rule import Rule
from main import State


def test_travel_preserves_item():
    """Test that traveling with an item preserves the item in context."""
    state = State(context={"planet": "A", "item": "FOOD"}, money=100)
    rule = Rule(
        name="TRAVEL_A_TO_B",
        context={"planet": "A"},
        action="travel",
        goal={"planet": "B"}
    )
    
    new_state = execute_rule(rule, state)
    assert new_state.context.get('item') == "FOOD", "Item should be preserved after travel"
    assert new_state.context['planet'] == "B", "Should be at destination planet"
    assert new_state.money == 99, "Should have paid travel cost"
    print("✅ test_travel_preserves_item passed")


def test_buy_rule_validity():
    """Test that buy rules are only valid when player has no item."""
    state_no_item = State(context={"planet": "A"}, money=100)
    state_with_item = State(context={"planet": "A", "item": "METAL"}, money=100)
    
    buy_rule = Rule(
        name="BUY_FOOD_AT_A",
        context={"planet": "A"},
        action="buy",
        goal={"planet": "A", "item": "FOOD"}
    )
    
    assert is_valid_rule(buy_rule, state_no_item) == True, "Should be valid without item"
    assert is_valid_rule(buy_rule, state_with_item) == False, "Should be invalid with item"
    print("✅ test_buy_rule_validity passed")


def test_sell_rule_validity():
    """Test that sell rules are only valid when player has the matching item."""
    state_with_food = State(context={"planet": "A", "item": "FOOD"}, money=100)
    state_with_metal = State(context={"planet": "A", "item": "METAL"}, money=100)
    state_no_item = State(context={"planet": "A"}, money=100)
    
    sell_food_rule = Rule(
        name="SELL_FOOD_AT_A",
        context={"planet": "A", "item": "FOOD"},
        action="sell",
        goal={"planet": "A"}
    )
    
    assert is_valid_rule(sell_food_rule, state_with_food) == True, "Should be valid with matching item"
    assert is_valid_rule(sell_food_rule, state_with_metal) == False, "Should be invalid with wrong item"
    assert is_valid_rule(sell_food_rule, state_no_item) == False, "Should be invalid without item"
    print("✅ test_sell_rule_validity passed")


def test_execute_buy():
    """Test that buying an item deducts money and adds item to context."""
    state = State(context={"planet": "A"}, money=100)
    rule = Rule(
        name="BUY_FOOD_AT_A",
        context={"planet": "A"},
        action="buy",
        goal={"planet": "A", "item": "FOOD"}
    )
    
    new_state = execute_rule(rule, state)
    food_price = get_price("A", "FOOD")  # Should be 8
    
    assert new_state.context.get('item') == "FOOD", "Should have FOOD in context"
    assert new_state.money == 100 - food_price, f"Should have paid {food_price} for FOOD"
    print("✅ test_execute_buy passed")


def test_execute_sell():
    """Test that selling an item adds money and removes item from context."""
    state = State(context={"planet": "B", "item": "FOOD"}, money=100)
    rule = Rule(
        name="SELL_FOOD_AT_B",
        context={"planet": "B", "item": "FOOD"},
        action="sell",
        goal={"planet": "B"}
    )
    
    new_state = execute_rule(rule, state)
    food_price = get_price("B", "FOOD")  # Should be 20
    
    assert new_state.context.get('item') is None, "Should have no item after selling"
    assert new_state.money == 100 + food_price, f"Should have gained {food_price} from selling FOOD"
    print("✅ test_execute_sell passed")


def test_full_trade_cycle():
    """Test a complete buy-travel-sell cycle for profit."""
    # Start at planet A with 100 money
    state = State(context={"planet": "A"}, money=100)
    
    # Buy FOOD at A (costs 8)
    buy_rule = Rule(
        name="BUY_FOOD_AT_A",
        context={"planet": "A"},
        action="buy",
        goal={"planet": "A", "item": "FOOD"}
    )
    state = execute_rule(buy_rule, state)
    assert state.money == 92, "After buying FOOD at A"
    
    # Travel to B (costs 1)
    travel_rule = Rule(
        name="TRAVEL_A_TO_B",
        context={"planet": "A"},
        action="travel",
        goal={"planet": "B"}
    )
    state = execute_rule(travel_rule, state)
    assert state.money == 91, "After traveling to B"
    assert state.context.get('item') == "FOOD", "Should still have FOOD"
    
    # Sell FOOD at B (gains 20)
    sell_rule = Rule(
        name="SELL_FOOD_AT_B",
        context={"planet": "B", "item": "FOOD"},
        action="sell",
        goal={"planet": "B"}
    )
    state = execute_rule(sell_rule, state)
    assert state.money == 111, "After selling FOOD at B"
    assert state.context.get('item') is None, "Should have no item after selling"
    
    print("✅ test_full_trade_cycle passed - Profit: 11 (100 -> 111)")


if __name__ == "__main__":
    test_travel_preserves_item()
    test_buy_rule_validity()
    test_sell_rule_validity()
    test_execute_buy()
    test_execute_sell()
    test_full_trade_cycle()
    print("\n🎉 All tests passed!")