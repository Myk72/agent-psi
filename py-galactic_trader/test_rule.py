from hyperon import MeTTa
from hyperon.atoms import ExpressionAtom
import re

def is_valid_stv(text: str) -> bool:
    pattern = r'^\(STV\s+[0-9]*\.?[0-9]+\s+[0-9]*\.?[0-9]+\)$'
    return re.match(pattern, text) is not None


metta = MeTTa()
def validate_rule():
    with open("starter_rules.metta", "r") as f:
        rule_code = f.read()

    rule_atoms = metta.parse_all(rule_code)
    for atom in rule_atoms:
        metta.space().add_atom(atom)

    response = metta.run("""
        !(match &self (: Rule $ruleId 
                            (TTV $ttv) 
                            $stv
                            (Complexity $complexity) 
                            (IMPLICATION 
                                (AND 
                                    (Context $contextSTV (AND $ruleContexts)) 
                                    (Action (SEQ_AND $ruleAction))
                                ) 
                                (Goal $goalSTV (AND $ruleGoal))
                            )
                ) 
            ($ruleId $ttv $stv $complexity $contextSTV $ruleContexts $ruleAction $goalSTV $ruleGoal))
    """)

    response = response[0]
    if not response:
        print("No matching rule found.")
        return False

    valid_rules = 0
    for rule in response:
        try:
            rule = rule.get_children() # Convert Expression to Python List
            if len(rule) != 9:
                print(f"Invalid rule structure: {rule}")
                continue

            rule_id = rule[0]
            rule_id = int(int(str(rule_id)))

            rule_ttv = rule[1]
            rule_ttv = int(str(rule_ttv))

            rule_stv = rule[2]
            if not is_valid_stv(str(rule_stv)):
                print(f"Invalid rule STV for rule {rule_id}: {rule_stv}")
                raise ValueError("Invalid rule STV")

            complexity = rule[3]
            complexity = int(str(complexity))

            context_stv = rule[4]
            if not is_valid_stv(str(context_stv)):
                print(f"Invalid context STV for rule {rule_id}: {context_stv}")
                raise ValueError("Invalid context STV")

            rule_contexts = rule[5]
            if not isinstance(rule_contexts, ExpressionAtom):
                print(f"Invalid rule contexts for {rule_id}: {rule_contexts}")
                continue
            for context in rule_contexts.get_children():
                if not isinstance(context, ExpressionAtom) or len(context.get_children()) < 2:
                    print(f"Invalid context in rule {rule_id}: {context}")
                    context_stv = context.get_children()[1]
                    if not is_valid_stv(str(context_stv)):
                        print(f"Invalid STV in context of rule {rule_id}: {context_stv}")
                        raise ValueError("Invalid STV in context")
                    break

            rule_action = rule[6]
            if not isinstance(rule_action, ExpressionAtom):
                print(f"Invalid rule action for {rule_id}: {rule_action}")
                if not rule_action.get_children():
                    print(f"Empty action in rule {rule_id}")
                    raise ValueError("Empty action")
                continue
            
            goal_stv = rule[7]
            if not is_valid_stv(str(goal_stv)):
                print(f"Invalid goal STV for rule {rule_id}: {goal_stv}")
                raise ValueError("Invalid goal STV")

            rule_goals = rule[8]
            if not isinstance(rule_goals, ExpressionAtom):
                print(f"Invalid rule goals for {rule_id}: {rule_goals}")
                continue
            for goal in rule_goals.get_children():
                if not isinstance(goal, ExpressionAtom) or len(goal.get_children()) < 2:
                    print(f"Invalid goal in rule {rule_id}: {goal}")
                    goal_stv = goal.get_children()[1]
                    if not is_valid_stv(str(goal_stv)):
                        print(f"Invalid STV in goal of rule {rule_id}: {goal_stv}")
                        raise ValueError("Invalid STV in goal")

                    break

            valid_rules += 1
            print(f"Rule {rule_id} is valid.")
        except Exception as e:
            print(f"Error processing rule: {e}")
            continue

    print(f"Total valid rules: {valid_rules}")

if __name__ == "__main__":
    validate_rule()