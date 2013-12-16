;;;; defmodule.lisp

(restas:define-policy datastore
  (:interface-package #:bash-clone.policy.datastore)
  (:interface-method-template "DATASTORE-~A")
  (:internal-package #:bash-clone.datastore)

  (define-method init ()
    "Initiates the datastore")

  (define-method find-user (username)
    "Finds the user by username")

  (define-method get-user (id)
    "Gets user by id")

  (define-method auth-user (username password)
    "Checks if a user exists and has the supplied password")

  (define-method register-user (username password)
    "Registers a new user")

  (define-method post-quote (body username)
    "Creates a new quote")

  (define-method get-quote (id)
    "Gets quote by id")

  (define-method get-quotes (offset limit)
    "Gets quotes")

  (define-method count-quotes ()
    "Gets the number of quotes"))

(restas:define-module #:bash-clone
  (:use #:cl #:restas #:bash-clone.datastore)
  (:export #:start-bash-clone))

(defpackage #:bash-clone.pg-datastore
  (:use #:cl #:postmodern #:bash-clone.policy.datastore)
  (:export #:pg-datastore))

(sexml:with-compiletime-active-layers
    (sexml:standard-sexml sexml:xml-doctype)
  (sexml:support-dtd
   (merge-pathnames "html5.dtd" (asdf:system-source-directory "sexml"))
   :<))

(in-package #:bash-clone)

(defparameter *static-directory*
  (merge-pathnames #P"static/" bash-clone-config:*base-directory*))
