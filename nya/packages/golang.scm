;;; -*- mode: scheme; -*- vim: ft=scheme
;;; golang package definitions

(define-module (nya packages golang)
							 #:use-module ((guix licenses) #:prefix license:)
							 #:use-module ((guix packages) #:select (package base32 origin))
							 #:use-module ((guix build-system go) #:select (go-build-system))
							 #:use-module ((guix git-download) #:select (git-reference git-file-name git-fetch))
							 #:use-module ((gnu packages golang) #:select (go-github-com-burntsushi-toml go-golang-org-x-sys go-etcd-io-bbolt))
							 #:export (elvish go-github-com-xiaq-persistent go-github-com-mattn-go-isatty go-github-com-creack-pty))

(define elvish
	(let
		(
		 (commit "09829ae9cd9cbf7f115fc26b56482729979b2aeb")
		 (hash "1gg197zwgbs160gpfj6najxqkh2ljlacwv21s36w2s3j1ksbw4xy"))
		(package
			(name "elvish")
			(version (string-append "git-" (string-take commit 7)))
			(source
				(origin
					(method git-fetch)
					(uri (git-reference
								 (url "https://github.com/elves/elvish")
								 (commit commit)
								 (recursive? #t)))
					(file-name "elvish")
					(sha256
						(base32
							hash))))
			(build-system go-build-system)
			(arguments '(#:import-path "github.com/elves/elvish"))
			(native-inputs
				`(("go-github-com-burntsushi-toml" ,go-github-com-burntsushi-toml)
					("go-github-com-creack-pty" ,go-github-com-creack-pty)
					("go-github-com-mattn-go-isatty" ,go-github-com-mattn-go-isatty)
					("go-github-com-xiaq-persistent" ,go-github-com-xiaq-persistent)
					("go-etcd-io-bbolt" ,go-etcd-io-bbolt)
					("go-golang-org-x-sys" ,go-golang-org-x-sys)))
			(synopsis "Friendly Interactive Shell and Expressive Programming Language")
			(description "Elvish is a friendly interactive shell and an expressive programming language. It runs on Linux, BSDs, macOS and Windows. Despite its pre-1.0 status, it is already suitable for most daily interactive use.")
			(home-page "https://elv.sh")
			(license license:bsd-2))))

(define go-github-com-mattn-go-isatty
  (package
    (name "go-github-com-mattn-go-isatty")
    (version "0.0.12")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mattn/go-isatty")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1dfsh27d52wmz0nmmzm2382pfrs2fcijvh6cgir7jbb4pnigr5w4"))))
    (build-system go-build-system)
    (propagated-inputs
     `(("go-golang-org-x-sys" ,go-golang-org-x-sys)))
    (arguments
     '(#:import-path "github.com/mattn/go-isatty"))
    (home-page "https://github.com/mattn/go-isatty")
    (synopsis "Provide @code{isatty} for Golang")
    (description "This package provides @code{isatty}, a Go module that can
tell you whether a file descriptor points to a terminal and the type of the
terminal.")
    (license license:expat)))

(define go-github-com-xiaq-persistent
  (package
    (name "go-github-com-xiaq-persistent")
    (version "git-3175cfb")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/xiaq/persistent")
             (commit "3175cfb92e14776bbe31ed7bd320aab8d516d792")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1q2qzisvpviznykz7cjlqz7nq9651xsp7vfzddkvl07b542w6z98"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/xiaq/persistent"))
    (home-page "https://github.com/xiaq/persistent")
    (synopsis "Persistent data structure in Go")
    (description "This is a Go clone of Clojure's persistent data structures.")
    (license license:epl1.0)))

(define go-github-com-creack-pty
  (package
    (name "go-github-com-creack-pty")
    (version "1.1.11")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/creack/pty")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0dwhch53vqxpnbiqvfa27cliabx9ma2m4dax4adlrz8rami4sakw"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/creack/pty"))
    (home-page "https://github.com/creack/pty")
    (synopsis "PTY interface for Go")
    (description "Pty is a Go package for using unix pseudo-terminals.")
    (license license:expat)))
