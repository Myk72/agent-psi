(= (extractRule $section $rule) (
    case $section (
        (Id (extractRuleId $rule))
        (STV (extractRuleSTV $rule))
        (AllContext (extractAllContext $rule))
        (Context (extractRuleContext $rule))
        (ContextSTV (extractRuleContextSTV $rule))
        (ContextValues (extractRuleContextValues $rule))
        (ContextValuesWithSTV (extractRuleContextValuesWithSTV $rule))
        (Action (extractRuleAction $rule))
        (ContextAndAction (extractContextAndAction $rule))
        (AllGoal (extractAllGoal $rule))
        (Goal (extractRuleGoal $rule))
        (GoalSTV (extractRuleGoalSTV $rule))
        (GoalValues (extractRuleGoalValues $rule))
        (GoalValuesWithSTV (extractRuleGoalValuesWithSTV $rule))
        ($default ())
    )
))

(: extractRuleId (-> Expression Number))
(= (extractRuleId $rule) (
    unify (: Rule $id $ttv $stv $complexity $implication) $rule
        $id
        -1
))

(= (extractRuleContext $rule) (
    unify
      (: Rule $id $ttv $stv $complexity
         (IMPLICATION
            (AND (Context $context-stv $context) $action)
            $goal
         )
      )
      $rule
      (cdr-atom $context) ;; To avoid 'AND'
      Empty         
))

(= (extractRuleContextValues $rule) (
    let $contexts (extractRuleContext $rule) (map-atom $contexts $context (car-atom $context))
))

(= (extractRuleAction $rule) (
    unify (: Rule $id $ttv $stv $complexity (IMPLICATION (AND $context (Action (SEQ_AND $action))) $goal)) $rule
        $action
        Empty
))

(= (extractRuleGoal $rule) (
    unify (: Rule $id $ttv $stv $complexity (IMPLICATION $and-link (Goal $goal-stv $goal))) $rule
        (cdr-atom $goal) ;; Avoids 'AND'
        Empty
))

(= (extractRuleGoalValues $rule) (
    ;; TODO: CLEAN UP
    let* (
        ($goals (extractRuleGoal $rule))
        ($cleanGoals (map-atom $goals $goal (car-atom $goal)))
        ; ($_ (println! (CleanGoals: $cleanGoals)))
    ) $cleanGoals
    ; let $goals (extractRuleGoal $rule) (map-atom $goals $goal (car-atom $goal))
))

(= (extractRuleSTV $rule) (
    unify (: Rule $id $ttv (STV $s $c) $complexity $implication) $rule
        (STV $s $c)
        (STV 1 0)
))

(= (extractRuleContextSTV $rule) (
    unify (: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $cont-stv $contexts) $actions) $goal)) $rule
        $cont-stv
        (STV 1 0)
))

(= (extractRuleGoalSTV $rule) (
    unify (: Rule $id $ttv $stv $complexity (IMPLICATION (AND $context $action) (Goal $goal-stv $goals))) $rule
        $goal-stv
        (STV 1 0)
))

(= (extractContextAndAction $rule) (
    unify (: Rule $id $ttv $stv $complexity (IMPLICATION $contextAction $goal)) $rule
        $contextAction
        Empty
))

(= (extractAllGoal $rule) (
    unify (: Rule $id $ttv $stv $complexity (IMPLICATION $contextAction $goal)) $rule
        $goal
        Empty
))

(= (extractAllContext $rule) (
    unify (: Rule $id $ttv $stv $complexity (IMPLICATION (AND $context $action) $goal)) $rule
        $context
        Empty
))

; !(extractRuleAction (: Rule 1
;         (TTV 0)
;         (STV 0.5 0.002)  
;         (Complexity 1)
;         (IMPLICATION
;             (AND 
;                 (Context (STV 0.2 0.1) (AND 
;                     (LEFT_SQUARE (STV 0.2 0.1))
;                     (STILL_ALIVE (STV 0.2 0.1))))
;                 (Action (SEQ_AND (MOVE_RIGHT)) ) )
;             (Goal (STV 0.2 0.1) (AND
;                     (CENTER_SQUARE (STV 0.2 0.1))
;                     (STILL_ALIVE (STV 0.2 0.1))
;         )) 
; )))