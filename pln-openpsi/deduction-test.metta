!(import! &self deduction)
!(import! &self utils:deduction-utils)
!(import! &self utils:util)
!(import! &self utils:rule-ops)
!(import! &self utils:deduction-engine)

(= (TestRules) (
    ;; Rule 1
    (: Rule 1
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION
            (AND 
                (Context (STV 0.2 0.1) (AND 
                    (LEFT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))))
                (Action (SEQ_AND (MOVE_RIGHT)) ) )
            (Goal (STV 0.2 0.1) (AND
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))
        )) 
    ))

    ;; Rule 3
    (: Rule 3
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND 
                    (RIGHT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))))
                (Action (SEQ_AND (MOVE_LEFT)) ) )
            (Goal (STV 0.2 0.1) (AND
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))
        )) 
    ))

    ;; Rule 2
    (: Rule 2
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND 
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))))
                (Action (SEQ_AND (MOVE_RIGHT)) ) )
            (Goal (STV 0.2 0.1) (AND
                    (RIGHT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))
        )) 
    ))
))

; !(reason

;     (: Rule 1
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
;     ))

;     (: Rule 2
;         (TTV 0)
;         (STV 0.5 0.002)  
;         (Complexity 1)
;         (IMPLICATION 
;             (AND 
;                 (Context (STV 0.2 0.1) (AND 
;                     (CENTER_SQUARE (STV 0.2 0.1))
;                     (STILL_ALIVE (STV 0.2 0.1))))
;                 (Action (SEQ_AND (MOVE_RIGHT)) ) )
;             (Goal (STV 0.2 0.1) (AND
;                     (RIGHT_SQUARE (STV 0.2 0.1))
;                     (STILL_ALIVE (STV 0.2 0.1))
;         )) 
;     ))

;     ((STV 0.7 0.1) (STV 1 0.3) (STV 0.9 0.7))
; )

!(bind! &ruleSpace (new-space))

!(add-reduct &ruleSpace (superpose (
    ;; Rule 1
    (: Rule 1
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION
            (AND 
                (Context (STV 0.2 0.1) (AND 
                    (LEFT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))))
                (Action (SEQ_AND (MOVE_RIGHT)) ) )
            (Goal (STV 0.2 0.1) (AND
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))
        )) 
    ))

    ;; Rule 3
    (: Rule 3
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND 
                    (RIGHT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))))
                (Action (SEQ_AND (MOVE_LEFT)) ) )
            (Goal (STV 0.2 0.1) (AND
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))
        )) 
    ))

    ;; Rule 2
    (: Rule 2
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND 
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))))
                (Action (SEQ_AND (MOVE_RIGHT)) ) )
            (Goal (STV 0.2 0.1) (AND
                    (RIGHT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1))
        )) 
    ))

)))

!(pln-deduction &ruleSpace)