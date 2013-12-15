;;;; util.lisp

(in-package #:bash-clone)

(defun logged-in-p ()
  (hunchentoot:session-value :username))

(defun s-user-logout (&optional (redirect-route 'home))
  (setf (hunchentoot:session-value :username) nil)
  (redirect redirect-route))

(defun s-user-login (username &option (redirect-route 'home))
  (hunchentoot:start-session)
  (setf (hunchentoot:session-value :username) username)
  (redirect redirect-route))
