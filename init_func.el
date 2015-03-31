;;; Commentary

;;; Code
(defun my-generate-tags ()
  (interactive)
  (shell-command
   (read-string
    "CTAG CMD : "
    (format "ctags -e  --language-force=%s -R ./" mode-name)
    )))

(defun set-region-read-only (begin end)
  "Sets the read-only text property on the marked region.
   Use `set-region-writeable' to remove this property."
  ;; See http://stackoverflow.com/questions/7410125
  (interactive "r")
  (let ((modified (buffer-modified-p)))
    (add-text-properties begin end '(read-only t))
    (set-buffer-modified-p modified)))

(defun set-region-writeable (begin end)
  "Removes the read-only text property from the marked region.
   Use `set-region-read-only' to set this property."
  ;; See http://stackoverflow.com/questions/7410125
  (interactive "r")
  (let ((modified (buffer-modified-p))
        (inhibit-read-only t))
    (remove-text-properties begin end '(read-only t))
    (set-buffer-modified-p modified)))

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(defun write-input-and-come-back (x def)
  "Moves back sexp, adds the passed character or default, comes back"
  (backward-sexp)
  (if (equal x nil) (insert def) (insert x))
  (forward-sexp))

(defun uniquify-all-lines-region (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
    (let ((end (copy-marker end)))
      (while
	  (progn
	    (goto-char start)
	    (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
	(replace-match "\\1\n\\2")))))

(defun uniquify-all-lines-buffer ()
  "Delete duplicate lines in buffer and keep first occurrence."
  (interactive "*")
  (uniquify-all-lines-region (point-min) (point-max)))

;; (defun my-speedbar-no-separate-frame ()
;;     (interactive)
;;     (when (not (buffer-live-p speedbar-buffer))
;;       (setq speedbar-buffer (get-buffer-create my-speedbar-buffer-name)
;;             speedbar-frame (selected-frame)
;;             dframe-attached-frame (selected-frame)
;;             speedbar-select-frame-method 'attached
;;             speedbar-verbosity-level 0
;;             speedbar-last-selected-file nil)
;;       (set-buffer speedbar-buffer)
;;       (speedbar-mode)
;;       (speedbar-reconfigure-keymaps)
;;       (speedbar-update-contents)
;;       (speedbar-set-timer 1)
;;       (make-local-hook 'kill-buffer-hook)
;;       (add-hook 'kill-buffer-hook
;;                 (lambda () (when (eq (current-buffer) speedbar-buffer)
;;                              (setq speedbar-frame nil
;;                                    dframe-attached-frame nil
;;                                    speedbar-buffer nil)
;;                              (speedbar-set-timer nil)))))
;;     (set-window-buffer (selected-window)
;;                        (get-buffer my-speedbar-buffer-name)))


(defun fix-indentation-xml ()
  "Reformats xml to make it readable (respects current selection)."
  (interactive)
  (save-excursion
    (let ((beg (point-min))
          (end (point-max)))
      (if (and mark-active transient-mark-mode)
          (progn
            (setq beg (min (point) (mark)))
            (setq end (max (point) (mark))))
        (widen))
      (setq end (copy-marker end t))
      (goto-char beg)
      (while (re-search-forward ">\\s-*<" end t)
        (replace-match ">\n<" t t))
      (goto-char beg)
      (indent-region beg end nil))))

(defun active-learn-publishing-completion ()
  "Set file permissions and clean up after publishing"
  (progn
    (shell-command "chmod 655 ~/public_html/*.html")
    ;;    (ignore-errors (shell-command "mv -f ~/public_html/sitemap.html ~/public_html/index.html"))
    (shell-command "rm ~/Dropbox/org/.*.orgx")
    (shell-command "rsync -avz --chmod=o+rx -p ~/public_html/notes/* prastog3@masters1.cs.jhu.edu:~/public_html/notes")
    ))


(defun dos-file-endings-p ()
  (string-match "dos" (symbol-name buffer-file-coding-system)))

(defun find-file-check-line-endings ()
  (when (dos-file-endings-p)
    (set-buffer-file-coding-system 'undecided-unix)
    (set-buffer-modified-p nil)))

(defun my-multi-occur-in-matching-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))

(defun dired-file-rename-mode ()
  "rename the file rename mode command to a more intuitive one"
  (interactive)
  (wdired-change-to-wdired-mode))

(defun apply-foo-to-every-word-in-region (foo beg)
  "foo must take the word boundaries  as two parameters, it should also ideally save-excursion, beg and end define the region
(apply-foo-to-every-word-in-region '(lambda (x y z) (message \"%d %d %s\" x y z)) (point-min) (point-max))"
  (save-excursion
    (goto-char beg)
    (let ((temp (lambda () (let ((bound (bounds-of-thing-at-point 'word)))
                            (if (not (eq bound nil))
                                (progn
                                  (funcall foo (car bound) (cdr bound) (buffer-substring-no-properties (car bound) (cdr bound)))
                                  (sit-for 0))
                              ))
                 )))
         (while (< (point) (point-max))
           (funcall temp)
           (forward-word 1))
         (funcall temp))))
(defun has-revisit-file-with-coding-windows-1252 ()
  "Re-opens currently visited file with the windows-1252 coding. (By: hassansrc at gmail dot com)
    Example:
    the currently opened file has french accents showing as codes such as:
        french: t\342ches et activit\340s   (\340 is shown as a unique char)
    then execute this function: has-revisit-file-with-coding-windows-1252
      consequence: the file is reopened with the windows-1252 coding with no other action on the part of the user.
                   Hopefully, the accents are now shown properly.
                   Otherwise, find another coding...
    "
  (interactive)
  (let ((coding-system-for-read 'windows-1252)
	(coding-system-for-write 'windows-1252)
	(coding-system-require-warning t)
	(current-prefix-arg nil))
    (message "has: Reopened file with coding set to windows-1252")
    (find-alternate-file buffer-file-name)
    )
  )


(defun show-file-name ()
  "Shows the full path file name in the minibuffer an dcopies it to kill-ring"
  (interactive)
  (message (concat "Copied path " (buffer-file-name) " to clipboard"))
  (kill-new (file-truename buffer-file-name)))

(defun save-line-to-kill-ring ()
  "Saves line (cursor to end) to kill ring (without killing)"
  (interactive)
  (progn
    (kill-ring-save (point) (line-end-position))
    (message (concat "copied: " (current-kill 0)))))

(defun save-entire-line-to-kill-ring ()
  "Save entire line to kill ring irrespective of cursor loc"
  (interactive)
  (progn
    (kill-ring-save (line-beginning-position) (line-end-position))
    (message (concat "copied: " (current-kill 0)))))
(defun insert-g ()
  "Inserts g at the current location"
  (interactive)
  (insert "g")
  (forward-paragraph 2)
  )

(defun insert-u ()
  "Inserts g at the current location"
  (interactive)
  (insert "u")
  (forward-paragraph 2)
  )
(defun two-para-down ()
  "Inserts g at the current location"
  (interactive)
  (forward-paragraph 1)
  )

(defun reload-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))

(defun am-annotate-tag (&optional tag)
  (interactive "SEnter tag: ")
  (insert (format "<%s corr=\"\">" tag))
  (left-char 2))

(defun am-annotate-and-close-tag ()
  (interactive)
  (insert "<ms/>"))

(defun surround-text-within-bounds (beg end)
  "surround region between beg end"
  (let ((tag (read-string "tag: ")))
    (goto-char beg)
    (insert (format "<%s corr=\"%s\">" tag (read-string "corr: ")))
    (forward-char (- end beg))
    (insert (format "</%s>" tag))))

(defun surround-selected-text-with-tag ()
  "surround selected region with tags if it is selected otherwise do nothing"
  (interactive)
  (if (use-region-p)
      (surround-text-within-bounds (region-beginning) (region-end))))

(defun surround-lone-i-with-tags (beg end word)
  "surround all solitary i with tags <cap corr=\"I\">i</corr>"
  (if (and (eq (- end beg) 1) (string= "i" word))
      (progn
        (goto-char beg)
        (insert "<cap corr=\"I\">")
        (forward-char)
        (insert "</cap>")
        )))

(defun am-annotate-all-spelling-errors (_x _y _z)
  (interactive)
  (flyspell-goto-next-error)
  (if (y-or-n-p "This is msp[y] or [n]name?")
      (progn
        (copy-region-as-kill (point) (progn (forward-word) (point)))
        (backward-word)
        (ispell-word)
        (backward-word)
        (sit-for 0)
        (insert "<msp corr=\"")
        (forward-word)
        (insert "\">")
        (yank)
        (insert "</msp>")
        (backward-word))
    (progn
      (insert "<name corr=\"\">")
      (forward-word)
      (insert "</name>")
      (backward-word))))

(defun insert-sms-tag (beg new_word)
  (interactive)
  (goto-char beg)
  (insert (format "<sms corr=\"%s\">" new_word))
  (forward-word)
  (insert "</sms>")
  )

(defun am-annotate-all-sms-language-errors (beg _e word)
  (interactive)
  (let ((d_word (downcase word)))
    (progn
      (when (string= "c"  d_word)(insert-sms-tag beg "see"))
      (when (string= "m"    d_word)(insert-sms-tag beg "am"))
      (when (string= "pls"  d_word)(insert-sms-tag beg "please"))
      (when (string= "plz"  d_word)(insert-sms-tag beg "please"))
      (when (string= "r"  d_word)(insert-sms-tag beg "are"))
      (when (string= "u"    d_word)(insert-sms-tag beg "you"))
      (when (string= "ur"    d_word)(insert-sms-tag beg "your"))
      (when (string= "v"  d_word)(insert-sms-tag beg "we"))
      (when (string= "y"    d_word)(insert-sms-tag beg "why"))
      )))

(defun surround-all-lone-i-with-tags () (apply-foo-to-every-word-in-region 'surround-lone-i-with-tags (point-min)))

(defun surround-all-names-and-msp-with-tags ()
  (interactive)
  (apply-foo-to-every-word-in-region 'am-annotate-all-spelling-errors (point)))

(defun surround-all-sms-language ()
  (interactive)
  (apply-foo-to-every-word-in-region 'am-annotate-all-sms-language-errors (point)))

(add-to-list 'auto-mode-alist '("\\.tio$" . (lambda ()
                                              (sgml-mode)
                                              ;; (goto-char (point-min))
                                              ;; (insert "#OVERALL_SCORE: ")
                                              ;; (kill-line)
                                              (text-scale-set 1)
                                              (sit-for 1)
                                              (sgml-tags-invisible 0)
                                              (goto-char (point-min))
                                              (move-end-of-line 1))))

(add-hook 'sgml-mode
          (lambda ()
            (progn
              (setq flyspell-generic-check-word-predicate 'sgml-mode-flyspell-verify)
              (setq flyspell-issue-message-flag nil)
					;(flyspell-mode 1)
              (setq case-fold-search nil)
              (modify-syntax-entry 92 "w" sgml-mode-syntax-table))))

(defun quickly-add-tags (tag) (insert tag) (next-line) (move-end-of-line 1))

(defun quickly-kill () (interactive) (save-buffer) (kill-this-buffer))


(defun copy-lines-matching-re (re)
  "find all lines matching the regexp RE in the current buffer
putting the matching lines in a buffer named *matching*"
  (interactive "sRegexp to match: ")
  (let ((result-buffer (get-buffer-create "*matching*")))
    (with-current-buffer result-buffer
      (erase-buffer))
    (save-match-data
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward re nil t)
          (princ
           (buffer-substring-no-properties
            (line-beginning-position)
            (line-beginning-position 2))
           result-buffer))))
    (pop-to-buffer result-buffer)))


(defun py-execute-current-line ()
  "Execute the current line assuming it's python"
  (interactive)
  (progn
    (python-send-region (line-beginning-position) (line-end-position))
    (message "Ran line in python")))

(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

(defun sarcasm-makefile-mode-hook ()
  "Hooks for Makefile mode."
  (font-lock-add-keywords nil '(("\\<\\(TARGET\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\<\\(SOURCE\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\<\\(EXAMPLE\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\([#]\\)" 1 font-lock-warning-face t)))
  )

(defun org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the same
directory as the org-buffer and insert a link to this file. This function wont work if the buffer is not saved to a file
"
  (interactive)
  (setq tilde-buffer-filename (replace-regexp-in-string "/" "\\" (buffer-file-name) t t))
  (setq filename (concat (make-temp-name (concat tilde-buffer-filename "_" (format-time-string "%Y%m%d_%H%M%S_")) ) ".jpg"))
  (shell-command (concat "screencapture -o -x -w -W " filename))
  (insert (concat "[[file:" filename "]]" "\n" filename))
  (org-display-inline-images))

(defun insert-org-line ()
  "Insert org-mode line to file"
  (interactive)
  (insert "-*- mode: org; -*-\n"))

(defun org-refresh-everything()
  "An example of how to have emacs 'interact' with the minibuffer use a kbd macro"
  (interactive)
  (progn
    (execute-kbd-macro [?\C-  ?\C- ])
    (beginning-of-buffer)
    (execute-kbd-macro [?\C-c ?\C-c])
    (execute-kbd-macro [?\C-u ?\C-c ?#])
    (execute-kbd-macro [?\C-u ?\C-c ?\C-x ?\C-u])
    (execute-kbd-macro [?\C-u ?\C- ])))

(defun c-hook-func()
  ;;(setq ac-sources (append '(ac-source-semantic) ac-sources))
  (linum-mode t)
  (c-turn-on-eldoc-mode)
  (helm-gtags-mode)
  (font-lock-add-keywords nil
			  '(("\\<\\(FIXME\\):" 1 font-lock-warning-face prepend)
			    ("\\<\\(and\\|or\\|not\\)\\>" . font-lock-keyword-face))))


(defun org-transpose-table-at-point ()
  "Transpose orgmode table at point, eliminate hlines."
  (interactive)
  (let ((contents
	 (apply
	  #'mapcar* #'list    ;; <== LOB magic imported here
	  (remove-if-not
	   'listp  ;; remove 'hline from list
	   (org-table-to-lisp))))  ;; signals  error if not table
	)
    (delete-region (org-table-begin) (org-table-end))
    (insert
     (mapconcat(lambda(x) (concat "| " (mapconcat 'identity x " | " ) " |\n" ))
	       contents
	       ""))
    (org-table-align)
    )
  )


(defun my-matlab-shell-mode-hook ()
  (define-key matlab-shell-mode-map (kbd "TAB") 'matlab-shell-tab))

(defun my-matlab-mode-hook ()
  (setq matlab-indent-function t)
  (setq matlab-shell-command "matlab")
  (setq fill-column 76)
  (setq matlab-indent-function-body nil); indent function bodies
  (setq matlab-verify-on-save-flag t); verify on save
  )

(defun run-matlab-once ()
  (remove-hook 'matlab-mode-hook 'run-matlab-once)
  (matlab-shell))

(defun my-ibuffer-mode-hook ()
  (setq ibuffer-show-empty-filter-groups nil)
  (setq ibuffer-saved-filter-groups
	(quote (("default"
		 ("dired" (mode . dired-mode))
		 ("fundamental" (mode . fundamental-mode))
		 ("Compilation" (mode . compilation-mode))
		 ("Package" (mode . package-menu-mode))
		 ("Python" (mode . python-mode))
		 ("StarMark" (name . "*Help*"))
		 ))))
  (ibuffer-switch-to-saved-filter-groups "default")
  ;;(ibuffer-filter-by-name "^[^*]")
  )

(defun my-java-mode-hook ()
  (setq indent-tabs-mode t)
  (setq java-indent 8)
  (setq tab-width 4))

(defun add-package-managers ()
  (add-to-list 'package-archives
	       '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (add-to-list 'package-archives
	       '("marmalade" . "http://marmalade-repo.org/packages/") t))


(defun transpose-line-down ()
  (interactive) (beginning-of-line 2) (transpose-lines 1) (beginning-of-line 0))

(defun transpose-line-up ()
  (interactive) (transpose-lines 1) (beginning-of-line -1))

(define-skeleton python-header-tmpl
  "Insert a comment block containing the module title, author, etc."
  ""
  "# -*- Mode: Python -*-"
  "\n# Filename        : " (buffer-name)
  "\n# Description     : " "NA"
  "\n# Author          : " (user-login-name)
  "\n# Created On      : " (current-time-string)
  "\n# Time-stamp: <>"
  "\n")

(defun python-header ()
  "Insert a descriptive header at the top of the file."
  (interactive "*")
  (save-excursion
    (goto-char (point-min))
    (python-header-tmpl)))

(defun my-python-mode-hook ()
  (setq pychecker-regexp-alist '(("\\([a-zA-Z]?:?[^:(\t\n]+\\)[:( \t]+\\([0-9]+\\)[:) \t]" 1 2)))
  (auto-make-header)
  (progn (jedi:setup)   (setq jedi:complete-on-dot t))
  ;; (add-to-list 'company-backends 'company-jedi)
  (company-mode -1)
  (ecb-activate)
  (run-python)
  (font-lock-add-keywords
   'python-mode
   '(("\\<\\(sys.argv\\)" 0 'font-lock-warning-face)
     ("\\([0123456789]\\)"  0 'font-lock-constant-face)
     ("\\([][{}]\\)" 0 'font-lock-builtin-face)
     ("\\([=+*/-]\\)" 0 'font-lock-builtin-face))))

(defun my-org-mode-hook ()
  (font-lock-add-keywords
   nil
   '(("\\<\\(QQQ\\)" 1 font-lock-warning-face t)
     ("\\<\\(BOOKMARK\\)" 1 font-lock-warning-face t)
     ("\\<\\(TODO\\)" 1 font-lock-warning-face t)))
  (writegood-mode)
  (define-key org-mode-map (kbd "C-c C-r") 'org-refresh-everything)
  (define-key org-mode-map (kbd "C-c q") 'org-set-tags-command))

(defun my-tex-mode-hook ()
  (font-lock-add-keywords
   nil
   '(("\\<\\(QQQ\\)" 1 font-lock-warning-face t)
     ("\\<\\(TODO\\)" 1 font-lock-warning-face t)))
  (writegood-mode))

(defun my-after-init-hook ()
  (add-package-managers)
  (recentf-mode 1)
  (global-company-mode 1)
  (autoload 'auto-update-file-header "header2")
  (autoload 'auto-make-header "header2")
  (global-flycheck-mode)
  (setq flycheck-check-syntax-automatically '(mode-enabled save newline))
  (when (equal system-type 'darwin) (exec-path-from-shell-initialize))
  (add-hook 'ibuffer-mode-hook 'my-ibuffer-mode-hook)
  (global-hungry-delete-mode)
  )
(provide 'init_func)
;;; init_func.el ends here
