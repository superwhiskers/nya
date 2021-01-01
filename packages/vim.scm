;;; -*- mode: scheme; -*- vim: ft=scheme
;;; a set of packages related to vim plugins

(define-module (nya packages vim)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages #:select (base32))
	       #:use-module ((guix build-system copy) #:select (copy-build-system))
	       #:use-module ((guix git-download) #:select (git-reference git-fetch)))

;; todo: revise this so that it is simpler to maintain

;; define a neovim plugin
(define* (neovim-plugin
	   #:key name version url synopsis description hash commit home-page license)
	 (package
	   (name name)
	   (version (string-append version "-" (string-take commit 7)))
	   (source
	     (origin
	       (method git-fetch)
	       (uri (git-reference
		      (url url)
		      (commit commit)))
	       (file-name name)
	       (sha256
		 (base32
		   hash))))
	   (build-system copy-build-system)
	   (arguments #:install-plan '(
				       (name "/usr/local/share/nvim/site/pack")))
	   (synopsis synopsis)
	   (description description)
	   (home-page (if home-page home-page url))
	   (license license)))

(define-public neovim-nerdtree
	       (vim-plugin
		 #:name "nerdtree"
		 #:version "6.9.11"
		 #:url "https://github.com/preservim/nerdtree"
		 #:synopsis "A tree explorer plugin for vim."
		 #:description "The NERDTree is a file system explorer for the
		 Vim editor. Using this plugin, users can visually browse
		 complex directory hierarchies, quickly open files for reading
		 or editing, and perform basic file system operations."
		 #:hash "1767zlm9vykivgir8xznjmax2xj93dxfb8z779apnr5slv5z14vn"
		 #:commit "2406c456ee73d32289c2c304ecd8dd1735bc2f2c"
		 #:home-page "https://github.com/preservim/nerdtree"
		 #:license license:wtfpl2))
