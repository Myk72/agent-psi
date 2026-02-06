!(import! &self ../inference/deduction)
!(import! &self ../inference/induction)
!(import! &self ../inference/abduction)
!(import! &self ../inference/conjunction)
!(import! &self ../formula)
!(import! &self ../utils)

!(import! &self ../rule/query)
!(import! &self ../rule/inference-utils)
!(import! &self ../rule/helpers)

!(bind! &ruleSpace (new-space))

(= (addRule $ruleSpace) ( 
    let $rules (superpose (
    ;; Rule 1
    (: Rule 1
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION
            (AND 
                (Context (STV 0.2 0.1) (AND (
                    (LEFT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND (
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))
        )) 
    ))

    ;; Rule 3
    (: Rule 3
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND (
                    (LEFT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND (
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (DEAD (STV 0.2 0.1)))
        )) 
    ))

    ;; Rule 2
    (: Rule 2
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND (
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT)) ) )
            (Goal (STV 0.2 0.1) (AND (
                    (RIGHT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))
        )) 
    ))

    )) (add-atom $ruleSpace $rules)
))



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
        ; ($_ (println! ("Reasoned size: " (size-atom $reasonedRules))))
        
        ;; Give them unique IDs, TTV, and Complexity
        ($prevRuleId (getLatestRuleId $rules))
        ($prevTTV (getCurrentTimeCycle $rules))
        ($currRuleId (+ 1 $prevRuleId))
        ($currTTV (+ 1 $prevTTV))
        
        ($newRules (processRules $reasonedRules $currRuleId $currTTV))
    ) $newRules
))

!(addRule &ruleSpace)

!(pln-reasoning (collapse (get-atoms &ruleSpace)))