;; Deduction Formula
(= (deductionFormula (STV $Ps $Pc) (STV $Qs $Qc) (STV $Rs $Rc) (STV $PQs $PQc) (STV $QRs $QRc)) (
    STV (if (< 0.9999 $Qs) ; avoid division by 0
                $Rs
                (+ (* $PQs $QRs) (/ (* (- 1 $PQs) (- $Rs (* $Qs $QRs))) (- 1 $Qs))))
            (min $Pc (min $Qc (min $Rc (min $PQc $QRc))))
))

; Induction formula: PLN book "Appendix A: Comparison of PLN Rules with NARS Rules", page 307
(= (inductionFormula (STV $sA $cA)
                    (STV $sB $cB)
                    (STV $sC $cC)
                    (STV $sBA $cBA)
                    (STV $sBC $cBC))
   (STV (+ (/safe (* (* $sBA $sBC) $sB) $sA)
           (* (- 1 (/safe (* $sBA $sB) $sA))
              (/safe (- $sC (* $sB $sBC)) (- 1 $sB))))
        (Truth_w2c (min $cBA $cBC))))

; Abduction formula: PLN book "Appendix A: Comparison of PLN Rules with NARS Rules", page 307
(= (abductionFormula (STV $sA $cA)
                    (STV $sB $cB)
                    (STV $sC $cC)
                    (STV $sAB $cAB)
                    (STV $sCB $cCB))
   (STV (+ (/safe (* (* $sAB $sCB) $sC)
                  $sB)
           (/safe (* $sC (* (- 1 $sAB) (- 1 $sCB)))
                  (- 1 $sB)))
        (Truth_w2c (min $cAB $cCB))))

;; Conjunction Introduction Formula
(= (conjunctionFormula (STV $Ps $Pc) (STV $Qs $Qc)) (
    STV (* $Ps $Qs) (min $Pc $Qc)
))

;; Helper Function
(: Truth_w2c (-> Number Number))
(= (Truth_w2c $w)
   (/safe $w (+ $w 1)))