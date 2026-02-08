(= (getPlanetFromContexts $contexts) (
    let* (
        (($head $tail) (decons-atom $contexts))
        (($data $stv) $head)
        ($contextType (index-atom $data 0))
        ($contextValue (index-atom $data 1))
    ) (if (== $contextType PLANET)
        $contextValue
        (getPlanetFromContexts $tail)
    ))
)

(= (isValidRule $contexts $money $rule) (
    let* (
        ($ruleContext (extractRule ContextValues $rule))
        ($ruleActions (extractRule Action $rule))
        ($ruleGoal (extractRule GoalValues $rule))
        ($ruleAction (car-atom $ruleActions))
        ($currPlanet (getPlanetFromContexts $contexts))
        ($rulePlanet (getPlanetFromContexts $ruleContext))
    ) (if (not (== $currPlanet $rulePlanet)) 
        False
        (case $ruleAction (
            (TRAVEL (
                let* (
                    ($source (getPlanetFromContexts $ruleContext))
                    ($destination (getPlanetFromContexts $ruleGoal))
                    ($cost (eval (getTravelCost $source $destination)))
                ) (if (> $cost $money)
                    False
                    True
                )
            ))

            (SELL (
                let* (
                    ($item (index-atom $ruleActions 1))
                    (($foundName $stv) (getItem $contexts $item))
                ) (if (== $item $foundName)
                    True
                    False
                )
            ))

            (BUY (
                let* (
                    (($item $stv) (getItem $ruleGoal))
                    ($itemPrice (eval (getItemPrice $item $currPlanet)))
                ) (if (>= $money $itemPrice ) 
                    True
                    False
                )
            ))
    ))
)))

(= (getApplicableRules $contexts $money $rules) (
    if (== () $rules)
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($isValid (isValidRule $contexts $money $head))
            ($rest (getApplicableRules $contexts $money $tail))
        ) (if $isValid
            (cons-atom $head $rest)
            $rest
        ))
))

(= (updatePlanet $contexts $planet) (
    if (== $contexts ())
        ()
        (let* (
            (($head $tail) (decons-atom $contexts))
            (($data $stv) $head)
            ($contextType (index-atom $data 0))
            ($rest (updatePlanet $tail $planet))
        ) (if (== $contextType PLANET)
            (cons-atom ((PLANET $planet) $stv) $rest)
            (cons-atom $head $rest)
        )))
)

(= (addItem $contexts $newItem $newStv) (
    if (== $contexts ())
        (cons-atom ((HAS $newItem) $newStv) ())
        (let* (
            (($head $tail) (decons-atom $contexts))
            (($data $stv) $head)
            ($rest (addItem $tail $newItem $newStv))
        ) (if (== $data (HAS $newItem))
            $rest
            (cons-atom $head $rest)
        ))
))

(= (removeItem $contexts $item) (
    if (== $contexts ())
        ()
        (let* (
            (($head $tail) (decons-atom $contexts))
            (($data $stv) $head)
            ($contextType (index-atom $data 0))
            ($contextValue (index-atom $data 1))
            ($rest (removeItem $tail $item))
        ) (if (and (== $contextType HAS) (== $contextValue $item))
            $rest
            (cons-atom $head $rest)
        ))
))

(= (applyTravel $rule $contexts $money) (
    let* (
        ($ruleContext (extractRule ContextValues $rule))
        ($ruleGoal (extractRule GoalValues $rule))
        ($source (getPlanetFromContexts $ruleContext))
        ($destination (getPlanetFromContexts $ruleGoal))
        ($cost (eval (getTravelCost $source $destination)))
        ($newContext (updatePlanet $contexts $destination)) ;; TODO
        ($newMoney (- $money $cost))
    ) ($newContext $newMoney)
))

(= (applySell $rule $contexts $money) (
    let* (
        ($ruleActions (extractRule Action $rule))
        ($item (index-atom $ruleActions 1))
        ($planet (getPlanetFromContexts $contexts))
        ($newContext (removeItem $contexts $item))
        ($newMoney (+ $money (eval (getItemPrice $item $planet))))
    ) ($newContext $newMoney)
))

(= (applyBuy $rule $contexts $money) (
    let* (
        ($ruleGoal (extractRule GoalValues $rule))
        (($item $stv) (getItem $ruleGoal))
        ($planet (getPlanetFromContexts $ruleGoal))
        ($itemPrice (eval (getItemPrice $item $planet)))
        ($newContext (addItem $contexts $item $stv))
        ($newMoney (- $money $itemPrice))
    ) ($newContext $newMoney)
))

(= (applyRule $rule $contexts $money) (
    let* (
        ($ruleActions (extractRule Action $rule))
        ($ruleAction (index-atom $ruleActions 0))
    ) (case $ruleAction (
        (TRAVEL (applyTravel $rule $contexts $money))
        (SELL (applySell $rule $contexts $money))
        (BUY (applyBuy $rule $contexts $money))
    ))
))

(= (getItem $contexts) (
    if (== $contexts ())
        (() ())
        (let* (
            (($head $tail) (decons-atom $contexts))
            (($data $stv) $head)
            ($contextType (index-atom $data 0))
            ($itemName (index-atom $data 1))
        ) (if (== $contextType HAS)
            ($itemName $stv)
            (getItem $tail)
        ))
))

(= (getItem $contexts $targetItem) (
    if (== $contexts ())
        (() ())
        (let* (
            (($head $tail) (decons-atom $contexts))
            (($data $stv) $head)
            ($contextType (index-atom $data 0))
            ($itemName (index-atom $data 1))
        ) (if (and (== $contextType HAS) (== $itemName $targetItem))
            ($itemName $stv)
            (getItem $tail $targetItem)
        ))
))


(= (getInventoryValue $contexts $planet) (
     if (== $contexts ())
         0
         (let* (
             (($head $tail) (decons-atom $contexts))
             (($data $stv) $head)
             ($contextType (index-atom $data 0))
             ($restValue (getInventoryValue $tail $planet))
         ) (if (== $contextType HAS)
             (let* (
                 ($itemName (index-atom $data 1))
                 ($itemValue (eval (getItemPrice $itemName $planet)))
             ) (+ $itemValue $restValue))
            $restValue
         ))
 ))


(= (evaluateState $contexts $money) (
     let* (
        ($planet (getPlanetFromContexts $contexts))
        ($inventoryValue (getInventoryValue $contexts $planet))
        ($_ (println! (Evaluating state at $planet with inventory: $inventoryValue money: $money)))
     ) (+ $inventoryValue $money)
 ))

(= (updateBeta $alpha $beta $reward) (
    if (== $reward 0) 
        ((+ 1 $alpha) (+ 1 $beta))
        (if (> $reward 0)
            ((+ $alpha $reward) $beta)
            ($alpha (+ $beta (abs-math $reward)))
        )
))

(= (updateSTV $rule ($strength $confidence)) (
    let* (
        ((: Rule $id $ttv (STV $s $c) $comp $impl) $rule)
    ) (: Rule $id $ttv (STV $strength $confidence) $comp $impl)
))

(= (updateRule $selectedRule $reward) (
    let* (
        ((STV $s $c) (extractRule STV $selectedRule))
        (($alpha $beta) (eval (stvToBeta ($s $c))))
        ($_ (println! (Rule STV: $alpha $beta)))
        (($newAlpha $newBeta) (updateBeta $alpha $beta $reward))
        (($newStrength $newConfidence) (eval (betaToSTV ($newAlpha $newBeta))))
        ($_ (println! (Updated $newStrength $newConfidence)))
        ($newRule (updateSTV $selectedRule ($newStrength $newConfidence)))
    ) $newRule
))

;; Update Atoms in a space
(= (updateAtom $oatom $natom $space) (let $_ (remove-atom $space $oatom) (add-atom $space $natom)))