;;; -*- mode: scheme; -*- vim: ft=scheme
;;; a set of packages related to vim plugins

(define-module (nya licenses)
							 #:export (none))

(define license (@@ (guix licenses) license))

(define* (none uri #:optional (comment ""))
				 "Return a nonfree license for packages which have no clear license, with a URI pointing to the package."
				 (license "None"
									uri
									(string-append
										"This is a nonfree license. This package does not have a clear license, check the URI for more information. "
										comment)))
