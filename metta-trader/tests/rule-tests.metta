!(register-module! ../../metta-trader)
!(import! &self metta-trader:rule-ops)
!(import! &self metta-trader:world)
!(import! &self metta-trader:utils)

(= (TestRule) 
        (: Rule 22
            (TTV 0)
            (STV 0.5 0.002)
            (Complexity 1)
            (IMPLICATION
                (AND
                    (Context (STV 0.2 0.1) (AND (
                        (PLANET A (STV 0.2 0.1))
                    )))
                    (Action (SEQ_AND (BUY FUEL)))
                )
                (Goal (STV 0.2 0.1) (AND (
                    (PLANET A (STV 0.2 0.1))
                    (HAS FUEL (STV 0.1 0.1))
                )))
        ))
)

!(assertEqual (isValidRule ((PLANET A)) 25 (TestRule)) True)
!(assertEqual (isValidRule ((PLANET A)) 24 (TestRule)) False)
