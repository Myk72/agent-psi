(: Rule 1
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
                (SEQ_AND (ATTACK_SWORD))))
        (Goal (STV 0.3 0.1) (AND
            (HIT (STV 0.2 0.1))
            (KILL (STV 0.2 0.1))
        )) 
    )
)