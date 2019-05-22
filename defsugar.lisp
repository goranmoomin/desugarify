;;;; defsugar.lisp

(defpackage :desugarify.defsugar
  (:use :cl :desugarify :trivia)
  (:export
   :defsugar
   :use-sugar))

(in-package :desugarify.defsugar)

(defmacro defsugar (name &rest rules)
  `(defun ,name (form)
     (match form
       ,@rules
       (otherwise nil))))

(defun use-sugar (name)
  (push (symbol-function name) *desugar-func*))
