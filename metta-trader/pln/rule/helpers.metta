;; General Rule helpers

;; (: createRule (-> Number Number Expression Expression))
(= (createRule $ruleId $ttv $rule) (
    let* (
        ($complexity (calculateComplexity $rule))
        ($_ (println! (Rule $complexity)))

        ((: Rule $id $t $stv $comp $implication) $rule)
        ($_ (println! (: Rule $id $t $stv $comp $implication)))
        ($newRule (: Rule $ruleId (TTV $ttv) $stv (Complexity $complexity) $implication))
        ($_ (println! (New Rule $newRule)))
    ) $newRule
))

(: chainActions (-> Expression Expression Expression))
(= (chainActions $actionOne $actionTwo) (
    SEQ_AND (union-atom $actionOne $actionTwo)
))

(: chainGoals (-> Expression Expression Expression))
(= (chainGoals $goalOne $goalTwo) (

))

(: (visualizeRule (-> Expression Expression)))
(= (visualizeRule $rule) (
    let* (
        ($contexts (extractRule ContextValues $rule))
        ($actions (extractRule Action $rule))
        ($goals (extractRule GoalValues $rule))
        ($visual ($contexts => [$actions] => $goals))
    ) $visual
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
(: getCurrentTimeCycleFromSpace (-> hyperon::space::DynSpace Number))
(= (getCurrentTimeCycleFromSpace $ruleSpace) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
        ($ttvValues (map-atom $rules $rule (extractRule TTV $rule)))
        ($currTTV (max-atom $ttvValues))
    ) (toInt $currTTV)
))

(: getCurrentTimeCycle (-> Expression Number))
(= (getCurrentTimeCycle $rules) (
    let* (
        ($ttvValues (map-atom $rules $rule (extractRule TTV $rule)))
        ($currTTV (max-atom $ttvValues))
    ) (toInt $currTTV)
))

;; 
(: getLatestRuleIdFromSpace (-> hyperon::space::DynSpace Number))
(= (getLatestRuleIdFromSpace $ruleSpace) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
        ($ruleIds (map-atom $rules $rule (extractRule Id $rule)))
        ($currId (max-atom $ruleIds))
    ) (toInt $currId)
))

(: getLatestRuleId (-> Expression Number))
(= (getLatestRuleId $rules) (
    let* (
        ($ruleIds (map-atom $rules $rule (extractRule Id $rule)))
        ($currId (max-atom $ruleIds))
    ) (toInt $currId)
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

;; (: processRules (-> Expression Number Number Expression))
(= (processRules $rules $ruleId $ttv) (
    if (== $rules ())
        ()
        (let* (
            ($_ (println! (Processing Rulingtons $rules)))
            (($head $tail) (decons-atom $rules))
            ($newRule (createRule $ruleId $ttv $head))
            ($nextRuleId (+ 1 $ruleId))
            ($rest (processRules $tail $nextRuleId $ttv))
        ) (cons-atom $newRule $rest))
))

;; (= (Rules) ((: Rule 1 (TTV 0) (STV 0.5 0.002) (Complexity 1) (IMPLICATION (AND (Context (STV 0.2 0.1) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1))))) (Action (SEQ_AND (MOVE_RIGHT)))) (Goal (STV 0.2 0.1) (AND ((CENTER_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1))))))) (: Rule 3 (TTV 0) (STV 0.5 0.002) (Complexity 1) (IMPLICATION (AND (Context (STV 0.2 0.1) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1))))) (Action (SEQ_AND (MOVE_RIGHT)))) (Goal (STV 0.2 0.1) (AND ((CENTER_SQUARE (STV 0.2 0.1)) (DEAD (STV 0.2 0.1))))))) (: Rule 2 (TTV 0) (STV 0.5 0.002) (Complexity 1) (IMPLICATION (AND (Context (STV 0.2 0.1) (AND ((CENTER_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1))))) (Action (SEQ_AND (MOVE_RIGHT)))) (Goal (STV 0.2 0.1) (AND ((RIGHT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))))))
;; !(processRules (Rules) 10 1)