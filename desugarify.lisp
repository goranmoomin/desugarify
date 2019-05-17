;;;; desugarify.lisp

(defpackage :desugarify
  (:use :cl
        :trivia)
  (:export :$))

(in-package :desugarify)

(defparameter *desugar-func* (list))

(defun arrow-checker (form)
  (match form
    ((list _ (guard => (equal (symbol-name =>) "=>")) _) t)
    (otherwise nil)))

(defun desugar-arrow (form)
  (when (and (first form) (atom (first form)))
    (setf (first form) (list (first form))))
  `(lambda ,(first form)
     ,(third form)))

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
