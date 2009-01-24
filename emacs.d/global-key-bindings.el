; I wish there were more consistency to the modifier keys.
; Some day I will be annoyed enough to do that.

; General keybindings
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-S-k") 'kill-whole-line)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "M-z") 'undo)
(global-set-key (kbd "M-s") 'save-buffer)
(global-set-key (kbd "M-SPC") 'set-mark-command) ; Quicksilver is C-SPC

(global-set-key (kbd "M-<return>") 'append-and-move-to-new-line)
(global-set-key (kbd "M-S-<return>") 'prepend-and-move-to-new-line)

(global-set-key (kbd "<f6>") 'linum-mode)

(global-set-key (kbd "C-M-<return>") 'toggle-fullscreen)

; Bindings from emacs-starter-kit that were reasonable enough
(global-set-key (kbd "C-c e") 'eval-buffer)
(global-set-key (kbd "C-h a") 'apropos) ; defaults to command-apropos
(global-set-key (kbd "C-/") 'hippie-expand) ; keep M-/ around for now, I suppose

; S-<dir> moves to the window in that direction
(windmove-default-keybindings)

; Handy ways to clean up whitespace around point
(global-set-key (kbd "C-c w") 'delete-trailing-whitespace)
(global-set-key (kbd "M-\\") 'delete-horizontal-space)

; irb and git are constants
(global-set-key (kbd "C-c r i") 'run-ruby)
(global-set-key (kbd "C-M-g") 'magit-status)
