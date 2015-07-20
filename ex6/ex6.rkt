#lang racket

(require "../mit-scheme-compatible.rkt")
(require racket/include)

(include "../teval.rkt")

(define (calc x)
  (let ((result (tool-eval x glb-env)))
    (if (not (void? result))
        (tool-print result))))

(define (error arg1 . rest-args)
  (display arg1)
  (for-each (lambda (x) (display " ") (display x)) (list->mlist rest-args))
  (newline))

;; exercise 2

(calc '(define-class <vector> <object> xcor ycor))

(calc '(define-method + ((v1 <vector>) (v2 <vector>))
         (make <vector>
               (xcor (+ (get-slot v1 'xcor) (get-slot v2 'xcor)))
               (ycor (+ (get-slot v1 'ycor) (get-slot v2 'ycor))))))

(calc '(define-method * ((v1 <vector>) (v2 <vector>))
         (+ (* (get-slot v1 'xcor) (get-slot v2 'xcor))
            (* (get-slot v1 'ycor) (get-slot v2 'ycor)))))

(calc '(define-method * ((v <vector>) (n <number>))
         (make <vector>
               (xcor (* (get-slot v 'xcor) n))
               (ycor (* (get-slot v 'ycor) n)))))

(calc '(define-method * ((n <number>) (v <vector>)) (* v n)))

(calc '(define-generic-function length))

(calc '(define-method length ((v <vector>))
         (sqrt (+ (square (get-slot v 'xcor))
                  (square (get-slot v 'ycor))))))

(calc '(define-method length ((n <number>)) (abs n)))


;; exercise 5

(calc '(define-method print ((v <vector>))
         (print (cons (get-slot v 'xcor) (get-slot v 'ycor)))))


;; test

(calc '(define v1 (make <vector> (xcor 3) (ycor 4))))
(calc '(define v2 (make <vector> (xcor -4) (ycor 3))))

(calc '(+ v1 v2))
(calc '(* v1 v2))
(calc '(* 5 v1))
(calc '(* v2 5))
(calc '(+ 10 v1))
(calc '(length -9))
(calc '(length v1))

(driver-loop)   ;you can try more tests
