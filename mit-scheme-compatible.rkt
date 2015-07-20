#lang racket

(require racket/mpair)

(require (only-in r5rs
                  quote
                  quasiquote
                  [apply r5rs-apply]
                  [read r5rs-read]
                  [display r5rs-display]))
          
(provide (all-defined-out)
         mlist->list
         list->mlist
         quote
         quasiquote
         (rename-out [r5rs-apply apply]
                     [r5rs-read read]
                     [r5rs-display display]))

(define-syntax (if stx)
  (syntax-case stx ()
    [(_ condition true-expr false-expr)
     #'(cond [condition true-expr]
             [else false-expr])]
    [(_ condition true-expr)
     #'(cond [condition true-expr])]))

(define pair? mpair?)
(define cons mcons)
(define car mcar)
(define cdr mcdr)
(define set-car! set-mcar!)
(define set-cdr! set-mcdr!)

(define list? mlist?)
(define list mlist)
(define length mlength)
(define list-ref mlist-ref)
(define list-tail mlist-tail)
(define append mappend)
(define append! mappend!)
(define reverse mreverse)
(define reverse! mreverse!)
(define map mmap)
(define for-each mfor-each)
(define member mmember)
(define memv mmemv)
(define memq mmemq)
(define assoc massoc)
(define assv massv)
(define assq massq)

;; for caadr, cdadr, ...

(require racket/mpair (for-syntax racket/base))

(define-syntax (define-combinations stx)
  (syntax-case stx ()
    [(_ n) (integer? (syntax-e #'n))
     (let ([n (syntax-e #'n)])
       (define options (list (cons "a" #'car) (cons "d" #'cdr)))
       (define (add-options r)
         (apply append
                (map (λ (opt)
                       (map (λ (l) (cons (string-append (car opt) (car l))
                                         (list (cdr opt) (cdr l))))
                            r))
                     options)))
       (define combinations
         (cdddr
          (let loop ([n n] [r '(("" . x))])
            (if (zero? n) r (append r (loop (sub1 n) (add-options r)))))))
       (define (make-name combo)
         (let ([s (string->symbol (string-append "c" (car combo) "r"))])
           (datum->syntax stx s stx)))
       (with-syntax ([(body ...) (map cdr combinations)]
                     [(name ...) (map make-name combinations)])
         #'(begin (define (name x) body) ...)))]))

(define-combinations 4)

(define (displayln x)
  (r5rs-display x)
  (newline))

;(define (error arg1 . rest-args)
;  (r5rs-display arg1)
;  (for-each (lambda (x) (r5rs-display " ") (r5rs-display x)) (list->mlist rest-args))
;  (newline))