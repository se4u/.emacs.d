;;; yaml-mode.el --- Major mode for editing YAML files
(require 'js)
(require 'rx)
(require 'json-snatcher)
(require 'json-reformat)

;; Constants
(defconst yaml-type-re "\\(![a-zA-z0-9]*:[^ %/]*\\)"
  "Regexp matching a single YAML hash key.")
(defconst yaml-comment-re "\\(# .*\\)"
  "Regex for comments.")
(defconst yaml-hashkey-re "\\(^ *[^ ]*: \\)"
  "Regex for parameters in a yaml type")
(defconst yaml-string-re "\\('[^']*'\\)"
  "Regex for string values.")
(defconst yaml-number-re "\\(\\.?[0-9]+\\.?\\)"
  "Regex for numeric values.")
(defconst yaml-node-anchor-alias-re "\\([&*][^ ,]+\\|!!python/[a-z/]*:\\)"
  "Regexp matching a YAML node anchor or alias.")
(defconst yaml-tag-re "!!?[^ \n]+"
  "Rexexp matching a YAML tag.")

(defconst yaml-font-lock-keywords-1
  (list
   (list yaml-comment-re 1 font-lock-comment-face)
   (list yaml-type-re 1 font-lock-type-face)
   (list yaml-hashkey-re 1 font-lock-variable-name-face)
   (list yaml-string-re 1 font-lock-string-face)
   (list yaml-node-anchor-alias-re 1 font-lock-keyword-face)
   (list yaml-number-re 1 font-lock-constant-face)
   )
  "Level one font lock.")

;;;###autoload
(define-derived-mode yaml-mode javascript-mode "YAML"
  "Major mode for editing YAML files"
  (set (make-local-variable 'font-lock-defaults) '(yaml-font-lock-keywords-1 t)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.taml$" . yaml-mode))
(provide 'yaml-mode)
;;; yaml-mode.el ends here
