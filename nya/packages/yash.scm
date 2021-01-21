;;; -*- mode: scheme; -*- vim: ft=scheme
;;; the package for the yash shell

(define-module (nya packages yash)
               #:use-module ((guix licenses) #:prefix license:)
               #:use-module ((guix packages) #:select (package base32 origin))
               #:use-module ((guix build-system gnu) #:select (gnu-build-system))
               #:use-module ((guix build gnu-build-system) #:select (%standard-phases))
               #:use-module ((guix git-download) #:select (git-reference git-file-name git-fetch))
               #:use-module ((guix build utils) #:select (modify-phases))
               #:use-module ((gnu packages ncurses) #:select (ncurses))
               #:use-module ((gnu packages gettext) #:select (gettext-minimal))
               #:use-module ((gnu packages bash) #:select (bash))
               #:use-module ((gnu packages documentation) #:select (asciidoc))
               #:export (yash))

(define yash
  (package
    (name "yash")
    (version "2.51")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/magicant/yash")
               (commit "2.51")))
        (file-name "yash")
        (sha256
          (base32
            "06990k6iai6qnidy1jmyvr9b5mbff9fjwlz5qmy0mk9f6j5kb4w4"))))
    (build-system gnu-build-system)
    (arguments
      `(#:tests? #f
        #:phases
        (modify-phases %standard-phases
                       (replace 'configure
                                (lambda* (#:key outputs #:allow-other-keys)
                                         (let ((prefix (assoc-ref outputs "out")))
                                           (invoke "./configure" (string-append "--prefix=" prefix)))))
                       (add-before 'build 'move-translation-directory
                                   (lambda* (#:rest _)
                                            (invoke "cp" "-rL" "--no-preserve=mode,ownership" "po/" "po-modifiable/")
                                            (invoke "sed" "-i" "s/(cd po/(cd po-modifiable/g" "Makefile"))))))
    (inputs
      `(("ncurses" ,ncurses)
        ("gettext" ,gettext-minimal)
        ("asciidoc" ,asciidoc)))
    (synopsis "Yash, yet another shell, is a POSIX-compliant command line shell written in C99")
    (description "Yash, yet another shell, is a POSIX-compliant command line shell written in C99 (ISO/IEC 9899:1999). Yash is intended to be the most POSIX-compliant shell in the world while supporting features for daily interactive and scripting use.")
    (home-page "https://yash.osdn.jp")
    (license license:gpl2)))

