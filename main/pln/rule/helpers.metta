;; General Rule helpers

(: createRule (-> Expression Expression))
(= (createRule ($ruleId $STV $implication)) (
    ; TODO
))

(: createRule (-> Expression Expression))
(= (createRule ($ruleId $STV $context $action $goal)) (
    ; TODO
))

(: chainActions (-> Expression Expression Expression))
(= (chainActions $actionOne $actionTwo) (
    ; TODO  RETURNS WITH THE WHOLE THING (SEQ_AND ...)
))

(: chainGoals (-> Expression Expression Expression))
(= (chainGoals $goalOne $goalTwo) (

))

(: (visualizeRule (-> Expression Expression)))
(= (visualizeRule $rule) (
    ; TODO
))

(: (removeDuplicateRules (-> Expression Expression)))
(= (removeDuplicateRules $rules) (
    ; TODO
))

;; For now complexity is the number of actions in the rule
(: calculateComplexity (-> Expression Number))
(= (calculateComplexity $rule) (
    let* (
        ($action (extractRuleAction $rule))
        ($actionCount (size-atom $action))
    ) $actionCount
))

;; This could be optimized by adding an atom that tracks the max TTV in the rule space instead of searching every time
(: getCurrentTimeCycle (-> hyperon::space::DynSpace Number))
(= (getCurrentTimeCycle $ruleSpace) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
        ($ttvValues (map-atom $rules $rule (extractRule TTV $rule)))
        ($_ (println! ("Current TTV values: " $ttvValues)))
    ) (max-atom $ttvValues) ;; For some reason max-atom returns a float instead of int
))

;; 
(: getLatestRuleId (-> hyperon::space::DynSpace Number))
(= (getLatestRuleId $ruleSpace) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
        ($ruleIds (map-atom $rules $rule (extractRule Id $rule)))
        ($_ (println! ("Current Rule IDs: " $ruleIds)))
    ) (max-atom $ruleIds)
))

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

;; Filters rules from a rule space based on matching context values
(= (filterByContext $context $ruleSpace) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
        ($filtered (filter-rules-by-context $context $rules))
    ) $filtered
))

(= (filter-rules-by-context $context $rules) (
    if (== () $rules)
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($ruleContext (extractRule ContextValues $head))
            ($isMatch (areSimilar $context $ruleContext))
            ($restMatches (filter-rules-by-context $context $tail))
        ) (if $isMatch
            (cons-atom $head $restMatches)
            $restMatches))
))