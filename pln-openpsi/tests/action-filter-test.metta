;; Tests for filterByAction function - filters rules by action values
!(register-module! ../../pln-openpsi)
!(import! &self pln-openpsi:utils:action-filter)
!(import! &self pln-openpsi:utils:rule-ops)
!(import! &self pln-openpsi:utils:util)

!(bind! &ruleSpace (new-space))

!(add-reduct &ruleSpace (superpose (
    (: Rule 1
        (TTV 0) (STV 0.5 0.002) (Complexity 1)
        (IMPLICATION
            (AND 
                (Context (STV 0.2 0.1) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND ((CENTER_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
    ))
    (: Rule 2
        (TTV 0) (STV 0.5 0.002) (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND ((CENTER_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND ((RIGHT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
    ))
    (: Rule 3
        (TTV 0) (STV 0.5 0.002) (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_LEFT))))
            (Goal (STV 0.2 0.1) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
    ))
)))

(= (count-rules $rules) (
    if (== () $rules) 0
        (let* (
            (($head $tail) (decons-atom $rules))
            ($restCount (count-rules $tail))
        ) (+ 1 $restCount))
))

!(bind! &result (filterByAction (MOVE_RIGHT) &ruleSpace))
!(println! ("Filtered rules: " &result))
!(bind! &count (count-rules &result))
!(println! ("Count: " &count))
!(assertEqual &count 2) ;; Should match Rules 1 and 2

!(println! "Action filter test passed!")
!(println! "")

