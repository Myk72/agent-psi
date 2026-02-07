;; Utility functions for Thompson Sampling based action planner

;; Convert confidence to count
(: confidenceToCount (-> Number Number))
(= (confidenceToCount $confidence) (
    / (* $confidence 800) (- 1 $confidence)
))

;; Convert count to confidence
(: countToConfindence (-> Number Number))
(= (countToConfindence $count) (
    / $count (+ 800 $count)
))

;; Convert strength and confidence to alpha and beta parameters of Beta distribution
(: stvToBeta (-> (Number Number) (Number Number)))
(= (stvToBeta ($strength $confidence)) (
    let* (
        ($count (confidenceToCount $confidence))
        ($alpha (* $strength $count))
        ($beta (- $count $alpha))
    ) ($alpha $beta)
))

;; Convert alpha and beta parameters of Beta distribution to strength and confidence
(: betaToSTV (-> (Number Number) (Number Number)))
(= (betaToSTV ($alpha $beta)) (
    let* (
        ($count (+ $alpha $beta))
        ($strength (round (/ $alpha $count) 2))
        ($confidence (+ 0.001 (round (countToConfindence $count) 2))) ;; A small value should be added to avoid 0 when rounding
    ) ($strength $confidence)
))

;; Math utilities for Metta
(: isBetween (-> Number Number Number Bool))
(= (isBetween $val $low $high) (and (>= $val $low) (<= $val $high)))

(: max (-> Number Number Number))
(= (max $x $y) (if (> $x $y) $x $y))

(: min (-> Number Number Number))
(= (min $x $y) (if (> $x $y) $y $x))

(: round (-> Number Number Number))
(= (round $num $sig) ((py-atom round) $num $sig))

(: getRandomInt (-> Number Number Number))
(= (getRandomInt $min $max) (
    (py-atom random.randint) $min $max
))

(: getRandom (-> Number))
(= (getRandom) (
    (py-atom random.random)
))

(: log (-> Number Number))
(= (log $value) (
    (py-atom math.log) $value
))

(: sqrt (-> Number Number))
(= (sqrt $num) (
    (py-atom math.sqrt) $num
))

(: exp (-> Number Number))
(= (exp $num) (
    (py-atom math.exp) $num
))

(: div (-> Number Number Number))
(= (div $num $denom) (
    (py-atom operator.truediv) $num $denom
))

(: sampleEngine (-> Number Number Number Number Number Number))
(= (sampleEngine $alpha $beta $a $b $gamma) (
    let* (
        ($u1 (getRandom))
        ($u2 (getRandom))
        ($v (* $beta (log (/ $u1 (- 1 $u1)))))
        ($w (* $a (exp $v)))
        ($temp (log (/ $alpha (+ $b $w))))
        ($left (+ (* $alpha $temp) (* $gamma $v)))
        ($right (+ (log 4) (log (* (* $u1 $u1) $u2))))
    ) (if (>= $left $right)
        (round (/ $w (+ $b $w)) 4)
        (sampleEngine $alpha $beta $a $b $gamma)
    )
))

(: betaSample (-> Number Number Number))
(= (betaSample $a $b) (
    let* (
        ($alpha (+ $a $b))
        ($beta (if (<= (min $a $b) 1) (max (/ 1 $a) (/ 1 $b)) (sqrt (/ (- $alpha 2) (- (* 2 (* $a $b)) $alpha))))) 
        ($gamma (/ (+ $a 1) $beta))
    ) (sampleEngine $alpha $beta $a $b $gamma)
))

;; An alternative to beta sampling for PeTTa
; (= (np) (import numpy))
; (= (np.random) (get-attribute (np) random))
; (= (betaSample $a $b) (
;     py-call (".beta" (np.random) $a $b 1)
; ))