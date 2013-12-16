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

(defun template/user/login ()
  (<:form :method "post" :action (genurl 'user/login/post)
          (<:label :for "username"
                   (<:span "Username: ")
                   (<:input :type "text" :id "username" :name "username"))
          (<:label :for "password"
                   (<:span "Password: ")
                   (<:input :type "password" :id "password" :name "password"))
          (<:input :type "submit" :value "Login")))

(defun template/user/register ()
  (<:form :method "post" :action (genurl 'user/register/post)
          (<:label :for "username"
                   (<:span "Username: ")
                   (<:input :type "text" :id "username" :name "username"))
          (<:label :for "password"
                   (<:span "Password: ")
                   (<:input :type "password" :id "password" :name "password"))
          (<:input :type "submit" :value "Register")))

(defun template/quote/add ()
  (<:form :method "post" :action (genurl 'quote/add/post)
          (<:label :for "body"
                   (<:span "Quote: ")
                   (<:textarea :id "body" :name "body"))))

(defun template/quote (q user)
  (<:div :class "quote"
         (<:div :class "body"
                (quote-body q))
         (<:div :class "author"
                (user-name user))))

(defun template/quotes (quotes)
  (<:div :class "quotes"
         (mapcar #'(lambda (q)
                     (<:div :class "quote" (quote-body q)))
                 quotes)))
