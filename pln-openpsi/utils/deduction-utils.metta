; (= (findMatchingRules $direction $rules) (
;     map-atom $rules $rule (unify (Name $name Go $direction) $rule $rule ())
;     ; map-atom $cogscm $rule (let $ruleGoal (extractRule GoalValues $rule) (if (areSimilar $currentGoal $ruleGoal) $rule Empty)) 
; ))

; (= (findMatchingRules $context $rules) (
;     let $rule (superpose $rules) (let $ruleContext (extractRule ContextValues $rule) (if (areSimilar $context $ruleContext) $rule Empty))
; ))

; (= (findMatchingRules $currentGoal $cogscm) (
;     if (== () $cogscm)
;         ()
;         (let* (
;             (($head $tail) (decons-atom $cogscm))
;             ($ruleGoal (extractRule GoalValues $head))
;             ($isSimilar (areSimilar $currentGoal $ruleGoal))
;             ; ($_ (println! (areSimilaring $currentGoal $ruleGoal : $isSimilar)))
;             ($restMatches (findMatchingRules $currentGoal $tail))
;         ) (if $isSimilar
;             (cons-atom $head $restMatches)
;             $restMatches))
; ))

(= (getMatchingPremises $premises $rule $remRules) (
    let* (
        ($ruleContext (extractRule ContextValues $rule))
        ($_ (println! (Rule Context: $ruleContext)))
        ($matchingRules (findMatchingRules $ruleContext $remRules))
        ($_ (println! (Matching Rules: $matchingRules)))
        ($reasoned (map-atom $matchingRules $matchingRule (reason $premises $matchingRule)))
        ($_ (println! (Reasoned: $reasoned)))
    ) $reasoned
))

(= (reason $rule $matchingRule $premises) (
    let* (
        ($randomNo 100) ;; TODO: Fix this
        ($ruleContext (extractRule AllContext $rule))

        ($ruleContextAndAction (extractRule ContextAndAction $rule))
        ($matchingRuleGoal (extractRule AllGoal $matchingRule))

        ($ruleAction (extractRule Action $rule))
        ($matchingRuleAction (extractRule Action $matchingRule))
        ($newRuleAction (union-atom $ruleAction $matchingRuleAction))
        (() (println! (Actions: $newRuleAction)))

        ($premise-five (extractRule STV $matchingRule))
        ($premise-three (extractRule GoalSTV $matchingRule))
        (($premise-one $premise-two $premise-four) $premises)

        ($_ (println! (Premises: $premise-one $premise-two $premise-three $premise-four $premise-five)))
        ($newRuleSTV (deduction-formula $premise-one $premise-two $premise-three $premise-four $premise-five))
        ($newRule (: Rule $randomNo (TTV 1) $newRuleSTV (Complexity 1) (IMPLICATION (AND $ruleContext (Action (SEQ_AND $newRuleAction))) $matchingRuleGoal)))
    ) $newRule
))

; (= (extractRule $field $rule) (
;     index-atom $rule 3
; ))

; (= (areSimilar $list1 $list2) (
;     if (== (index-atom $list1 0) (index-atom $list2 0))
;         True
;         False
; ))
; !(findMatchingRules (Right) ((Name Nati Go (Right)) (Name Josh Go (Right))))

; !(areSimilar (Name Nati Go (Right)) (Name Josh Go (Right)))
; !(extractRule C (Name Nati Go Right))
; (Name Nati Go Right)
; (Name Josh Go Left)

; !(help! filter-atom)
