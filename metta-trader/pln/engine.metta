!(import! &self inference/deduction)
!(import! &self inference/induction)
!(import! &self inference/abduction)
!(import! &self inference/conjunction)
!(import! &self formula)
!(import! &self utils)

!(import! &self rule/query)
!(import! &self rule/inference-utils)
!(import! &self rule/helpers)

(= (pln-reasoning $rules) (
    let* (
        ($abductionResults (pln-abduction $rules))
        ($conjunctionResults (pln-conjunction $rules))
        ($deductionResults (pln-deduction $rules))
        ($inductionResults (pln-induction $rules))

        ($_ (println! (Abduction Results: $abductionResults)))
        ($_ (println! (Conjunction Results: $conjunctionResults)))
        ($_ (println! (Deduction Results: $deductionResults)))
        ($_ (println! (Induction Results: $inductionResults)))
        
        ($reasonedRules (flattenList ($deductionResults $conjunctionResults $abductionResults $inductionResults)))
        
        
        ;; Give them unique IDs, TTV, and Complexity
        ($prevRuleId (getLatestRuleId $rules))
        ($prevTTV (getCurrentTimeCycle $rules))
        ($currRuleId (+ 1 $prevRuleId))
        ($currTTV (+ 1 $prevTTV))
        
        ($newRules (processRules $reasonedRules $currRuleId $currTTV))
    ) $newRules
))