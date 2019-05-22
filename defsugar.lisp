;;;; defsugar.lisp

(defpackage :desugarify.defsugar
  (:use :cl :desugarify :trivia)
  (:export
   :defsugar
   :use-sugar))

(in-package :desugarify.defsugar)

(defmacro defsugar (name &rest rules)
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     (defun ,name (form)
       (match form
         ,@rules
         (otherwise nil)))))

(defmacro use-sugar (name)
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     (push (symbol-function ',name) *desugar-func*)))

