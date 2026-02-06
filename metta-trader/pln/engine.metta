!(register-module! ../../metta-trader)

!(import! &self metta-trader:pln:inference:abduction)
!(import! &self metta-trader:pln:inference:conjunction)
!(import! &self metta-trader:pln:inference:deduction)
!(import! &self metta-trader:pln:inference:induction)
!(import! &self metta-trader:pln:formula)
!(import! &self metta-trader:pln:rule:rule)
!(import! &self metta-trader:pln:utils)

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