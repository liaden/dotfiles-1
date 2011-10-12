(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (let (el-get-master-branch)
    (pd/eval-url
     "https://raw.github.com/dimitri/el-get/master/el-get-install.el")))

(setq el-get-verbose t)

(setq el-get-sources
      '((:name el-get
               :branch "master")

        (:name package
               :after (lambda ()
                        (package-initialize)))

        (:name magit
               :after (lambda ()
                        (require 'magit) ; force load, autoload is fucked TODO
                        (global-set-key (kbd "C-M-g") 'magit-status)
                        (pd/magit-setup)))

        (:name save-visited-files
               :type git
               :url "https://github.com/nflath/save-visited-files.git"
               :after (lambda ()
                        (autoload 'turn-on-save-visited-files-mode "save-visited-files" "meh" t)))

        (:name rspec-mode
               :url "https://github.com/earakaki/rspec-mode.git")

        (:name rvm
               :after (lambda ()
                        (rvm-autodetect-ruby)
                        (defadvice shell-dirstack-message (after rvm-on-shell-dirstack-message last activate)
                          (rvm-activate-corresponding-ruby))))

        (:name haml-mode
               :url "git://github.com/pd/haml-mode.git"
               :branch "wip")

        (:name feature-mode
                :after (lambda ()
                         (setq org-table-number-fraction 2))) ; impossible, thus never right-align.

        (:name buffer-move
               :after (lambda ()
                        (global-set-key (kbd "C-x w k") 'buf-move-up)
                        (global-set-key (kbd "C-x w j") 'buf-move-down)
                        (global-set-key (kbd "C-x w h") 'buf-move-left)
                        (global-set-key (kbd "C-x w l") 'buf-move-right)))

        (:name full-ack
               :after (lambda ()
                        (setq ack-ignore-case t
                              ack-arguments '("-a")
                              ack-executable (or (executable-find "ack")
                                                 (executable-find "ack-grep")))))))

(setq pd/el-get-packages
      (append
       '(el-get package
                color-theme color-theme-sanityinc
                smex buffer-move notify
                magit git-blame
                full-ack sudo-save tail cheat
                ruby-mode inf-ruby inf-ruby-bond
                rvm rinari rspec-mode yari yaml-mode feature-mode
                haml-mode sass-mode
                coffee-mode
                scala-mode ;ensime
                clojure-mode paredit elein
                eredis
                emacschrome)
       (mapcar 'el-get-source-name el-get-sources)))

(el-get 'sync pd/el-get-packages)

(provide 'pd/packages)
