(: (visualizeRule (-> Expression Expression)))
(= (visualizeRule $rule) (
    let* (
        ($contexts (extractRule ContextValues $rule))
        ($actions (extractRule Action $rule))
        ($goals (extractRule GoalValues $rule))
        ($visual ($contexts => [ $actions ] => $goals))
    ) $visual
))
