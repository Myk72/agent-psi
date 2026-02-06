!(register-module! ../../metta-trader)
!(import! &self metta-trader:rule-ops)
!(import! &self metta-trader:world)
!(import! &self metta-trader:utils)

;; Test for getting an item
!(assertEqual (getItem ((HAS FOOD) (PLANET A))) FOOD)
!(assertEqual (getItem ((PLANET A) (HAS FOOD))) FOOD)
!(assertEqual (getItem ((PLANET C) (HAS FUEL))) FUEL)

;; Test for evaluating state
!(assertEqual (evaluateState ((HAS FOOD) (PLANET A)) 10) 25)
!(assertEqual (evaluateState ((HAS FUEL) (PLANET B)) 0) 16)
!(assertEqual (evaluateState ((HAS METAL) (PLANET C)) 23) 38)

;; Test for getting the planet
!(assertEqual (getPlanetFromContexts ((PLANET C))) C)
!(assertEqual (getPlanetFromContexts ((PLANET A) (HAS METAL))) A)
!(assertEqual (getPlanetFromContexts ((HAS METAL) (PLANET A))) A)