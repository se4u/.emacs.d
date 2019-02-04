;;; package --- Setup.
;;; Commentary:
;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq-default bidi-display-reordering nil)
;; Setting line move visual to nil is very annoying. When you
;; do this then the pointer moves by logical lines and skips over
;; wrapped visual lines. The following is default behavior so I dont
;; need to do something explicitly but I keep this as reminder for future.
;; (setq-default line-move-visual 1)
(display-time)  ;; Displays time in minibuffer
(ido-mode t)    ;; Helps in switching buffers
(ido-everywhere 1)

(blink-cursor-mode -1)
(set-cursor-color "Red")
;; DONT DELETE THE FOLLOWING COMMENTED OPTIONS. Keep them for future.
;; (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
;; ;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode) ; This shows summary of tokens in echo area, very anoying, interferes with error messages etc.
;; ;;(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
;; (semantic-mode)
;; (global-semantic-idle-completions-mode)
;; (global-semantic-decoration-mode)
;; (global-semantic-highlight-func-mode)
;; (global-semantic-show-unmatched-syntax-mode nil)
;; (global-srecode-minor-mode 1)
;; (semantic-complete-analyze-inline)


(auto-fill-mode 1) ;; Turn on auto fill mode globally
(show-paren-mode)  ;; Highlights parenthesis
;; (electric-pair-mode)
(semantic-mode)    ;; Emacs parses buffers in this mode.
;; (global-ede-mode)  ;; EDE is a project manager
(add-hook 'before-save-hook 'time-stamp)
(setq shift-select-mode t)
(transient-mark-mode)
;; ido-dired is bound to C-x d. It lets you filter files through globs
;; Graphics Settings
;; (global-font-lock-mode t)
(defvar font-lock-operator-face 'font-lock-operator-face)
(defface font-lock-operator-face ()
  "Basic face for highlighting."
  :group 'basic-faces)
(set-face-foreground 'font-lock-operator-face "red")
(setq ring-bell-function (lambda () (message "*beep*")))
(menu-bar-mode -1)
(menu-bar-showhide-tool-bar-menu-customize-disable)
(kill-buffer "*scratch*")
(winner-mode 1)
(column-number-mode 1)
(if (display-graphic-p) (fringe-mode '(nil . 0)))
(setq ediff-split-window-function 'split-window-horizontally)
;; Settings for the abbreviation mode
(setq abbrev-file-name "~/.emacs.d/abbrev_defs") ;; Where to save/read abbrevs
(setq save-abbrevs t)
;; Do not turn on abbrev mode till you have time to figure out
;; how to make sure it doesn't turn on in comint, shells and programming modes.
;; (setq-default abbrev-mode t) ;; Turn abbrev mode by default
(when (equal system-type 'darwin)
  (setq
   mac-option-modifier 'meta
   mac-command-modifier 'super
   mac-function-modifier 'hyper
   redisplay-dont-pause t
   scroll-margin 3
   scroll-step 1
   scroll-up-aggressively 0.01
   scroll-down-aggressively 0.01
   scroll-conservatively 100000
   scroll-preserve-screen-position 1)
)
;; (if (equal system-type 'darwin)
;;     ;; (if (display-graphic-p)
;;     ;;     (setq custom-file "~/.emacs.d/pushpendrerastogi_custom_mac.el")
;;     ;;   (setq custom-file "~/.emacs.d/pushpendrerastogi_custom_mac_nogui.el"))
;;   (setq custom-file "~/.emacs.d/pushpendrerastogi_custom.el"))
;; (load custom-file)
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
	    '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; After loading the helper functions, Now add them as hooks to various modes
(load "~/.emacs.d/init_func.el")
(add-hook 'auto-fill-mode-hook
          #'(lambda () (setq comment-auto-fill-only-comments t)))
(add-hook 'c-mode-hook
	  'c-hook-func)
(add-hook 'c++-mode-hook
	  'c-hook-func)
(add-hook 'cmake-mode-hook
	  'my-cmake-mode-hook)
(add-hook 'dired-mode-hook
          'my-dired-mode-hook)
(add-hook 'doc-view-mode-hook
          'auto-revert-mode)
(add-hook 'find-file-hook
          'my-find-file-hook)
(add-hook 'hl-line-mode-hook
          'my-hl-line-mode-hook)
(add-hook 'java-mode-hook
	  'my-java-mode-hook)
(add-hook 'LaTeX-mode-hook
	  'my-latex-mode-hook)
(add-hook 'markdown-mode-hook
          'my-markdown-mode-hook)
(add-hook 'matlab-shell-mode-hook
	  'my-matlab-shell-mode-hook)
(add-hook 'matlab-mode-hook
	  'my-matlab-mode-hook)
(add-hook 'matlab-mode-hook
	  'run-matlab-once)
(add-hook 'makefile-gmake-mode-hook
	  'my-makefile-mode-hook)
(add-hook 'makefile-bsdmake-mode-hook
	  'my-makefile-mode-hook)
(add-hook 'org-mode-hook
	  'my-org-mode-hook)
(add-hook 'python-mode-hook
          'my-python-mode-hook)
(add-hook 'text-mode-hook
	  'my-text-mode-hook)
(add-hook 'write-file-hooks
	  'delete-trailing-whitespace)
(add-hook 'yaml-mode-hook
          'my-yaml-mode-hook)
(add-hook 'ess-mode-hook
          'my-ess-mode-hook)
(add-hook 'sgml-mode-hook
          'my-sgml-mode-hook)
(add-hook 'shell-mode-hook
	  'ansi-color-for-comint-mode-on)
(add-hook 'sh-mode-hook
          'my-sh-mode-hook)
(add-hook 'html-mode-hook
          'my-html-mode-hook)
(add-hook 'nxml-mode-hook
          'my-nxml-mode-hook)
(add-hook 'js-mode-hook
          'my-js-mode-hook)
(add-hook 'prog-mode-hook
          'my-prog-mode-hook)

;; ORG Mode Setup
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
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline (concat org-directory "/gtd.org") "Tasks")
         "* TODO %?\n %i\n")
        ))
(setq org-alphabetical-lists t
      ;; NOTE: I spent 4 and 5 Feb debugging crashes that happened while I
      ;; worked on org files that contained some pretty-entities and tables.
      ;; I noted that the crashes did not occur when I start with -Q flag.
      ;; I also noticed ;; that the crashes did not occur when I commented out
      ;; the `org-startup-indented` flag.
      ;;
      ;; This behavior was consistent on the
      ;; carbon-mac-port as well as the stock DMG that's distributed at
      ;; emacsformac. Also, I found an old bug report stating that
      ;; org-startup-indented used to cause crashed in emacs 23 and that this
      ;; bug was fixed.
      ;;
      ;; Although that bug was fixed, what seems to have
      ;; happened is that a combination of flags need to be set to crash emacs,
      ;; one of which is the org-startup-indented flag.  However at this point
      ;; since I have the workaround, I have stopped investigating further.
      ;; org-startup-indented t
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

(setq org-agenda-files (list "~/Dropbox/org/gtd.org"))

(org-babel-do-load-languages
    'org-babel-load-languages '((python . t) (R . t)))


;;(server-start)
(setq browse-url-mailto-function 'browse-url-generic)
(setq browse-url-generic-program "open")

;; Eval AFTER load
(eval-after-load "org"
  '(progn
     '(defun org-return (&optional indent) "" (interactive) (newline-and-indent))
     (define-prefix-command 'org-todo-state-map)
     (define-key org-mode-map (kbd "C-c x") 'org-todo-state-map)
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
     ))

(eval-after-load "sgml-mode"
  '(progn
     (define-key sgml-mode-map (kbd "C-\\") 'sgml-close-tag)
     (define-key sgml-mode-map (kbd "C-v") 'sgml-validate)
     ))

(eval-after-load "python"
  '(progn
     (define-key python-mode-map (kbd "DEL") 'hungry-delete-backward)
     (define-key python-mode-map (kbd "H-<backspace>") 'hungry-delete-forward)
     (define-key python-mode-map (kbd "C-<tab>") 'insert-4-space)
     )
  )

(defadvice quit-window (before quit-window-always-kill)
  "When running `quit-window', always kill the buffer."
  (ad-set-arg 0 t))
(ad-activate 'quit-window)


(eval-after-load "flyspell"  '(defun flyspell-mode (&optional arg))) ;;disable flyspell
;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "pyflakes" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;; 	       '("\\.py\\'" flymake-pyflakes-init))
;;   )
;; Key bindings
;; They should be set last so that they override any other mode
(global-set-key (kbd "<S-kp-9>") '(lambda () (interactive) (insert "(")))
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key [f1] 'kmacro-end-or-call-macro)
(global-set-key (kbd "<f2> <f2>") 'describe-key-briefly)
(global-set-key (kbd "<f2> `") 'describe-face)
(global-set-key (kbd "<f2> 1") 'describe-char)
(global-set-key (kbd "<f2> 2") 'describe-function)
(global-set-key (kbd "<f2> 3") 'describe-bindings)
(global-set-key (kbd "<f2> 4") 'describe-mode)
(global-set-key (kbd "<f2> 5") 'describe-variable)
(global-set-key (kbd "<f2> 6") 'describe-font)
(global-set-key [f3] 'kmacro-start-macro-or-insert-counter)
(global-set-key [f4] 'flymake-goto-next-error)
(global-set-key [f7] 'my-generate-tags)
(global-set-key [f8] 'magit-stage-commit-push)
(global-set-key [f13] 'pop-global-mark)
(global-set-key [f14] 'auto-fill-mode)
(global-set-key [f15] 'mu4e)
(global-set-key [f16] 'magit-status)
(global-set-key [f17] 'keyboard-quit)
(global-set-key [f18] 'kill-this-buffer)
(global-set-key [f19] 'keyboard-quit)
(global-set-key [home] 'back-to-indentation)
(global-set-key (kbd "DEL") 'hungry-delete-backward)
(global-set-key (kbd "M-DEL") 'kill-this-buffer)
(global-set-key (kbd "M-<down>") 'transpose-line-down)
(global-set-key (kbd "M-<up>") 'transpose-line-up)
(global-set-key (kbd "M-<left>") 'previous-multiframe-window)
(global-set-key (kbd "M-<right>") 'next-multiframe-window)
;; (global-set-key (kbd "ESC <left>") 'hs-hide-block)
;; (global-set-key (kbd "ESC <right>") 'hs-show-block)
(global-set-key [27 down] 'transpose-line-down) ; M-down
(global-set-key [27 up] 'transpose-line-up) ; M-up
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-below)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-6")  'enlarge-window)
(global-set-key (kbd "M-8") 'pop-tag-mark)
(global-set-key (kbd "M-9") 'keyboard-quit)
(global-set-key (kbd "M-p") 'next-multiframe-window)
(global-set-key (kbd "M-P") 'next-multiframe-window)
(global-set-key (kbd "M-;") 'comment-or-uncomment-region)
(progn (define-key key-translation-map (kbd "M-o") (kbd "C-x M-n"))
       (global-set-key (kbd "C-x M-n") 'previous-multiframe-window))
(global-set-key (kbd "M-k") 'recentf-ido-find-file)
(global-set-key (kbd "M-K") 'ido-find-file)
(global-set-key (kbd "M-RET") 'save-buffer)
(global-set-key (kbd "M-D") 'kill-whole-line)
(global-set-key (kbd "M-O V") 'my-generate-tags)
(global-set-key (kbd "M-O W") 'magit-stage-commit-push)
(global-set-key (kbd "M-O X") 'menu-bar-open)
(global-set-key (kbd "M-O Y") 'magit-status)
(global-set-key (kbd "M-O Z") 'kill-this-buffer)
(global-set-key (kbd "M-,") (lambda () (interactive) (set-mark-command t)))
(global-set-key (kbd "M-'") 'ido-switch-buffer)
(global-set-key (kbd "M-a") 'align-current)
(global-set-key (kbd "M-}") 'mark-sexp)
(global-set-key (kbd "M-{") (lambda () (interactive) (backward-sexp) (mark-sexp)))
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-z") 'kill-word-at-point)
(global-set-key (kbd "M-?") 'pop-tag-mark)
(global-set-key (kbd "M-=") 'move-end-of-line)
(global-set-key (kbd "M--") 'back-to-indentation)
(global-set-key (kbd "M-s /") 'my-multi-occur-in-matching-buffers)
(global-set-key (kbd "M-[") 'backward-sexp)
(global-set-key (kbd "M-]") 'forward-sexp)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "M-`") (lambda () (interactive) (insert "̅"))) ; Insert a bar on t̅o̅p̅
(global-set-key (kbd "C-.") 'pop-tag-mark)
(global-set-key (kbd "C-;")  'previous-line)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-1") 'bookmark-set)
(global-set-key (kbd "C-2") 'bookmark-jump)
(global-set-key (kbd "C-5") 'magit)
(global-set-key (kbd "C-8") 'create-file-at-point)
(global-set-key (kbd "C-9") 'yas-expand)
(global-set-key (kbd "C-a") 'back-to-indentation)
(global-set-key (kbd "C-p") 'save-line-to-kill-ring)
(global-set-key (kbd "C-M-e") 'mark-file-at-point-as-executable)
(global-set-key (kbd "M-r") 'goto-random-line)
(define-key ctl-x-map (kbd "C-i") #'endless/ispell-word-then-abbrev)
(global-set-key (kbd "C-x M-b") 'scroll-other-window-down)
(global-set-key (kbd "C-x M-v") 'scroll-other-window)
(global-set-key (kbd "C-c r") 'reload-buffer-no-confirm)
(global-set-key (kbd "C-x C-k") 'ido-kill-buffer)
(global-set-key (kbd "C-x C-f") 'find-file)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c c") '(lambda () (interactive) (org-capture nil "t")))
(global-set-key (kbd "C-c a") 'org-todo-list)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-x 9") 'close-and-kill-next-pane)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; Key Pad Commands.
(global-set-key (kbd "H-6") 'undo) ; H-6 means clear
(global-set-key (kbd "H--") 'shrink-window-horizontally)
(global-set-key (kbd "H-=") 'enlarge-window-horizontally)
(global-set-key (kbd "H-<up>") 'scroll-down)
(global-set-key (kbd "H-<down>") 'scroll-up)
(global-set-key (kbd "H-<left>") 'back-to-indentation)
(global-set-key (kbd "H-<right>") 'move-end-of-line)
(global-set-key (kbd "H-<backspace>") 'hungry-delete-forward)
(global-set-key (kbd "C-H-<backspace>") 'kill-word)
(global-set-key (kbd "<kp-equal>") 'save-buffer)
(global-set-key (kbd "<kp-decimal>") 'repeat)
(global-set-key (kbd "s-.") 'my-find-file-at-point-wrapper)
(global-set-key (kbd "s-v") 'yank)
(global-set-key (kbd "s-c") 'kill-ring-save)
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-o") 'ido-find-file)
(global-set-key (kbd "C-M-x M-n") 'overwrite-mode)
(define-key key-translation-map [f5] (kbd "C-c C-c"))
(define-key key-translation-map [f19] (kbd "C-g"))
(define-key key-translation-map (kbd "M-O T") (kbd "C-c C-c"))
;; Ansi Term
;; (expose-global-binding-in-term (kbd "M-o"))
;; (expose-global-binding-in-term (kbd "M-k"))
;; (expose-global-binding-in-term (kbd "<up>"))
;; (expose-global-binding-in-term (kbd "<down>"))
;; (expose-global-binding-in-term (kbd "<left>"))
;; (expose-global-binding-in-term (kbd "<right>"))
;; (expose-global-binding-in-term (kbd "C-h"))
(setq server-socket-dir "~/.emacs.d/server") ; Emacs Server

;; C-c C-j Switch to line mode (term-line-mode). Do nothing if already in line mode.
;; C-c C-k Switch to char mode (term-char-mode). Do nothing if already in char mode.
;; The following commands are only available in char mode:

;; C-c C-c Send a literal C-c to the sub-shell.
;; C-c char This is equivalent to C-x char in normal Emacs.

;; Term mode has a page-at-a-time feature.
;; When enabled, it makes output pause at the end of each screenful:

;; C-c C-q Toggle the page-at-a-time feature. This command works in both line and char modes. When the feature is enabled, the mode-line
;;     displays the word ‘page’, and each time Term receives more than a screenful of output, it pauses and displays ‘**MORE**’ in the
;;     mode-line. Type SPC to display the next screenful of output, or ? to see your other options. The interface is similar to the
;;     more program.




;; http://stackoverflow.com/questions/24725778/how-to-rebuild-elpa-packages-after-upgrade-of-emacs
;; (byte-recompile-directory package-user-dir nil 'force)
;; (dolist (package-name package-activated-list) (package-install package-name))


;; SETUP Package Managers
(add-hook 'after-init-hook
	  'my-after-init-hook)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" "67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" default)))
 '(ensime-startup-notification nil)
 '(exec-path
   (quote
    ("/opt/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/MacPorts/Emacs.app/Contents/MacOS/libexec" "/Applications/MacPorts/Emacs.app/Contents/MacOS/bin" "/usr/local/bin" "/Library/TeX/texbin" "/Users/rastogi/Library/Python/3.6/bin")))
 '(flycheck-flake8rc ".flake8rc")
 '(flycheck-python-flake8-executable nil)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(magit-git-executable "/usr/local/bin/git")
 '(org-agenda-files (quote ("~/Dropbox/org/gtd.org")))
 '(org-clock-persist (quote history))
 '(org-confirm-babel-evaluate nil)
 '(org-enforce-todo-checkbox-dependencies t)
 '(org-enforce-todo-dependencies t)
 '(org-from-is-user-regexp "\\<Pushpendre Rastogi\\>")
 '(org-hide-leading-stars t)
 '(org-list-allow-alphabetical t)
 '(org-log-done (quote time))
 '(org-plantuml-jar-path "/Users/rastogi/.emacs.d/plantuml.jar")
 '(org-src-fontify-natively t)
 '(org-startup-truncated nil)
 '(org-todo-keywords (quote ((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE"))))
 '(org-use-tag-inheritance nil)
 '(package-selected-packages
   (quote
    (ess dracula-theme flycheck-pyflakes yasnippet ensime matlab-mode yaml-mode zenburn-theme writegood-mode thrift smex smartparens mu4e-maildirs-extension mu4e-alert markdown-preview-mode markdown-mode+ magit luarocks lua-mode json-mode jekyll-modes hungry-delete flycheck)))
 '(python-indent-guess-indent-offset t)
 '(python-indent-offset 2)
 '(python-shell-completion-native-enable nil)
 '(recenter-positions (quote (middle top)))
 '(safe-local-variable-values (quote ((TeX-master . "root") (TeX-master . t))))
 '(sh-basic-offset 2)
 '(sh-indentation 2)
 '(tab-width 2)
 '(tool-bar-mode nil)
 '(vc-follow-symlinks t)
 '(yas-snippet-dirs (quote ("/Users/rastogi/.emacs.d/snippets"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:underline t))))
 '(mode-line ((t (:background "Cyan" :foreground "black" :box (:line-width -1 :style released-button)))))
 '(org-hide ((t (:foreground "White"))))
 '(org-table ((t (:foreground "Blue1" :underline "selectedTextBackgroundColor")))))
