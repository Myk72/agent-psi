!(import! &self utils:rule-ops)
!(import! &self utils:util)
!(import! &self utils:directly-evaluate-utils)

(= (pln-directly-evaluate $ruleSpace $perceptaSpace) (
    let* (
        ($_ (println! "PLN Direct Evaluation Started"))
        ($rules (collapse (get-atoms $ruleSpace)))
        ($allPerceptas (collapse (get-atoms $perceptaSpace)))
        ($perceptas (map-atom $allPerceptas $percept (extract-percepta-values $percept)))
        ($evaluatedRules (evaluate-all-rules $rules $perceptas))
        ($_ (println! "PLN Direct Evaluation Completed"))
    ) $evaluatedRules
))

(= (evaluate-all-rules $rules $perceptas) (
    if (<= (size-atom $rules) 0)
        ()
        (let* (
            (($rule $remRules) (decons-atom $rules))
            ($evaluatedRule (directly-evaluate $rule $perceptas))
            ($_ (println! ("Evaluated Rule: " (extractRule Id $rule))))
            ($restEvaluated (evaluate-all-rules $remRules $perceptas))
        ) (cons-atom $evaluatedRule $restEvaluated))
))

(= (directly-evaluate $rule $perceptas) (
    let* (
        ($ruleContext (extractRule ContextValues $rule))
        ($perceptaCount (size-atom $perceptas))
        ($matchCount (facts-in-percepta $ruleContext $perceptas))
        ($totalCount $perceptaCount)
        ($frequency (if (== $totalCount 0) 0 (div $matchCount $totalCount)))
        ($confidence (calculate-confidence $matchCount $totalCount))
        ($roundedConfidence (round $confidence 4))
        ($newContextSTV (STV $frequency $roundedConfidence))
        ($_ (println! (Total Count: $totalCount " | Match Count: " $matchCount " | Frequency: " $frequency " | Confidence: " $roundedConfidence)))
        
        ($updatedRule (construct-rule-with-new-context-stv $rule $newContextSTV))
        ($_ (println! ("Rule ID: " (extractRule Id $rule) " | Matches: " $matchCount " / " $totalCount " | Frequency: " $frequency)))
    ) $updatedRule
))

;; Can be simplified using superpose or map-atom
(= (count-matching-perceptions $contextFacts $perceptions) (
    if (== $perceptions ())
        0
        (let* (
            (($perception $remaining) (decons-atom $perceptions))
            ($isMatch (facts-in-percepta $contextFacts $perceptions))
            ($_ (println! ("Checking perception:" $perceptions Resulted: $isMatch)))
            ($rest (count-matching-perceptions $contextFacts $remaining))
        ) (if $isMatch
            (+ 1 $rest)
            $rest))
))

(= (facts-in-percepta $contextFact $perceptionFacts) (
    if (== () $perceptionFacts)
        0
        (let* (
            (($pfact $remPfacts) (decons-atom $perceptionFacts))
            ($matchFound (areSimilar $contextFact $pfact))
            ; ($_ (println! ("Comparing Context Fact:" $contextFact " with Perception Fact:" $pfact " Resulted: " $matchFound)))
            ($restResult (facts-in-percepta $contextFact $remPfacts))
        ) (if $matchFound
            (+ 1 $restResult)
            $restResult))
))

(= (extract-percepta-values $percepta) (
    unify (: Percepta $id $facts) $percepta
        $facts
        ()
))

(= (construct-rule-with-new-context-stv $rule $newContextSTV) (
    let* (
        ((: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $_ $contexts) $action) $goal)) $rule)
    ) (: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $newContextSTV $contexts) $action) $goal))
))

(= (calculate-confidence $matchCount $totalCount) (
    let $K 800
    (if (== $totalCount 0)
        0
        (div $matchCount (+ $K $matchCount))
    )
))
