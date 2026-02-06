!(register-module! ../../metta-trader)
!(import! &self metta-trader:rule-ops)
!(import! &self metta-trader:world)
!(import! &self metta-trader:utils)

;; Test for adding an item
!(assertEqual (addItem ((PLANET A)) FOOD) ((PLANET A) (HAS FOOD)))
!(assertEqual (addItem ((PLANET A) (HAS FUEL)) FOOD) ((PLANET A) (HAS FOOD)))
!(assertEqual (addItem ((PLANET A) (HAS FOOD)) FOOD) ((PLANET A) (HAS FOOD)))

;; Test for removing an item
!(assertEqual (removeItem ((PLANET A) (HAS FOOD)) FOOD) ((PLANET A)))
!(assertEqual (removeItem ((PLANET A) (HAS FUEL)) FOOD) ((PLANET A) (HAS FUEL)))
!(assertEqual (removeItem ((PLANET A)) FOOD) ((PLANET A)))

;; Test for updating planet 
!(assertEqual (updatePlanet ((PLANET A)) B) ((PLANET B)))
!(assertEqual (updatePlanet ((PLANET A)) C) ((PLANET C)))
!(assertEqual (updatePlanet ((PLANET A)(HAS FOOD)) B) ((PLANET B) (HAS FOOD)))