;;;;mod:

;;;; The entire evaluator code for the problem set is contained in the file teval.scm.
;;;; The two procedures here are the only ones that you should need to
;;;; modify for the problem set (except for the extra credit part).


(define (eval-define-method2 exp env)
  (let* ((name (method-definition-generic-function exp))
         (gf (with-handlers
                 ((exn:fail?
                   (lambda (x)
                     (define-variable! name (make-generic-function name) glb-env)   ;** Choice 2
                     (tool-eval name env))))         
               (tool-eval name env))))
    (if (not (generic-function? gf))
        (error "Unrecognized generic function -- DEFINE-METHOD >> "
               (method-definition-generic-function exp))
        (let ((params (method-definition-parameters exp)))
          (install-method-in-generic-function
           gf
           (map (lambda (p) (paramlist-element-class p env))
                params)
           (make-procedure (make-lambda-expression
                            (map paramlist-element-name params)
                            (method-definition-body exp))
                           env))
          (list 'added 'method 'to 'generic 'function:
                (generic-function-name gf))))))

(set! eval-define-method eval-define-method2)