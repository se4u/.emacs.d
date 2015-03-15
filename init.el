(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/elpa")
(add-to-list 'load-path "~/.emacs.d/elpa/smex-3.0" "~/.emacs.d/elpa/igrep-2.113" )
(add-to-list 'load-path "~/.emacs.d/elpa/icicles-20140115.354")
(add-to-list 'load-path "~/.emacs.d/elpa/yaml-mode-20140824.2132")
(add-to-list 'load-path "~/.emacs.d/elpa/flx-20140921.739")
(add-to-list 'load-path "~/.emacs.d/async")
(add-to-list 'load-path "~/.emacs.d/helm")
(add-to-list 'load-path "~/.emacs.d/cl-lib")
(add-to-list 'load-path "~/.emacs.d/elpa/flymake-0.4.16")
; http://raebear.net/comp/emacscolors.html
; The list of colors available on emacs unix
(require 'helm-config)
(require 'python)
(require 'package)
(require 'dired-x)
(require 'org-latex)
(require 'smex)
(require 'ido)
(require 'flymake-cursor)
(require 'ska-skel-matlab)
(require 'yaml-mode)
;(require 'flymake-settings)
;(require 'c-eldoc)
(require 'cl-lib)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
;(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(semantic-mode 1)

(global-set-key [f4] 'flymake-goto-next-error)

(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      (list "pyflakes" (list local-file))))
  
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-pyflakes-init)))

(add-hook 'find-file-hook 'flymake-find-file-hook)

;; (require 'flx)
;; (require 'flx-ido)
(defvar font-lock-operator-face 'font-lock-operator-face)
(defface font-lock-operator-face ()
  "Basic face for highlighting."
  :group 'basic-faces)

(set-face-foreground 'font-lock-operator-face "red")

(font-lock-add-keywords
 'python-mode
 '(("\\<\\(sys.argv\\)" 0 'font-lock-warning-face)
   ("\\<\\(TODO\\)" 0 'font-lock-constant-face)
   ("\\([0123456789]\\)"  0 'font-lock-constant-face)
   ("\\([][{}]\\)" 0 'font-lock-builtin-face)
   ("\\([=+*/-]\\)" 0 'font-lock-builtin-face)))

(defun sarcasm-makefile-mode-hook ()
  "Hooks for Makefile mode."
  (font-lock-add-keywords nil
			  '(("\\<\\(TARGET\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\<\\(SOURCE\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil
			  '(("\\<\\(EXAMPLE\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil
			  '(("\\([#]\\)" 1 font-lock-warning-face t)))
  )

(add-hook 'makefile-gmake-mode-hook 'sarcasm-makefile-mode-hook)
(add-hook 'makefile-bsdmake-mode-hook 'sarcasm-makefile-mode-hook)
(ido-mode t)



;(add-hook 'c-mode-hook 'c-turn-on-eldoc-mode)
;(add-hook 'c++-mode-hook 'c-turn-on-eldoc-mode)
(add-hook 'c-mode-common-hook
	  (progn 
	    (lambda () (define-key c-mode-base-map "\C-m" 'newline-and-indent))
	    (lambda () (c-toggle-auto-state 1))
	    (lambda () (c-toggle-hungry-state 1)) 
	    )
	  )
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(ido-mode t)
(ido-everywhere 1)
;; (flx-ido-mode 1)
;; ;; disable ido faces to see flx highlights.
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-faces nil)
;; (setq flx-ido-use-faces nil)
(global-set-key [?\M-}] 'mark-sexp)
(global-set-key [?\C-x ?p] 'previous-multiframe-window)
(define-skeleton python-header
  "Insert author name, date created, description, and file name"
  "Module Description: "
  "\"\"\"" str \n
  "\"\"\"" \n
  (format "__date__    = \"%s\"\n" (format-time-string "%d %B %Y"))
  (format "__author__  = \"%s\"\n" (user-full-name))
  "__contact__ = \"pushpendre@jhu.edu\"\n")
(add-hook 'find-file-hook 'auto-insert)
(setq auto-insert-alist '((python-mode . python-header)))
(setq auto-insert-query nil)
;; (eval-after-load 'autoinsert
;;   '(define-auto-insert '(matlab-mode . "Matlab skeleton") ska-skel-matlab-function))
(recentf-mode 1)
(defun recentf-ido-find-file ()
  "Find a recent file using Ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))
(global-set-key [?\C-x ?f] 'recentf-ido-find-file)

;; Any add to list for package-archives (to add marmalade or melpa) goes here
(add-to-list 'package-archives 
	     '("marmalade" .
	       "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/")
	     'APPEND)
(package-initialize)

(smex-initialize)
(global-set-key (kbd "M-x") 'smex)


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


(setq ediff-split-window-function 'split-window-horizontally)

;;(global-set-key (kbd "M-=") '(lambda () (interactive) (progn (org-return-indent) (insert "==> "))))
(global-set-key (kbd "M-=") 'end-of-buffer)


(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
	     '("article"
	       "\\documentclass{article}"
	       ("\\section{%s}" . "\\section*{%s}")))


;;(add-to-list 'load-path "~/.emacs.d/org-blog-sitemap")

(defun active-learn-publishing-completion ()
  "Set file permissions and clean up after publishing"
  (progn
    (shell-command "chmod 644 ~/public_html/*.html")
    ;;    (ignore-errors (shell-command "mv -f ~/public_html/sitemap.html ~/public_html/index.html"))
    (shell-command "rm ~/Dropbox/org/.*.orgx")
    ))

(setq org-publish-project-alist
      (list
       '("active-learn" 
	 :base-directory "~/Dropbox/org/"
	 :base-extension "org"
	 :publishing-directory "~/public_html"
	 :exclude "morepersonal.org"
	 :publishing-function org-publish-org-to-html
	 :auto-sitemap t
	 :sitemap-sort-files "anti-chronologically"
	 :makeindex nil
	 :auto-preamble t
	 :with-section-numbers nil
	 :completion-function active-learn-publishing-completion
	 ;;:sitemap-function org-blog-export
	 ;;sitemap-title
	 ;;sitemap-filename
	 )))



(add-hook 'org-mode-hook
	  (lambda ()
	    (font-lock-add-keywords nil
				    '(("\\<\\(QQQ\\)" 1 font-lock-warning-face t)
				      ("\\<\\(BOOKMARK\\)" 1 font-lock-warning-face t)
				      ("\\<\\(TODO\\)" 1 font-lock-warning-face t)))))

;;(setq custom-file "~/.emacs.d/pushpendrerastogi_custom.el")
;;(load custom-file)

(if
    (string= system-type "darwin")
    (set-default-font "-apple-Consolas-medium-normal-normal-*-*-*-*-*-m-0-iso10646-1")
  (if (ignore-errors (set-default-font "Consolas")) 'true (set-default-font "Liberation Mono"))
  )

(set-face-attribute 'default nil :height 150)

(server-start)
(setq ring-bell-function (lambda () (message "*beep*")))

(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

(winner-mode 1)
(column-number-mode 1)
(kill-buffer "*scratch*")
(menu-bar-mode -1)
(eval-after-load "flyspell"  '(defun flyspell-mode (&optional arg))) ;;disable flyspell
(setq truncate-lines nil)
(setq browse-url-mailto-function 'browse-url-generic)
(setq browse-url-generic-program "open")
(setq shift-select-mode t)
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
	    '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))
(set-frame-parameter (selected-frame) 'alpha '(100 100));; This actually sets alpha
;;(electric-pair-mode 1)
(transient-mark-mode 1)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline (concat org-directory "/gtd.org") "Tasks")
	 "* TODO %?\n %i\n")
	))

(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
		  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
		  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
;;(multi-web-global-mode 1)

;; Make hidden Info text visible.
(set-variable 'Info-hide-note-references nil nil)

(defun save-and-kill-this-buffer ()
  "Saves and kills buffer without asking for confirmation"
  (interactive)
  (save-buffer)
  (kill-this-buffer)
  )

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

(global-set-key [?\C-c ?r] (quote reload-buffer-no-confirm))
(global-set-key [?\C-c ?\C-r] (quote revert-buffer-no-confirm))
(global-set-key [apps] 'hippie-expand)
(global-set-key [?\M-1] 'shell-command)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; AM ANNOTATE



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

(eval-after-load "sgml-mode" '(progn
				(define-key sgml-mode-map (kbd "C-\\") 'sgml-close-tag)
				(define-key sgml-mode-map (kbd "<C-delete>") 'sgml-delete-tag)
				(define-key sgml-mode-map [?\C-v] 'sgml-validate)
				(define-key sgml-mode-map (kbd "C--") 'sgml-tags-invisible)
					;(define-key sgml-mode-map (kbd "C-r") 'am-annotate-and-close-tag)
				(define-key sgml-mode-map (kbd "C-]") 'surround-selected-text-with-tag)
				(define-key sgml-mode-map (kbd "C-t") 'am-annotate-tag)
				(define-key sgml-mode-map (kbd "M-.") 'end-of-buffer)
				(define-key sgml-mode-map (kbd "M-,") 'beginning-of-buffer)
				(define-key sgml-mode-map (kbd "C-.") 'end-of-buffer)
				(define-key sgml-mode-map (kbd "C-,") 'beginning-of-buffer)
				(define-key sgml-mode-map (kbd "C-p") 'previous-line)
				(define-key sgml-mode-map (kbd "C-=") 'surround-all-names-and-msp-with-tags)
				(define-key sgml-mode-map (kbd "C-+") 'surround-all-sms-language)
				(define-key sgml-mode-map (kbd "<tab>") 'right-word)
				(define-key sgml-mode-map (kbd "<backtab>") 'left-word)
				(define-key sgml-mode-map (kbd "<C-return>") 'hippie-expand)
				(define-key sgml-mode-map (kbd "M-=") (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([67108896 C-right 134217847 C-left 60 99 97 112 32 99 111 114 114 61 34 134217836 34 62 25 60 47 99 97 112 right 4] 0 "%d")) arg)))
				(define-key sgml-mode-map (kbd "<f11>") (lambda (&optional arg) "Keyboard macro." (interactive "p") (save-buffer) (kmacro-exec-ring-item (quote ([24 111 down 111] 0 "%d")) arg)))
					;(define-key sgml-mode-map (kbd "C-k") 'quickly-kill)
				))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;TO STUDY

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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;; GENERAL
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

(defun key (desc)
  (or (and window-system (read-kbd-macro desc))
      (or (cdr (assoc desc real-keyboard-keys))
          (read-kbd-macro desc))))

(defconst real-keyboard-keys
  '(("M-<up>"        . [27 up])
    ("M-<down>"      . [27 down])
    ("M-p"           . "p")
    ("M-n"           . "n")
    ("C-S-p"         . "")
    ("C-S-r"         . ""))
  "An assoc list of pretty key strings                                                                                                                 
and their terminal equivalents.")

(defadvice quit-window (before quit-window-always-kill)
  "When running `quit-window', always kill the buffer."
  (ad-set-arg 0 t))
(ad-activate 'quit-window)

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

(defun close-and-kill-next-pane ()
  "Switch to next pane, close buffer, kill window"
  (interactive)
  (other-window 1)
  (kill-buffer-and-window))

(defun select-next-window ()
  "Switch to the next window"
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  "Switch to the previous window"
  (interactive)
  (select-window (previous-window)))

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

(global-set-key (kbd "M-s /") 'my-multi-occur-in-matching-buffers)
(global-set-key [f4] 'forward-paragraph)
(global-set-key (key "C-]") 'enlarge-window)

(global-set-key [f12] 'select-next-window)
(global-set-key (key "M-p") 'backward-paragraph)
(global-set-key (key "M-n") 'forward-paragraph)
(global-set-key (key "M-[") 'backward-sexp)
(global-set-key (key "M-]") 'forward-sexp)
(global-set-key [?\C-x ?\C-k] 'ido-kill-buffer)
(global-set-key [?\C-=] 'text-scale-increase)
(global-set-key [?\M-k] 'pop-tag-mark)
(global-set-key (key "M-<up>") 'org-metaup)
(global-set-key (key "M-<down>") 'org-metadown)
(global-set-key [?\C-c ?l] 'org-store-link)
(global-set-key [?\C-c ?c] '(lambda () (interactive) (org-capture nil "t")))
(global-set-key [?\C-c ?a] 'org-todo-list)
(global-set-key [?\C-c ?b] 'org-iswitchb)
(global-set-key "" 'newline-and-indent)
(global-set-key [?\C-a] 'back-to-indentation)
(global-set-key [f1] (quote call-last-kbd-macro))
(global-set-key [home] 'back-to-indentation)
(global-set-key [?\C-x ?9] 'close-and-kill-next-pane)
(global-set-key [?\C-p] 'save-line-to-kill-ring)
(add-hook 'find-file-hook 'find-file-check-line-endings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TAGS
(defadvice find-tag (around refresh-etags activate)
  "Rerun etags and reload tags if tag not found and redo find-tag.
If buffer is modified, ask about save before running etags."
  (let ((extension (file-name-extension (buffer-file-name))))
    (condition-case err
	ad-do-it
      (error (and (buffer-modified-p)
		  (not (ding))
		  (y-or-n-p "Buffer is modified, save it? ")
		  (save-buffer))
	     (make-tags extension)
	     ad-do-it))))

(defun make-tags (&optional extension)
  "Run etags on all peer files in current dir and reload them silently."
  (interactive)
  (shell-command (format "etags *.%s" (or extension "el")))
  (let ((tags-revert-without-query t))  ; don't query, revert silently          
    (visit-tags-table default-directory nil)))
(global-set-key [?\M-8] 'pop-tag-mark)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; MATLAB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;; PYTHON
(defun run-python-new ()
  "Spawn a new python shell - we must rename the existing python shell from *python* to something else"
  (run-python nill nil t)
  )

(defun py-execute-current-line ()
  "Execute the current line assuming it's python"
  (interactive)
  (progn
    (python-send-region (line-beginning-position) (line-end-position))
    (message "Ran line in python")))

(defun pychecker ()
  "Run pychecker against the file behind the current buffer after                                                                                      
  checking if unsaved buffers should be saved."
  (interactive)
  (let* ((file (buffer-file-name (current-buffer)))
	 (command (concat "pychecker \"" file "\"")))
    (save-some-buffers (not compilation-ask-about-save) nil) ; save  files.                                                               
    (compile-internal command "No more errors or warnings" "pychecker"
		      nil pychecker-regexp-alist)))

(add-hook 'python-mode-hook
          (lambda ()
            (setq pychecker-regexp-alist '(("\\([a-zA-Z]?:?[^:(\t\n]+\\)[:( \t]+\\([0-9]+\\)[:) \t]" 1 2)))))

(eval-after-load "python-mode" '(define-key python-mode-map [?\C-r] 'py-execute-current-line)) 

(defun org-transpose-table-at-point ()
  "Transpose orgmode table at point, eliminate hlines."
  (interactive)
  (let ((contents (apply #'mapcar* #'list    ;; <== LOB magic imported here
			 (remove-if-not 'listp  ;; remove 'hline from list
					(org-table-to-lisp))))  ;; signals  error if not table
	)
    (delete-region (org-table-begin) (org-table-end))
    (insert (mapconcat (lambda(x) (concat "| " (mapconcat 'identity x " | " ) " |\n" ))
		       contents
		       ""))
    (org-table-align)
    )
  )
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-basic-offset 4))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(flymake-errline ((((class color) (background dark)) (:background "lightblue" :foreground "black" :inverse-video nil :weight bold))))
 '(flymake-warnline ((((class color) (background dark)) (:background "lightyellow"))))
 '(font-lock-comment-face ((((class color) (min-colors 8) (background dark)) (:foreground "red"))))
 '(font-lock-keyword-face ((default (:foreground "lightblue")) (nil nil))))
