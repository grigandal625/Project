(define (problem tutor-ies-designtime-1)
(:domain tutor-ies-designtime)
(:objects 

)

(:init

(follows training-impact-development-step skills-extraction-select-step)
(follows onthology-development-step competences-development-step)
(follows training-impact-development-step onthology-development-step)
(follows training-impact-development-step group-config-step)
(follows timetables-development-step training-impact-development-step)

##INITIAL-STATE##

(= (total-cost) 0)

)

(:goal
(and
(completed)
))

(:metric minimize (total-cost))

)

