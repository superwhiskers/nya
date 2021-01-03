;;; -*- mode: scheme; -*- vim: ft=scheme
;;; a set of packages related to vim plugins

(define-module (nya packages neovim)
               #:use-module ((guix licenses) #:prefix license:)
               #:use-module ((nya licenses) #:prefix license:)
               #:use-module ((guix packages) #:select (package-name package base32 origin))
               #:use-module ((guix build-system copy) #:select (copy-build-system))
               #:use-module ((guix git-download) #:select (git-reference git-fetch))
               #:use-module ((gnu packages vim) #:select (neovim))
               #:export (neovim-with-plugins nerdtree iceberg neoformat lightline startify direnv easymotion incsearch incsearch-easymotion cool quick-scope elvish polyglot rainbow-parentheses))

;; todo: revise this so that it is simpler to maintain
;; todo: complete the neovim-with-plugins package generator

;; define a neovim package with the specified plugins
(define (neovim-with-plugins . plugins)
  (package
    (inherit neovim)
	   (propagated-inputs (map (lambda (plugin)
			 (let ((name (package-name plugin)))
			   `(,name ,plugin))) plugins))))

;; define a neovim plugin
(define* (plugin
	   #:key name version url synopsis hash commit home-page license)
	 (package
	   (name (string-append "neovim-" name))
	   (version (string-append version "-" (string-take commit 7)))
	   (source
	     (origin
	       (method git-fetch)
	       (uri (git-reference
                (url url)
                (commit commit)
                (recursive? #t)))
	       (file-name name)
	       (sha256
           (base32
             hash))))
	   (build-system copy-build-system)
	   (arguments '(#:install-plan
                  (let
                    ((package-directory
                       (string-append
                         "/share/nvim/site/pack/vendor/start/"
                         ,name)))
                    `(("./" ,package-directory)))))
	   (synopsis synopsis)
	   (description "")
	   (home-page (if home-page home-page url))
	   (license license)))

(define nerdtree
  (plugin
    #:name "nerdtree"
    #:version "git"
    #:url "https://github.com/preservim/nerdtree"
    #:synopsis "A tree explorer plugin for vim."
    #:hash "1fhwfwqlvz0pm5qdpjbmjx4dqlnchbp170jw63dc5fxin90h4ivh"
    #:commit "aaa946fb6bd79b9af86fbaf4b6b63fd81d839bd9"
    #:license license:wtfpl2))

(define iceberg
  (plugin
    #:name "iceberg.vim"
    #:version "git"
    #:url "https://github.com/cocopon/iceberg.vim"
    #:synopsis "Bluish color scheme for Vim and Neovim"
    #:hash "0v102i9lp5xwxnrvxm1809jvxd52zpz66s8fln88ha3xa97bqsns"
    #:commit "937ad122f51230ca62deb334a95f5acadb3141b5"
    #:license license:expat))

(define neoformat
  (plugin
    #:name "neoformat"
    #:version "git"
    #:url "https://github.com/sbdchd/neoformat"
    #:synopsis "A (Neo)vim plugin for formatting code."
    #:hash "00x6yx4y4m45p3silwz084scs1a602d4xazyr39lgc0ssv6d9jhv"
    #:commit "7e458dafae64b7f14f8c2eaecb886b7a85b8f66d"
    #:license license:bsd-2))

(define lightline
  (plugin
    #:name "lightline.vim"
    #:version "git"
    #:url "https://github.com/itchyny/lightline.vim"
    #:synopsis "A light and configurable statusline/tabline plugin for Vim"
    #:hash "08v68ymwj6rralfmjpjggd29sc2pvan4yg1y7sysylwlmwl7nhlp"
    #:commit "709b2d8dc88fa622d6c076f34b05b58fcccf393f"
    #:license license:expat))

(define startify
  (plugin
    #:name "vim-startify"
    #:version "git"
    #:url "https://github.com/mhinz/vim-startify"
    #:synopsis "The fancy start screen for Vim."
    #:hash "18n16hpkqadq18gpgppbr4s516jpc8qwd357vb2c7069q79kfx39"
    #:commit "f2fc11844b234479d37bef37faa7ceb2aade788b"
    #:license license:expat))

(define direnv
  (plugin
    #:name "direnv.vim"
    #:version "git"
    #:url "https://github.com/direnv/direnv.vim"
    #:synopsis "vim plugin for direnv support"
    #:hash "136z8axjd66l4yy6rkjr6gqm86zxnqpbw9pzkvii0lsaz11w9wak"
    #:commit "ff37d76da391e1ef299d2f5eb84006cb27a67799"
    #:license license:expat))

(define easymotion
  (plugin
    #:name "vim-easymotion"
    #:version "git"
    #:url "https://github.com/easymotion/vim-easymotion"
    #:synopsis "Vim motions on speed!"
    #:hash "1j2kgh1iri0fqkbgbgvfjqgsksfipnmr1xbj554i602pnm0hbg19"
    #:commit "d75d9591e415652b25d9e0a3669355550325263d"
    #:license (license:none "https://github.com/easymotion/vim-easymotion")))

(define incsearch
  (plugin
    #:name "incsearch.vim"
    #:version "git"
    #:url "https://github.com/haya14busa/incsearch.vim"
    #:synopsis "Improved incremental searching for Vim"
    #:hash "05v0d9b5sm4d1bvhb01jk6s7brlli2xc16hvzr6gik1nm1ks6ai1"
    #:commit "25e2547fb0566460f5999024f7a0de7b3775201f"
    #:license license:expat))

(define incsearch-easymotion
  (plugin
    #:name "incsearch-easymotion.vim"
    #:version "git"
    #:url "https://github.com/haya14busa/incsearch-easymotion.vim"
    #:synopsis "Integration between haya14busa/incsearch.vim and easymotion/vim-easymotion"
    #:hash "1bscr3xs1zggm9qzk1mb88fkc8qj6yrnkxmqwwyr75sf1xzy74mk"
    #:commit "fcdd3aee6f4c0eef1a515727199ece8d6c6041b5"
    #:license (license:none "https://github.com/haya14busa/incsearch-easymotion.vim")))

(define cool
  (plugin
    #:name "vim-cool"
    #:version "git"
    #:url "https://github.com/romainl/vim-cool"
    #:synopsis "Vim-cool disables search highlighting when you are done searching and re-enables it when you search again."
    #:hash "1in44gf7hs978nc9328zh1kj3jh04kcinw0m8spcbgj079782sg8"
    #:commit "27ad4ecf7532b750fadca9f36e1c5498fc225af2"
    #:license license:expat))

(define quick-scope
  (plugin
    #:name "quick-scope"
    #:version "git"
    #:url "https://github.com/unblevable/quick-scope"
    #:synopsis "An always-on highlight for a unique character in every word on a line to help you use f, F and family."
    #:hash "16hl1np40p3wrk1q0blmxfaa28lljvca1dv9xpiw1ddm9n7qlr21"
    #:commit "d4c02b85ff168f7749833607536cb02281464c26"
    #:license license:expat))

(define elvish
  (plugin
    #:name "elvish.vim"
    #:version "git"
    #:url "https://github.com/dmix/elvish.vim"
    #:synopsis "Vim plugin for the Elvish programming language with syntax highlighting"
    #:hash "133hr3i7zxysf2gnnimhz3gf3nda3fyfxmqq7mhq544v2mki4x9m"
    #:commit "67ef8e89bff7cb8ea936f2164c8c268bbb3295f0"
    #:license license:expat))

(define polyglot
  (plugin
    #:name "vim-polyglot"
    #:version "git"
    #:url "https://github.com/sheerun/vim-polyglot"
    #:synopsis "A solid language pack for Vim."
    #:hash "0l7f80gas6rmiw5m0varsyv3sk3sfkqx0z05hlh4719a304b16pv"
    #:commit "05b8bbc938bdeac4a5ee2d3ae5cf7a7f05e822d3"
    #:license license:expat))

(define rainbow-parentheses
  (plugin
    #:name "rainbow_parentheses.vim"
    #:version "git"
    #:url "https://github.com/junegunn/rainbow_parentheses.vim"
    #:synopsis "Simpler Rainbow Parentheses"
    #:hash "0izbjq6qbia013vmd84rdwjmwagln948jh9labhly0asnhqyrkb8"
    #:commit "27e7cd73fec9d1162169180399ff8ea9fa28b003"
    #:license (license:none "https://github.com/junegunn/rainbow_parentheses.vim")))
