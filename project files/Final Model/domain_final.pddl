(define (domain robotGreeter)

    (:requirements :action-costs :conditional-effects :negative-preconditions :equality :adl :non-deterministic)

    (:types
        locateable location - object
        humans robot - locateable
        visitor labmember - humans
        searchable notsearchable - location
    )

    (:predicates
        (at ?obj - locateable ?loc - location) ; locating predicate
        (greeted ?v - visitor) ; visitor has been greeted
        (desiredMeet ?v - visitor ?m - labmember) ; visitor wants to meet with a lab member
        (following ?v - humans) ; visitor is following robot
        (knownIntention ?v - visitor) ; robot knows the intention of the visitor
        (satisfied ?v - visitor) ; visitor has achieved goal
        (searched ?loc - location) ; location has been searched
        (searchDone ?r - robot) ; search is complete
        (office ?loc - location) ; if the location is an office
        (absent) ; lab member cannot be found
        (helping) ; the robot is helping someone
        (done ?v - visitor) ; leave person alone
        (reset ?v - visitor) ; robot should forget conditions and help next visitor
        (resetswitch) ;switch between reset actions
        (busy ?m - labmember) ; lab member is in a meeting
        (lastmember ?m - labmember) ; holds the member who was last interacted with
        (resetmember ?m - labmember) ; holds the member who was interacted with before and who's availability should now be reset
        
        )

   
    (:action welcome ;first point of contact for visitor, robot greets visitor to space and starts interaction

        :parameters (?v - visitor ?r - robot ?ent - location)

        :precondition (and
                (not(greeted ?v))
                (at ?v ?ent)
                (at ?r ?ent)
                (not(helping))
                (not(done ?v))
        )

        :effect (and
                (greeted ?v)
                (helping)
        )
    )

    (:action meeting_who ; robot asks who visitor wants to meet

        :parameters (?v - visitor ?r - robot ?ent - location)

        :precondition (and
                (greeted ?v)
                (at ?v ?ent)
                (at ?r ?ent)
                (not(knownIntention ?v))
                (not(done ?v))
        )

        :effect (and ;visitor wants to meet with one of the three lab members
                (oneof
                        (desiredMeet ?v m1)
                        (desiredMeet ?v m2)
                        (desiredMeet ?v m3)
                )
                (knownIntention ?v)
        )
    )

    (:action request_follow_visitor ; robot tells visitor to follow them

        :parameters (?v - visitor ?r - robot ?ent - location)

        :precondition (and
                (greeted ?v)
                (at ?v ?ent)
                (at ?r ?ent)
                (knownIntention ?v)
                (not(done ?v))
        )

        :effect (and
                (following ?v)
                (not(at ?v ?ent))
        )
    )

    (:action memberBusy ; member is busy meeting previous visitor and is not available for a meeting

        :parameters (?v - visitor ?m - labmember ?r - robot ?ent - location)

        :precondition (and
                (greeted ?v)
                (at ?v ?ent)
                (at ?r ?ent)
                (knownIntention ?v)
                (desiredMeet ?v ?m)
                (not(done ?v))
                (busy ?m)
        )

        :effect (and ; assume interaction is complete which will force visitor to return later
                (done ?v)
                (satisfied ?v)
        )
    )

    (:action moveRobot ; robot brings visitor to another location

        :parameters (?r - robot ?loc1 ?loc2 - location)

        :precondition (and
                (at ?r ?loc1)
                
        )

        :effect (and
                (at ?r ?loc2)
                (not(at ?r ?loc1))
        )
    )


    (:action dropWaiting ; drop visitor at waiting room, requirement to begin search

        :parameters (?v - visitor ?r - robot)

        :precondition (and
                (following ?v)
                (at ?r waitingRm)
                (not(done ?v))
        )

        :effect (and
                (at ?v waitingRm)
                (not(following ?v))
        )
    )

    (:action search ; robot checks to see if lab member is at location

        :parameters (?v - visitor ?r - robot ?m - labmember ?loc - location)

        :precondition (and
                (at ?v waitingRm)
                (at ?r ?loc)
                (desiredMeet ?v ?m)
                (not(searched ?loc))
                (not(searchDone ?r))
                (not(done ?v))
                
        )

        :effect (and
                (oneof
                    (and (at ?m ?loc)(searchDone ?r)(searched ?loc))
                    (searched ?loc)
                )
        )
    )

    (:action request_follow_member ; robot tells lab member to follow them

        :parameters (?v - visitor ?m - labmember ?r - robot ?loc - location)

        :precondition (and
                (at ?m ?loc)
                (at ?r ?loc)
                (searched ?loc)
                (searchDone ?r)
                (at ?v waitingRm)
                (desiredMeet ?v ?m)
                (not(done ?v))
        )

        :effect (and
                (following ?m)
                (not(at ?m ?loc))
                
        )
    )

    (:action memberAbsent ; robot has checked all locations and has not found lab member

        :parameters ()

        :precondition (and
                (searched office1)
                (searched office2)
                (searched office3)
                (searched ent)
                (searched waitingRm)
                (not(searchDone r))
        )

        :effect (and
                (searchDone r)
                (absent)
        )
    )

    (:action Meeting ; robot has found lab member and is organizing meeting

        :parameters (?v - visitor ?r - robot ?m - labmember ?loc - location)

        :precondition (and
                (searchDone ?r)
                (following ?v)
                (following ?m)
                (desiredMeet ?v ?m)
                (at ?r ?loc)
                (office ?loc)
                (not(done ?v))
                
        )

        :effect (and
                (at ?v ?loc)
                (at ?m ?loc)
                (not(following ?v))
                (not(following ?m))
                (satisfied ?v)
                (done ?v)
                (not(helping))
                (reset ?v)
                (busy ?m)
                (lastmember ?m)
        )
    )

    (:action CannotMeet ; robot tells visitor the lab member is absent and a meeting cannot occur

        :parameters (?v - visitor ?m - labmember ?r - robot ?loc - location)

        :precondition (and
                (searchDone ?r)
                (absent)
                (at ?v ?loc)
                (at ?r ?loc)
                (not(done ?v))
                (desiredMeet ?v ?m)
                
        )

        :effect (and
                (satisfied ?v)
                (not(absent))
                (done ?v)
                (not(helping))
                (reset ?v)
                (busy ?m)
                (lastmember ?m)

        )
    )
    (:action Reset ; robot resets searched conditions to begin next interaction

        :parameters (?v - visitor ?m - labmember)

        :precondition (and
                (reset ?v)
                (not(helping))
                (not(resetswitch))
                (desiredMeet ?v ?m)
                (lastmember ?m)
        )

        :effect (and
                (not(searched ent))
                (not(searched office1))
                (not(searched office2))
                (not(searched office3))
                (not(searched waitingRm))
                (not(searchDone r))
                (not(absent))
                (not(helping))
                (not(reset ?v))
                (resetswitch)
                (not(lastmember ?m))
                (resetmember ?m) ; stores knowledge of current lab member to know they are busy throughout next visitor interaction
                
        )
    )

    (:action Reset2 ; robot resets searched conditions to begin next interaction

        :parameters (?v - visitor ?m1 ?m2 - labmember)

        :precondition (and
                (reset ?v)
                (not(helping))
                (resetswitch)
                (desiredMeet ?v ?m2)
                (lastmember ?m2)
                (resetmember ?m1)
        )

        :effect (and
                (not(searched ent))
                (not(searched office1))
                (not(searched office2))
                (not(searched office3))
                (not(searched waitingRm))
                (not(searchDone r))
                (not(absent))
                (not(helping))
                (not(reset ?v))
                (resetswitch)
                (not(lastmember ?m2))
                (resetmember ?m2) 
                (not(resetmember ?m1))
                (not(busy ?m1)) ; lab member from previous visitor interaction is no longer busy
        )
    )



)