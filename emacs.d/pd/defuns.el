; filter a list. but i never remember the remove-if-not name,
; so name it something i don't forget
(defalias 'pd/filter 'remove-if-not)
(defalias 'pd/reject 'remove-if)

(defun pd/uniq (list)
  "Remove duplicate elements from a list"
  (let ((list list))
    (while list
      (setq list (setcdr list (delete (car list) (cdr list))))))
  list)

(defun pd/load-directory (path &optional noerror nomessage)
  "Load all .el files in the given directory. Non-recursive."
  (dolist (file (directory-files path 'full "\\.el\\'"))
    (load file noerror nomessage)))

(defun pd/eval-url (url)
  "Load url and eval its contents as an Emacs Lisp script"
  (let ((buffer (url-retrieve-synchronously url)))
    (save-excursion
      (set-buffer buffer)
      (goto-char (point-min))
      (re-search-forward "^$" nil 'move)
      (eval-region (point) (point-max))
      (kill-buffer (current-buffer)))))

(defun pd/has-private-emacsd-p ()
  "t if my private dotfiles init.el is available"
  (file-exists-p "~/dotfiles/private/emacs.d/init.el"))

(defun pd/load-private-emacsd ()
  "add private emacs.d to load-path and load the init.el"
  (add-to-list 'load-path "~/dotfiles/private/emacs.d")
  (load "~/dotfiles/private/emacs.d/init.el"))

; from xale@#emacs
(defun reload-buffer ()
  "Kill the current buffer and immediately reload it without moving point.
Useful for rerunning mode hooks."
  (interactive)
  (let ((path (buffer-file-name)) (point (point)))
    (kill-buffer)
    (find-file path)
    (goto-char point)))

; superior mark handling
; stolen from http://www.masteringemacs.org/articles/2010/12/22/fixing-mark-commands-transient-mark-mode/
(defun pd/push-mark ()
  "Pushes `point' to `mark-ring' and does not activate the region
Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))

(defun pd/jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))

; vi's o and O
(defun pd/insert-newline ()
  (funcall (or (local-key-binding (kbd "<return>"))
               (key-binding (kbd "RET")))))

(defun pd/append-and-move-to-new-line ()
  "Inserts a blank line after the current one, and moves to it"
  (interactive)
  (end-of-line)
  (pd/insert-newline))

(defun pd/prepend-and-move-to-new-line ()
  "Inserts a blank line before the current one, and moves to it"
  (interactive)
  (if (= 1 (line-number-at-pos))
      (progn
        (beginning-of-buffer)
        (open-line 1)
        (beginning-of-buffer))
    (progn
      (previous-line)
      (pd/append-and-move-to-new-line))))

; from https://github.com/rejeep/emacs
(defun pd/back-to-indentation-or-beginning-of-line ()
  "Moves point back to indentation if there is any
non blank characters to the left of the cursor.
Otherwise point moves to beginning of line."
  (interactive)
  (if (= (point) (save-excursion (back-to-indentation) (point)))
      (beginning-of-line)
    (back-to-indentation)))

(defun pd/modify-font-size (amount)
  "Increase/decrease the font size by amount"
  (set-face-attribute 'default nil
                      :height
                      (+ (face-attribute 'default :height)
                         amount)))

(defun pd/increase-font-size ()
  "Increase the font size by 20 (whatever the fuck that is)"
  (interactive)
  (pd/modify-font-size 20))

(defun pd/decrease-font-size ()
  "Decrease the font size by 20 (whatever the fuck that is)"
  (interactive)
  (pd/modify-font-size -20))

;; smarter shell creation
(defun pd/smart-shell ()
  "If currently in a shell-mode buffer, restart the shell if it has exited.
Otherwise, start a new shell.

If not in shell-mode and one shell-mode buffer exists, switch to it.
If more than one shell-mode buffer exists, switch to the nearest one,
according to pd/nearest-shell."
  (interactive)
  (let ((next-shell-name (generate-new-buffer-name "*shell*"))
        (in-shell-buffer (eq 'shell-mode major-mode))
        (process-alive-p (eq nil (get-buffer-process (current-buffer))))
        (wants-new-shell (not (eq nil current-prefix-arg))))
    (if in-shell-buffer
        (if process-alive-p (shell) (shell next-shell-name))
      (switch-to-buffer (if wants-new-shell (shell next-shell-name)
                          (or (pd/nearest-shell) (shell next-shell-name)))))))

(defun pd/shell-buffer-list ()
  "Returns a list of all shell buffers"
  (remove-if-not (lambda (buf)
                   (eq 'shell-mode (with-current-buffer buf major-mode)))
                 (buffer-list)))

(require 'levenshtein)
(defun pd/distance-to-buffer (buffer)
  "Returns the levenshtein distance between BUFFER's directory and this buffer's directory"
  (levenshtein-distance (with-current-buffer buffer default-directory)
                        default-directory))

(defun pd/nearest-shell ()
  "Returns the shell buffer whose default-directory is closest
to the default-directory of the current buffer."
  (car (sort* (pd/shell-buffer-list) '< :key 'pd/distance-to-buffer)))

(defun pd/ido-switch-shell ()
  "Handy wrapper around ido-switch-buffer which only lists shell-mode buffers."
  (interactive)
  (let* ((shell-names (mapcar 'buffer-name (pd/shell-buffer-list)))
         (buffer-name (ido-completing-read "Buffer: " shell-names)))
    (when buffer-name (switch-to-buffer buffer-name))))

(defun pd/clear-shell ()
  "Clear the contents of a buffer without bothering with the kill-ring."
  (interactive)
  (delete-region (point-min) (point-max)))

;; ansi-term creation
(defun pd/term-buffer-name ()
  "Return the name of the first buffer in term-mode"
  (find-if (lambda (buf) (with-current-buffer buf (eq 'term-mode major-mode)))
           (buffer-list)))

(defun pd/term-buffer-exists ()
  "t if a term-mode buffer exists"
  (not (eq nil (pd/term-buffer-name))))

(defun pd/term (create-new)
  "Open an ansi-term running $SHELL (or /bin/zsh if undefined)"
  (interactive "P")
  (let ((current-term (pd/term-buffer-name)))
    (if (and current-term (not create-new))
        (switch-to-buffer current-term)
      (ansi-term (or (getenv "SHELL") "/bin/zsh")))))

(defun pd/ssh (user host)
  "Open a terminal buffer ssh'd to user@host"
  (interactive "MUser: \nMHost: ")
  (let* ((dest (concat user "@" host))
         (buf (apply 'make-term (generate-new-buffer-name dest) "ssh" nil (list dest))))
    (switch-to-buffer buf)))

(defun pd/psql (host port db user)
  "Open a comint buffer running psql"
  (switch-to-buffer
   (make-comint (format "PSQL %s@%s" db host)
                "psql" nil "-U" user "-h" host "-p" port "--pset" "pager=off" db)))

(defun pd/add-mode-to-first-line ()
  "Add the -*- mode: foo -*- line to the beginning of the current buffer"
  (interactive)
  (let ((mode-name (replace-regexp-in-string "-mode\\'" "" (symbol-name major-mode))))
    (save-excursion
      (beginning-of-buffer)
      (pd/prepend-and-move-to-new-line)
      (insert (concat "-*- mode: " mode-name " -*-"))
      (comment-region (point-min) (point)))))

(defun pd/macosx-p ()
  "t if on a darwin system"
  (string-equal "darwin" system-type))

; http://stackoverflow.com/questions/1242352/get-font-face-under-cursor-in-emacs
(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

;; zsh directory alias support
(defun pd/zsh-dir-aliases ()
  "Return list of zsh's dir aliases as (alias . expansion); or NIL if none."
  (let* ((aliases  nil)
         (zshout   (shell-command-to-string "zsh -i -c 'print -l -n ${(kv)nameddirs}'"))
         (zshlines (if (s-blank? zshout) nil (s-lines zshout))))
    (when (= 0 (% (length zshlines) 2))
      (while (> (length zshlines) 0)
        (push (cons (concat "~" (car zshlines)) (cadr zshlines))
              aliases)
        (setq zshlines (cddr zshlines)))
      aliases)))

(defvar pd/zsh-dir-aliases-cache (pd/zsh-dir-aliases)
  "A local cache of zsh's hash table for use in `pd/abbreviate-file-name'
and `pd/expand-file-name'. See also `pd/zsh-dir-aliases'.")

(defvar pd/directory-abbrev-alist
        (mapcar (lambda (alias) (cons (cdr alias) (car alias)))
                (pd/zsh-dir-aliases))
        "Reordering of `pd/zsh-dir-aliases' for use with `pd/abbreviate-file-name'.")

(defun pd/abbreviate-file-name (filename)
  "A version of `abbreviate-file-name' which replaces the
`directory-abbrev-alist' with my `pd/directory-abbrev-alist'."
  (let ((directory-abbrev-alist pd/directory-abbrev-alist))
    (abbreviate-file-name (expand-file-name filename))))

(defun pd/expand-file-name (filename)
  "Like `expand-file-name', but expands directory names based
on `pd/zsh-dir-aliases-cache'."
  (reduce (lambda (str alias)
            (s-replace (car alias) (cdr alias) str))
          pd/zsh-dir-aliases-cache
          :initial-value path))

; ganked from emacs-prelude
(defun pd/google ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "Google: "))))))

(provide 'pd/defuns)
