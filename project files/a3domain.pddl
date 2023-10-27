(define (domain robotGreeter)

    (:requirements :action-costs :conditional-effects :negative-preconditions :equality :adl :non-deterministic)

    (:types
        locateable location - object
        visitor labmember robot - locateable
    )

    (:predicates
        (at ?obj - locateable ?loc - location) 
        (greeted ?v - visitor) ; visitor has been greeted
        (bye ?v - visitor)
        (desiredMeet ?v - visitor ?m - labmember) ; visitor wants to meet with that lab member
        (following ?v - visitor) ; visitor is following robot
        (office ?m - labmember ?off - location) ; lab member is in office
        (busy ?m - labmember) ; lab member availability
        (knownAvailability ?m - labmember) ; robot knows the availability of lab member
        (knownIntention ?v - visitor) ; robot knows the intention of the visitor
        (satisfied ?v - visitor) ; visitor has achieved goal
        (socialAction ?r - robot) ;social action is required
        (visit ?v - visitor ?loc - location); visitor wants to see location
        (visitable ?loc - location);is the location somewhere the person can visit?
        )

   
    (:action welcome ;first point of contact for visitor, robot greets visitor to space and starts interaction

        :parameters (?v - visitor ?r - robot ?ent - location)

        :precondition (and
                (not(greeted ?v))
                (at ?v ?ent)
                (at ?r ?ent)   
        )

        :effect (and
                (greeted ?v)
                
        )
    )

    (:action meeting_who ; robot asks who visitor wants to meet

        :parameters (?v - visitor ?r - robot ?ent - location)

        :precondition (and
                (greeted ?v)
                (at ?v ?ent)
                (at ?r ?ent)
                (not(knownIntention ?v))
        )

        :effect (and ;visitor wants to meet with one of the three lab members
                (oneof
                        (desiredMeet ?v m1)
                        (desiredMeet ?v m2)
                        (desiredMeet ?v m3)
                        (visit ?v rbtarea)
                        (visit ?v mcparea)
                        (visit ?v mecharea)
                )
                (knownIntention ?v)
                
        )
    )

    (:action request_follow ; robot tells visitor to follow them

        :parameters (?v - visitor ?r - robot ?ent - location)

        :precondition (and
                (greeted ?v)
                (at ?v ?ent)
                (at ?r ?ent)
                (knownIntention ?v)
        )

        :effect (and
                (following ?v)
                (not(at ?v ?ent))
                ;(satisfied ?v)
        )
    )

    (:action guideVisitor ; robot brings visitor to office of desired lab member 

        :parameters (?v - visitor ?r - robot ?m - labmember ?ent ?loc - location)

        :precondition (and
                ;(greeted ?v)
                (at ?r ?ent)
                (following ?v)
                (knownIntention ?v)
                (or
                        (and (desiredMeet ?v ?m)(office ?m ?loc))
                        (and (visit ?v ?loc)(visitable ?loc))
                )
                (not(socialAction ?r))
        )

        :effect (and
                ; (at ?r ?off)
                ; (not(at ?r ?ent))
                (when (and (desiredMeet ?v ?m)(office ?m ?loc)) 
                        (and
                                (forall (?loc - location)(when(office ?m ?loc)(and (at ?r ?loc)(not(at ?r ?ent)))))
                                (forall (?v - visitor)(when(following ?v)(and (not(at ?v ?ent)))))
                        )
                )
                ; when theres a visitor who wants to meet with someone, go to their office
                (when (and (visit ?v ?loc)(visitable ?loc))
                        (and
                                (forall (?v - visitor)(when(following ?v)(and (not(at ?v ?loc)))))
                                (at ?r ?loc)
                                (not(at ?r ?ent))
                        )
                )
                ;(satisfied ?v)
                
                
                        
        )
    )

    (:action checkAvailability ; robot checks to see if lab member is availabile for meeting

        :parameters (?v - visitor ?r - robot ?m - labmember ?off - location)

        :precondition (and
                (greeted ?v)
                (following ?v)
                (desiredMeet ?v ?m)
                (at ?r ?off)
                (office ?m ?off)
                (not(knownAvailability ?m))
                (knownIntention ?v)
        )

        :effect (and
                (oneof
                    (busy ?m)
                    (not(busy ?m))
                )
                (knownAvailability ?m)
        )
    )

    (:action dropoff ; robot drops visitor off at meeting

        :parameters (?v - visitor ?r - robot ?m - labmember ?loc - location)

        :precondition (and
                (greeted ?v)
                (following ?v)
                (knownIntention ?v)
                (or     (and    (desiredMeet ?v ?m)
                                (at ?r ?loc)
                                (office ?m ?loc)
                                (knownAvailability ?m)
                                (not(busy ?m))
                        )
                        (and
                                (visitable ?loc)
                                (visit ?v ?loc)
                                (at ?r ?loc)
                        )
                )
        )

        :effect (and
                        (when (visit ?v ?loc)
                                (and
                                        (at ?v ?loc)
                                        (not(following ?v))
                        
                                )
                        )
                        (when   (and 
                                        (desiredMeet ?v ?m)
                                        (office ?m ?loc)
                                )
                                (and
                                        (at ?v ?loc)
                                        (not(following ?v))
                                )
                
                        )
                        (socialAction ?r)
                        ;(satisfied ?v)
                
                
        )
    )

    (:action wait ; robot and visitor wait because lab member is busy 

        :parameters (?v - visitor ?r - robot ?m - labmember)

        :precondition (and
                (greeted ?v)
                (following ?v)
                (desiredMeet ?v ?m)
                (knownIntention ?v)
                (knownAvailability ?m)
                (busy ?m)
        )

        :effect (and
                (not(knownAvailability ?m)) ; resets robot not knowing availabilty and therefore must check again in future
        )
    )

    (:action goodbye ; robot ends interaction with visitor

        :parameters (?v - visitor ?r - robot ?m - labmember ?off ?loc - location)

        :precondition (and
                (at ?v ?off)
                (at ?r ?off)
                (or     (and    (desiredMeet ?v ?m)
                                (at ?r ?off)
                                (office ?m ?off)
                                (knownAvailability ?m)
                                (not(busy ?m))
                        )
                        (and
                                (visitable ?loc)
                                (visit ?v ?loc)
                                (at ?r ?loc)
                        )
                )
                (socialAction ?r)
        )

        :effect (and
                (bye ?v)
                (not(socialAction ?r))
                (satisfied ?v)
        )
    )

;     (:action reset
;         :parameters (?r - robot ?ent ?off - location ?v - visitor)
;         :precondition (and 
;                         (at ?r ?ent)
;                         (bye ?v)
                        
;         )
;         :effect (and 

;                         (oneof
;                                 (and    (at ?v ?ent)
;                                         (not (at ?v ?off))
;                                         (at ?r ?off)
;                                         (not (at ?r ?ent))

;                                         (not(greeted ?v))
;                                         (not(following ?v))
;                                         (not(knownIntention ?v))            
                                        
                                        
;                                         (not(satisfied ?v))
;                                         (not(bye ?v))
;                                         (when (visit ?v ?loc)
;                                                 (and
                                                        
                        
;                                                 )
;                                         )
;                                         (when   (and 
;                                                         (desiredMeet ?v ?m)
;                                                         (office ?m ?off)
;                                                 )
;                                                 (and
;                                                         (forall (?m - labmember)(and (not (busy ?m)) (not(desiredMeet ?v ?m))))
;                                                         (not(knownAvailability m1))
;                                                         (not(knownAvailability m2))
;                                                         (not(knownAvailability m3))
;                                                 )
                                
;                                         )
                                        
;                                 )
;                                 (satisfied ?v)
;                         )
;                 )
;     )
    

)