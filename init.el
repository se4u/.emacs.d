;; Now setup IDO, Semantic. Features that help with auto completion, IDE like features
;;; Code:
(ido-mode t)
(ido-everywhere 1)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
;;(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode) ; This shows summary of tokens in echo area, very anoying, interferes with error messages etc.
;;(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(semantic-mode)
(show-paren-mode)
(global-semantic-idle-completions-mode)
(global-semantic-decoration-mode)
;; (global-semantic-highlight-func-mode)
;; (global-semantic-show-unmatched-syntax-mode nil)
;; (global-srecode-minor-mode 1)
;; (semantic-complete-analyze-inline)
(global-ede-mode)
(add-hook 'before-save-hook 'time-stamp)
(setq shift-select-mode t)
;; (electric-pair-mode)
(transient-mark-mode)
;; This turns on auto-fill only in the comments line
(progn (auto-fill-mode 1)
       (setq comment-auto-fill-only-comments t))
;; ido-dired is bound to C-x d. It lets you filter files through globs
;; Graphics Settings
(global-font-lock-mode t)
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
(fringe-mode '(nil . 0))
(setq ediff-split-window-function 'split-window-horizontally)
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
  (add-to-list 'load-path "~/.emacs.d/w3m/")

  (require 'w3m))
(if (equal system-type 'darwin)
    (if (display-graphic-p)
	(setq custom-file "~/.emacs.d/pushpendrerastogi_custom_mac.el")
      (setq custom-file "~/.emacs.d/pushpendrerastogi_custom_mac_nogui.el"))
  (setq custom-file "~/.emacs.d/pushpendrerastogi_custom.el"))
(load custom-file)
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
	    '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))
;; After loading the helper functions, Now add them as hooks to various modes
(load "~/.emacs.d/init_func.el")
(add-hook 'c-mode-hook
	  'c-hook-func)
(add-hook 'c++-mode-hook
	  'c-hook-func)
(add-hook 'find-file-hook
	  'find-file-check-line-endings)
(add-hook 'java-mode-hook
	  'my-java-mode-hook)
(add-hook 'LaTeX-mode-hook
	  'my-latex-mode-hook)
(add-hook 'matlab-shell-mode-hook
	  'my-matlab-shell-mode-hook)
(add-hook 'matlab-mode-hook
	  'my-matlab-mode-hook)
(add-hook 'matlab-mode-hook
	  'run-matlab-once)
(add-hook 'makefile-gmake-mode-hook
	  'sarcasm-makefile-mode-hook)
(add-hook 'makefile-bsdmake-mode-hook
	  'sarcasm-makefile-mode-hook)
(add-hook 'org-mode-hook
	  'my-org-mode-hook)
(add-hook 'python-mode-hook
          'my-python-mode-hook)
(add-hook 'tex-mode-hook
	  'my-tex-mode-hook)
(add-hook 'text-mode-hook
	  'my-text-mode-hook)
(add-hook 'write-file-hooks
	  'auto-update-file-header)
(add-hook 'write-file-hooks
	  'delete-trailing-whitespace)

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
     ;; (define-key sgml-mode-map (kbd "C-k") 'quickly-kill)
     ))

(eval-after-load "python"
  '(progn
     (define-key python-mode-map (kbd "DEL") 'hungry-delete-backward)
     (define-key python-mode-map (kbd "H-<backspace>") 'hungry-delete-forward)
     )
  )

(defadvice quit-window (before quit-window-always-kill)
  "When running `quit-window', always kill the buffer."
  (ad-set-arg 0 t))
(ad-activate 'quit-window)


(eval-after-load "flyspell"  '(defun flyspell-mode (&optional arg))) ;;disable flyspell
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
;; Key bindings
;; They should be set last so that they override any other mode
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key [f1] 'kmacro-end-or-call-macro)
(global-set-key (kbd "<f2> <f2>") 'describe-key-briefly)
(global-set-key (kbd "<f2> 1") 'describe-char)
(global-set-key (kbd "<f2> 2") 'describe-function)
(global-set-key (kbd "<f2> 3") 'describe-bindings)
(global-set-key (kbd "<f2> 4") 'describe-mode)
(global-set-key [f3] 'kmacro-start-macro-or-insert-counter)
(global-set-key [f4] 'flymake-goto-next-error)
(global-set-key [f7] 'my-generate-tags)
(global-set-key [f16] 'magit-status)
(global-set-key [f17] '(lambda () (interactive) (message "[f17] is too close to KILL, intentionally left empty.")))
(global-set-key [f18] 'kill-this-buffer)
(global-set-key [f19] 'keyboard-quit)
(global-set-key [home] 'back-to-indentation)
(global-set-key (kbd "DEL") 'hungry-delete-backward)
(global-set-key (kbd "M-DEL") 'kill-this-buffer)
(global-set-key (kbd "M-<down>") 'transpose-line-down)
(global-set-key (kbd "M-<up>") 'transpose-line-up)
(global-set-key [M-left] 'previous-multiframe-window)
(global-set-key [M-right] 'next-multiframe-window)
(global-set-key [27 down] 'transpose-line-down)
(global-set-key [27 up] 'transpose-line-up)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-below)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-6")  'enlarge-window)
(global-set-key (kbd "M-8") 'pop-tag-mark)
(global-set-key (kbd "M-9") 'keyboard-quit)
(global-set-key (kbd "M-p") 'next-multiframe-window)
(global-set-key (kbd "M-;") 'comment-or-uncomment-region)
(progn (define-key key-translation-map (kbd "M-o") (kbd "C-x M-n"))
       (global-set-key (kbd "C-x M-n") 'previous-multiframe-window))
(global-set-key (kbd "M-k") 'recentf-ido-find-file)
(global-set-key (kbd "M-K") 'ido-find-file)
(global-set-key (kbd "M-RET") 'save-buffer)
(global-set-key (kbd "M-D") 'kill-whole-line)
(global-set-key (kbd "M-O V") 'my-generate-tags)
(global-set-key (kbd "M-O W") 'buffer-save)
(global-set-key (kbd "M-O X") 'menu-bar-open)
(global-set-key (kbd "M-O Y") 'magit-status)
(global-set-key (kbd "M-O Z") 'kill-this-buffer)
(global-set-key (kbd "M-,") (lambda () (interactive) (set-mark-command t)))
(global-set-key (kbd "M-'") 'ido-switch-buffer)
(global-set-key (kbd "M-a") 'align-current)
(global-set-key (kbd "M-}") 'mark-sexp)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-?") 'pop-tag-mark)
(global-set-key (kbd "M-=") 'move-end-of-line)
(global-set-key (kbd "M--") 'back-to-indentation)
(global-set-key (kbd "M-s /") 'my-multi-occur-in-matching-buffers)
(global-set-key (kbd "M-[") 'backward-sexp)
(global-set-key (kbd "M-]") 'forward-sexp)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-.") 'pop-tag-mark)
(global-set-key (kbd "C-x M-b") 'scroll-other-window-down)
(global-set-key (kbd "C-x M-v") 'scroll-other-window)
(global-set-key (kbd "C-;")  'previous-line)
(global-set-key (kbd "C-c r") 'reload-buffer-no-confirm)
(global-set-key (kbd "C-x C-k") 'ido-kill-buffer)
(global-set-key (kbd "C-x C-f") 'find-file)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c c") '(lambda () (interactive) (org-capture nil "t")))
(global-set-key (kbd "C-c a") 'org-todo-list)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-a") 'back-to-indentation)
(global-set-key (kbd "C-x 9") 'close-and-kill-next-pane)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-p") 'save-line-to-kill-ring)
(global-set-key (kbd "H-<up>") 'scroll-down)
(global-set-key (kbd "H-<down>") 'scroll-up)
(global-set-key (kbd "H-<left>") 'back-to-indentation)
(global-set-key (kbd "H-<right>") 'move-end-of-line)
(global-set-key (kbd "C-H-<left>") 'beginning-of-buffer)
(global-set-key (kbd "C-H-<right>") 'end-of-buffer)
(global-set-key (kbd "H-<backspace>") 'hungry-delete-forward)
(global-set-key (kbd "C-H-<backspace>") 'kill-word)
(global-set-key (kbd "H-6") 'undo)
(global-set-key (kbd "<kp-equal>") 'save-buffer)
(global-set-key (kbd "<kp-divide>") 'describe-key)
(global-set-key (kbd "<kp-equal>") 'describe-function)
(global-set-key (kbd "<kp-equal>") 'save-buffer)
(global-set-key (kbd "s-v") 'yank)
(global-set-key (kbd "s-c") 'kill-ring-save)
(define-key key-translation-map [f5] (kbd "C-c C-c"))
(define-key key-translation-map [f19] (kbd "C-g"))
(define-key key-translation-map (kbd "M-O T") (kbd "C-c C-c"))
;; Emacs Server
(setq server-socket-dir "~/.emacs.d/server")

;; http://stackoverflow.com/questions/24725778/how-to-rebuild-elpa-packages-after-upgrade-of-emacs
;; (byte-recompile-directory package-user-dir nil 'force)
;; (dolist (package-name package-activated-list) (package-install package-name))

;; SETUP Package Managers
(add-hook 'after-init-hook
	  'my-after-init-hook)

(add-to-list 'load-path "~/.emacs.d/matlab-emacs/")
(require 'matlab-load)
(add-to-list 'auto-mode-alist  '("\\.m$" . matlab-mode))
(matlab-cedet-setup)
