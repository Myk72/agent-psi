; (= (findMatchingFromGoal $currentGoal $cogscm) (
;     let* (
;         ($_ (println! (CurrentGoal $currentGoal)))
;         ($_ (println! (CogScm $cogscm)))
;     ) (
;     ; map-atom $cogscm $rule (let $ruleGoal (extractRule GoalValues $rule) (if (areSimilar $currentGoal $ruleGoal) $rule Empty)) 
;     collapse (let $rule (superpose $cogscm) (let $ruleGoal (extractRule GoalValues $rule) (if (areSimilar $currentGoal $ruleGoal) $rule Empty))) 
; )))

; (= (findMatchingFromContext $currentContext $cogscm) (
;     let $rule (superpose $cogscm) (unify 
;         (: Rule $handle $ttv $stv $complexity $currentContext $action (Goal $goal))
;         $rule
;         $rule
;         Empty
;     )
; ))

(= (findMatchingFromGoalRec $currentGoal $cogscm) (
    if (== () $cogscm)
        ()
        (let* (
            (($head $tail) (decons-atom $cogscm))
            ($ruleGoal (extractRule GoalValues $head))
            ($isSimilar (areSimilar $currentGoal $ruleGoal))
            ; ($_ (println! (areSimilaring $currentGoal $ruleGoal : $isSimilar)))
            ($restMatches (findMatchingFromGoalRec $currentGoal $tail))
        ) (if $isSimilar
            (cons-atom $head $restMatches)
            $restMatches))
))

(= (findMatchingFromContextRec $currentContext $cogscm) (
    if (== () $cogscm)
        ()
        (let* (
            (($head $tail) (decons-atom $cogscm))
            ($ruleContext (extractRule ContextValues $head))
            ($isSimilar (areSimilar $currentContext $ruleContext))
            ; ($_ (println! (areSimilaring $currentContext $ruleContext : $isSimilar)))
            ($restMatches (findMatchingFromContextRec $currentContext $tail))
        ) (if $isSimilar
            (cons-atom $head $restMatches)
            $restMatches))
))

(= (searchMatchingRulesFromGoal $currentId $currentGoal $cogscm) (
    if (== () $cogscm)
        (Empty)
        (let* (
            ($rules (findMatchingFromContextRec $currentGoal $cogscm))
            ($rulePremises (map-atom $rules $rule (createGoalPremise $currentId $rule)))
        ) $rulePremises)
))

(= (searchMatchingRulesFromContext $currentId $currentContext $cogscm) (
    let* (
        ($rules (findMatchingFromGoalRec $currentContext $cogscm))
        ($rulePremises (map-atom $rules $rule (createContextPremise $currentId $rule)))
    ) $rulePremises
))

(= (createGoalPremise $currentId $rule) (
    let* (
        ($ruleId (extractRule Id $rule))
        ($contextSTV (extractRule ContextSTV $rule))
        ($goalSTV (extractRule GoalSTV $rule))
        ($ruleSTV (extractRule STV $rule))

        ; ($premise-one (≞ ($ruleId C) $contextSTV)) ;; (≞ (1 C) (STV 0.5 0.002))
        ($premise-one (≞ ($ruleId G) $goalSTV));; (≞ (1 G) (STV 0.5 0.002)) CAUTION: Aggreagation could be required 
        ($premise-two (≞ (→ ($currentId G) ($ruleId G)) $ruleSTV)) ;; (≞ (→ (1 C) (1 G)) (STV 0.1 0.4))
        ($premises ($premise-one $premise-two))
    ) $premises
))

(= (createContextPremise $currentId $rule) (
    let* (
        ($ruleId (extractRule Id $rule))
        ($contextSTV (extractRule ContextSTV $rule))
        ($goalSTV (extractRule GoalSTV $rule))
        ($ruleSTV (extractRule STV $rule))
        
        ($premise-one (≞ ($ruleId C) $contextSTV))
        ($premise-two (≞ (→ ($ruleId C) ($currentId C)) $ruleSTV))
        ($premises ($premise-one $premise-two))
    ) $premises
))

(= (reason-deduction $premises $space) (
    let* (
        ; ($space (new-space))
        ($_ (add-reduct $space (superpose $premises)))
        ($deduced (deduction_match $space))
        ; ($_ (clearSpace $space))
    ) $deduced
    ; (Mock Reasoning)
))