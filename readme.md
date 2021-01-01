# nya

a software repository for [guix](https://guix.gnu.org) systems containing a
handful of things (primarily neovim plugins)

## basic usage

```scheme
(cons* (channel
        (name 'nya)
	(url "https://github.com/superwhiskers/nya)
	(introduction
	 (make-channel-introduction
	  "134d3fe02bb34ac33cbb1f174f765cc38956fec5"
	  (openpgp-fingerprint
	   "78C4 DF75 47AF 93D6 B4C6  894D 0134 BBC5 4141 A521"))))
       %default-channels)
```

```sh
$ guix pull
```

