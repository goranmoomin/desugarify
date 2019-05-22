;;;; desugarify.asd

(asdf:defsystem :desugarify
  :description "Framework to define syntax sugar and desugar sugared code."
  :version "0.0.1"
  :depends-on (:alexandria
               :quickutil
               :trivia)
  :serial t
  :components ((:file "desugarify")
               (:file "defsugar")
               (:file "sugars/arrow-func")))
