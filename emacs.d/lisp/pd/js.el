(after 'js
  (setq-default js-indent-level 2))

(after 'js2-mode
  (setq-default js2-basic-offset 2
                js2-bounce-indent-p nil
                js2-missing-semi-one-line-override t
                js2-include-node-externs t
                js2-include-browser-externs nil
                js2-idle-timer-delay 0.5
                js2-skip-preprocessor-directives t) ; aka, ignore #!env node
  (add-hook 'js2-mode-hook 'js2-imenu-extras-mode))

(provide 'pd/js)
