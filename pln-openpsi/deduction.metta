;; Not sure if filtering is required here
(= (pln-deduction $ruleSpace) (
    let* (
            ($rules (collapse (get-atoms $ruleSpace)))
            ($conclusions (deductionHelper $rules))
            ; ($_ (println! (Premises: $premises)))
            ; ($_ (add-reduct $premiseSpace (superpose (superpose $premises))))
            ; ($premiseAtoms (collapse (get-atoms $premiseSpace)))
            ; ($_ (println! (Atoms: $premiseAtoms)))
            ; ($conclusions (deduction_match $premiseSpace))
            ; ($_ (println! (Conclusions: $conclusions)))
            ; ($_ (println! (Rules: $rules)))
            ; ($cogscm (collapse (let $rule (superpose $rules) (if (isCogScm $rule) $rule Empty))))
        ) $conclusions
))

;; Create premises for the rule
;; Fill in the other premises from the matching rule 
;; combine the premises
;; call the reasoning function with the premises
;; accumulate the result in conclusions
;; Return the accumulated conclusions
(= (deductionHelper $cogscm) (
    if (<= (size-atom $cogscm) 1)
        ()
    (let* (
        (($rule $remCogscm) (decons-atom $cogscm))
        ($_ (println! (ProcessingRule: $rule)))
        ($_ (println! (RemainingRules: (size-atom $remCogscm))))
        ; ($_ (println! (CurrentConclusions: $conclusions)))

        ($ruleId (extractRule Id $rule))
        ; ($d (println! (RuleId: $ruleId)))
        ($currentContext (extractRule ContextValues $rule)) ;; Leave out the stv and and-link
        ; ($a (println! (CurrentContext: $currentContext)))
        ; ($currentAction (extractAction $rule)) ;; leave the ..
        ($currentGoal (extractRule GoalValues $rule))
        (() (println! (Rule Info: $ruleId $currentContext $currentGoal)))
        ($currentSTV (extractRule STV $rule))
        ($ruleContextSTV (extractRule ContextSTV $rule))
        ($ruleGoalSTV (extractRule GoalSTV $rule))
        (() (println! (Rule STVs: $ruleContextSTV $ruleGoalSTV $currentSTV)))
        ($premise-one (≞ ($ruleId C) $ruleContextSTV)) ;; (≞ (1 C) (STV 0.5 0.002))
        ($premise-two (≞ ($ruleId G) $ruleGoalSTV));; (≞ (1 G) (STV 0.5 0.002)) CAUTION: Aggreagation could be required 
        ($premise-three (≞ (→ ($ruleId C) ($ruleId G)) $currentSTV)) ;; (≞ (→ (1 C) (1 G)) (STV 0.1 0.4))
        ($rulePremises ($premise-one $premise-two $premise-three))
        ($rulesWithMatchingGoals (searchMatchingRulesFromGoal $ruleId $currentGoal $remCogscm)) ;; Returns an Expression 
        ; (
        ;   (
        ;     (≞ (→ (2 C) (2 G)) (STV 0.1 0.2)) 
        ;     (≞ (2 G) (STV 0.1 0.3)) 
        ;   )
        ;   (...)
        ; )
        ($GoalPremiseCollection (map-atom $rulesWithMatchingGoals $newPremises (union-atom $newPremises $rulePremises)))
        ($_ (println! (GoalPremiseCollection: $GoalPremiseCollection)))
        ($premisesActually (car-atom $GoalPremiseCollection))
        ($_ (println! (PremisesActually: $premisesActually)))
        ; ($_ (add-reduct $premiseSpace (superpose $premisesActually)))
        ; (() (println! (Added premises to premise space)))
        ; (() (println! (Premise Space after addition: (collapse (get-atoms $premiseSpace)))))
        ($space (new-space))
        ($reasoned (reason-deduction $premisesActually $space))
        ; ($reasoned (deduction_match $premiseSpace))
        ($_ (println! (Reasoned: $reasoned)))
        ($_ (println! (Type of Reasoned: (get-type $reasoned))))
        ; ($_ (clearSpace $premiseSpace))
        ; ($GoalReasonedRules (map-atom $GoalPremiseCollection $premises (deductionReasoning $premises)))
        ; ($_ (println! (GoalReasonedRules: $GoalReasonedRules)))

        ; ($rulesWithMatchingContext (searchMatchingRulesFromContext $ruleId $currentContext $remCogscm)) ;; Returns an Expression (((≞ Q (STV 0.1 0.2)) (≞ R (STV 0.1 0.3)) (≞ (→ P Q) (STV 0.1 0.4))) ...)
        ; ($ContextPremiseCollection (map-atom $rulesWithMatchingContext $newPremises (union-atom $newPremises $rulePremises)))
        ; ($_ (println! (ContextPremiseCollection: $ContextPremiseCollection)))
        ; ($ContextReasonedRules (map-atom $ContextPremiseCollection $premises (deductionReasoning $premises)))
        ; ($_ (println! (ContextReasonedRules: $ContextReasonedRules)))

        ; ($allReasonedRules (union-atom $GoalReasonedRules $ContextReasonedRules))
        ; ($updatedConclusions (union-atom $conclusions $reasoned))
        ; ($_ (println! (UpdatedConclusions: $updatedConclusions)))
        ($restDeduction (deductionHelper $remCogscm))
    ) 
        (cons-atom $reasoned $restDeduction)
        ; ()
    )
))

