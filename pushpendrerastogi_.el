(setq browse-url-browser-function 'browse-url-default-macosx-browser)
(add-to-list 'load-path "~/.emacs.d/matlab-emacs")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun pychecker ()
  """Run pychecker against the file behind the current buffer after
  checking if unsaved buffers should be saved."""
  (interactive)
  (let* ((file (buffer-file-name (current-buffer)))
                 (command (concat "pychecker " file)))
                 (save-some-buffers (not compilation-ask-about-save) nil) ; save  files.                                                              
                 (compile-internal command "No more errors or warnings" "pychecker"
                                                   nil pychecker-regexp-alist)))

(defun kill-current-line (&optional n)
  "Emulate dd of vim by C-d"
  (interactive "p")
  (save-excursion
    (beginning-of-line)
    (let ((kill-whole-line t))
      (kill-line n))))

(defun select-next-window ()
  "Switch to the next window"
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  "Switch to the previous window"
  (interactive)
  (select-window (previous-window)))

(defun key (desc)
  (or (and window-system (read-kbd-macro desc))
      (or (cdr (assoc desc real-keyboard-keys))
          (read-kbd-macro desc))))

(defun java-hook ()
  (when (and (stringp buffer-file-name)
             (string-match "\\.java\\'" buffer-file-name))
    (require 'javadoc-help)
    (jdh-jmenu-add-url)
    (global-set-key [f2] 'javadoc-lookup)
    (global-set-key [f3] 'javadoc-help)
    ))

(defun py-execute-current-line ()
  "Execute the current line assuming it's python"
  (interactive)
  (python-send-region (line-beginning-position) (line-end-position)))

(defun python-hook ()
  (when (string-match "\\.py\\'" buffer-file-name)
    (require 'python)
    (python-send-string "import sys;sys.path.insert(0,'')")
    (setq pychecker-regexp-alist '(("\\([a-zA-Z]?:?[^:(\t\n]+\\)[:( \t]+\\([0-9]+\\)[:) \t]" 1 2)))
    (global-set-key "\C-r" 'py-execute-current-line)))

(defun matlab-hook ()
  (when (and (stringp buffer-file-name) (string-match "\\.m\\'" buffer-file-name))
    (load-library "matlab-load")
    (autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
    (setq matlab-indent-function t)
    (setq matlab-shell-command "matlab")
))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;; KEY BINDINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst real-keyboard-keys
  '(("M-<up>"        . [27 up])
    ("M-<down>"      . [27 down])
    ("M-p"           . "p")
    ("M-n"           . "n"))
  "An assoc list of pretty key strings and their terminal equivalents.")

(global-set-key (key "M-<up>") 'select-next-window)
(global-set-key (key "M-<down>") 'select-previous-window)
(global-set-key (key "M-p") 'backward-paragraph)
(global-set-key (key "M-n") 'forward-paragraph)
(global-set-key "
" 'newline-and-indent)
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "C-d") 'delete-forward-char)
(global-set-key (kbd "C-a") 'back-to-indentation)
(global-set-key [f1] 'call-last-kbd-macro)
(add-hook 'find-file-hook 'python-hook)
(add-hook 'find-file-hook 'java-hook)
(add-hook 'find-file-hook 'matlab-hook)
(add-to-list 'load-path "/usr/share/emacs/site-lisp/w3m")
(add-to-list 'auto-mode-alist '("\\.m$" . matlab-mode))
(global-set-key "d" (quote delete-backward-char))
