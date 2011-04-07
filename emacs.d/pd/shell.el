(require 'ansi-color)

(setq shell-prompt-pattern "^[^\n]*[#$%>»] *")

(defun pd/enable-shell-mode-bindings ()
  (define-key shell-mode-map (kbd "C-c d") 'dirs))

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'shell-mode-hook 'pd/turn-off-show-trailing-whitespace)
(add-hook 'shell-mode-hook 'pd/enable-shell-mode-bindings)

(setq term-prompt-regexp "^[^\n]*[#$%>»] *"
      term-ansi-buffer-base-name t)
(add-hook 'term-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'term-mode-hook 'pd/turn-off-show-trailing-whitespace)

; dunno where else to put this really.
(add-hook 'comint-mode-hook 'pd/turn-off-show-trailing-whitespace)

(provide 'pd/shell)
