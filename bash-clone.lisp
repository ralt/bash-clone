;;;; bash-clone.lisp

(in-package #:bash-clone)

;;; "bash-clone" goes here. Hacks and glory await!

(define-route home ("")
  (let ((offset (or (hunchentoot:get-parameter "offset") 0))
        (limit (or (hucnehtoot:get-parameter "limit") 10)))
    (list :body (get-quotes limit offset))))

(define-route user/logout ("user/logout")
  (s-user-logout))

(define-route user/login ("user/login")
  (list :body (template/user/login)))

(define-route user/login/post ("user/login" :method :post)
  (let ((user (auth-user (hunchentoot:post-parameter "username")
                         (hunchentoot:post-parameter "password"))))
    (if user
        (s-user-login user)
        (redirect 'user/login))))

(define-route user/register ("user/register")
  (list :body (template/user/register)))

(define-route user/register/post ("user/register" :method :post)
  (let ((user (register-user (hunchentoot:post-parameter "username")
                             (hunchentoot:post-parameter "password"))))
    (if user
        (s-user-login user)
        (redirect 'user/register))))

(define-route quote/add ("quote/add")
  (list :body (template/quote/add)))

(define-route quote/add/post ("quote/add" :method :post)
  (let ((q (post-quote (hunchentoot:post-parameter "body")
                       (hunchentoot:session-value :username))))
    (if q
        (redirect (concatenate 'string "quote/" q))
        (redirect 'quote/add))))
