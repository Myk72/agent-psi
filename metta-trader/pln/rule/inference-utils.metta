(= (getMatchingPremises $type $premises $rule $remRules) (
    let* (
        ($ruleGoal (extractRule GoalValues $rule))
        ($matchingRules (eval (filter-rules-by-goal $ruleGoal $remRules)))
    ) (
        if (== $type deduction)
            (map-atom $matchingRules $matchingRule (reason-ded $rule $matchingRule $premises))
            (if (== $type abduction)
                (map-atom $matchingRules $matchingRule (reason-abd $rule $matchingRule $premises))
                (if (== $type induction)
                    (map-atom $matchingRules $matchingRule (reason-ind $rule $matchingRule $premises))
                    (empty)
                ))
    )
))

(= (findMatchingRules $ruleGoal $rules) (
    if (== () $rules)
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($matchingContext (eval (extractRule ContextValues $head)))
            ($isSimilar (eval (areSimilar $ruleGoal $matchingContext)))
            ($restMatches (findMatchingRules $ruleGoal $tail))
        ) (if $isSimilar
            (cons-atom $head $restMatches)
            $restMatches))
))