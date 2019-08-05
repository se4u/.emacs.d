;; Setting line move visual to nil is very annoying. When you
;; do this then the pointer moves by logical lines and skips over
;; wrapped visual lines. The following is default behavior so I dont
;; need to do something explicitly but I keep this as reminder for future.
;; (setq-default line-move-visual 1)
;; (setq-default bidi-display-reordering nil)

;; The abbreviation mode auto corrects typos.
;; Auto correction can not be ued while programming and scripting!
;; (setq-default abbrev-mode t)
;; (setq abbrev-file-name "~/.emacs.d/abbrev_defs")


(kill-buffer "*scratch*")
(display-time)  ;; Displays time in minibuffer
(ido-mode t)    ;; Helps in switching buffers
(ido-everywhere 1)
(blink-cursor-mode -1)
(set-cursor-color "Red")
(auto-fill-mode 1) ;; Turn on auto fill mode globally
(show-paren-mode 1)  ;; Highlights parenthesis
(transient-mark-mode 1)
(semantic-mode)    ;; Emacs parses buffers in this mode.
(column-number-mode 1)
(setq browse-url-mailto-function 'browse-url-generic
      browse-url-generic-program "open"
      redisplay-dont-pause t
      scroll-margin 3
      scroll-step 1
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      scroll-conservatively 100000
      scroll-preserve-screen-position 1
      custom-file (if (display-graphic-p) "~/.emacs.d/custom_gui.el" "~/.emacs.d/custom_nogui.el"))
(when (equal system-type 'darwin)
  (setq
   mac-option-modifier 'meta
   mac-command-modifier 'super
   mac-function-modifier 'hyper))
(custom-set-variables
 '(shift-select-mode t)
 '(ring-bell-function (lambda () (message "*beep*")))
 '(cursor-in-non-selected-windows 'hollow)
 '(dired-use-ls-dired nil)
 '(display-time-format "%H:%M:%S")
 '(display-time-interval 1)
 '(doc-view-continuous t)
 '(fill-column 80)
 '(flycheck-pylintrc "~/.emacs.d/.pylintrc")
 '(font-lock-maximum-decoration 2)
 ;; company mode is not included with emacs.
 ;; so this variable may not have any effect
 '(global-company-mode t)
 '(global-flycheck-mode t)
 '(ido-ignore-buffers '("\\` " "*Messages*" "*GNU Emacs*"
                        "*Calendar*" "*Completions*" "TAGS"
                        "*magit-process*"))
 '(ido-ignore-files '("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./"))
 '(header-date-format t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-buffer-choice "~/Dropbox/org/gtd.org")
 '(line-move-visual t)
 ;; setting magit-use-overlays to nil will color diffs
 ;; using text properties instead of overlays, which
 ;; scales much better with larger diffs.
 '(magit-use-overlays nil)
 '(menu-bar-mode nil)
 '(org-directory "~/Dropbox/org")
 '(save-abbrevs 'silently)
 '(tool-bar-mode nil)
 '(warning-suppress-types '(undo discard-info))

 ;; Nest yas calls, and put contents of region as $0.
 '(yas-triggers-in-field t)
 '(yas-wrap-around-region nil)

 '(python-eldoc-function-timeout 3)
 '(python-eldoc-function-timeout-permanent nil)
 '(python-python-command "/Users/pushpendrerastogi/Library/Enthought/Canopy_64bit/User/bin/python")
 '(python-shell-interpreter "python")

 '(sh-basic-offset 2)
 '(scroll-bar-mode nil)
 '(ediff-split-window-function 'split-window-horizontally)
 '(frame-title-format (list (format "%s %%S: %%j " (system-name)) '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))
 '(org-return-follows-link t)

 '(make-header-hook
   '(header-file-name
     header-description
     header-author
     header-creation-date
     header-modification-date
     header-update-count
     header-end-line))
 ;; save the place of cursor in closed buffers
 '(save-place t nil (saveplace))

 ;; company mode settings.
 '(company-abort-manual-when-too-short t)
 '(company-auto-complete t)
 '(company-auto-complete-chars nil)
 '(company-global-modes t)
 '(company-idle-delay 1)
 '(company-minimum-prefix-length 2)
 '(company-quickhelp-delay 0.25)
 '(company-quickhelp-max-lines 10)
 '(company-show-numbers t)
 '(company-tooltip-limit 20)
 )
(load custom-file)
(load "~/.emacs.d/init_func.el")
(add-hook 'auto-fill-mode-hook
          #'(lambda () (setq comment-auto-fill-only-comments t)))
(add-hook 'after-init-hook            'my-after-init-hook) ;; SETUP Package Managers
(add-hook 'before-save-hook           'time-stamp)
(add-hook 'c-mode-hook                'c-hook-func)
(add-hook 'c++-mode-hook              'c-hook-func)
(add-hook 'cmake-mode-hook            'my-cmake-mode-hook)
(add-hook 'dired-mode-hook            'my-dired-mode-hook)
(add-hook 'doc-view-mode-hook         'auto-revert-mode)
(add-hook 'find-file-hook             'find-file-check-line-endings)
(add-hook 'java-mode-hook             'my-java-mode-hook)
(add-hook 'LaTeX-mode-hook            'my-latex-mode-hook)
(add-hook 'markdown-mode-hook         'my-markdown-mode-hook)
(add-hook 'matlab-shell-mode-hook     'my-matlab-shell-mode-hook)
(add-hook 'matlab-mode-hook           'my-matlab-mode-hook)
(add-hook 'matlab-mode-hook           'run-matlab-once)
(add-hook 'makefile-gmake-mode-hook   'my-makefile-mode-hook)
(add-hook 'makefile-bsdmake-mode-hook 'my-makefile-mode-hook)
(add-hook 'org-mode-hook              'my-org-mode-hook)
(add-hook 'python-mode-hook           'my-python-mode-hook)
(add-hook 'text-mode-hook             'my-text-mode-hook)
(add-hook 'write-file-hooks           'delete-trailing-whitespace)
(add-hook 'yaml-mode-hook             'my-yaml-mode-hook)
(add-hook 'ess-mode-hook              'my-ess-mode-hook)
(add-hook 'sgml-mode-hook             'my-sgml-mode-hook)
(add-hook 'html-mode-hook             'my-html-mode-hook)
(add-hook 'nxml-mode-hook             'my-nxml-mode-hook)
(add-hook 'js-mode-hook               'my-js-mode-hook)
(add-hook 'shell-mode-hook            'ansi-color-for-comint-mode-on)
(add-hook 'prog-mode-hook             'my-prog-mode-hook)
(add-hook 'term-mode-hook             'my-term-hook)
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

;; Key bindings are set last so that they override all modes.
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
(global-set-key (kbd "C-]") 'magit-status)
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
(global-set-key (kbd "C-4") 'bookmark-set)
(global-set-key (kbd "C-5") 'magit-status)
(global-set-key (kbd "C-8") 'create-file-at-point)
(global-set-key (kbd "C-a") 'back-to-indentation)
(global-set-key (kbd "C-p") 'save-line-to-kill-ring)
(global-set-key (kbd "C-l") 'recenter)
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
(define-key key-translation-map [f5] (kbd "C-c C-c"))
(define-key key-translation-map [f19] (kbd "C-g"))
(define-key key-translation-map (kbd "M-O T") (kbd "C-c C-c"))

;; http://stackoverflow.com/questions/24725778/how-to-rebuild-elpa-packages-after-upgrade-of-emacs
;; (byte-recompile-directory package-user-dir nil 'force)
;; (dolist (package-name package-activated-list) (package-install package-name))
