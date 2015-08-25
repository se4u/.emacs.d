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
 '(company-idle-delay 1)
 '(company-minimum-prefix-length 2)
 '(company-show-numbers t)
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(dired-use-ls-dired nil)
 '(doc-view-continuous t)
 '(ecb-layout-name "left9")
 '(ecb-options-version "2.40")
 '(ecb-show-sources-in-directories-buffer (quote always))
 '(ecb-tip-of-the-day nil)
 '(fill-column 80)
 '(flycheck-checkers
   (quote
    (ada-gnat asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint d-dmd elixir emacs-lisp emacs-lisp-checkdoc erlang eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck haml handlebars haskell-ghc haskell-hlint html-tidy javascript-jshint javascript-eslint javascript-gjslint json-jsonlint less lua perl perl-perlcritic php php-phpmd php-phpcs puppet-parser puppet-lint python-pylint python-flake8 python-pycompile r-lintr racket rpm-rpmlint rst rst-sphinx ruby-rubocop ruby-rubylint ruby ruby-jruby rust sass scala scala-scalastyle scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim tex-chktex tex-lacheck texinfo verilog-verilator xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby)))
 '(flycheck-pylintrc "~/.emacs.d/.pylintrc")
 '(flymake-allowed-file-name-masks (quote (("\\.py\\'" flymake-pyflakes-init))))
 '(header-date-format t)
 '(ido-ignore-buffers
   (quote
    ("\\` " "*Messages*" "*GNU Emacs*" "*Calendar*" "*Completions*" "TAGS" "*magit-process*")))
 '(ido-ignore-files (quote ("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./")))
 '(indent-tabs-mode nil)
 '(jedi:get-in-function-call-delay 4000)
 '(jedi:key-complete [C-\'])
 '(jedi:key-goto-definition [C-\.])
 '(jedi:key-related-names nil)
 '(jedi:key-show-doc [C-\;])
 '(jedi:server-command
   (quote
    (list "/Users/pushpendrerastogi/anaconda/envs/emacs-jedi")))
 '(magit-use-overlays nil)
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
 '(org-entities-user
   (quote
    (("brokebar" "|" nil "|" "" "" "¦")
     ("implies" "\\Rightarrow" t "" "=>" "=>" "⇒")
     ("flat" "\\flat" t "&flat;" "b" "b" "♭")
     ("entails" "\\vDash" t "&#8872;" "|=" "|=" "⊨")
     ("notentails" "\\notvDash" t "" "|=/=" "U+22AD" "⊭")
     ("notprovable" "\\notvdash" t "" "|-\\-" "U+22AC" "⊬")
     ("provable" "\\vdash" t "&#8866;" "|-" "U+22A2" "⊢")
     ("defines" "\\triangleq" t ":=" ":=" ":=" "≜"))))
 '(org-export-creator-info nil)
 '(org-export-with-timestamps nil)
 '(org-hide-emphasis-markers t)
 '(org-hide-leading-stars t)
 '(org-latex-to-pdf-process
   (quote
    ("/usr/texbin/pdflatex -interaction nonstopmode -output-directory %o %f" "/usr/texbin/pdflatex -interaction nonstopmode -output-directory %o %f" "/usr/texbin/pdflatex -interaction nonstopmode -output-directory %o %f")))
 '(org-pretty-entities t)
 '(package-selected-packages
   (quote
    (magit header2 ac-python company-cmake company-coq company-jedi ac-c-headers ac-helm ac-math auto-complete-c-headers auto-complete-chunk c-eldoc ecb ess flymake-cursor helm-company helm-flycheck helm-flymake helm-google jedi-direx markdown-mode org-ac popup-complete recentf-ext writegood-mode yasnippet yaml-mode smex org-blog org multi-web-mode igrep flymake-shell flymake cython-mode csv-mode)))
 '(python-python-command
   "/Users/pushpendrerastogi/Library/Enthought/Canopy_64bit/User/bin/python")
 '(python-shell-interpreter "python")
 '(save-place t nil (saveplace))
 '(scroll-bar-mode nil)
 '(semantic-default-submodes
   (quote
    (global-semantic-decoration-mode global-semantic-idle-completions-mode global-semanticdb-minor-mode global-semantic-mru-bookmark-mode)))
 '(semantic-matlab-dependency-system-include-path
   (quote
    ("/Applications/MATLAB_R2010a.app/toolbox/matlab/funfun" "/Applications/MATLAB_R2010a.app/toolbox/matlab/general")))
 '(tags-add-tables (quote ask-user))
 '(tags-case-fold-search nil)
 '(tags-table-list
   (quote
    ("/Users/pushpendrerastogi/.emacs.d/TAGS" "/Users/pushpendrerastogi/Dropbox/paper/nmcr/src/python/TAGS")))
 '(tool-bar-mode nil)
 '(yaml-block-literal-electric-alist nil)
 '(yaml-imenu-generic-expression (quote ((nil "^\\(:?[a-zA-Z_!-]+\\):" 1))))
 '(yaml-indent-offset 4))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#fdf6e3" :foreground "#111111" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "nil" :family "Monaco"))))
 '(flycheck-warning ((t (:background "white"))))
 '(font-lock-keyword-face ((t (:foreground "blue" :weight normal))))
 '(font-lock-warning-face ((t (:inherit error :background "yellow"))))
 '(magit-item-highlight ((t (:weight semi-bold))))
 '(semantic-decoration-on-unknown-includes ((t nil)))
 '(semantic-decoration-on-unparsed-includes ((t nil)))
 '(semantic-highlight-func-current-tag-face ((t (:background "white"))))
 '(semantic-tag-boundary-face ((t nil))))
