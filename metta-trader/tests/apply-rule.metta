!(register-module! ../../metta-trader)
!(import! &self metta-trader:rule-ops)
!(import! &self metta-trader:world)
!(import! &self metta-trader:utils)

(= (TravelRule) 
        (: Rule 1
            (TTV 0)
            (STV 0.5 0.002)
            (Complexity 1)
            (IMPLICATION
                (AND
                    (Context (STV 0.2 0.1) (AND (
                        (PLANET A (STV 0.2 0.1))
                    )))
                    (Action (SEQ_AND (TRAVEL)))
                )
                (Goal (STV 0.2 0.1) (AND (
                    (PLANET B (STV 0.2 0.1))
            )))
        ))
)

;; Travel Rule Tests
!(assertEqual (applyTravel (TravelRule) ((PLANET A) (HAS FOOD)) 10) (((PLANET B) (HAS FOOD)) 9))
!(assertEqual (applyTravel (TravelRule) ((PLANET A)) 10) (((PLANET B)) 9))


(= (BuyRule) 
        (: Rule 9
            (TTV 0)
            (STV 0.5 0.002)
            (Complexity 1)
            (IMPLICATION
                (AND
                    (Context (STV 0.2 0.1) (AND ((PLANET C (STV 0.2 0.1)))))
                    (Action (SEQ_AND (BUY FOOD)))
                )
                (Goal (STV 0.2 0.1) (AND (
                    (PLANET C (STV 0.2 0.1))
                    (HAS FOOD (STV 0.2 0.1))
                )))
        ))
)

;; Buy Rule Tests: It buys food in this case
!(assertEqual (applyBuy (BuyRule) ((PLANET C)) 100) (((PLANET C) (HAS FOOD)) 82))
!(assertEqual (applyBuy (BuyRule) ((PLANET C) (HAS FOOD)) 100) (((PLANET C) (HAS FOOD)) 82))
!(assertEqual (applyBuy (BuyRule) ((PLANET C) (HAS FUEL)) 100) (((PLANET C) (HAS FOOD)) 82))


(= (SellRule)         
        (: Rule 16
            (TTV 0)
            (STV 0.5 0.002)
            (Complexity 1)
            (IMPLICATION
                (AND
                    (Context (STV 0.2 0.1) (AND (
                        (PLANET A (STV 0.2 0.1))
                        (HAS FOOD (STV 0.1 0.1))
                    )))
                    (Action (SEQ_AND (SELL FOOD)))
                )
                (Goal (STV 0.2 0.1) (AND (
                    (PLANET A (STV 0.2 0.1))
                )))
        ))
)

;; Sell Rule Tests: It sells food in this case
!(assertEqual (applySell (SellRule) ((PLANET A) (HAS FOOD)) 10) (((PLANET A)) 18))
!(assertEqual (applySell (SellRule) ((PLANET A) (HAS FOOD)) 0) (((PLANET A)) 8))