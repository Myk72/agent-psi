(: Rule 1
    (TTV 0)
    (STV 0.5 0.002)  
    (Complexity 1)
    (IMPLICATION_LINK 
    	(AND_LINK 
(Context (STV 0.2 0.1) (AND_LINK 
(CLOSE_RANGE (STV 0.2 0.1))
(WEARING_BLUE_HAT (STV 0.2 0.1))) 
)
    		(Action (SEQ_AND_LINK (ATTACK_SWORD)) ) )
  	(Goal (AND_LINK (STV 0.2 0.1)
(HIT (STV 0.2 0.1))
(KILL (STV 0.2 0.1))
)) 
 ))

(= (visualProcessor ))