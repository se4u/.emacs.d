(require 'cl)

(defvar flyc--e-at-point nil
  "Error at point, after last command")

(defvar flyc--e-display-timer nil
  "A timer; when it fires, it displays the stored error message.")

(defun flyc/maybe-fixup-message (errore)
  "pyflake is flakey if it has compile problems, this adjusts the
message to display, so there is one ;)"
  (cond ((not (or (eq major-mode 'Python) (eq major-mode 'python-mode) t)))
	((null (flymake-ler-file errore))
	 ;; normal message do your thing
	 (flymake-ler-text errore))
	(t ;; could not compile error
	 (format "compile error, problem on line %s" (flymake-ler-line errore)))))

(defun flyc/show-stored-error-now ()
  "Displays the stored error in the minibuffer."
  (interactive)
  (let ((editing-p (= (minibuffer-depth) 0)))
    (if (and flyc--e-at-point editing-p)
	(progn
	  (message "%s" (flyc/maybe-fixup-message flyc--e-at-point))
	  (setq flyc--e-display-timer nil)))))


(defun flyc/-get-error-at-point ()
  "Gets the first flymake error on the line at point."
  (let ((line-no (line-number-at-pos))
	flyc-e)
    (dolist (elem flymake-err-info)
      (if (eq (car elem) line-no)
	  (setq flyc-e (car (second elem)))))
    flyc-e))


;;;###autoload
(defun flyc/show-fly-error-at-point-now ()
  "If the cursor is sitting on a flymake error, display
the error message in the  minibuffer."
  (interactive)
  (if flyc--e-display-timer
      (progn
	(cancel-timer flyc--e-display-timer)
	(setq flyc--e-display-timer nil)))
  (let ((error-at-point (flyc/-get-error-at-point)))
    (if error-at-point
	(progn
	  (setq flyc--e-at-point error-at-point)
	  (flyc/show-stored-error-now)))))


;;;###autoload
(defun flyc/show-fly-error-at-point-pretty-soon ()
  "If the cursor is sitting on a flymake error, grab the error,
and set a timer for \"pretty soon\". When the timer fires, the error
message will be displayed in the minibuffer.

This allows a post-command-hook to NOT cause the minibuffer to be
updated 10,000 times as a user scrolls through a buffer
quickly. Only when the user pauses on a line for more than a
second, does the flymake error message (if any) get displayed.

"
  (if flyc--e-display-timer
      (cancel-timer flyc--e-display-timer))

  (let ((error-at-point (flyc/-get-error-at-point)))
    (if error-at-point
	(setq flyc--e-at-point error-at-point
	      flyc--e-display-timer
	      (run-at-time "0.9 sec" nil 'flyc/show-stored-error-now))
      (setq flyc--e-at-point nil
	    flyc--e-display-timer nil))))


;;;###autoload
(eval-after-load "flymake"
  '(progn

     (defadvice flymake-goto-next-error (after flyc/display-message-1 activate compile)
       "Display the error in the mini-buffer rather than having to mouse over it"
       (flyc/show-fly-error-at-point-now))

     (defadvice flymake-goto-prev-error (after flyc/display-message-2 activate compile)
       "Display the error in the mini-buffer rather than having to mouse over it"
       (flyc/show-fly-error-at-point-now))

     (defadvice flymake-mode (before flyc/post-command-fn activate compile)
       "Add functionality to the post command hook so that if the
cursor is sitting on a flymake error the error information is
displayed in the minibuffer (rather than having to mouse over
it)"
       (add-hook 'post-command-hook 'flyc/show-fly-error-at-point-pretty-soon t t))))


(provide 'flymake-cursor)