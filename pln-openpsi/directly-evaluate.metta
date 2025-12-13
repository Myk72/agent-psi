!(import! &self utils:rule-ops)
!(import! &self utils:util)
!(import! &self utils:directly-evaluate-utils)

;; ============================================================================
;; Main Entry Point: pln-directly-evaluate
;; ============================================================================

(= (pln-directly-evaluate $ruleSpace $perceptaSpace) (
    let* (
        ($_ (println! "PLN Direct Evaluation Started"))
        ($rules (collapse (get-atoms $ruleSpace)))
        ($evaluatedRules (evaluate-all-rules $rules $perceptaSpace))
        ($_ (println! "PLN Direct Evaluation Completed"))
    ) $evaluatedRules
))

;; ============================================================================
;; Rule Evaluation Recursion
;; ============================================================================


(= (evaluate-all-rules $rules $perceptaSpace) (
    if (<= (size-atom $rules) 0)
        ()
        (let* (
            (($rule $remRules) (decons-atom $rules))
            ($evaluatedRule (directly-evaluate $rule $perceptaSpace))
            ($_ (println! ("Evaluated Rule: " (extractRule Id $rule))))
            ($restEvaluated (evaluate-all-rules $remRules $perceptaSpace))
        ) (cons-atom $evaluatedRule $restEvaluated))
))

;; ============================================================================
;; Core Evaluation Function: directly-evaluate
;; ============================================================================


(= (directly-evaluate $rule $perceptaSpace) (
    let* (
        ;; Step 1: Extract context information from rule
        ($contextFacts (extractRule Context $rule))
        ($contextFacts (if (== $contextFacts Empty) () $contextFacts))
        
        ;; Step 2: Get all perceptions from percepta space
        ($allPerceptions (collapse (get-atoms $perceptaSpace)))
        ($totalCount (size-atom $allPerceptions))
        
        ;; Step 3: Count matching perceptions
        ($matchCount (count-matching-perceptions $contextFacts $allPerceptions 0))
        
        ;; Step 4 & 5: Calculate frequency and confidence
        ($frequency (if (== $totalCount 0) 0 (/ $matchCount $totalCount)))
        ($confidence (calculate-confidence $matchCount $totalCount))
        ($newContextSTV (STV $frequency $confidence))
        
        ;; Step 6 & 7: Build updated rule with new context STV
        ($updatedRule (construct-rule-with-new-context-stv $rule $newContextSTV))
        ($_ (println! ("Rule ID: " (extractRule Id $rule) " | Matches: " $matchCount " / " $totalCount " | Frequency: " $frequency)))
    ) $updatedRule
))

;; ============================================================================
;; Utility Functions for directly-evaluate
;; ============================================================================

;; (count-matching-perceptions $contextFacts $perceptions $accumulator) -> $count

(= (count-matching-perceptions $contextFacts $perceptions $accumulator) (
    if (== $perceptions ())
        $accumulator
        (let* (
            (($perception $remaining) (decons-atom $perceptions))
            ($perceptionFacts (extract-percepta-facts $perception))
            ($isMatch (facts-in-percepta $contextFacts $perceptionFacts))
            ($newAccumulator (if $isMatch (+ $accumulator 1) $accumulator))
        ) (count-matching-perceptions $contextFacts $remaining $newAccumulator))
))

;; (facts-in-percepta $contextFacts $perceptionFacts) -> Bool
;;
;; Purpose:
;;   Checks if all context facts are present in a perception
;;
;; Process:
;;   Uses areSimilar to verify all required facts exist in the perception
(= (facts-in-percepta $contextFacts $perceptionFacts) (
    areSimilar $contextFacts $perceptionFacts
))

;; (extract-percepta-facts $percepta) -> $factsList

(= (extract-percepta-facts $percepta) (
    unify (: Percepta $id (AND $facts)) $percepta
        $facts
        (unify (: Percepta $id $fact) $percepta
            ($fact)
            ()
        )
))

;; (construct-rule-with-new-context-stv $rule $newContextSTV) -> $updatedRule

(= (construct-rule-with-new-context-stv $rule $newContextSTV) (
    unify (: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $_ (AND $contextFacts)) $action) $goal))
        $rule
        (: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $newContextSTV (AND $contextFacts)) $action) $goal))
        $rule
))

;; ============================================================================
;; Confidence Calculation
;; ============================================================================

;; (calculate-confidence $matchCount $totalCount) -> $confidence
(= (calculate-confidence $matchCount $totalCount) (
    let $K 800
    (if (== $totalCount 0)
        0
        (/ $matchCount (+ $K $matchCount))
    )
))
