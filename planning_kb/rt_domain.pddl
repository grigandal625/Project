(define (domain tutor-ies-runtimetime)
(:requirements :typing :adl :action-costs)
(:types 
    extractable-object - object
    skill knowldege psycho - extractable-object
  )

(:constants 
)

(:predicates 
    (pending ?eo - extractable-object)
    (low-knowledge-level ?k - knowldege)
    (pending-tutoring ?k - knowledge)
    (finished ?eo - extractable-object)
    (not-first-step ?eo - extractable-object)
    (completed)
)

(:functions
    (total-cost) - number
)

(:action extract-knowledge
    :parameters (?k - knowldege)
    :precondition (and (pending ?k) (not (not-first-step ?k)))
    :effect (and (not (pending ?k)) (finished ?k) (not-first-step ?k) (increase (total-cost) 1))
)

(:action future-extract-knowledge
    :parameters (?k - knowldege)
    :precondition (and (pending ?k) (not-first-step ?k))
    :effect (and (not (pending ?k)) (finished ?k) (increase (total-cost) 1))
)

(:action generate-tutor-strategy
    :parameters (?k - knowldege)
    :precondition (low-knowledge-level ?k)
    :effect (and (not (low-knowledge-level ?k)) (pending-tutoring ?k) (not-first-step ?k))
)

(:action release-tutor-strategy
    :parameters (?k - knowldege)
    :precondition (and (pending-tutoring ?k) (not (not-first-step ?k)))
    :effect (and (not (pending-tutoring ?k)) (pending ?k) (not-first-step ?k))
)

(:action future-release-tutor-strategy
    :parameters (?k - knowldege)
    :precondition (and (pending-tutoring ?k) (not-first-step ?k))
    :effect (and (not (pending-tutoring ?k)) (pending ?k))
)

(:action extract-skill
    :parameters (?s - skill)
    :precondition (pending ?s)
    :effect (and (not (pending ?s)) (finished ?s) (increase (total-cost) 1))
)

(:action extract-psycho
    :parameters (?p - psycho)
    :precondition (pending ?p)
    :effect (and (not (pending ?p)) (finished ?p) (increase (total-cost) 1))
)

(:action int-finalize
    :parameters ()
    :precondition (forall (?eo - extractable-object) (finished ?eo))
    :effect (completed)
)



)

