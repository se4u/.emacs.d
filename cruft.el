Important keys M-x imenu and C-s foo then C-x C-x
The basic way to run a function when turning on a mode is to use (add-hook 'XXXX-mode-hook 'MY-FUNCTION-NAME)


M-x highlight-changes-mode, and  (global-hi-lock-mode 1)  and M-x
hi-lock-mode and C-x w h regexp <RET> face <RET> and C-x w r regexp
<RET> C-x w l regexp <RET> face <RET> and
(font-lock-add-keywords 'emacs-lisp-mode  '(("foo" . font-lock-keyword-face)))
and
http://orgmode.org/manual/A-LaTeX-example.html#A-LaTeX-example
table-capture
table-release
table-generate-source
align-current


(setenv "PATH" (concat (getenv "PATH") ":/sw/bin" ":/usr/texbin"))
(setq exec-path (append '("/Users/pushpendrerastogi/Library/Enthought/Canopy_64bit/User/bin/python") exec-path '("/sw/bin") '("/usr/texbin")))




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



(require 'org-inlinetask)
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
;; Automatically load utop.el
Setup environment variables using opam for UTOP
(dolist (var (car (read-from-string (shell-command-to-string "opam config env --sexp"))))
  (setenv (car var) (cadr var)))
;; Update the emacs path
(setq exec-path (append (parse-colon-path (getenv "PATH"))
                        (list exec-directory)))
;; Update the emacs load path
(add-to-list 'load-path "/Users/pushpendrerastogi/.opam/system/share/emacs/site-lisp")
(require 'utop)
;;(autoload 'utop "utop" "Toplevel for OCaml" t)
;; key-binding	function	Description
;; C-c C-s	utop	Start a utop buffer
;; C-x C-e	utop-eval-phrase	Evaluate the current phrase
;; C-x C-r	utop-eval-region	Evaluate the selected region
;; C-c C-b	utop-eval-buffer	Evaluate the current buffer
;; C-c C-k	utop-kill	Kill a running utop process
(autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
(remove-hook 'tuareg-mode-hook 'utop-minor-mode)
(add-hook 'tuareg-mode-hook 'merlin-mode)

(require 'flymake-cursor)
(require 'w3m)
(require 'recentf)


(multi-web-global-mode 1)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))



(if
;;     ;; custom-set-variables was added by Custom.
;;     ;; If you edit it by hand, you could mess it up, so be careful.
;;     ;; Your init file should contain only one such instance.
;;     ;; If there is more than one, they won't work right.
     (and (string= system-type "darwin") (display-graphic-p))
     (custom-set-faces
      '(default ((t (:inherit nil :stipple nil :background "gridColor" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "Consolas"))))
      '(font-lock-warning-face ((t (:inherit error :background "Yellow"))))
      '(org-hide ((t (:foreground "gridColor")))))
   )

(if (string= system-type "darwin")
    (set-default-font "-apple-Consolas-medium-normal-normal-*-*-*-*-*-m-0-iso10646-1")
  (if (ignore-errors (set-default-font "Consolas")) 'true (set-default-font "Liberation Mono")))
(set-face-attribute 'default nil :height 150)
