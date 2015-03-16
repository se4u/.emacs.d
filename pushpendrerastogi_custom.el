(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function (quote browse-url-default-macosx-browser))
 '(ecb-options-version "2.40")
 '(flymake-allowed-file-name-masks (quote (("\\.py\\'" flymake-pyflakes-init))))
 '(indent-tabs-mode t)
 '(mlint-calculate-cyclic-complexity-flag t)
 '(mlint-programs (quote ("/usr/local/R2012a/bin/glnxa64/mlint")))
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
    (ac-python company-cmake company-coq company-jedi ac-c-headers ac-helm ac-math auto-complete-c-headers auto-complete-chunk c-eldoc ecb ess flymake-cursor helm-company helm-flycheck helm-flymake helm-google jedi-direx markdown-mode org-ac popup-complete recentf-ext writegood-mode yasnippet yaml-mode smex org-blog org multi-web-mode igrep flymake-shell flymake cython-mode csv-mode)))
 '(python-python-command
   "/Users/pushpendrerastogi/Library/Enthought/Canopy_64bit/User/bin/python")
 '(semantic-matlab-dependency-system-include-path
   (quote
    ("/usr/local/R2012a/toolbox/matlab/funfun" "/usr/local/R2012a/toolbox/matlab/general")))
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "default"))))
 '(font-lock-warning-face ((t (:inherit error :background "Yellow")))))
