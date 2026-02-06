(: isMember (-> Expression Number Bool))
(= (isMember $list $val) (
    let $exists (collapse (let $member (superpose $list) (if (== $member $val) True Empty)))
    (if (== $exists ()) 0 1)
))

(: sum (-> Expression Number))
(= (sum $list) (
    if (== $list ())
        0
        (let* (
            (($head $tail) (decons-atom $list))
            ($rest (sum $tail))
        ) (+ $head $rest))
))

(: countSimilar (-> Expression Expression Number))
(= (countSimilar $listOne $listTwo) (
    let* (
        ($count (collapse (let $value (superpose $listOne) (let $isIn (isMember $listTwo $value) $isIn))))
    ) (sum $count)
))

(= (areSimilar $listOne $listTwo) 
    (if (not (== (size-atom $listOne) (size-atom $listTwo)))
        False
        (if (== (size-atom $listOne) (countSimilar $listOne $listTwo))
            True 
            False)
))

(= (clearSpace $space)
  (match $space $atom
    (remove-atom $space $atom)
  )
)

(: min (-> Number Number Number))
(= (min $num1 $num2) (
    if (< $num1 $num2)
        $num1
        $num2
))

(: div (-> Number Number Number))
(= (div $num $denom) (
    (py-atom operator.truediv) $num $denom
))

(: round (-> Number Number Number))
(= (round $num $sig) ((py-atom round) $num $sig))

(= (generateIdRand) (
    ((py-atom random.randint) 10000 99999)
))

(: (removeDuplicateRules (-> hyperon::space::DynSpace Expression)))
(= (removeDuplicateRules $ruleSpace) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
    ) (remove-duplicate-rules $rules)
))

(: isPresent (-> Expression Number Bool))
(= (isPresent $list $val) (
    let $exists (collapse (let $member (superpose $list) (if (== $member $val) True Empty)))
    (if (== $exists ()) False True)
))

(: (remove-duplicate-rules (-> Expression Expression)))
(= (remove-duplicate-rules $rules) (
    if (== () $rules)
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($rest (remove-duplicate-rules $tail))
            ($exists (isPresent $rest $head))
        ) (if $exists $rest (cons-atom $head $rest)))
))
