;; Filters rules from a rule space based on matching goal values
(= (filterByGoal $goal $ruleSpace) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
        ($filtered (filter-rules-by-goal $goal $rules))
    ) $filtered
))

(= (filter-rules-by-goal $goal $rules) (
    if (== () $rules)
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($ruleGoal (extractRule GoalValues $head))
            ($isMatch (areSimilar $goal $ruleGoal))
            ($restMatches (filter-rules-by-goal $goal $tail))
        ) (if $isMatch
            (cons-atom $head $restMatches)
            $restMatches))
))

