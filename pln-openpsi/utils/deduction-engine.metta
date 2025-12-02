;;;;;;;;;;
;; Type ;;
;;;;;;;;;;

(: TruthValue Type)

;;;;;;;;;;;;;;;;;;
;; Constructors ;;
;;;;;;;;;;;;;;;;;;

;; Boolean TV constructor
;; TODO: alternatively we could have (: ⊤ TruthValue) and (: ⊥ TruthValue)
(: Bl (-> Bool TruthValue))

;; First order probability TV constructor, i.e. mere probability.
(: Pr (-> Number TruthValue))

;; Simple Truth Value.  A Second order probability TV constructor,
;; i.e. probability and confidence.  The probability is in fact the
;; mode of the corresponding beta distribution.
(: STV (-> Number Number TruthValue))

;;;;;;;;;;;;;;;
;; Constants ;;
;;;;;;;;;;;;;;;

;; For now the underlying beta distributions have a Jeffreys prior,
;; i.e. the prior alpha and beta are 0.5.
(: prior-alpha (-> Number))
(= (prior-alpha) 0.5)
(: prior-beta (-> Number))
(= (prior-beta) 0.5)

;; Lookahead
(: lookahead (-> Number))
(= (lookahead) 1.0)

;; Maximum supported count (till +inf is supported, possibly).
(: max-count (-> Number))
(= (max-count) 1e9)

;;;;;;;;;;;;;
;; Methods ;;
;;;;;;;;;;;;;

;; Convert count to confidence using the formula
;;
;; confidence = count / (count + lookahead)
(: count->confidence (-> Number Number))
(= (count->confidence $cnt) (/ $cnt (+ $cnt (lookahead))))

;; Convert confidence to count using the formula
;;
;; count = (confidence * lookahead) / (1 - confidence)
(: confidence->count (-> Number Number))
(= (confidence->count $conf) (if (approxEq 1.0 $conf 1e-9)
                                 (max-count)
                                 (/ (* $conf (lookahead)) (- 1.0 $conf))))

;; Increment the negative count of a given truth value, by
;; incrementing its total count without incrementing the positive
;; count.
(: inc-neg-count (-> TruthValue TruthValue))
(= (inc-neg-count (STV $s $c)) (let* (($tot_cnt (confidence->count $c))
                                      ($pos_cnt (* $s $tot_cnt))
                                      ($new_tot_cnt (+ $tot_cnt 1)))
                                 (STV (/ $pos_cnt $new_tot_cnt)
                                      (count->confidence $new_tot_cnt))))

;; Increment the positive count of a given truth value, by
;; incrementing its total count and its positive count.
(: inc-pos-count (-> TruthValue TruthValue))
(= (inc-pos-count (STV $s $c)) (let* (($tot_cnt (confidence->count $c))
                                      ($pos_cnt (* $s $tot_cnt))
                                      ($new_pos_cnt (+ $pos_cnt 1))
                                      ($new_tot_cnt (+ $tot_cnt 1)))
                                 (STV (/ $new_pos_cnt $new_tot_cnt)
                                      (count->confidence $new_tot_cnt))))

;; Return the first order probability mode of the second order
;; distribution associated to a truth value.
(: mode (-> TruthValue Number))
(= (mode (Bl True)) 1.0)
(= (mode (Bl False)) 0.0)
(= (mode (Pr $pr)) $pr)
(= (mode (STV $pr $_)) $pr)

;; Return the total count of a truth value.  For truth values not
;; capturing a notion of confidence, such as Bl or Pr then the count
;; is assumed to be a very large number (cause +inf does not seem to
;; be supported at the moment).
(: count (-> TruthValue Number))
(= (count (Bl $_)) (max-count))
(= (count (Pr $_)) (max-count))
(= (count (STV $_ $conf)) (confidence->count $conf))

;; Return the confidence of a truth value.  For truth values not
;; capturing a notion of confidence, such as Bl or Pr then the
;; confidence is assumed to be 1.0.  For truth values capturing a
;; notion of confidence, such as STV, the formula to convert a count
;; into confidence is as follows
;;
;; confidence = count / (count + lookahead)
(: confidence (-> TruthValue Number))
(= (confidence (Bl $_)) 1.0)
(= (confidence (Pr $_)) 1.0)
(= (confidence (STV $_ $conf)) $conf)

;; Return the positive count of a truth value.
(: pos-count (-> TruthValue Number))
(= (pos-count $tv) (* (mode $tv) (count $tv)))

;; Return the negative count of a truth value.
(: neg-count (-> TruthValue Number))
(= (neg-count $tv) (* (- 1 (mode $tv)) (count $tv)))

;; Return the posterior alpha of a truth value
(: post-alpha (-> TruthValue Number))
(= (post-alpha $tv) (+ (prior-alpha) (pos-count $tv)))

;; Return the posterior beta of a truth value
(: post-beta (-> TruthValue Number))
(= (post-beta $tv) (+ (prior-beta) (neg-count $tv)))

;; Return the first order probability mean of the second order
;; distribution associated to a truth value.  For truth values not
;; capturing a notion of confidence, such as Bl or Pr then the
;; confidence is assumed to be 1.0.  For truth values capturing a
;; notion of confidence, such as STV, a beta distribution is assumed.
(: mean (-> TruthValue Number))
(= (mean (Bl True)) 1.0)
(= (mean (Bl False)) 0.0)
(= (mean (Pr $pr)) $pr)
(= (mean (STV $pr $conf))
   (let* (($a (post-alpha (STV $pr $conf)))
          ($b (post-beta (STV $pr $conf))))
     (/ $a (+ $a $b))))

;; Collection of functions operating on numbers

;; Define max
(: max (-> $a $a $a))
(= (max $x $y) (if (> $x $y) $x $y))

;; Define min
(: min (-> $a $a $a))
(= (min $x $y) (if (< $x $y) $x $y))

;; Clamp a number to be within a certain range
(: clamp (-> $a $a $a $a))
(= (clamp $x $l $u) (max $l (min $u $x)))

;; Define abs
(: abs (-> $a $a))
(= (abs $x) (if (< $x 0) (* -1 $x) $x))

;; Define <=
(: <= (-> $a $a Bool))
(= (<= $x $y) (or (< $x $y) (== $x $y)))

;; Define >=
(: >= (-> $a $a Bool))
(= (>= $x $y) (or (> $x $y) (== $x $y)))

;; Define approximately equal
(: approxEq (-> $a $a $a Bool))
(= (approxEq $x $y $epsilon) (<= (abs (- $x $y)) $epsilon))

;; Define Nat
(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

;; Define cast functions between Nat and Number
(: fromNumber (-> Number Nat))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))
(: fromNat (-> Nat Number))
(= (fromNat Z) 0)
(= (fromNat (S $k)) (+ 1 (fromNat $k)))

;; Define a generic less than operator, ⩻, for Nat.  < cannot be used
;; because it is a built-in, its type is hardwired and cannot be
;; overloaded.
(: ⩻ (-> Nat Nat Bool))
(= (⩻ $_ Z) False)
(= (⩻ Z (S $_)) True)
(= (⩻ (S $x) (S $y)) (⩻ $x $y))

;; Overload ⩻ for Number.
(: ⩻ (-> Number Number Bool))
(= (⩻ $x $y) (< $x $y))

;; Return the ceiling of a non negative number.  If the number is
;; negative it returns 1.
(: ceil (-> Number Number))
(= (ceil $n) (fromNat (fromNumber $n)))

;; Convert Number to Bool.  Anything above 0 converts to True.
(: number->bool (-> Number Bool))
(= (number->bool $x) (< 0 $x))

;; Convert Bool to Number.  False converts to 0, True converts to 1.
(: bool->number (-> Bool Number))
(= (bool->number False) 0)
(= (bool->number True) 1)

;; Define a less than type.  Note that it is purposefully different
;; than ⩻ as it is a type, not an operator.  Inhabitants of (⍃ x y)
;; are proofs that x ⩻ y == True.  For now ⍃ is only axiomatized for
;; Nat.
(: ⍃ (-> $t $t Type))

;; Zero is always less than the successor of something
(: (zero-lt-succ-axiom) (-> Atom))
(= (zero-lt-succ-axiom)
   (: ZeroLTSucc (⍃ Z (S $k))))

;; If x ⍃ y then (S x) ⍃ (S y)
(: (succ-monotonicity-rule) (-> Atom))
(= (succ-monotonicity-rule)
   (: SuccMonotonicity (-> (⍃ $x $y)
                           (⍃ (S $x) (S $y)))))


; Consistency Conditions
(: smallest-intersection-probability (-> Number Number Number))
(= (smallest-intersection-probability $As $Bs)
  (clamp (/ (- (+ $As $Bs) 1) $As) 0 1))

(: largest-intersection-probability (-> Number Number Number))
(= (largest-intersection-probability $As $Bs)
  (clamp (/ $Bs $As) 0 1))

(: conditional-probability-consistency (-> Number Number Number Bool))
(= (conditional-probability-consistency $As $Bs $ABs)
   (and (< 0 $As)
        (and (<= (smallest-intersection-probability $As $Bs) $ABs)
             (<= $ABs (largest-intersection-probability $As $Bs)))))

;; Main Formula
(: simple-deduction-strength-formula (-> Number Number Number Number Number Number))
(= (simple-deduction-strength-formula $As $Bs $Cs $ABs $BCs)
  (if
     (and
        (conditional-probability-consistency $As $Bs $ABs)
        (conditional-probability-consistency $Bs $Cs $BCs))
     ;; Preconditions are met
     (if (< 0.99 $Bs)
        ;; sB tends to 1
        $Cs
        ;; otherwise
        (+ (* $ABs $BCs) (/ (* (- 1 $ABs) (- $Cs (* $Bs $BCs))) (- 1 $Bs))))
     ;; Preconditions are not met
     0))

;; Alternate deduction formula hardwired for STV to make it faster.
(= (deduction-formula (STV $Ps $Pc)
                      (STV $Qs $Qc)
                      (STV $Rs $Rc)
                      (STV $PQs $PQc)
                      (STV $QRs $QRc))
   (if (and (conditional-probability-consistency $Ps $Qs $PQs)
            (conditional-probability-consistency $Qs $Rs $QRs))
       ;; Preconditions are met
       (STV (if (< 0.9999 $Qs)                  ; avoid division by 0
                ;; Qs tends to 1
                $Rs
                ;; Otherwise
                (+ (* $PQs $QRs) (/ (* (- 1 $PQs) (- $Rs (* $Qs $QRs))) (- 1 $Qs))))
            (min $Pc (min $Qc (min $Rc (min $PQc $QRc)))))
       ;; Preconditions are not met
       (STV 1 0)))

;;;;;;;;;;;;;;;;;;;;;
;; Rule Definition ;;
;;;;;;;;;;;;;;;;;;;;;

;; Deduction rule represented as a function.
;;
;; P ≞ PTV
;; Q ≞ QTV
;; R ≞ RTV
;; P → Q ≞ PQTV
;; Q → R ≞ RQTV
;; ⊢
;; P → R ≞ TV
(= (deduction (≞ $p $ptv)
              (≞ $q $qtv)
              (≞ $r $rtv)
              (≞ (→ $p $q) $pqtv)
              (≞ (→ $q $r) $qrtv))
   (≞ (→ $p $r) (deduction-formula $ptv $qtv $rtv $pqtv $qrtv)))

;; Corresponding matching query of that rule
(: deduction_match (-> $kb Atom))
(= (deduction_match $kb)
   (let* (($prem1 (≞ $p $ptv))
          ($prem2 (≞ $q $qtv))
          ($prem3 (≞ $r $rtv))
          ($prem4 (≞ (→ $p $q) $pqtv))
          ($prem5 (≞ (→ $q $r) $qrtv))
          )
     (match $kb
       ;; Premises
       (, $prem1 $prem2 $prem3 $prem4 $prem5)
       ;; Conclusion
       (deduction $prem1 $prem2 $prem3 $prem4 $prem5))))


; (≞ (P) (STV 0.3 0.1))
; (≞ (Q) (STV 0.1 0.2))
; (≞ (R) (STV 0.1 0.3))
; (≞ (→ (P) (Q)) (STV 0.1 0.4))
; (≞ (→ (Q) (R)) (STV 0.3 0.5))

; (≞ 1 (STV 0.3 0.1))
; (≞ 2 (STV 0.1 0.2))
; (≞ 3 (STV 0.1 0.3))
; (≞ (→ 1 2) (STV 0.1 0.4))
; (≞ (→ 2 3) (STV 0.3 0.5))

; (≞ (→ (1 C) (1 G)) (STV 0.5 0.002))
; (≞ (2 G) (STV 0.2 0.1)) 
; (≞ (1 G) (STV 0.2 0.1))
; (≞ (→ (1 G) (2 G)) (STV 0.5 0.002)) 
; (≞ (1 C) (STV 0.2 0.1)) 

; (≞ (2 G) (STV 0.2 0.1)) 
; (≞ (→ (1 G) (2 G)) (STV 0.5 0.002)) 
; (≞ (1 C) (STV 0.2 0.1)) 
; (≞ (1 G) (STV 0.2 0.1)) 
; (≞ (→ (1 C) (1 G)) (STV 0.5 0.002)) 
; (≞ (2 G) (STV 0.2 0.1)) 
; (≞ (→ (3 G) (2 G)) (STV 0.5 0.002)) 
; (≞ (3 C) (STV 0.2 0.1)) 
; (≞ (3 G) (STV 0.2 0.1)) 
; (≞ (→ (3 C) (3 G)) (STV 0.5 0.002))

; (≞ (2 G) (STV 0.2 0.1)) (≞ (→ (1 G) (2 G)) (STV 0.5 0.002)) (≞ (1 C) (STV 0.2 0.1)) (≞ (1 G) (STV 0.2 0.1)) (≞ (→ (1 C) (1 G)) (STV 0.5 0.002))
; (≞ (2 G) (STV 0.2 0.1)) (≞ (→ (3 G) (2 G)) (STV 0.5 0.002)) (≞ (3 C) (STV 0.2 0.1)) (≞ (3 G) (STV 0.2 0.1)) (≞ (→ (3 C) (3 G)) (STV 0.5 0.002))


; !(deduction_match &self)
; !(deduction-formula (STV 0.3 0.1) (STV 0.1 0.2) (STV 0.1 0.3) (STV 0.1 0.4) (STV 0.3 0.5))


; !(bind! &ruleSpace (new-space))
; !(add-reduct &ruleSpace (superpose (
;     (≞ (P) (STV 0.3 0.1))
;     (≞ (Q) (STV 0.1 0.2))
;     (≞ (R) (STV 0.1 0.3))
;     (≞ (→ (P) (Q)) (STV 0.1 0.4))
;     (≞ (→ (Q) (R)) (STV 0.3 0.5))
; )))
; !(add-reduct &self (superpose ((Name Josh) (Name Nati))))
; !(match &ruleSpace (≞ $val $stv) $val)
; !(match &self (Name $name) $name)
; !(deduction_match &ruleSpace)

; (= (makeDeduction $ruleSpace) (
;     let* (
;         ; ($_ !(add-reduct &ruleSpace (superpose $premises)))
;         ; ($atoms (match &ruleSpace (≞ $val $stv) $val))
;         ; ; ($atoms (get-atoms &ruleSpace))
;         ; ($_ (println! (RuleSpaceAtoms: $atoms)))
;         ($result (deduction_match $ruleSpace))
;         ; ($_ (clearSpace &ruleSpace))
;     ) $result
; ))

; !(makeDeduction &ruleSpace)
