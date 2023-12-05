(define (problem hri_lab)
    (:domain robotGreeter)
    (:objects 
        r - robot
        v1 v2 v3 v4 v5 - visitor
        m1 m2 m3 - labmember
        ent office1 office2 office3 waitingRm - location

    )

    (:init
        ;initial locations of entities
        (at v1 ent)
        (at v2 ent)
        (at v3 ent)
        (at v4 ent)
        (at v5 ent)
        (at r ent)

        ; interaction with each visitor is not complete
        (not(done v1))
        (not(done v2))
        (not(done v3))
        (not(done v4))
        (not(done v5))

        ;inital conditions of visitors
        (not(greeted v1))
        (not(following v1))
        (not(knownIntention v1))
        (not(greeted v2))
        (not(following v2))
        (not(knownIntention v2))
        (not(greeted v3))
        (not(following v3))
        (not(knownIntention v3))
        (not(greeted v4))
        (not(following v4))
        (not(knownIntention v4))
        (not(greeted v5))
        (not(following v5))
        (not(knownIntention v5))

        ;locations are not searched initially
        (not(searched ent))
        (not(searched office1))
        (not(searched office2))
        (not(searched office3))
        (not(searched waitingRm))
        (not(searchDone r))

        ;offices are meeting rooms
        (office office1)
        (office office2)
        (office office3)

        ; visitors are not satisfied initially
        (not(satisfied v1))
        (not(satisfied v2))
        (not(satisfied v3))
        (not(satisfied v4))
        (not(satisfied v5))

        ; initial states for robot specific predicates
        (not(absent))
        (not(helping))
        (not(reset v1))
        (not(reset v2))
        (not(reset v3))
        (not(reset v4))
        (not(reset v5))
        (not(resetswitch))


    )

    ; Goal is for all visitors to be satisfied
    (:goal
        (and
            (satisfied v1)
            (satisfied v2)
            (satisfied v3)
            (satisfied v4)
            (satisfied v5)

        )
    )

    
)