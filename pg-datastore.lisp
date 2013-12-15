;;;; pg-datastore.lisp

(in-package #:bash-clone.pg-datastore)

(defclass pg-datastore ()
  ((connection-spec :initarg :connection-spec
                    :accessor connection-spec)))

(defclass users ()
  ((id :col-type serial :reader user-id)
   (name :col-type string :reader user-name :initarg :name)
   (password :col-type string :reader user-password :initarg :password)
   (salt :col-type string :reader user-salt :initarg :salt))
  (:metaclass dao-class)
  (:keys id))

(defclass quotes ()
  ((id :col-type serial :reader quote-id)
   (body :col-type string :reader quote-body :initarg :body)
   (author-id :col-type integer :reader author-id :initarg :author-id))
  (:metaclass dao-class)
  (:keys id))

(deftable quotes
  (!dao-def)
  (!foreign 'users 'author-id 'id))

(defmethod datastore-init ((datastore pg-datastore))
  (with-connection (connection-spec datastore)
    (unless (table-exists-p 'users)
      (execute (dao-table-definition 'users)))
    (unless (table-exists-p 'quotes)
      (execute (dao-table-definition 'quotes)))))

(defun hash-password (password)
  (multiple-value-bind (hash salt)
      (ironclad:pbkdf2-hash-password (babel:string-to-octets password))
    (list :password-hash (ironclad:byte-array-to-hex-string hash)
          :salt (ironclad:byte-array-to-hex-string salt))))

(defun check-password (password password-hash salt)
  (let ((hash (ironclad:pbkdf2-hash-password
               (babel:string-to-octets password)
               :salt (ironclad:hex-string-to-byte-array salt))))
    (string= (ironclad:byte-array-to-hex-string hash)
             password-hash)))

(defmethod datastore-find-user ((datastore pg-datastore) username)
  (with-connection (connection-spec datastore)
    (query (:select :* :from 'users :where (:= 'name username))
           :plist)))

(defmethod datastore-auth-user ((datastore pg-datastore) username password)
  (with-connection (connection-spec datastore)
    (let ((user (datastore-find-user datastore username)))
      (when (and user
                 (check-password password
                                 (user-password user)
                                 (user-salt user)))
        username))))

(defmethod datastore-register-user ((datastore pg-datastore) username password)
  (with-connection (connection-spec datastore)
    (unless (datastore-find-user datastore username)
      (let ((password-salt (hash-password password)))
        (when (save-dao (make-instance 'users
                                       :name username
                                       :password (getf password-salt :password-hash)
                                       :salt (getf password-salt :salt)))
          username)))))

(defmethod datastore-post-quote ((datastore pg-datastore) body username)
  (with-connection (connection-spec datastore)
    (let* ((user (datastore-find-user datastore username))
           (q (make-instance 'quotes :body body :author-id (user-id user))))
      (when (save-dao q)
        (quote-id q)))))

(defmethod datastore-get-quotes ((datastore pg-datastore) offset limit)
  (with-connection (connection-spec datastore)
    (query-dao 'quotes
               (:limit (:select (:*) :from 'quotes) limit offset))))

(defmethod datastore-count-quotes ((datastore pg-datastore))
  (with-connection (connection-spec datastore)
    (query (:select (:count *) :from 'quotes)
           :single)))
