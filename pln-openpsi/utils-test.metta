!(import! &self utils)

!(isMember (1 2 3 4) 10)
!(sum (1 2 3 4))
!(countSimilar (1 2 8 4) (2 4 6 8)) 
!(areSimilar (1 3 2) (2 4 3))
!(areSimilar (One Two Three) (Three Two One))

!(bind! &testSpace (new-space))
!(add-reduct &testSpace (superpose (
    (: TestAtom 1)
    (: TestAtom 2)
    (: TestAtom 3)
)))
!(println! (Before Clear: (collapse (get-atoms &testSpace))))
!(clearSpace &testSpace)
!(println! (After Clear: (collapse (get-atoms &testSpace))))