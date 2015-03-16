(server-start)
(setq server-socket-dir "~/.emacs.d/server")
(add-to-list 'load-path "~/.emacs.d/elpa/company-0.8.11")
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4")
(add-to-list 'load-path "/Applications/Emacs.app/Contents/share/emacs/site-lisp/w3m")

(autoload 'company-mode "company" nil t)

;; Important keys M-x imenu and C-s foo then C-x C-x
;; The basic way to run a function when turning on a mode is to use (add-hook 'XXXX-mode-hook 'MY-FUNCTION-NAME)
;; To run dired and dired+ I basically need to understand a few keys
;; You can filter filenames by regex by using C-x d *.sh

;; M-x highlight-changes-mode, and  (global-hi-lock-mode 1)  and M-x
;; hi-lock-mode and C-x w h regexp <RET> face <RET> and C-x w r regexp
;; <RET> C-x w l regexp <RET> face <RET> and
;; (font-lock-add-keywords 'emacs-lisp-mode  '(("foo" . font-lock-keyword-face)))
;; and
;;(font-lock-add-keywords 'c-mode
;;  '(("\\<\\(FIXME\\):" 1 font-lock-warning-face prepend)
;;    ("\\<\\(and\\|or\\|not\\)\\>" . font-lock-keyword-face)))

;;(load-file "~/.emacs.d/cedet-1.1/common/cedet.el")
;;(add-to-list 'load-path "~/.emacs.d/ess-13.09")
;;(load-library "ess-autoloads")
;;(matlab-cedet-setup)

;; http://orgmode.org/manual/A-LaTeX-example.html#A-LaTeX-example
;; table-capture
;; table-release
;; table-generate-source
;; align-current
;;  C-x r r to copy the rectangular area
;; C-x r k to cut ("kill-rectangle")
;; C-x r y to paste ("yank-rectagle") 
(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
;(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(semantic-mode 1)

;; (add-hook 'text-mode-hook 'remove-dos-eol)

; (setq ns-function-modifier ‘super)
(global-set-key (kbd "M-k") 'kill-this-buffer)
(global-set-key (kbd "M-D") 'kill-whole-line)
(define-key key-translation-map (kbd "s-c") (kbd "C-c C-c"))
(define-key key-translation-map (kbd "s-x") (kbd "C-x"))
(define-key key-translation-map (kbd "s-e") (kbd "C-e"))
(global-set-key (kbd "C-x M-b") 'scroll-other-window-down)
(global-set-key (kbd "C-x M-v") 'scroll-other-window)
(global-set-key (kbd "M-,") (lambda () (interactive) (set-mark-command t)))
(global-set-key (kbd "M-'") 'ido-switch-buffer)
(defun write-input-and-come-back (x def)
  "Moves back sexp, adds the passed character or default, comes back"
  (backward-sexp)
  (if (equal x nil) (insert def) (insert x))
  (forward-sexp))

(global-set-key [?\M-a] 'align-current)
(global-set-key [?\M-}] 'mark-sexp)
(global-set-key (kbd "C-x ^")  'enlarge-window)
(global-set-key [f7]  '(lambda (x) (interactive "P") (write-input-and-come-back x "_")))
(global-set-key [f8]  '(lambda (x) (interactive "P") (write-input-and-come-back x "^")))
(add-to-list 'load-path "/opt/local/share/whizzytex/emacs/")
(autoload 'whizzytex-mode "whizzytex" "WhizzyTeX, a minor-mode WYSIWIG environment for LaTeX" t)

(fringe-mode (quote (nil . 0)))
(global-set-key (kbd "C-;")  'previous-line)
(global-set-key [?\C-x ?p] 'previous-multiframe-window)
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
;; (require 'cython-mode)
;;(yas-global-mode 1)

(global-set-key  [f3] (lambda () (interactive) (manual-entry (current-word))))

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

;;(global-set-key (kbd "TAB") 'self-insert-command) 
(add-hook 'java-mode-hook  (lambda () (setq indent-tabs-mode t) (setq java-indent 8) (setq tab-width 4)))
;; (global-ede-mode 1)
;; (require 'semantic/sb)
;; (semantic-mode 1)
;; (global-semantic-idle-completions-mode t)
;; (global-semantic-decoration-mode t)
;; (global-semantic-highlight-func-mode t)
;; (global-semantic-show-unmatched-syntax-mode t)

;; ;; CC-mode
;; (add-hook 'c-mode-hook '(lambda ()
;;         (setq ac-sources (append '(ac-source-semantic) ac-sources))
;;         (local-set-key (kbd "RET") 'newline-and-indent)
;;         (linum-mode t)
;;         (semantic-mode t)))

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

(setenv "PATH" (concat (getenv "PATH") ":/sw/bin" ":/usr/texbin"))
(setq exec-path (append '("/Users/pushpendrerastogi/Library/Enthought/Canopy_64bit/User/bin/python") exec-path '("/sw/bin") '("/usr/texbin")))

(setq ediff-split-window-function 'split-window-horizontally)

(global-set-key (kbd "M-=") '(lambda () (interactive) (progn (org-return-indent) (insert "==> "))))

(require 'dired-x)
(setq dired-omit-files "^\\...+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

(require 'org-latex)
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")))

(add-to-list 'org-entities '("pp"
                             "misc"
                             ("emptyset" "\\emptyset" t "" "" "" "")))

(add-to-list 'load-path "~/.emacs.d/org-blog-sitemap")
(require 'org-blog-sitemap)

(defun active-learn-publishing-completion ()
  "Set file permissions and clean up after publishing"
  (progn
    (shell-command "chmod 655 ~/public_html/*.html")
;;    (ignore-errors (shell-command "mv -f ~/public_html/sitemap.html ~/public_html/index.html"))
    (shell-command "rm ~/Dropbox/org/.*.orgx")
    (shell-command "rsync -avz --chmod=o+rx -p ~/public_html/notes/* prastog3@masters1.cs.jhu.edu:~/public_html/notes")
  ))

(setq org-publish-project-alist
      (list
       '("active-learn" 
         :base-directory "~/Dropbox/org/"
         :base-extension "org"
         :publishing-directory "~/public_html/notes/"
         :exclude "morepersonal.org" ; talks-with-ben.html ass4.html gtd.html theindex.html ToReadPersonal.html
         :publishing-function org-publish-org-to-html
         :auto-sitemap t
         :sitemap-sort-files "anti-chronologically"
         :makeindex nil
         :auto-preamble t
         :with-section-numbers nil
         :completion-function active-learn-publishing-completion
         :sitemap-function org-blog-export
         :sitemap-title
         :sitemap-filename
         )))


(add-hook 'tex-mode-hook
	  (lambda ()
	    (font-lock-add-keywords nil
             '(("\\<\\(QQQ\\)" 1 font-lock-warning-face t)
               ("\\<\\(TODO\\)" 1 font-lock-warning-face t)))))


(add-hook 'tex-mode-hook 'writegood-mode)


 (add-hook 'org-mode-hook
	  (lambda ()
	    (font-lock-add-keywords nil
	     '(("\\<\\(QQQ\\)" 1 font-lock-warning-face t)
               ("\\<\\(BOOKMARK\\)" 1 font-lock-warning-face t)
               ("\\<\\(TODO\\)" 1 font-lock-warning-face t)))))

(add-hook 'org-mode-hook 'writegood-mode)

(setq custom-file "~/.emacs.d/pushpendrerastogi_custom.el")
(load custom-file)



(if
    (string= system-type "darwin")
    (set-default-font "-apple-Consolas-medium-normal-normal-*-*-*-*-*-m-0-iso10646-1")
  (if (ignore-errors (set-default-font "Consolas")) 'true (set-default-font "Liberation Mono"))
  )

(set-face-attribute 'default nil :height 150)



;;(server-start)
(setq ring-bell-function (lambda () (message "*beep*")))
(add-to-list 'load-path "~/.emacs.d/elpa/smex-2.0/")
(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

(require 'smex)
(smex-initialize)
(require 'python)
(require 'igrep)
(require 'multi-web-mode)
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
(electric-pair-mode 1)
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
(multi-web-global-mode 1)

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


(global-set-key [f4] 'flymake-goto-next-error)
 

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
(global-set-key (kbd "<apps>") 'smex)
(global-set-key [?\M-x] 'smex)
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
(add-to-list 'load-path "~/.emacs.d/matlab-emacs")
(load-library "matlab-load")
(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list 'auto-mode-alist  '("\\.m$" . matlab-mode))
(setq matlab-indent-function t)
(setq matlab-shell-command "matlab")

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; ORG
(setq org-alphabetical-lists t
      org-startup-indented t
      org-enforce-todo-checkbox-dependencies t
      org-enforce-todo-dependencies t
      org-clock-persist 'history
      org-log-done t
      org-use-tag-inheritance nil
      org-startup-truncated nil
      org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE"))
      org-confirm-babel-evaluate nil
      org-tag-alist '((:startgroup . nil)
                      ("@reading" . ?r)
                      ("@coding" . ?c)
                      ("@errand" . ?e)
                      (:endgroup . nil)
                      (:startgroup . nil)
                      ("@work" . ?w)
                      ("@personal" . ?p)
                      (:endgroup . nil)
                      ))

(define-key mode-specific-map [?a] 'org-agenda)

;; org-clock-persistance-insinutae has a side effect dont shift it behind that eval-after function
(org-clock-persistence-insinuate)
(eval-after-load "org"
  '(progn
     '(defun org-return (&optional indent) "" (interactive) (newline-and-indent))
     (define-prefix-command 'org-todo-state-map)
     (define-key org-mode-map "\C-cx" 'org-todo-state-map)
     (define-key org-mode-map [home] 'org-beginning-of-line)
     (define-key org-todo-state-map "x"
       #'(lambda nil (interactive) (org-todo "CANCELLED")))
     (define-key org-todo-state-map "d"
       #'(lambda nil (interactive) (org-todo "DONE")))
     (define-key org-todo-state-map "f"
       #'(lambda nil (interactive) (org-todo "DEFERRED")))
     (define-key org-todo-state-map "l"
       #'(lambda nil (interactive) (org-todo "DELEGATED")))
     (define-key org-todo-state-map "s"
       #'(lambda nil (interactive) (org-todo "STARTED")))
     (define-key org-todo-state-map "w"
       #'(lambda nil (interactive) (org-todo "WAITING")))
     
     (define-key org-agenda-mode-map "\C-n" 'next-line)
     (define-key org-agenda-keymap "\C-n" 'next-line)
     (define-key org-agenda-mode-map "\C-p" 'previous-line)
     (define-key org-agenda-keymap "\C-p" 'previous-line)))

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
(global-set-key [f5] 'org-screenshot)

(defun insert-org-line ()
  "Insert org-mode line to file"
  (interactive)
  (insert "-*- mode: org; -*-\n"))
(setq org-agenda-files (list "~/Dropbox/org/gtd.org"))

(org-babel-do-load-languages
    'org-babel-load-languages '((python . t) (R . t)))

(require 'org-inlinetask)

; rememember that to update its C-u C-c # or C-u C-c C-x C-u
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

(defun org-ka-hook ()
  "Orgmode hook"
  (progn
    (global-set-key (kbd "C-S-r") 'org-refresh-everything)    
    (global-set-key [?\C-c ?q] 'org-set-tags-command)))
(add-hook 'org-mode-hook 'org-ka-hook)



(add-to-list 'load-path "/Users/pushpendrerastogi/.opam/system/share/emacs/site-lisp")
(add-to-list 'load-path  "/Users/pushpendrerastogi/.emacs.d/tuareg")
(require 'tuareg)
(setq tuareg-use-smie nil)
;; Load merlin-mode
(require 'merlin)
; https://github.com/the-lambda-church/merlin/wiki/emacs-from-scratch
;; Start merlin on ocaml files
(add-hook 'tuareg-mode-hook 'merlin-mode)
(add-hook 'caml-mode-hook 'merlin-mode)
;; Enable auto-complete
(setq merlin-use-auto-complete-mode 'easy)
(require 'auto-complete)
; Make company aware of merlin
(require 'company)
(add-to-list 'company-backends 'merlin-company-backend)
; Enable company on merlin managed buffers
(add-hook 'merlin-mode-hook 'company-mode)

;; Use opam switch to lookup ocamlmerlin binary
(setq merlin-command 'opam)
(add-to-list 'load-path "/Users/pushpendrerastogi/.opam/system/share/emacs/site-lisp")
(require 'ocp-indent)
(eval-after-load "merlin-mode" '(progn
                                (define-key merlin-mode-map (kbd "C-c t") 'merlin-type-expr)))
;; ;; Automatically load utop.el
;; Setup environment variables using opam for UTOP
;; (dolist (var (car (read-from-string (shell-command-to-string "opam config env --sexp"))))
;;   (setenv (car var) (cadr var)))
;; ;; Update the emacs path
;; (setq exec-path (append (parse-colon-path (getenv "PATH"))
;;                         (list exec-directory)))
;; ;; Update the emacs load path
;; (add-to-list 'load-path "/Users/pushpendrerastogi/.opam/system/share/emacs/site-lisp")
;; (require 'utop)
;; ;;(autoload 'utop "utop" "Toplevel for OCaml" t)
;; ;; key-binding	function	Description
;; ;; C-c C-s	utop	Start a utop buffer
;; ;; C-x C-e	utop-eval-phrase	Evaluate the current phrase
;; ;; C-x C-r	utop-eval-region	Evaluate the selected region
;; ;; C-c C-b	utop-eval-buffer	Evaluate the current buffer
;; ;; C-c C-k	utop-kill	Kill a running utop process
;; (autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
;; (remove-hook 'tuareg-mode-hook 'utop-minor-mode)
;; (add-hook 'tuareg-mode-hook 'merlin-mode)


(defvar font-lock-operator-face 'font-lock-operator-face)
(defface font-lock-operator-face ()
  "Basic face for highlighting."
  :group 'basic-faces)

(set-face-foreground 'font-lock-operator-face "red")

(font-lock-add-keywords
 'python-mode
 '(("\\<\\(sys.argv\\)" 0 'font-lock-warning-face)
   ("\\([0123456789]\\)"  0 'font-lock-constant-face)
   ("\\([][{}]\\)" 0 'font-lock-builtin-face)
   ("\\([=+*/-]\\)" 0 'font-lock-builtin-face)))

(defun sarcasm-makefile-mode-hook ()
  "Hooks for Makefile mode."
  (font-lock-add-keywords nil '(("\\<\\(TARGET\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\<\\(SOURCE\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\<\\(EXAMPLE\\):" 1 font-lock-keyword-face t)))
  (font-lock-add-keywords nil '(("\\([#]\\)" 1 font-lock-warning-face t)))
  )

(add-hook 'makefile-gmake-mode-hook 'sarcasm-makefile-mode-hook)
(add-hook 'makefile-bsdmake-mode-hook 'sarcasm-makefile-mode-hook)

;; This turns on auto-fill only in the comments line
(auto-fill-mode 1)
(setq comment-auto-fill-only-comments t)


(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pyflakes" (list local-file))))
 
  (add-to-list 'flymake-allowed-file-name-masks
              '("\\.py\\'" flymake-pyflakes-init))
  )
 
(add-hook 'find-file-hook 'flymake-find-file-hook)
(require 'flymake-cursor)
(require 'w3m)
