;;;; desugarify.lisp

(defpackage #:desugarify
  (:use #:cl))

(in-package #:desugarify)

(defparameter *desugar-func* (list))

(defun arrow-checker (form)
  (if (and (listp form) (eql (second form) '=>)) t nil))

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
  `(progn ,@(loop :for form :in forms :collect (desugar form))))

;; ($ (funcall (funcall (a => (() => a)) 3)))
;; => 3
