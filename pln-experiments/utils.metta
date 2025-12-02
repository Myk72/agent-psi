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

(= (areSimilar $listOne $listTwo) (
    if (not (== (size-atom $listOne) (size-atom $listTwo)))
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

