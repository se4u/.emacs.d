(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-command-list
   (quote
    (("TeX" "%(PDF)%(tex) %(file-line-error) %(extraopts) %`%S%(PDFout)%(mode)%' %t" TeX-run-TeX nil
      (plain-tex-mode texinfo-mode ams-tex-mode)
      :help "Run plain TeX")
     ("LaTeX" "%`%l%(mode)%' %t" TeX-run-TeX nil
      (latex-mode doctex-mode)
      :help "Run LaTeX")
     ("Makeinfo" "makeinfo %(extraopts) %t" TeX-run-compile nil
      (texinfo-mode)
      :help "Run Makeinfo with Info output")
     ("Makeinfo HTML" "makeinfo %(extraopts) --html %t" TeX-run-compile nil
      (texinfo-mode)
      :help "Run Makeinfo with HTML output")
     ("AmSTeX" "%(PDF)amstex %(extraopts) %`%S%(PDFout)%(mode)%' %t" TeX-run-TeX nil
      (ams-tex-mode)
      :help "Run AMSTeX")
     ("ConTeXt" "texexec --once --texutil %(extraopts) %(execopts)%t" TeX-run-TeX nil
      (context-mode)
      :help "Run ConTeXt once")
     ("ConTeXt Full" "texexec %(extraopts) %(execopts)%t" TeX-run-TeX nil
      (context-mode)
      :help "Run ConTeXt until completion")
     ("Glossaries" "~/Library/texmf/tex/latex/glossaries/makeglossaries %s" TeX-run-command nil t)
     ("BibTeX" "bibtex %s" TeX-run-BibTeX nil t :help "Run BibTeX")
     ("Biber" "biber %s" TeX-run-Biber nil t :help "Run Biber")
     ("View" "%V" TeX-run-discard-or-function t t :help "Run Viewer")
     ("Print" "%p" TeX-run-command t t :help "Print the file")
     ("Queue" "%q" TeX-run-background nil t :help "View the printer queue" :visible TeX-queue-command)
     ("File" "%(o?)dvips %d -o %f " TeX-run-command t t :help "Generate PostScript file")
     ("Index" "makeindex %s" TeX-run-command nil t :help "Create index file")
     ("Xindy" "texindy %s" TeX-run-command nil t :help "Run xindy to create index file")
     ("Check" "lacheck %s" TeX-run-compile nil
      (latex-mode)
      :help "Check LaTeX file for correctness")
     ("ChkTeX" "chktex -v6 %s" TeX-run-compile nil
      (latex-mode)
      :help "Check LaTeX file for common mistakes")
     ("Spell" "(TeX-ispell-document \"\")" TeX-run-function nil t :help "Spell-check the document")
     ("Clean" "TeX-clean" TeX-run-function nil t :help "Delete generated intermediate files")
     ("Clean All" "(TeX-clean t)" TeX-run-function nil t :help "Delete generated intermediate and output files")
     ("Other" "" TeX-run-command t t :help "Run an arbitrary command"))))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(browse-url-browser-function (quote browse-url-default-macosx-browser))
 '(column-number-mode t)
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
 '(cursor-in-non-selected-windows (quote hollow))
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(dired-use-ls-dired nil)
 '(display-time-format "%H:%M:%S")
 '(display-time-interval 1)
 '(doc-view-continuous t)
 '(ecb-layout-name "left9")
 '(ecb-options-version "2.40")
 '(ecb-show-sources-in-directories-buffer (quote always))
 '(ecb-tip-of-the-day nil)
 '(fill-column 80)
 '(flycheck-checkers
   (quote
    (ada-gnat asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint d-dmd elixir emacs-lisp emacs-lisp-checkdoc erlang eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck haml handlebars haskell-ghc haskell-hlint html-tidy javascript-eslint javascript-jshint javascript-gjslint json-jsonlint less lua perl perl-perlcritic php php-phpmd php-phpcs puppet-parser puppet-lint python-pylint python-flake8 python-pycompile r-lintr racket rpm-rpmlint rst rst-sphinx ruby-rubocop ruby-rubylint ruby ruby-jruby rust sass scala scala-scalastyle scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim tex-chktex tex-lacheck texinfo verilog-verilator xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby)))
 '(flycheck-pylintrc "~/.emacs.d/.pylintrc")
 '(flymake-allowed-file-name-masks (quote (("\\.py\\'" flymake-pyflakes-init))))
 '(flymake-proc-allowed-file-name-masks (quote (("\\.py\\'" flymake-pyflakes-init))))
 '(font-lock-maximum-decoration 2)
 '(global-company-mode t)
 '(global-flycheck-mode t)
 '(header-date-format t)
 '(ido-ignore-buffers
   (quote
    ("\\` " "*Messages*" "*GNU Emacs*" "*Calendar*" "*Completions*" "TAGS" "*magit-process*")))
 '(ido-ignore-files (quote ("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./")))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-buffer-choice "~/Dropbox/org/gtd.org")
 '(jit-lock-stealth-nice nil)
 '(jit-lock-stealth-time nil)
 '(line-move-visual t)
 '(magit-use-overlays nil)
 '(mail-host-address "pushpendre-mu4e")
 '(make-header-hook
   (quote
    (header-file-name header-description header-author header-creation-date header-modification-date header-update-count header-end-line)))
 '(menu-bar-mode nil)
 '(mlint-calculate-cyclic-complexity-flag t)
 '(mlint-programs
   (quote
    ("/Applications/MATLAB_R2010a.app/bin/maci64/mlint")))
 '(mlint-verbose t)
 '(org-directory "~/Dropbox/org")
 '(org-emphasis-alist
   (quote
    (("*"
      (:overline t :foreground "red" :underline t :weight bold)
      "<b>" "</b>")
     ("/" italic "<i>" "</i>")
     ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
     ("=" org-code "<code>" "</code>" verbatim)
     ("~" org-verbatim "<code>" "</code>" verbatim)
     ("`"
      (:overline t)))))
 '(org-entities-user
   (quote
    (("real" "\\mathbb{R}" nil "&#8477;" "R" "+211D" "ℝ")
     ("nat" "\\mathbb{N}" nil "&#8469;" "N" "+2115" "ℕ")
     ("circ" "\\circ" nil "&#8728;" "o" "" "∘")
     ("rrb" "\\rrbracket" nil "&#27E7;" "]]" "" "⟧")
     ("llb" "\\llbracket" nil "&#27E6;" "[[" "" "⟦")
     ("brokebar" "|" nil "|" "" "" "¦")
     ("implies" "\\Rightarrow" t "" "=>" "=>" "⇒")
     ("flat" "\\flat" t "&flat;" "b" "b" "♭")
     ("entails" "\\vDash" t "&#8872;" "|=" "|=" "⊨")
     ("notentails" "\\notvDash" t "" "|=/=" "U+22AD" "⊭")
     ("notprovable" "\\notvdash" t "" "|-\\-" "U+22AC" "⊬")
     ("provable" "\\vdash" t "&#8866;" "|-" "U+22A2" "⊢")
     ("defines" "\\triangleq" t ":=" ":=" ":=" "≜")
     ("nimplies" "\\nRightArrow" t "/=>" "/=>" "U+21CF" "⇏"))))
 '(org-export-creator-info nil)
 '(org-export-with-timestamps nil)
 '(org-hide-emphasis-markers t)
 '(org-hide-leading-stars t)
 '(org-latex-to-pdf-process
   (quote
    ("/usr/texbin/pdflatex -interaction nonstopmode -output-directory %o %f" "/usr/texbin/pdflatex -interaction nonstopmode -output-directory %o %f" "/usr/texbin/pdflatex -interaction nonstopmode -output-directory %o %f")))
 '(org-link-frame-setup
   (quote
    ((vm . vm-visit-folder-other-frame)
     (vm-imap . vm-visit-imap-folder-other-frame)
     (gnus . org-gnus-no-new-news)
     (file . find-file-other-frame)
     (wl . wl-other-frame))))
 '(org-pretty-entities t)
 '(org-return-follows-link t)
 '(package-selected-packages
   (quote
    (web-mode web-mode-edit-element latex-extra company-auctex htmlize mu4e-alert mu4e-maildirs-extension top-mode markdown-mode company-quickhelp elpy hl-anything expand-region auctex-latexmk hungry-delete ido-at-point smartparens yaml-mode exec-path-from-shell fill-column-indicator flycheck flycheck-cython flycheck-google-cpplint yasnippet magit header2 ac-c-headers ac-helm auto-complete-c-headers auto-complete-chunk c-eldoc ecb ess flymake-cursor org-ac popup-complete recentf-ext smex org-blog org multi-web-mode igrep flymake-shell flymake)))
 '(python-eldoc-function-timeout 3)
 '(python-eldoc-function-timeout-permanent nil)
 '(python-python-command
   "/Users/pushpendrerastogi/Library/Enthought/Canopy_64bit/User/bin/python")
 '(python-shell-interpreter "python")
 '(safe-local-variable-values
   (quote
    ((eval org-mode t)
     (eval progn
           (anaconda-mode -1)
           (eldoc-mode -1)
           (linum-mode 1))
     (eval defun reftex-get-bibfile-list nil
           (reftex-default-bibliography))
     (eval setq-default TeX-master nil)
     (eval setq-default TeX-master "root")
     (eval progn
           (eldoc-mode -1)
           (anaconda-mode -1)
           (flycheck-mode -1))
     (eval org-toggle-pretty-entities)
     (eval add-hook
           (quote after-save-hook)
           (quote org-html-export-to-html)
           nil
           (quote make-it-local))
     (eval add-hook
           (quote write-file-hooks)
           (quote org-html-export-to-html)
           nil
           (quote make-it-local))
     (eval progn
           (flycheck-mode -1)
           (orgtbl-mode -1))
     (eval progn
           (flycheck-mode -1)
           (hs-minor-mode -1))
     (eval progn
           (anaconda-mode -1)
           (eldoc-mode -1))
     (eval progn
           (flycheck-mode -1))
     (eval progn
           (flycheck-mode -1)
           (orgtbl-mode -1)
           (auto-revert-mode -1))
     (eval progn
           (flychek-mode -1)
           (orgtbl-mode -1))
     (eval progn
           (linum-mode 1)
           (eldoc-mode -1))
     (eval progn
           (linum-mode 1)
           (anaconda-mode -1)
           (eldoc-mode -1))
     (eval progn
           (linum-mode 1)
           (anaconda-mode -1)
           (eldoc-mode -1))
     (eval progn
           (anaconda-mode -1))
     (eval progn
           (flycheck-mode -1)
           (anaconda-mode -1))
     (eval progn
           (flycheck-mode -1))
     (eval
      (flycheck-mode -1))
     (eval
      (anaconda-mode nil)
      (flycheck-mode -1))
     (eval
      (anaconda-mode -1)
      (flycheck-mode -1))
     (eval progn
           (hs-minor-mode -1)
           (orgtbl-mode -1))
     (eval progn
           (anaconda-mode -1)
           (eldoc-mode -1))
     (header-auto-update-enabled)
     (eval remove-hook
           (quote write-file-hooks)
           (quote delete-trailing-whitespace))
     (whitespace-style face tabs spaces trailing lines space-before-tab::space newline indentation::space empty space-after-tab::space space-mark tab-mark newline-mark))))
 '(save-place t nil (saveplace))
 '(scroll-bar-mode nil)
 '(semantic-default-submodes
   (quote
    (global-semantic-decoration-mode global-semantic-idle-completions-mode global-semanticdb-minor-mode global-semantic-mru-bookmark-mode)))
 '(semantic-matlab-dependency-system-include-path
   (quote
    ("/Applications/MATLAB_R2010a.app/toolbox/matlab/funfun" "/Applications/MATLAB_R2010a.app/toolbox/matlab/general")))
 '(sh-basic-offset 2)
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 587)
 '(sp-escape-quotes-after-insert nil)
 '(sp-escape-wrapped-region nil)
 '(tags-add-tables (quote ask-user))
 '(tags-case-fold-search nil)
 '(textlint-location-vm (quote textlint-location-vm-macos))
 '(tool-bar-mode nil)
 '(w3m-default-display-inline-images t)
 '(warning-suppress-types (quote (undo discard-info)))
 '(yaml-block-literal-electric-alist nil)
 '(yaml-imenu-generic-expression (quote ((nil "^\\(:?[a-zA-Z_!-]+\\):" 1))))
 '(yaml-indent-offset 4)
 '(yas-triggers-in-field t)
 '(yas-wrap-around-region nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#fdf6e3" :foreground "#111111" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "nil" :family "Monaco"))))
 '(cursor ((t (:background "Red" :foreground "black"))))
 '(flycheck-warning ((t (:background "white"))))
 '(flymake-errline ((t nil)) t)
 '(font-latex-sectioning-5-face ((t (:inherit variable-pitch :foreground "blue4" :weight normal))))
 '(font-latex-warning-face ((t (:foreground "red"))))
 '(font-lock-keyword-face ((t (:foreground "blue" :weight normal))))
 '(font-lock-warning-face ((t (:inherit error :background "yellow"))))
 '(highlight-indent-guides-even-face ((t (:background "gridColor"))))
 '(highlight-indent-guides-odd-face ((t (:background "selectedControlColor"))))
 '(magit-item-highlight ((t (:weight semi-bold))))
 '(mode-line ((t (:background "Orange" :foreground "black" :box (:line-width -1 :style released-button)))))
 '(semantic-decoration-on-unknown-includes ((t nil)))
 '(semantic-decoration-on-unparsed-includes ((t nil)))
 '(semantic-highlight-func-current-tag-face ((t (:background "white"))))
 '(semantic-tag-boundary-face ((t nil)))
 '(whitespace-newline ((t (:background "Yellow" :distant-foreground "Yellow" :foreground "Red" :box (:line-width 2 :color "selectedControlTextColor" :style released-button) :weight normal)))))
