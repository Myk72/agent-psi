!(register-module! ../../pln-openpsi)
!(import! &self pln-openpsi:utils:directly-evaluate-utils)
!(import! &self pln-openpsi:utils:util)

!(assertEqual (calculate-confidence 3 10) 0.0037)
!(assertEqual (extract-percepta-values (: Percepta 1 (LEFT_SQUARE STILL_ALIVE))) (LEFT_SQUARE STILL_ALIVE))
!(assertEqual (facts-in-percepta (LEFT_SQUARE STILL_ALIVE) ((LEFT_SQUARE STILL_ALIVE) (CENTER_SQUARE DEAD))) 1)