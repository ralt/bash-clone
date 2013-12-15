;;;; templates.lisp

(in-package #:bash-clone)

(<:augment-with-doctype "html" "" :auto-emit-p t)

(defun html-frame (context)
  (<:html
   (<:head
    (<:meta :name "charset" :value "utf-8")
    (<:title "Bash clone"))
   (<:body
    (<:div :class "menu"
           (if (logged-in-p)
               (<:div :class "logged-in"
                      (<:a :href (genurl 'quote/add) "Add quote")
                      (<:a :href (genurl 'user/logout) "Logout"))
               (<:div :class "not-logged"
                      (<:a :href (genurl 'user/login) "Login")
                      (<:a :href (genurl 'user/register) "Register"))))
    (<:div :class "title"
           (<:h1 "Bash clone"))
    (<:div :class "body"
           (getf context :body)))))

(defun template/user/login ())

(defun template/user/register ())

(defun template/quote/add ())
