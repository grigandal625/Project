(define (domain tutor-ies-designtime)
(:requirements :typing :adl :action-costs)
(:types 
    developed-component - object
    development-step - developed-component
    ontology skills-extractor - developed-component
    )

(:constants 
 psycho-config-step group-config-step timetables-development-step competences-development-step onthology-development-step training-impact-development-step - development-step
)

(:predicates 
    (finished ?s - developed-component)
    (finished-in-current-session ?s - developed-component)
    (follows ?s1 - development-step ?s2 - development-step)
    (completed)
)

(:functions
    (total-cost) - number
)

(:action execute-development-step
    :parameters (?step - development-step)
    :precondition (and (not (finished ?step))
               (forall (?pstep - development-step)
                   (imply (follows ?step ?pstep)
                      (and (not (finished-in-current-session ?pstep)) (finished ?pstep)))))
    :effect (and (finished ?step) (finished-in-current-session ?step) (increase (total-cost) 1))
)

(:action execute-development-step-future
    :parameters (?step - development-step)
    :precondition (and (not (finished ?step))
               (forall (?pstep - development-step)
                   (imply (follows ?step ?pstep)
                      (finished ?pstep))))
    :effect (and (finished ?step) (finished-in-current-session ?step) (increase (total-cost) 2))
)

(:action int-finalize-development
    :parameters ()
    :precondition (forall (?comp - developed-component) (finished ?comp))
    :effect (completed)
)

)

