!(register-module! ../../agent-psi)
!(import! &self agent-psi:monster-combat:util)
!(import! &self agent-psi:utils:math)
!(import! &self agent-psi:utils:utils)
!(import! &self agent-psi:agent-utils)

(= (game-loop $context $goal $ruleSpace) (
    let* (
        ($applicableGoals (match-goal $goal $ruleSpace))
        ($applicableRules (match-contexts $applicableGoals $context $ruleSpace))
        ($_ (println! ("Applicable rules: " $applicableRules)))
        (($chosenActionId $score) (thompson-sample $applicableRules $ruleSpace))
        ($result (perform-action $chosenActionId $context $ruleSpace))
        ($_ (println! (# $chosenActionId was chosen and executed and resulted in $result)))
        ($updatedRule (update-rule $chosenActionId $result $ruleSpace))
    ) ()
))

!(bind! &rules (new-space))
!(addRules2 &rules)

(= (get-random-context) (
    let* (
        ($random (getRandomInt 1 3))
    ) (if (== $random 1)
        ((Position CLOSE_RANGE))
        (if (== $random 2)
            ((Position MID_RANGE))
            ((Position LONG_RANGE))
        )
)))

(= (run $iter) (
    if (== $iter 0)
        ()
        (let* (
            ($context (get-random-context))
            ($_ (println! (--- Iteration  $iter with context $context  ---)))
            ($_ (game-loop $context (HIT) &rules))
            ($_ (println! (--- After iteration $iter ---)))
        ) (run (- $iter 1))
    )
))

!(run 10)
!(get-atoms &rules)