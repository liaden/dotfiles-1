;; -*- mode: Emacs-Lisp -*-

(add-to-list 'load-path "~/.emacs.d")

; generic
(require 'pd/core)
(require 'pd/packages)
(require 'pd/defuns)
(require 'pd/bindings)
(require 'pd/ido)
(require 'pd/theme)
(require 'pd/coding)
(require 'pd/yasnippet)

; focused
(require 'pd/shell)
(require 'pd/tramp)
(require 'pd/magit)
(require 'pd/p4)
(require 'pd/lisps)
(require 'pd/ruby)
(require 'pd/js)
(require 'pd/haskell)
(require 'pd/scala)
(require 'pd/yaml)
(require 'pd/irc)
(require 'pd/smex)

; wasn't it silly to have pd/misc in the "focused" section?
; this is an artificial comment to put an end to such madness.
(require 'pd/misc)

; private
(when (pd/has-private-emacsd-p)
  (pd/load-private-emacsd))

; hack. start save-visited-files-mode for non-daemon processes, and
; any daemon that isn't irc.
(add-hook 'before-make-frame-hook 'pd/run-once-maybe-save-visited-files)
