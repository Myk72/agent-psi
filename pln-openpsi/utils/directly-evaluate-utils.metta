(= (percepta-contains-all-facts $facts $percepta) (
    let* (
        ($perceptaFacts (extract-percepta-facts $percepta))
    ) (areSimilar $facts $perceptaFacts)
))

(= (filter-matching-perceptions $contextFacts $allPerceptions) (
    if (== $allPerceptions ())
        ()
        (let* (
            (($head $tail) (decons-atom $allPerceptions))
            ($isMatch (percepta-contains-all-facts $contextFacts $head))
            ($restMatches (filter-matching-perceptions $contextFacts $tail))
        ) (if $isMatch
            (cons-atom $head $restMatches)
            $restMatches))
))