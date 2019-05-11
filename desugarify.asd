;;;; desugarify.asd

(asdf:defsystem #:desugarify
  :description "Framework to define syntax sugar and desugar sugared code."
  :version "0.0.1"
  :depends-on (#:alexandria
               #:quickutil)
  :serial t
  :components ((:file "desugarify")))
