#!/usr/bin/env racket
#lang racket

(require "../mit-scheme-compatible.rkt")
(require racket/include)

(include "../teval.rkt")
(include "mod-for-ex8.rkt")
(driver-loop)

;; Example

;(define-class <vector> <object> xcor ycor)
;(define V (make <vector> (xcor 21) (ycor 31)))
;(xcor V) => 21
;(ycor V) => 31