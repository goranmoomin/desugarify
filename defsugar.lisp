;;;; defsugar.lisp

(defpackage :desugarify.defsugar
  (:use :cl)
  (:use :desugarify)
  (:import-from :trivia :match))

(in-package :desugarify.defsugar)

;; (defmacro defsugar)
;; (defun macro-expander (forms))
