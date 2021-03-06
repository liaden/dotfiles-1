(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(load-theme 'molokai t)
(load-theme 'despot t)

(setq sml/theme 'dark)
(require 'smart-mode-line)
(setq sml/no-confirm-load-theme t)
(sml/setup)

(provide 'pd/theme)
