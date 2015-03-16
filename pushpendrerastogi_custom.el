(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function (quote browse-url-default-macosx-browser))
 '(flymake-allowed-file-name-masks (quote (("\\.py\\'" flymake-pyflakes-init))))
 '(indent-tabs-mode t)
 '(org-directory "~/Dropbox/org")
 '(org-export-creator-info nil)
 '(org-export-with-timestamps nil)
 '(org-hide-emphasis-markers t)
 '(org-hide-leading-stars t)
 '(org-latex-to-pdf-process (quote ("/usr/texbin/pdflatex -interaction nonstopmode -output-directory %o %f" "/usr/texbin/pdflatex -interaction nonstopmode -output-directory %o %f" "/usr/texbin/pdflatex -interaction nonstopmode -output-directory %o %f")))
 '(org-pretty-entities t)
 '(python-python-command "/Users/pushpendrerastogi/Library/Enthought/Canopy_64bit/User/bin/python")
 '(tool-bar-mode nil))


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
