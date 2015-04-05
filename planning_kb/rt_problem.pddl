(define (problem tutor-ies-runtimetime-1)
(:domain tutor-ies-runtimetime)
(:objects 
##OBJECTS##
)

(:init

##INITIAL-STATE##

(= (total-cost) 0)

)

(:goal
(and
(completed)
))

(:metric minimize (total-cost))

)

