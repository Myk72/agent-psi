(= (getPlanetFromContexts $contexts) (
    let* (
        (($head $tail) (decons-atom $contexts))
        ($contextType (index-atom $head 0))
        ($contextValue (index-atom $head 1))
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
                    ($cost (getTravelCost $source $destination))
                ) (if (> $cost $money)
                    False
                    True
                )
            ))

            (SELL (
                let* (
                    ($item (index-atom $ruleActions 1))
                    ($currItem (getItem $contexts))
                ) (if (== $item $currItem)
                    True
                    False
                )
            ))

            (BUY (
                let* (
                    ($item (getItem $ruleGoal))
                    ($itemPrice (getItemPrice $item $currPlanet))
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
            ($contextType (index-atom $head 0))
            ($contextValue (index-atom $head 1))
            ($rest (updatePlanet $tail $planet))
        ) (if (== $contextType PLANET)
            (cons-atom (PLANET $planet) $rest)
            (cons-atom $head $rest)
        )))
)

(= (addItem $contexts $item) (
    if (== $contexts ())
        (cons-atom (HAS $item) ())
        (let* (
            (($head $tail) (decons-atom $contexts))
            ($contextType (index-atom $head 0))
            ($contextValue (index-atom $head 1))
            ($rest (addItem $tail $item))
        ) (if (== $contextType HAS)
            $rest
            (cons-atom $head $rest)
        ))
))

(= (removeItem $contexts $item) (
    if (== $contexts ())
        ()
        (let* (
            (($head $tail) (decons-atom $contexts))
            ($contextType (index-atom $head 0))
            ($contextValue (index-atom $head 1))
            ($rest (removeItem $tail $item))
        ) (if (== $contextValue $item)
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
        ($cost (getTravelCost $source $destination))
        ($newContext (updatePlanet $contexts $destination)) 
        ($newMoney (- $money $cost))
    ) ($newContext $newMoney)
))

(= (applySell $rule $contexts $money) (
    let* (
        ($item (getItem $contexts))
        ($planet (getPlanetFromContexts $contexts))
        ($newContext (removeItem $contexts $item))
        ($newMoney (+ $money (getItemPrice $item $planet)))
    ) ($newContext $newMoney)
))

(= (applyBuy $rule $contexts $money) (
    let* (
        ($ruleGoal (extractRule GoalValues $rule))
        ($item (getItem $ruleGoal))
        ($planet (getPlanetFromContexts $ruleGoal))
        ($itemPrice (getItemPrice $item $planet))
        ($newContext (addItem $contexts $item))
        ($newMoney (- $money $itemPrice))
    ) ($newContext $newMoney)
))

(= (applyRule $rule $contexts $money) (
    let* (
        ($ruleActions (extractRule Actions $rule))
        ($ruleAction (index-atom $ruleActions 0))
    ) (case $ruleAction (
        (TRAVEL (applyTravel $rule $contexts $money))
        (SELL (applySell $rule $contexts $money))
        (BUY (applyBuy $rule $contexts $money))
    ))
))

(= (getItem $contexts) (
    if (== $contexts ())
        ()
        (let* (
            (($head $tail) (decons-atom $contexts))
            ($contextType (index-atom $head 0))
            ($itemName (index-atom $head 1))
        ) (if (== $contextType HAS)
            $itemName
            (getItem $tail)
        ))
))

(= (evaluateState $contexts $money) (
    let* (
        ($item (getItem $contexts))
        ($itemValue (getAvgPrice $item))
    ) (+ $itemValue $money)
))

(= (updateBeta $alpha $beta $reward) (
    if (== $reward 0) 
        ((+ 1 $alpha) (+ 1 $beta))
        (if (> $reward 0)
            ((+ $alpha $reward) $beta)
            ($alpha (+ $beta $reward))
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
        (($alpha $beta) (stvToBeta ($s $c)))
        ($_ (println! (Rule STV: $alpha $beta)))
        (($newAlpha $newBeta) (updateBeta $alpha $beta $reward))
        (($newStrength $newConfidence) (betaToSTV ($newAlpha $newBeta)))
        ($_ (println! (Updated $newStrength $newConfidence)))
        ($newRule (updateSTV $selectedRule ($newStrength $newConfidence)))
    ) $newRule
))

;; Update Atoms in a space
; (: updateAtom (-> Grounded Atom Atom (->)))
(= (updateAtom $oatom $natom $space) (let $_ (remove-atom $space $oatom) (add-atom $space $natom)))