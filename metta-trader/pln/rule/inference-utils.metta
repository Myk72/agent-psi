(= (getMatchingPremises $premises $rule $remRules) (
    let* (
        ($ruleGoal (extractRule GoalValues $rule))
        ($matchingRules (filter-rules-by-goal $ruleGoal $remRules))
        ($reasoned (map-atom $matchingRules $matchingRule (reason-abd $rule $matchingRule $premises)))
    ) $reasoned
))

(= (findMatchingRules $ruleGoal $rules) (
    if (== () $rules)
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($matchingContext (extractRule ContextValues $head))
            ($isSimilar (areSimilar $ruleGoal $matchingContext))
            ($restMatches (findMatchingRules $ruleGoal $tail))
        ) (if $isSimilar
            (cons-atom $head $restMatches)
            $restMatches))
))