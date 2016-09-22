;;; Requires
(require 'cl-lib)
;;; Code

(defmacro measure-time (&rest body)
  "Macro to measure time. Wrap function call as body of this macro."
  ;; Example : (measure-time
  ;; (cl-loop for i from 1 to 10 collect (json-encode-string ss)))
 `(let ((time (current-time)))
    ,@body
    (message "%.06f" (float-time (time-since time)))))

;; Override the default json encoding mechanism because it is too slow.
(eval-after-load "json"
  '(defun json-encode-string (string)
     "Return a JSON representation of STRING."
     (with-temp-buffer
       (insert string)
       (goto-char (point-min))
       ;; Skip over ASCIIish printable characters.
       (while (re-search-forward "\\([\"\\/\b\f\n\r\t]\\)\\|[^ -~]" nil t)
         (let ((c (char-before)))
           (replace-match
            (if (match-beginning 1)
                ;; Special JSON character (\n, \r, etc.).
                (string ?\\ (car (rassq c json-special-chars)))
              ;; Fallback: UCS code point in \uNNNN form.
              (format "\\u%04x" c))
            t t)))
       (concat "\"" (buffer-string) "\""))))

;; Remove the pesky pre-command-refresh function from the pre-command-hook
;; that eldoc mode unnecessarily adds.
;; (eval-after-load "eldoc"
;;   '(add-hook 'pre-command-hook 'eldoc-pre-command-refresh-echo-area t nil))
;; (eval-after-load "eldoc"
;;   '(add-hook 'pre-command-hook 'eldoc-pre-command-refresh-echo-area nil t))

(defun my-generate-tags ()
  (interactive)
  (shell-command
   (read-string
    "CTAG CMD : "
    (format "ctags -e -R --extra=+fq --exclude=db --exclude=test --exclude=.git -a -f TAGS --language-force=%s ./" mode-name)
    ))
  (visit-tags-table "TAGS"))

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

;; http://endlessparentheses.com/fixing-double-capitals-as-you-type.html
;; http://emacs.stackexchange.com/q/13970/50
;; Note that this mode automatically changes words that start with two
;; caps to single cap like THe -> The but it does not change THE.
(defun dcaps-to-scaps ()
  "Convert word in DOuble CApitals to Single Capitals."
  (interactive)
  (and (= ?w (char-syntax (char-before)))
       (save-excursion
         (and (if (called-interactively-p)
                  (skip-syntax-backward "w")
                (= -3 (skip-syntax-backward "w")))
              (let (case-fold-search)
                (looking-at "\\b[[:upper:]]\\{2\\}[[:lower:]]"))
              (capitalize-word 1)))))

(define-minor-mode dubcaps-mode
  "Toggle `dubcaps-mode'.  Converts words in DOuble CApitals to
Single Capitals as you type."
  :init-value nil
  :lighter (" DC")
  (if dubcaps-mode
      (add-hook 'post-self-insert-hook #'dcaps-to-scaps nil 'local)
    (remove-hook 'post-self-insert-hook #'dcaps-to-scaps 'local)))

;; http://endlessparentheses.com/ispell-and-abbrev-the-perfect-auto-correct.html
;; Basically this setting gradually learns from your mistakes and maps
(defun endless/ispell-word-then-abbrev (p)
  "Call `ispell-word', then create an abbrev for it.
With prefix P, create local abbrev. Otherwise it will
be global."
  (interactive "P")
  (let ((bef (downcase (or (thing-at-point 'word)
                           "")))
        aft)
    (call-interactively 'ispell-word)
    (setq aft (downcase
               (or (thing-at-point 'word) "")))
    (unless (or (string= aft bef)
                (string= aft "")
                (string= bef ""))
      (message "\"%s\" now expands to \"%s\" %sally"
               bef aft (if p "loc" "glob"))
      (define-abbrev
        (if p local-abbrev-table global-abbrev-table)
        bef aft))))

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

(defun add-css-jekyll ()
  "Shows the full path file name in the minibuffer an dcopies it to kill-ring"
  (interactive)
  (message "Create a _sass/<NAME>.scss file and import it from css/main.scss" )
)

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


(defun my-sgml-mode-hook ()
  (setq flyspell-generic-check-word-predicate 'sgml-mode-flyspell-verify)
  (setq flyspell-issue-message-flag nil)
					;(flyspell-mode 1)
  (setq case-fold-search nil)
  (modify-syntax-entry 92 "w" sgml-mode-syntax-table))

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

(defun my-makefile-mode-hook ()
  "Hooks for Makefile mode."
  (font-lock-add-keywords nil '(("\\<\\(TARGET\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\<\\(EXPECTATION\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\<\\(OPTIONS\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\<\\(SOURCE\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\<\\(EXAMPLE\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\([#]\\)" 1 font-lock-warning-face t)))
  (auto-fill-mode)
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
  (if (display-graphic-p) (fci-mode) ())
  (company-mode -1)
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

(defun python-split-args (arg-string)
  "Split a python argument string into ((name, default)..) tuples"
  (mapcar (lambda (x)
             (split-string x "[[:blank:]]*=[[:blank:]]*" t))
          (split-string arg-string "[[:blank:]]*,[[:blank:]]*" t)))


(defun python-args-to-docstring-impl (yas-text)
  (let* ((indent (concat "\n" (make-string (current-column) 32)))
         (args (cl-remove-if
                (lambda (x) (or (string-equal (car x) "self")
                                (string-equal (car x) "cls")))
                (python-split-args yas-text)))
         (max-len (if args
                      (apply 'max (mapcar (lambda (x) (length (nth 0 x))) args))
                    0))
         (formatted-args (mapconcat
                (lambda (x)
                   (concat (nth 0 x) (make-string (- max-len (length (nth 0 x))) ? ) " : "
                           (if (nth 1 x) (concat "\(default " (nth 1 x) "\)"))))
                args
                indent)))
    (unless (string= formatted-args "")
      (mapconcat 'identity (list "Params" "------" formatted-args) indent))))

(defun python-args-to-docstring ()
  "return docstring format for the python arguments in yas-text"
  (python-args-to-docstring-impl yas-text))

(defun python-param-populator ()
  "The python-args-to-docstring-impl function is inside
   elpa/yasnippet-20150318.348/snippets/python-mode/.yas-setup.el"
  (save-excursion
    (let ((arg-start nil) (arg-end nil) (curcol (current-column)))
       (save-excursion
          (python-nav-beginning-of-defun)
          (move-end-of-line nil)
          (backward-char)
          (setq arg-end (- (point) 1))
          (backward-sexp)
          (setq arg-start (+ 1 (point)))
          )
       (insert "'''\n")
       (insert (make-string curcol ? ))
       (insert (python-args-to-docstring-impl (buffer-substring arg-start arg-end)))
       (insert (concat "\n" (make-string curcol ? ) "Returns\n" (make-string curcol ? ) "-------\n" (make-string curcol ? ) "'''"))))
  (move-end-of-line nil))

(defun insert-4-space ()
  (interactive)
  (insert (make-string 4 ? )))

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(defun transpose-line-down ()
  (interactive) (beginning-of-line 2) (transpose-lines 1) (beginning-of-line 0))

(defun transpose-line-up ()
  (interactive) (transpose-lines 1) (beginning-of-line -1))

(defun my-dired-mode-hook ()
  (define-key dired-mode-map (kbd "M-DEL") 'kill-this-buffer))

(defun my-python-after-save-hook ()
  (shell-command (concat "autopep8 --in-place " (buffer-file-name)))
  (reload-buffer-no-confirm))

(defun my-python-mode-hook ()
  (setq pychecker-regexp-alist '(("\\([a-zA-Z]?:?[^:(\t\n]+\\)[:( \t]+\\([0-9]+\\)[:) \t]" 1 2)))
  (add-to-list 'company-backends 'company-anaconda)
  (run-python "python")
  (anaconda-mode)
  (orgtbl-mode)
  (autoload 'auto-update-file-header "header2")
  (and (zerop (buffer-size)) (not buffer-read-only) (buffer-file-name)
       (progn (insert "header") (message "Press [TAB] to insert header")))
  (add-hook 'write-file-hooks 'auto-update-file-header nil 'make-it-local)
  (add-hook 'after-save-hook 'my-python-after-save-hook nil 'make-it-local)
  (font-lock-add-keywords
   'python-mode
   '(("\\<\\(sys.argv\\)" 0 'font-lock-warning-face)
     ("\\<\\([0-9]+\\([eE][+-]?[0-9]*\\)?\\)\\>"  0 'font-lock-constant-face)
     ("\\([][{}]\\)" 0 'font-lock-builtin-face)
     ("\\([=+*/-]\\)" 0 'font-lock-builtin-face)
     ("\\<\\(QQQ\\)" 1 font-lock-warning-face t)
     ("\\<\\(TODO\\)" 1 font-lock-warning-face t)
     ("\\<\\(NOTE\\)" 1 font-lock-warning-face t)))
  (auto-fill-mode 1)
  (eldoc-mode)
  (hs-minor-mode)
  (define-key python-mode-map (kbd "<H-left>") 'hs-hide-block)
  (define-key python-mode-map (kbd "<H-right>") 'hs-show-block)
  (define-key python-mode-map (kbd "<C-d>") 'hungry-delete-forward)
  )

(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

(defun my-yaml-mode-hook ()
  (abbrev-mode -1))

(defun my-org-mode-hook ()
  (font-lock-add-keywords
   nil
   '(("\\<\\(NOTE:\\)" 1 font-lock-warning-face t)
     ("\\<\\(TODO\\)" 1 font-lock-warning-face t)
     ("\\<\\(GOAL:\\)" 1 font-lock-string-face t)
     ("\\<\\(UTILITY:\\)" 1 font-lock-string-face t)
     ("\\<\\(PROOF:\\)" 1 font-lock-string-face t)
     ("\\<\\(GUESS:\\)" 1 font-lock-string-face t)
     ("\\<\\(ToProve:.*\\)" 1 font-lock-warning-face t)))
  (writegood-mode -1)
  (define-key org-mode-map (kbd "C-c C-r") 'org-refresh-everything)
  (define-key org-mode-map (kbd "C-c q") 'org-set-tags-command)
  (define-key org-mode-map (kbd "C-c C-S-o") 'org-mark-ring-goto)
  (define-key org-mode-map (kbd "C-c C-o") 'org-open-at-point)
  ;; (define-key org-mode-map (kbd "C-=") 'text-scale-increase)
  ;; (define-key org-mode-map (kbd "C-=") 'er/expand-region)
  (auto-fill-mode)
  (setq org-emphasis-alist '(("*" bold "<b>" "</b>")
                             ("/" italic "<i>" "</i>")
                             ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
                             ("=" org-code "<code>" "</code>" verbatim)
                             ("~" org-verbatim "<code>" "</code>" verbatim)))
  )

(defun my-tex-mode-hook ()
  (font-lock-add-keywords
   nil
   '(("\\<\\(NOTE:\\)" 1 font-lock-warning-face t)
     ("\\<\\(TODO\\)" 1 font-lock-warning-face t)))
  (writegood-mode))

(defun my-text-mode-hook ()
  (remove-dos-eol)
  ;; (auto-fill-mode)
  (writegood-mode)
  )

(defun my-latex-mode-hook ()
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq reftex-plug-into-AUCTeX t)
  (flyspell-mode)
  (LaTeX-math-mode)
  (turn-on-reftex)
  (auto-fill-mode)
  (writegood-mode)
  (require 'company-auctex)
  (company-auctex-init)
  (define-key latex-mode-map (kbd "<C-return>") 'latex-insert-item)
  (setq comment-auto-fill-only-comments nil)
  )

(defun my-after-init-hook ()
  (require 'yasnippet)
  (add-package-managers)
  (recentf-mode 1)
  (global-company-mode 1)     ;; Company mode globally is a visual autocompletion mode.
  ;; (global-flycheck-mode)
  (setq flycheck-check-syntax-automatically '(mode-enabled save newline))
  (when (equal system-type 'darwin) (exec-path-from-shell-initialize))
  (add-hook 'ibuffer-mode-hook 'my-ibuffer-mode-hook)
  (global-hungry-delete-mode)
  (load "auctex.el" nil t t)
  (setq tags-case-fold-search nil)
  (setq ido-ignore-buffers
  	'("\\` " "*Messages*" "*GNU Emacs*" "*Calendar*" "*Completions*" "TAGS" "*magit-process*" "*Flycheck error message*" "*Ediff Registry*" "*Ibuffer*" "*epc con " "#" "*magit" "*Help*" "*tramp" "*anaconda-mode*" "*anaconda-doc*" "*info*" "*Shell Command Output*" "*Python*"))
  (setq ido-ignore-files '("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./"))
  (autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
  (autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
  (setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))
  (setq exec-path (append exec-path '("/usr/local/bin")))
  (setq org-src-fontify-natively t)
  (setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
        backup-by-copying t    ; Don't delink hardlinks
        version-control t      ; Use version numbers on backups
        delete-old-versions t  ; Automatically delete excess backups
        kept-new-versions 20   ; how many of the newest versions to keep
        kept-old-versions 5    ; and how many of the old
        )
  (setq org-plantuml-jar-path
        (expand-file-name "~/.emacs.d/plantuml.jar"))
  (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))
  (require 'expand-region)
  (global-set-key (kbd "C-=") 'er/expand-region)
  ;; http://draketo.de/light/english/free-software/read-your-python-module-documentation-emacs
  ;; https://bitbucket.org/jonwaltman/pydoc-info
  (require 'pydoc-info)
  (pydoc-info-add-help '("python" "theano" "pylearn2" "Lasagne"))
  (add-to-list 'load-path "~/.emacs.d/mymodes")
  (require 'yaml-mode)
  (require 'math-symbol-lists)
  (quail-define-package "math" "UTF-8" "Ω" t)
  (quail-define-rules ; Manual overrides for the Tex Input method
   ("\\from"    #X2190)
   ("\\to"      #X2192)
   ("\\lhd"     #X22B2)
   ("\\rhd"     #X22B3)
   ("\\unlhd"   #X22B4)
   ("\\unrhd"   #X22B5))
  (mapc (lambda (x)
        (if (cddr x)
            (quail-defrule (cadr x) (car (cddr x)))))
        (append math-symbol-list-basic math-symbol-list-extended))
  (add-to-list 'load-path "~/.emacs.d/matlab-emacs/")
  (require 'matlab-load)
  (add-to-list 'auto-mode-alist  '("\\.m$" . matlab-mode))
  ;; (matlab-cedet-setup)
  (yas-global-mode 1)
  )
(provide 'init_func)
;; Set line spacing http://stackoverflow.com/questions/5061321/letterspacing-in-gnu-emacs
;; or use customize-face and set height to 100.
;;; init_func.el ends here
