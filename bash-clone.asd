(defpackage #:bash-clone-config (:export #:*base-directory*))
(defparameter bash-clone-config:*base-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(asdf:defsystem #:bash-clone
  :serial t
  :description "An ugly bash.org clone"
  :author "Florian Margaine"
  :license "MIT License"
  :depends-on (:RESTAS :SEXML :POSTMODERN :IRONCLAD :BABEL)
  :components ((:file "defmodule")
               (:file "pg-datastore")
               (:file "util")
               (:file "templates")
               (:file "bash-clone")))
