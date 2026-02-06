(= (pln-deduction $rules) (
    let* (
        ($_ (println! "PLN Deduction Started"))
        ($deductions (deduction-helper $rules))
    ) $deductions
))

(= (deduction-helper $rules) (
    if (<= (size-atom $rules) 1)
        ()
        (let* (
            (($rule $remRules) (decons-atom $rules))
            ($premise-one (extractRule ContextSTV $rule))
            ($premise-two (extractRule GoalSTV $rule))
            ($premise-four (extractRule STV $rule))
            ($premises ($premise-one $premise-two $premise-four))
            ($matchingRuleDeductions (getMatchingPremises $premises $rule $remRules))
            ($restDeductions (deduction-helper $remRules))
        ) (union-atom $restDeductions $matchingRuleDeductions))
))

(= (reason-ded $rule $matchingRule $premises) (
    let* (
        ($randomNo 100) ;; TODO: Fix this
        ($ruleContext (extractRule Context $rule))
        ($matchingGoal (extractRule Goal $matchingRule))
        ($matchingGoalSTV (extractRule GoalSTV $matchingRule))

        ($ruleAction (extractRule Action $rule))
        ($ruleContextSTV (extractRule ContextSTV $rule))
        ($matchingRuleAction (extractRule Action $matchingRule))
        ($newRuleAction (union-atom $ruleAction $matchingRuleAction))

        ($premise-five (extractRule STV $matchingRule))
        ($premise-three (extractRule GoalSTV $matchingRule))
        (($premise-one $premise-two $premise-four) $premises)

        ($newRuleSTV (deductionFormula $premise-one $premise-two $premise-three $premise-four $premise-five))
        ($newRule (: Rule $randomNo (TTV 1) $newRuleSTV (Complexity 1) (IMPLICATION (AND (Context $ruleContextSTV (AND $ruleContext)) (Action (SEQ_AND $newRuleAction))) (Goal $matchingGoalSTV (AND $matchingGoal)))))
    ) $newRule
))

