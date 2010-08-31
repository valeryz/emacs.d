(add-to-list 'load-path "~/slime")
(require 'slime)

;; (require 'clojure-mode)
(require 'paredit)

(add-hook 'lisp-mode-hook '(lambda ()
			    (setq fill-column 79)
			    (column-marker-1 79)
			    (add-hook 'before-save-hook 'whitespace-cleanup nil t)))


(setq inferior-lisp-program "/Users/vz/bin/ccl64")
(setq slime-lisp-implementations
      '((ccl64 ("/Users/vz/bin/ccl64") :coding-system utf-8-unix)
	(ccl32 ("/Users/vz/bin/ccl") :coding-system utf-8-unix)
	(ecl ("/opt/local/bin/ecl"))
	(acl ("/Applications/AllegroCL/alisp"))
	(sbcl ("~/bin/sbcl") :coding-system utf-8-unix)))

(setq common-lisp-hyperspec-root "file:/opt/local/share/doc/lisp/HyperSpec-7-0/HyperSpec/")
 
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
 
(setq lisp-indent-function 'common-lisp-indent-function
      slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
 
(slime-setup)
(global-set-key "\C-cs" 'slime-selector)


;;;; Scratch
(defvar slime-scratch-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map slime-mode-map)
    map))

(slime-define-keys slime-scratch-mode-map
  ("C-j" 'slime-eval-print-last-expression))

(defun slime-scratch-buffer ()
  "Return the scratch buffer, create it if necessary."
  (or (get-buffer "*slime-scratch*")
      (with-current-buffer (get-buffer-create "*slime-scratch*")
	(lisp-mode)
	(use-local-map slime-scratch-mode-map)
	(slime-mode t) 
	(current-buffer))))


(defun slime-php/macroexpand (&optional repeatedly)
  "Display the macro expansion of the form at point.  The form is
expanded with CL:MACROEXPAND-1 or, if a prefix argument is given, with
CL:MACROEXPAND."
  (interactive "P")
  (slime-eval-macroexpand 'php:php/macroexpand))

