;;;; util.lisp

(in-package #:bash-clone)

(defun logged-in-p ()
  (hunchentoot:session-value :username))

(defun s-user-logout (&optional (redirect-route 'home))
  (setf (hunchentoot:session-value :username) nil)
  (redirect redirect-route))

(defun s-user-login (username &optional (redirect-route 'home))
  (hunchentoot:start-session)
  (setf (hunchentoot:session-value :username) username)
  (redirect redirect-route))

(defun validate-quote-id (id)
  (get-quote id))

(defun start-bash-clone (&key
                           (port 8080)
                           (datastore 'bash-clone.pg-datastore:pg-datastore)
                           (datastore-init nil))
  (setf *datastore* (apply #'make-instance datastore datastore-init))
  (init)
  (start '#:bash-clone :port port :render-method 'html-frame))
