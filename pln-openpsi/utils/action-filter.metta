;; Filters rules from a rule space based on matching action values
(= (filterByAction $action $ruleSpace) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
        ($filtered (filter-rules-by-action $action $rules))
    ) $filtered
))

(= (filter-rules-by-action $action $rules) (
    if (== () $rules)
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($ruleAction (extractRule Action $head))
            ($isMatch (areSimilar $action $ruleAction))
            ($restMatches (filter-rules-by-action $action $tail))
        ) (if $isMatch
            (cons-atom $head $restMatches)
            $restMatches))
))

