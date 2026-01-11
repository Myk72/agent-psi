(= (pln-induction $ruleSpace) (
    let* (
        ($_ (println! "PLN Induction Started"))
        ($rules (collapse (get-atoms $ruleSpace)))
        ($_ (println! (Got (size-atom $rules) Rules)))
        ($inductions (induction-helper $rules))
    ) $inductions
))

(= (induction-helper $rules) (
    if (<= (size-atom $rules) 1)
        ()
        (let* (
            (($rule $remRules) (decons-atom $rules))
            ($premise-one (extractRule GoalSTV $rule))
            ($premise-two (extractRule ContextSTV $rule))
            ($premise-four (extractRule STV $rule))
            ($premises ($premise-one $premise-two $premise-four))
            ($matchingRuleAbductions (getMatchingPremises $premises $rule $remRules))
            ($_ (println! (Abductions: $matchingRuleAbductions)))
            ($restAbductions (induction-helper $remRules))
        ) (union-atom $restAbductions $matchingRuleAbductions))
))

(= (getMatchingPremises $premises $rule $remRules) (
    let* (
        ($ruleContext (extractRule ContextValues $rule))
        ($matchingRules (filter-rules-by-context $ruleContext $remRules))
        ($reasoned (map-atom $matchingRules $matchingRule (reason-ind $rule $matchingRule $premises)))
    ) $reasoned
))

(= (reason-ind $rule $matchingRule $premises) (
    let* (
        ($randomNo 100) ;; TODO: Fix this
        ($ruleContext (extractRule Context $rule))
        ($ruleGoal (extractRule Goal $rule))
        ($matchingContext (extractRule Context $matchingRule))
        ($matchingGoal (extractRule Goal $matchingRule))
        ($matchingGoalSTV (extractRule GoalSTV $matchingRule))

        ($ruleAction (extractRule Action $rule))
        ($ruleContextSTV (extractRule ContextSTV $rule))
        ($ruleGoalSTV (extractRule GoalSTV $rule))
        ($matchingRuleAction (extractRule Action $matchingRule))
        ($newRuleAction (union-atom $ruleAction $matchingRuleAction))

        (($premise-one $premise-two $premise-four) $premises)
        ($premise-three (extractRule GoalSTV $matchingRule))
        ($premise-five (extractRule STV $matchingRule))
        
        ($newRuleSTV (inductionFormula $premise-one $premise-two $premise-three $premise-four $premise-five))
        ($_ (println! (New Rule STV: $newRuleSTV)))

        ($newRule (: Rule $randomNo (TTV 1) $newRuleSTV (Complexity 1) (IMPLICATION (AND (Context $matchingGoalSTV (AND $matchingGoal)) (Action (SEQ_AND $matchingRuleAction))) (Goal $ruleGoalSTV (AND $ruleGoal)))))

        ;; The inverse can be applied.
    ) $newRule
))

