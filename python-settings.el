;; Emacs settings for Python
;; (add-to-list 'load-path "~/Desktop/projects/Twisted/twisted/emacs")
;; (require 'twisted-dev)

(require 'python)

;; Configure flymake for python
(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "epylint" (list local-file))))

  (defun python-flymake-enable()
    (when (eq major-mode 'python-mode)
      (set (make-local-variable 'flymake-allowed-file-name-masks)
	   '(("." flymake-pylint-init)))
      (condition-case err
	  (flymake-mode)
	(message (format "The error was: %s" err)))))
  
)
  ;;(add-hook 'find-file-hook 'python-flymake-enable))

(load-library "pylint")

(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)

(require 'pymacs)
(pymacs-load "ropemacs" "rope-")
(setq rope-enable-autoimport t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Auto-completion
;;;  Integrates:
;;;   1) Rope
;;;   2) Yasnippet
;;;   all with AutoComplete.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun prefix-list-elements (list prefix)
  (let (value)
    (nreverse
     (dolist (element list value)
       (setq value (cons (format "%s%s" prefix element) value))))))

(defvar ac-source-rope
  '((candidates
     . (lambda ()
         (prefix-list-elements (rope-completions) ac-target))))
  "Source for Rope")

(defun ac-python-find ()
  "Python `ac-find-function'."
  (require 'thingatpt)
  (let ((symbol (car-safe (bounds-of-thing-at-point 'symbol))))
    (if (null symbol)
        (if (string= "." (buffer-substring (- (point) 1) (point)))
            (point)
	    nil)
	symbol)))

(defun ac-python-candidate ()
  "Python `ac-candidates-function'"
  (let (candidates)
    (dolist (source ac-sources)
      (if (symbolp source)
          (setq source (symbol-value source)))
      (let* ((ac-limit (or (cdr-safe (assq 'limit source)) ac-limit))
             (requires (cdr-safe (assq 'requires source)))
             cand)
        (if (or (null requires)
                (>= (length ac-target) requires))
            (setq cand
                  (delq nil
                        (mapcar (lambda (candidate)
                                  (propertize candidate 'source source))
                                (funcall (cdr (assq 'candidates source)))))))
        (if (and (> ac-limit 1)
                 (> (length cand) ac-limit))
            (setcdr (nthcdr (1- ac-limit) cand) nil))
        (setq candidates (append candidates cand))))
    (delete-dups candidates)))

;;Ryan's python specific tab completion
(defun ryan-python-tab ()
  ; Try the following:
  ; 1) Do a yasnippet expansion
  ; 2) Do a Rope code completion
  ; 3) Do an indent
  (interactive)
  (let ((result (ac-start)))
    (if (or (not result) (eql (ac-start) 0))
	(indent-for-tab-command))))

(defadvice ac-start (before advice-turn-on-auto-start activate)
  (set (make-local-variable 'ac-auto-start) t))

(defadvice ac-cleanup (after advice-turn-off-auto-start activate)
  (set (make-local-variable 'ac-auto-start) nil))

(define-key python-mode-map "\t" 'ryan-python-tab)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; End Auto Completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun my-python-hook ()
  (set (make-local-variable 'no-cleanup) nil)
  (add-hook 'before-save-hook (lambda ()
				(when (not no-cleanup)
				  (whitespace-cleanup)))
	    nil t)
  (column-marker-1 79)
  ;;			      (add-hook 'before-save-hook '(lambda () (untabify 0 (buffer-end 1))) nil t)
  (setq whitespace-indent-tabs-mode nil)
  (auto-complete-mode 1)
  (set (make-local-variable 'ac-sources)
       (append ac-sources '(ac-source-rope) '(ac-source-yasnippet)))
  (set (make-local-variable 'ac-find-function) 'ac-python-find)
  (set (make-local-variable 'ac-candidate-function) 'ac-python-candidate)
  (set (make-local-variable 'ac-auto-start) nil))


(add-hook 'python-mode-hook #'my-python-hook)

(defun save-buffer-no-wscleanup (&rest args)
  (interactive "p")
  (let ((no-cleanup t))
    (apply #'save-buffer args)))
