(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (let (el-get-master-branch)
    (pd/eval-url
     "https://raw.github.com/dimitri/el-get/master/el-get-install.el")))

(setq el-get-verbose nil ; t = message for every little thing. useful.
      el-get-user-package-directory (concat user-emacs-directory "package-inits"))

(setq el-get-sources
      '((:name el-get
               :branch "master")

        (:name package
               :after (progn (package-initialize)))

        (:name save-visited-files
               :type git
               :url "https://github.com/nflath/save-visited-files.git")

        (:name ruby-tools
               :type git
               :url "https://github.com/rejeep/ruby-tools.git")

        (:name rspec-mode
               :url "https://github.com/earakaki/rspec-mode.git")

        (:name haml-mode
               :url "git://github.com/pd/haml-mode.git"
               :branch "wip")))

(setq pd/el-get-packages
      (append
       '(el-get package
                color-theme color-theme-sanityinc
                levenshtein
                smex buffer-move notify
                browse-kill-ring vkill
                magit git-blame pcmpl-git
                full-ack sudo-save
                ;; evil
                ;; Enhanced-Ruby-Mode
                ;; inf-ruby inf-ruby-bond
                ruby-tools
                rvm rinari rspec-mode yari yaml-mode feature-mode
                haml-mode sass-mode
                coffee-mode
                paredit
                )
       (mapcar 'el-get-source-name el-get-sources)))

(el-get 'sync pd/el-get-packages)

(provide 'pd/packages)
