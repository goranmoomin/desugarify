;;;; sugars/arrow-func.lisp

(defpackage :desugarify.arrow-func
  (:use :cl :trivia :desugarify.defsugar)
  (:export
   :arrow-func))

(in-package :desugarify.arrow-func)

(defsugar arrow-func
  ((list (and (list) args)
         (and (symbol) (guard => (string= => "=>")))
         return-value) `(lambda ,args ,return-value))
  ((list (and (symbol) arg)
         (and (symbol) (guard => (string= => "=>")))
         return-value) `(lambda (,arg) ,return-value)))
