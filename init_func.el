;;; Requires
(require 'cl-lib)
;;; Code
(defun kill-word-at-point ()
  "Kill the word under cursor"
  (interactive)
  (let ((bound (bounds-of-thing-at-point 'word)))
    (kill-region (car bound) (cdr bound))))

(defun buffer-line-count ()
  "Return the number of lines in this buffer."
  (count-lines (point-min) (point-max)))

(defun goto-random-line ()
  "Go to a random line in this buffer."
  (interactive) ;; (buffer-line-count)
  (goto-line (1+ (random (buffer-line-count)))))

(defun setup-markup ()
  (interactive)
  (use-local-map (copy-keymap text-mode-map))
  (local-set-key [right] 'markup-fnplus)
  (define-derived-mode my-derived-mode text-mode
    (setq font-lock-defaults
	  '('(("text: " . font-lock-comment-face)
              ("hypothesis: " . font-lock-constant-face)
              ("entailed: .*" . font-lock-keyword-face)
              )))
    (setq mode-name "MY-DERIVED-MODE"))
  (my-derived-mode)
  )

(defun markup-fnplus ()
  (interactive)
  (goto-random-line)
  (re-search-forward "partof:")
  (forward-line 1)
  (recenter)
  (yas-expand-snippet ;; $$(yas-choose-value '(\"Yes\" \"No\" \"Maybe\"))
"hypothesis_grammatical: Yes
judgement_valid: Yes$0\n")
  )


;; Note the extra listing
(defun my-font-lock-derived-mode ()
  "Create a mode called my-derived-mode which has the syntax highlighting we want"
  (interactive)
  (define-derived-mode my-derived-mode fundamental-mode
    (setq font-lock-defaults
	  '('(("[a-zA-z0-9]*.mode_[0-9]" . font-lock-function-name-face)
	      ("[a-zA-z0-9]*.baseline" . font-lock-constant-face)
	      ("Total entities" . font-lock-constant-face)
              ("," . font-lock-comment-face)
              ("|" . font-lock-comment-face)
              ("http://en.wikipedia.org/wiki" . font-lock-keyword-face)
              )))
    (setq mode-name "MY-DERIVED-MODE"))
  (my-derived-mode))

(defmacro measure-time (&rest body)
  "Macro to measure time. Wrap function call as body of this macro."
  ;; Example : (measure-time
  ;; (cl-loop for i from 1 to 10 collect (json-encode-string ss)))
 `(let ((time (current-time)))
    ,@body
    (message "%.06f" (float-time (time-since time)))))

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

(defun my-nxml-mode-hook ()
  (hs-minor-mode 1)
  (add-to-list 'hs-special-modes-alist
               '(nxml-mode
                 "<!--\\|<[^/>]*[^/]>"
                 "-->\\|</[^/>]*[^/]>"
                 "<!--"
                 sgml-skip-tag-forward
                 nil))
  (define-key nxml-mode-map (kbd "C-c h") 'hs-toggle-hiding)
  )


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
  (font-lock-add-keywords
   nil
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

(defun magit-stage-commit-push (arg)
  "Push whatever can be pushed upstream.
   Then if the repo can be staged then stage it and commit it.
   If Ctrl-U is prefixed then only stage the current file and commit that."
  (interactive "P") ;; Note that interactive requires an argument.
  (magit-push-current-to-upstream nil)
  (if arg
      (magit-stage-modified)
    (magit-stage-file (buffer-file-name)))
  (when (magit-commit-assert nil)
    (magit-commit)))

(defun my-cmake-mode-hook ()
  (define-key cmake-mode-map (kbd "M-?") 'cmake-help)
  (define-key cmake-mode-map (kbd "M-h") 'cmake-help)
  (define-key cmake-mode-map (kbd "M-H") (lambda ()
                                           (interactive)
                                           (message
  "TODO: Figure out a good location for this information
  CMAKE_INSTALL_PREFIX=/a/path | Install path is /a/path
  BUILD_SHARED_LIBS=ON(1?)     | Build shared dynamic libraries
  CMAKE_BUILD_TYPE=Debug       | Generate files with debug flags
  CMAKE_C_COMPILER=icc         | Sets C language compiler to icc
  CMAKE_CXX_FLAGS=\"-O3\"        | Sets Cpp flags
  CMAKE_PREFIX_PATH=/a/path    | Search for dependencies in /a/path")))
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
      (mapconcat 'identity (list formatted-args) indent))))

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
       (insert (concat "\n" (make-string curcol ? ) "--- OUTPUT ---\n" (make-string curcol ? ) "'''"))))
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

(defun LaTeX-transpose-table (start end)
  (interactive "r")
  (goto-char start)
  (let ((last start)
        (rows (list ()))
        (nrows 0)
        (ncols 0)
        (maxcols 0))
    (while (re-search-forward "&\\|\\\\\\\\" end t)
      (setf (car rows)
            (cons (buffer-substring last (match-beginning 0)) (car rows)))
      (incf ncols)
      (when (string= "\\\\" (match-string-no-properties 0))
        (setq maxcols (max maxcols ncols))
        (setq rows (cons () rows))
        (incf nrows)
        (setq ncols 0))
      (setq last (match-end 0))
      (goto-char last))
    ;; empty row
    (setq rows (cdr rows))
    ;; now output the transposed variant
    (kill-region start end)
    (insert
      (let (i j table trow)
        (loop for j from 1 upto maxcols collect
          (loop for i from 1 upto nrows
            collect (let* ((row (nth (- nrows i) rows))
                           (cell (if row (nth (- maxcols j) row) "")))
                      (concat cell (if (< i nrows) "&" "\\\\\n")))
            into trow
            finally return (apply 'concat trow))
          into table
          finally return (apply 'concat table)))))
  (message "Old table saved to kill ring."))

(defun transpose-line-down ()
  (interactive) (beginning-of-line 2) (transpose-lines 1) (beginning-of-line 0))

(defun transpose-line-up ()
  (interactive) (transpose-lines 1) (beginning-of-line -1))

(defun my-dired-mode-hook ()
  (define-key dired-mode-map (kbd "M-DEL") 'kill-this-buffer))


(defun expose-global-binding-in-term (binding)
   (define-key term-raw-map binding
     (lookup-key (current-global-map) binding)))

(defun my-python-after-save-hook ()
  ()
  ;; (call-process-shell-command
  ;;  (concat "autopep8 --in-place " (buffer-file-name) " &")
  ;;  nil
  ;;  "*Shell Command Output*"
  ;;  nil)
  ;; (reload-buffer-no-confirm)
  )

(defun my-insert-header ()
  (and (zerop (buffer-size)) (not buffer-read-only) (buffer-file-name)
       (progn (insert "header") (message "Press [TAB] to insert header"))))


(defun python-mode-setup-tabs ()
  (interactive)
  (setq indent-tabs-mode t)
  (setq python-indent 8)
  (setq tab-width 4)
  )

(defun my-python-mode-hook ()
  ;; (run-python)
  (company-mode 1)
  (company-quickhelp-mode 1)
  ;; Minor modes.
  (auto-fill-mode 1)
  (hs-minor-mode)
  ;; Editing support
  ;; (setq pychecker-regexp-alist
  ;;       '(("\\([a-zA-Z]?:?[^:(\t\n]+\\)[:( \t]+\\([0-9]+\\)[:) \t]" 1 2)))
  (modify-syntax-entry 95 "w") ; Consider _ as part of a word.
  ;; Header maintenance
  (autoload 'auto-update-file-header "header2")
  (my-insert-header)
  (add-hook 'write-file-hooks 'auto-update-file-header nil 'make-it-local)
  (add-hook 'after-save-hook 'my-python-after-save-hook nil 'make-it-local)
  ;; Add keywords to font lock.
  (font-lock-add-keywords
   'python-mode
   '(("\\<\\(sys.argv\\)" 0 'font-lock-warning-face)
     ("\\<\\([0-9]+\\([eE][+-]?[0-9]*\\)?\\)\\>"  0 'font-lock-constant-face)
     ("\\([][{}]\\)" 0 'font-lock-builtin-face)
     ("\\([=+*/-]\\)" 0 'font-lock-builtin-face)
     ("\\<\\(QQQ\\)" 1 font-lock-warning-face t)
     ("\\<\\(TODO\\)" 1 font-lock-warning-face t)
     ("\\<\\(NOTE\\)" 1 font-lock-warning-face t)))
  ;; Add key bindings
  (define-key python-mode-map (kbd "<kp-subtract>") 'hs-hide-block)
  (define-key python-mode-map (kbd "<kp-add>") 'hs-show-block)
  (define-key python-mode-map (kbd "<C-d>") 'hungry-delete-forward)
  (define-key python-mode-map (kbd "C-?") 'elpy-doc)
  (define-key python-mode-map (kbd "C-c C-d") 'elpy-doc)
  (define-key python-mode-map (kbd "C-M-i") 'elpy-company-backend)
  ;; Bugfix
  ;; Somehow the C-c C-d key for elpy doc clashes with a key that yas sets.
  ;; If I set this value to nil then the clash does not happen any more.
  (define-key yas-minor-mode-map (kbd "C-c C-d") 'elpy-doc)
  (setq yas--direct-python-mode nil)
  )

(defun my-html-mode-hook ()
  ;;(my-insert-header)
  (define-key html-mode-map (kbd "C-p") 'save-line-to-kill-ring)
  (local-set-key (kbd "C-p") 'save-line-to-kill-ring)
  )

(defun my-sgml-mode-hook ()
  (define-key sgml-mode-map (kbd "C-c C-p") 'sgml-skip-tag-backward)
  (define-key sgml-mode-map (kbd "C-c C-n") 'sgml-skip-tag-forward)
  )

(defun my-js-mode-hook ()
  (font-lock-add-keywords
   'js-mode
   '(("\\<\\(angular\\)" 1 font-lock-keyword-face t)
     ("\\<\\(module\\)" 1 font-lock-keyword-face t)
     ("\\<\\(controller\\)" 1 font-lock-keyword-face t)
     ("\\<\\(factory\\)" 1 font-lock-keyword-face t)
     ("\\<\\(service\\)" 1 font-lock-keyword-face t))))

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
     ("\\<\\(SKIP:\\)" 1 font-lock-string-face t)
     ("\\<\\(ToProve:.*\\)" 1 font-lock-warning-face t)))
  (define-key org-mode-map (kbd "C-c C-r") 'org-refresh-everything)
  (define-key org-mode-map (kbd "<return>") 'newline-and-indent)
  (define-key org-mode-map (kbd "C-j") 'newline-and-indent)
  (define-key org-mode-map (kbd "C-=") 'text-scale-increase)
  (define-key org-mode-map (kbd "C-c q") 'org-set-tags-command)
  (define-key org-mode-map (kbd "C-c d") 'org-deadline)
  (define-key org-mode-map (kbd "C-c C-S-o") 'org-mark-ring-goto)
  (define-key org-mode-map (kbd "C-c C-o") 'org-open-at-point)
  (define-key org-mode-map (kbd "<M-up>") 'org-shiftmetaup)
  (define-key org-mode-map (kbd "<M-down>") 'org-shiftmetadown)
  (define-key org-mode-map  [f8] 'org-agenda-list)
  ;; (define-key org-mode-map (kbd "C-=") 'text-scale-increase)
  ;; (define-key org-mode-map (kbd "C-=") 'er/expand-region)
  (auto-fill-mode)
  ;; Do not set org-emphasis-alist over here. Customize it.
  ;; (setq org-emphasis-alist '(("*" bold "<b>" "</b>")
  ;;                            ("/" italic "<i>" "</i>")
  ;;                            ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
  ;;                            ("=" org-code "<code>" "</code>" verbatim)
  ;;                            ("~" org-verbatim "<code>" "</code>" verbatim)))
  )

;; (defun my-tex-mode-hook ()
;;   (font-lock-add-keywords
;;    nil
;;    '(("\\<\\(NOTE:\\)" 1 font-lock-warning-face t)
;;      ("\\<\\(TODO\\)" 1 font-lock-warning-face t)))
;;   (writegood-mode)
;;   )

(defun my-text-mode-hook ()
  (remove-dos-eol)
  )

(defun latex-add-new-list-item ()
  (interactive)
  (insert "\n\\item "))


;;; Potentially *DANGEROUS* hack
;; (defun reftex-get-bibfile-list () (reftex-default-bibliography))

(defun my-latex-mode-hook ()
  ;; (hl-sentence-mode)
  (message "running my-latex-mode-hook")
  (require 'company-auctex)
  (company-auctex-init)
  ;; Disable latex-pretty-symbols
  ;; (require #'latex-pretty-symbols)

  ;; Navigating and folding by sections.
  ;; C-c C-a `latex/compile-commands-until-done'
  ;; C-c C-n `latex/next-section'
  ;; C-M-a `latex/beginning-of-environment'
  ;; C-c C-p `latex/previous-section'
  (latex-extra-mode)

  ;; Automatically save style information when saving the buffer.
  (setq TeX-auto-save t)

  ;; Parse file after loading it if no style hook is found for it.
  (setq TeX-parse-self t)

  ;; A minor mode with easy access to TeX math macros.
  ;; Easy insertion of LaTeX math symbols.  If you give a prefix argument,
  ;; the symbols will be surrounded by dollar signs.
  (LaTeX-math-mode)

  ;; http://tex.stackexchange.com/questions/113970/emacs-auctex-customization-of-keyword-highlight-syntax
  ;; http://tex.stackexchange.com/questions/81680/emacsauctex-lost-highlighting
  ;; http://stackoverflow.com/tags/font-lock/hot
  ;; (latex-unicode-simplified) ;; This doen't work due to some mysterious reason.
  (turn-on-reftex)
  (setq reftex-default-bibliography '("~/Dropbox/Bibliography_all.bib"))
  (auto-fill-mode 1)
  (setq comment-auto-fill-only-comments nil)
  (setq reftex-plug-into-AUCTeX t)
  (flyspell-mode)
  (define-key latex-extra-mode-map (kbd "<C-return>") 'latex/compile-commands-until-done)
  (define-key latex-extra-mode-map (kbd "C-0") 'latex-add-new-list-item)
  (define-key latex-extra-mode-map (kbd "C-c 9") (lambda ()
                                                   (interactive)
                                                   (insert (reftex-reference " " t nil))))
  ;; warn every time we write would
  (font-lock-add-keywords 'latex-mode
   '(("\\<\\(TODO\\)" 1 font-lock-warning-face t)
     ("\\<\\(NOTE\\)" 1 font-lock-warning-face t)
     ("\\<\\(would\\)" 1 font-lock-warning-face t)))
  (font-lock-add-keywords 'tex-mode
   '(("\\<\\(TODO\\)" 1 font-lock-warning-face t)
     ("\\<\\(NOTE\\)" 1 font-lock-warning-face t)
     ("\\<\\(would\\)" 1 font-lock-warning-face t)))
  (orgtbl-mode)

  (tex-fold-mode 1)
  (define-key latex-extra-mode-map (kbd "C-9") 'TeX-fold-dwim)
  )

(defun my-markdown-mode-hook ()
  (orgstruct-mode))

(defun my-prog-mode-hook ()
  ;; (eldoc-mode)
  ;; (if (display-graphic-p)
  ;;     ;; (highlight-indent-guides-mode) ;; Too ugly
  ;;     ;; (progn (fci-mode) )
  ())

(defun my-ess-mode-hook ()
  (ess-set-style 'C++ 'quiet)
  (ess-toggle-underscore nil)
  ;; (setq ess-smart-S-assign-key ";")
  ;; Because
  ;;                                 DEF GNU BSD K&R C++
  ;; ess-indent-level                  2   2   8   5   4
  ;; ess-continued-statement-offset    2   2   8   5   4
  ;; ess-brace-offset                  0   0  -8  -5  -4
  ;; ess-arg-function-offset           2   4   0   0   0
  ;; ess-expression-offset             4   2   8   5   4
  ;; ess-else-offset                   0   0   0   0   0
  ;; ess-close-brace-offset            0   0   0   0   0
  (add-hook 'local-write-file-hooks
            (lambda ()
              (ess-nuke-trailing-whitespace))))

(defun un-camelcase-string (s &optional sep start)
  "Convert CamelCase string S to lower case with word separator SEP.
   Default for SEP is a hyphen. If third argument START is non-nil,
   convert words after that index in STRING."
  (let ((case-fold-search nil))
    (while (string-match "[A-Z]" s (or start 1))
      (setq s (replace-match (concat (or sep "-")
                                     (downcase (match-string 0 s)))
                             t nil s)))
    (downcase s)))

(defun mark-file-at-point-as-executable ()
  (interactive)
  (call-process-shell-command
   (concat "chmod +x " (thing-at-point 'filename))
   nil
   "*Shell Command Output*"
   nil)
  )

(defun create-file-at-point ()
  (interactive)
  (call-process-shell-command
   (concat "touch " (thing-at-point 'filename))
   nil
   "*Shell Command Output*"
   nil)
  )

(defun my-find-file-at-point-wrapper (arg)
  "Press M-2 to split window vertically"
  (interactive "P")
  (when (eq arg 3) (split-window-horizontally))
  (when (eq arg 2) (split-window-below))
  (find-file-at-point)
  )

(defun my-mu4e-setup ()
  ;; http://www.ict4g.net/adolfo/notes/2014/12/27/EmacsIMAP.html
  ;; http://manifold.io/blog/setting-up-mu4e
  (setq
   mail-user-agent 'mu4e-user-agent             ;; set mu4e as default mail client
   mu4e-maildir "/Users/pushpendrerastogi/.mail"                 ;; root mail directory
   mu4e-attachments-dir "/Users/pushpendrerastogi/.mail_attachments"
   mu4e-get-mail-command "mbsync -q -a"         ;; update command
   mu4e-update-interval (* 60 60)                ;; update database every sixty minutes
   message-send-mail-function 'message-send-mail-with-sendmail ;; use smtpmail (bundled with emacs) for sending
   sendmail-program "msmtp"
   smtpmail-debug-info t                        ;; optionally log smtp output to a buffer
   message-kill-buffer-on-exit t                ;; close sent message buffers
   mu4e-headers-fields '((:flags      . 4)      ;; customize list columns
                         (:from       . 20)
                         (:human-date . 10)
                         (:subject))
   mu4e-change-filenames-when-moving t ;; for mbsync
   mu4e-context-policy 'pick-first     ;; pick first context automatically on launch
   mu4e-compose-context-policy nil     ;; use current context for new mail
   mu4e-confirm-quit           nil
   mu4e-html2text-command "w3m -dump -T text/html"
   mu4e-drafts-folder "/local/drafts"
   mu4e-sent-folder "/local/sent"
   mu4e-trash-folder "/local/trash"
   mu4e-view-prefer-html t
   mu4e-view-show-images t
   mu4e-compose-signature "Thanks,\nPushpendre\n"
   )
  (add-to-list
   'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)
  (setq
   user-mail-address "pushpendre@gmail.com"
   user-full-name  "Pushpendre Rastogi"
  )
  ;; https://github.com/iqbalansari/mu4e-alert
  (mu4e-alert-set-default-style 'notifier)
  (mu4e-alert-enable-mode-line-display)
  (mu4e-alert-enable-notifications)
  )

(defun setup-el-get ()
  "docstring"
  ;; (add-to-list 'load-path "~/.emacs.d/el-get/textlint-recipe/")
  (add-to-list 'load-path "~/.emacs.d/el-get/el-get")
  (unless (require 'el-get nil 'noerror)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
  (el-get 'sync)
  )

(defun my-after-init-hook ()
  (require 'package)
  (package-initialize)
  (add-to-list 'load-path "~/.emacs.d/snippets")
  (add-package-managers)
  (require 'yasnippet)
  (yas-minor-mode-on) ;; It's possible to add this to prog-mode hook instead
  (yas-global-mode 1)
  (recentf-mode 1)
  (global-flycheck-mode)
  (setq flycheck-check-syntax-automatically '(mode-enabled save newline))
  (when (equal system-type 'darwin) (exec-path-from-shell-initialize))
  (add-hook 'ibuffer-mode-hook 'my-ibuffer-mode-hook)
  (global-hungry-delete-mode)
  (load "auctex.el" nil t t)
  ;;(setq tags-case-fold-search nil)
  (setq ido-ignore-buffers
	'("\\` " "*Messages*" "*GNU Emacs*" "*Calendar*" "*Completions*" "TAGS"
          "*Flycheck error message*" "*Ediff Registry*"
          "*Ibuffer*" "*epc con " "#" "*Help*" "*tramp"
          "*anaconda-mode*" "*anaconda-doc*" "*info*"
          "*Shell Command Output*" "*Compile-Log*" "*Python*"
          "*notes*" "*Reftex Select*" "*Shell Command Output*"
          "*.+ output*" "*TeX Help*"))
  (setq ido-ignore-files '("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./"))
  (setq exec-path (append exec-path '("/usr/local/bin")))
  (setq org-src-fontify-natively t)
  (setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
        backup-by-copying t    ; Don't delink hardlinks
        version-control t      ; Use version numbers on backups
        delete-old-versions t  ; Automatically delete excess backups
        kept-new-versions 20   ; how many of the newest versions to keep
        kept-old-versions 5    ; and how many of the old
        )
  ;;(org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))
  (require 'smartparens-config)
  (smartparens-global-mode 1)
  (menu-bar-mode -1)
  (kill-buffer "*scratch*")
  (winner-mode 1)
  )

(provide 'init_func)
;;; init_func.el ends here
