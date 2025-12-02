!(import! &self deduction-utils)
!(import! &self rule-ops)
!(import! &self utils)

(= (TestRule) (: Rule 1
    (TTV 0)
    (STV 0.5 0.002)  
    (Complexity 1)
    (IMPLICATION
    	(AND
            (Context (STV 0.2 0.1) (AND
                (CLOSE_RANGE (STV 0.2 0.1))
                (WEARING_BLUE_HAT (STV 0.2 0.1))) 
            )
            (Action 
                (SEQ_AND (JUMP ATTACK_SWORD))))
        (Goal (STV 0.3 0.1) (AND
            (HIT (STV 0.2 0.1))
            (KILL (STV 0.2 0.1))
        )) 
    )
))

; !(createPremise (TestRule))
; !(findMatchingFromGoalRec (HIT KILL) ((TestRule) (: Rule 2
;     (TTV 0)
;     (STV 0.5 0.002)  
;     (Complexity 1)
;     (IMPLICATION
;     	(AND
;             (Context (STV 0.2 0.1) (AND
;                 (CLOSE_RANGE (STV 0.2 0.1))
;                 (WEARING_BLUE_HAT (STV 0.2 0.1))) 
;             )
;             (Action 
;                 (SEQ_AND (JUMP ATTACK_SWORD))))
;         (Goal (STV 0.3 0.1) (AND
;             (HITS (STV 0.2 0.1))
;             (KILL (STV 0.2 0.1))
;         )) 
;     )
; )))

!(findMatchingFromContextRec (CLOSE_RANGE WEARING_BLUE_HAT) ((TestRule) (: Rule 2
    (TTV 0)
    (STV 0.5 0.002)  
    (Complexity 1)
    (IMPLICATION
    	(AND
            (Context (STV 0.2 0.1) (AND
                (CLOSE_RANGE (STV 0.2 0.1))
                (WEARING_RED_HAT (STV 0.2 0.1))) 
            )
            (Action 
                (SEQ_AND (JUMP ATTACK_SWORD))))
        (Goal (STV 0.3 0.1) (AND
            (HITS (STV 0.2 0.1))
            (KILL (STV 0.2 0.1))
        )) 
    )
)))