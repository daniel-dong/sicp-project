;;;;mod:

;;;; The entire evaluator code for the problem set is contained in the file teval.scm.
;;;; The two procedures here are the only ones that you should need to
;;;; modify for the problem set (except for the extra credit part).


(define (eval-define-class2 exp env)
  (let ((superclass (tool-eval (class-definition-superclass exp)
                               env)))
    (if (not (class? superclass))
        (error "Unrecognized superclass -- MAKE-CLASS >> "
               (class-definition-superclass exp))
        (let ((name (class-definition-name exp))
              (all-slots (collect-slots
                          (class-definition-slot-names exp)
                          superclass)))
          (let ((new-class
                 (make-class name superclass all-slots)))
            (define-variable! name new-class env)
            (for-each
             (lambda (slot)
               (tool-eval `(define-generic-function ,slot) env)
               (tool-eval `(define-method ,slot ((obj ,name)) (get-slot obj ',slot)) env))
             all-slots)             
            (list 'defined 'class: name))))))

(set! eval-define-class eval-define-class2)
