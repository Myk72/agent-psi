;; Filters rules from a rule space based on matching both context and action values
(= (filterByContextAndAction $context $action $ruleSpace) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
        ($filtered (filter-rules-by-context-and-action $context $action $rules))
    ) $filtered
))

(= (filter-rules-by-context-and-action $context $action $rules) (
    if (== () $rules)
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($ruleContext (extractRule ContextValues $head))
            ($ruleAction (extractRule Action $head))
            ($isContextMatch (areSimilar $context $ruleContext))
            ($isActionMatch (areSimilar $action $ruleAction))
            ($isMatch (and $isContextMatch $isActionMatch))
            ($restMatches (filter-rules-by-context-and-action $context $action $tail))
        ) (if $isMatch
            (cons-atom $head $restMatches)
            $restMatches))
))

