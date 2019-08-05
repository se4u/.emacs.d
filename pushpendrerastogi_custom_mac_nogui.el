(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(browse-url-browser-function (quote browse-url-default-macosx-browser))
 '(company-idle-delay 1)
 '(ecb-options-version "2.40")
 '(flycheck-checkers
   (quote
    (ada-gnat asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint d-dmd elixir emacs-lisp emacs-lisp-checkdoc erlang eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck haml handlebars haskell-ghc haskell-hlint html-tidy javascript-jshint javascript-eslint javascript-gjslint json-jsonlint less lua perl perl-perlcritic php php-phpmd php-phpcs puppet-parser puppet-lint python-pylint python-flake8 python-pycompile r-lintr racket rpm-rpmlint rst rst-sphinx ruby-rubocop ruby-rubylint ruby ruby-jruby rust sass scala scala-scalastyle scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim tex-chktex tex-lacheck texinfo verilog-verilator xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby)))
 '(flycheck-pylintrc "~/.emacs.d/.pylintrc")
 '(flymake-allowed-file-name-masks (quote (("\\.py\\'" flymake-pyflakes-init))))
 '(flymake-proc-allowed-file-name-masks (quote (("\\.py\\'" flymake-pyflakes-init))))
 '(header-date-format t)
 '(indent-tabs-mode t)
 '(magit-use-overlays nil)
 '(make-header-hook
   (quote
    (header-file-name header-description header-author header-creation-date header-modification-date header-modification-author header-update-count header-commentary header-end-line)))
 '(mlint-calculate-cyclic-complexity-flag t)
 '(mlint-programs
   (quote
    ("/Applications/MATLAB_R2010a.app/bin/maci64/mlint")))
 '(mlint-verbose t)
 '(org-directory "~/Dropbox/org")
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
    (exec-path-from-shell auctex smartparens hungry-delete flycheck magit header2 ac-python company-cmake company-coq ac-c-headers ac-helm ac-math auto-complete-c-headers auto-complete-chunk c-eldoc ecb ess flymake-cursor helm-company helm-flycheck helm-flymake helm-google markdown-mode org-ac popup-complete recentf-ext writegood-mode yasnippet yaml-mode smex org-blog org multi-web-mode igrep flymake-shell flymake cython-mode csv-mode)))
 '(python-python-command
   "/Users/pushpendrerastogi/Library/Enthought/Canopy_64bit/User/bin/python")
 '(python-shell-interpreter "python")
 '(semantic-matlab-dependency-system-include-path
   (quote
    ("/Applications/MATLAB_R2010a.app/toolbox/matlab/funfun" "/Applications/MATLAB_R2010a.app/toolbox/matlab/general"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "default"))))
 '(flycheck-warning ((t (:background "white"))))
 '(font-latex-sedate-face ((t (:foreground "green"))))
 '(font-lock-keyword-face ((t (:foreground "lightblue"))))
 '(font-lock-warning-face ((t (:inherit error))))
 '(magit-item-highlight ((t (:background "grey"))))
 '(semantic-decoration-on-unparsed-includes ((t (:background "#ffffff"))))
 '(semantic-highlight-func-current-tag-face ((t (:background "white")))))
