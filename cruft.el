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




// (add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
// (add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
// (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
// (add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
// (require 'semantic/ia)
// (require 'semantic/bovine/gcc) ; or depending on you compiler
// ; (require 'semantic/bovine/clang)
// ;; Autocomplete
// (require 'auto-complete-config)
// (add-to-list 'ac-dictionary-directories (expand-file-name
//              "~/.emacs.d/elpa/auto-complete-AAAAMMDD.rrrr/dict"))
// (setq ac-comphist-file (expand-file-name
//              "~/.emacs.d/ac-comphist.dat"))
// (ac-config-default)
// (setq
//  helm-gtags-ignore-case t
//  helm-gtags-auto-update t
//  helm-gtags-use-input-at-cursor t
//  helm-gtags-pulse-at-cursor t
//  helm-gtags-prefix-key "\C-cg"
//  helm-gtags-suggested-key-mapping t
//  )
// (define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
// (define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
// (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
// (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
// (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
// (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
// ;; CEDET
// (load-file "~/.emacs.d/cedet-1.0pre7/common/cedet.el")
 
// (global-ede-mode 'nil)                  ; do NOT use project manager
 
// (semantic-load-enable-excessive-code-helpers)
 
// (require 'semantic-ia)          ; names completion and display of tags
// (require 'semantic-gcc)         ; auto locate system include files
 
// (semantic-add-system-include "~/3rd-party/boost-1.43.0/include/" 'c++-mode)
// (semantic-add-system-include "~/3rd-party/protobuf-2.3.0/include" 'c++-mode)
 
// (require 'semanticdb)
// (global-semanticdb-minor-mode 1)
 
// (defun my-cedet-hook ()
//   (local-set-key [(control return)] 'semantic-ia-complete-symbol)
//   (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
//   (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
//   (local-set-key "\C-c=" 'semantic-decoration-include-visit)
//   (local-set-key "\C-cj" 'semantic-ia-fast-jump)
//   (local-set-key "\C-cq" 'semantic-ia-show-doc)
//   (local-set-key "\C-cs" 'semantic-ia-show-summary)
//   (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
//   (local-set-key "\C-c+" 'semantic-tag-folding-show-block)
//   (local-set-key "\C-c-" 'semantic-tag-folding-fold-block)
//   (local-set-key "\C-c\C-c+" 'semantic-tag-folding-show-all)
//   (local-set-key "\C-c\C-c-" 'semantic-tag-folding-fold-all)
//   )
// (add-hook 'c-mode-common-hook 'my-cedet-hook)
 
// (global-semantic-tag-folding-mode 1)
 
// (require 'eassist)
 
// ;(concat essist-header-switches ("hh" "cc"))
// (defun alexott/c-mode-cedet-hook ()
//   (local-set-key "\C-ct" 'eassist-switch-h-cpp)
//   (local-set-key "\C-xt" 'eassist-switch-h-cpp)
//   (local-set-key "\C-ce" 'eassist-list-methods)
//   (local-set-key "\C-c\C-r" 'semantic-symref)
//   )
// (add-hook 'c-mode-common-hook 'alexott/c-mode-cedet-hook)
 
// ;; gnu global support
// (require 'semanticdb-global)
// (semanticdb-enable-gnu-global-databases 'c-mode)
// (semanticdb-enable-gnu-global-databases 'c++-mode)
 
// ;; ctags
// (require 'semanticdb-ectag)
// (semantic-load-enable-primary-exuberent-ctags-support)
 
// (global-semantic-idle-tag-highlight-mode 1)

// control return: whatever the symbol you are typing, this hot key automatically complete it for you.
// C-c?: another way to complete the symbol you are typing
// C-c>: when you typed . or -> after an object name, use this key to show possible public member functions or data members.
// C-cj: jump to the definition of the symbol under cursor
// C-cs: show a summary about the symbol under cursor
// C-cq: show the document of the symbol under cursor
// C-c=: visit the header file under cursor
// C-cp: toggle between the implementation and a prototype of symbol under cursor
// C-ce: when your cursor is in the scope of a class or one of its member function, list all methods in the class
// C-cC-r: show references of the symbol under cursor
// C-cC-c-: fold all
// C-cC-c+: unfold all
// C-c-: fold the block under cursor
// C-c+: unfold the block under cursor


// (add-to-list 'load-path "~/.emacs.d/ecb-2.40")
// (require 'ecb)
// (require 'ecb-autoloads)




// global-semanticdb-minor-mode
// enables global support for Semanticdb;
// global-semantic-mru-bookmark-mode
// enables automatic bookmarking of tags that you edited, so you can return to them later with the semantic-mrub-switch-tags command;
// global-cedet-m3-minor-mode
// activates CEDET's context menu that is bound to right mouse button;
// global-semantic-highlight-func-mode
// activates highlighting of first line for current tag (function, class, etc.);
// global-semantic-stickyfunc-mode
// activates mode when name of current tag will be shown in top line of buffer;
// global-semantic-decoration-mode
// activates use of separate styles for tags decoration (depending on tag's class). These styles are defined in the semantic-decoration-styles list;
// global-semantic-idle-local-symbol-highlight-mode
// activates highlighting of local names that are the same as name of tag under cursor;
// global-semantic-idle-scheduler-mode
// activates automatic parsing of source code in the idle time;
// global-semantic-idle-completions-mode
// activates displaying of possible name completions in the idle time. Requires that global-semantic-idle-scheduler-mode was enabled;
// global-semantic-idle-summary-mode
// activates displaying of information about current tag in the idle time. Requires that global-semantic-idle-scheduler-mode was enabled.
// Following sub-modes are usually useful when you develop and/or debug CEDET:

// global-semantic-show-unmatched-syntax-mode
// shows which elements weren't processed by current parser's rules;
// global-semantic-show-parser-state-mode
// shows current parser state in the modeline;
// global-semantic-highlight-edits-mode
// shows changes in the text that weren't processed by incremental parser yet.
// This approach allows to make Semantic's customization more flexible, as user can switch on only necessary features. You can also use functions with the same names to enable/disable corresponding sub-modes for current Emacs session. And you can also enable/disable these modes on the per-buffer basis (usually this is done from hook): names of corresponding variables you can find in description of global-semantic-* functions.

// To enable more advanced functionality for name completion, etc., you can load the semantic/ia with following command:

// (require 'semantic/ia)


// http://altom.ro/blog/emacs-python-ide-recipe
// http://www.masteringemacs.org/article/jedi-completion-library-python
// http://alexott.net/en/writings/emacs-devenv/EmacsCedet.html
// http://tuhdo.github.io/c-ide.html
// http://emacswiki.org/emacs/AutomaticFileHeaders
http://www.kurup.org/blog/2012/10/24/emacs-for-python-programming/
post init hook
// (require 'recentf)
// (setq recentf-max-saved-items 200
//       recentf-max-menu-items 15)
// (recentf-mode +1)
// (defun recentf-ido-find-file ()
//   "Find a recent file using ido."
//   (interactive)
//   (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
//     (when file
//       (find-file file))))

(add-hook 'before-save-hook 'time-stamp)
