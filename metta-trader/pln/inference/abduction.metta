(= (pln-abduction $rules) (
    let* (
        ($_ (println! "PLN Abduction Started"))
        ($abductions (abduction-helper $rules))
    ) $abductions
))

(= (abduction-helper $rules) (
    if (<= (size-atom $rules) 1)
        ()
        (let* (
            (($rule $remRules) (decons-atom $rules))
            ($premise-one (extractRule ContextSTV $rule))
            ($premise-two (extractRule GoalSTV $rule))
            ($premise-four (extractRule STV $rule))
            ($premises ($premise-one $premise-two $premise-four))
            ($matchingRuleAbductions (getMatchingPremises $premises $rule $remRules))
            ($restAbductions (abduction-helper $remRules))
        ) (union-atom $restAbductions $matchingRuleAbductions))
))

(= (reason-abd $rule $matchingRule $premises) (
    let* (
        ($randomNo 100) ;; TODO: Fix this
        ($ruleContext (extractRule Context $rule))
        ($matchingContext (extractRule Context $matchingRule))
        ($matchingGoal (extractRule Goal $matchingRule))
        ($matchingGoalSTV (extractRule GoalSTV $matchingRule))

        ($ruleAction (extractRule Action $rule))
        ($ruleContextSTV (extractRule ContextSTV $rule))
        ($matchingRuleAction (extractRule Action $matchingRule))
        ($newRuleAction (union-atom $ruleAction $matchingRuleAction))

        (($premise-one $premise-two $premise-four) $premises)
        ($premise-three (extractRule ContextSTV $matchingRule))
        ($premise-five (extractRule STV $matchingRule))

        ($newRuleSTV (abductionFormula $premise-one $premise-two $premise-three $premise-four $premise-five))

        ($newRule (: Rule $randomNo (TTV 1) $newRuleSTV (Complexity 1) (IMPLICATION (AND (Context $ruleContextSTV (AND $matchingContext)) (Action (SEQ_AND $matchingRuleAction))) (Goal $matchingGoalSTV (AND $ruleContext)))))
    ) $newRule
))

