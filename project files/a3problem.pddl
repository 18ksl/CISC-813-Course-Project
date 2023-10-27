(define (problem hri_lab)
    (:domain robotGreeter)
    (:objects 
        r - robot
        v1 v2 - visitor
        m1 m2 m3 - labmember
        ent office1 office2 office3 rbtarea mcparea mecharea - location

    )

    (:init
        ;initial locations of entities
        (at v1 ent)
        (at v2 ent)
        (at r ent)


        ;corresponding offices of lab members
        (office m1 office1)
        (office m2 office2)
        (office m3 office3)

        ;setup visitable locations
        (visitable rbtarea)
        (visitable mcparea)
        (visitable mecharea)

        ;inital conditions of visitors
        (not(greeted v1))
        (not(following v1))
        (not(knownIntention v1))
        (not(bye v1))

        (not(greeted v2))
        (not(following v2))
        (not(knownIntention v2))
        (not(bye v2))

        ;all lab members' availability is unknown
        (not(knownAvailability m1))
        (not(knownAvailability m2))
        (not(knownAvailability m3))

        ;visitor is not satisified
        (not(satisfied v1))
        (not(satisfied v2))

        ;(= (total-cost) 0)
    )

    ; Goal to get to the end of the street
    (:goal
        (and
            (satisfied v1)
            (satisfied v2)
            ;(done v r)
        )
    )

    ;(:metric minimize
        ;(total-cost)
    ;)
)