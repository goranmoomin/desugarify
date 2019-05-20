;;;; desugarify.lisp

(defpackage :desugarify
  (:use :cl
        :trivia)
  (:export :$))

(in-package :desugarify)

(defparameter *desugar-func* (list))

(defun arrow-checker (form)
  (match form
    ((list _ (and (symbol) (guard => (equal (symbol-name =>) "=>"))) _) t)
    (otherwise nil)))

(defun desugar-arrow (form)
  (match form
    ((list (and (list) args) _ return-value) `(lambda ,args ,return-value))
    ((list (and (symbol) arg) _ return-value) `(lambda (,arg) ,return-value))))

(push (cons #'arrow-checker #'desugar-arrow) *desugar-func*)

(defun desugar (forms)
  (loop :for form :in forms
        :if (atom form)
          :collect form
        :else
          :collect (desugar
                    (or (loop :for funcs :in *desugar-func*
                              :for checker := (car funcs)
                              :for desugarer := (cdr funcs)
                              :if (funcall checker form)
                                :return (funcall desugarer form))
                        form))))

(defmacro $ (&rest forms)
  `(progn ,@(desugar forms)))

;; ($ (funcall (funcall (a => (() => a)) 3)))
;; => 3
;; ($ (a => a))
;; => #<Anonymous Function #x3020013B0FDF>
