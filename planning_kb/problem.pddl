(define (problem tutor-ies-designtime-1)
(:domain tutor-ies-designtime)
(:objects 

)

(:init

(follows skills-extraction-select-step onthology-development-step)
(follows testing-development-step onthology-development-step)
(follows training-impact-development-step onthology-development-step)

##INITIAL-STATE##

(= (total-cost) 0)

)

(:goal
(and
(completed)
))

(:metric minimize (total-cost))

)

