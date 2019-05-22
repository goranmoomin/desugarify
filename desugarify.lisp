;;;; desugarify.lisp

(defpackage :desugarify
  (:use :cl :trivia)
  (:export
   :$
   :*desugar-func*))

(in-package :desugarify)

(defparameter *desugar-func* (list))

(defun desugar (forms)
  (loop :for form :in forms
        :if (atom form)
          :collect form
        :else
          :collect (desugar
                    (loop :for sugar :in *desugar-func*
                          :return (or (funcall sugar form) form)))))

(defmacro $ (&rest forms)
  `(progn ,@(desugar forms)))

;; ($ (funcall (funcall (a => (() => a)) 3)))
;; => 3
;; ($ (a => a))
;; => #<Anonymous Function #x3020013B0FDF>
