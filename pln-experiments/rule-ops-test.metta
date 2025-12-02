!(import! &self rule-ops)

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

; !(extractRule id (TestRule))
; !(extractRule Context (TestRule))
!(extractRule ContextValues (TestRule))
; !(extractRule Action (TestRule))
; !(extractRule Goal (TestRule))
; !(extractRule GoalValues (TestRule))
; !(extractRule STV (TestRule))
; !(extractRule ContextSTV (TestRule))
; !(extractRule GoalSTV (TestRule))
; !(extractRule ContextValues (: Rule 1 (TTV 0) (STV 0.5 0.002) (Complexity 1) (IMPLICATION_LINK (AND_LINK (Context (STV 0.2 0.1) (AND_LINK (LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))) (Action (SEQ_AND_LINK (MOVE_RIGHT)))) (Goal (AND_LINK (STV 0.2 0.1) (CENTER_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))))