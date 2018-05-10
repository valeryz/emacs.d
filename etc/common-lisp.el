;; (require 'clojure-mode)
(require 'paredit)

(setq slime-net-coding-system 'utf-8-unix)
(setenv "CCL_DEFAULT_DIRECTORY" "/Users/vz/ccl")
(load (expand-file-name "~/quicklisp/slime-helper.el"))



(setq inferior-lisp-program "/Users/vz/ccl/scripts/ccl64 -K utf-8")

(setq slime-lisp-implementations
      '((ccl ("/Users/vz/ccl/scripts/ccl64") :coding-system utf-8-unix)
	(sbcl ("/Users/vz/sbcl-1.1.8/run-sbcl.sh") :coding-system utf-8-unix)))
 
(global-set-key "\C-cs" 'slime-selector)

(add-hook 'lisp-mode-hook '(lambda ()
			    (setq fill-column 79)
			    (column-marker-1 79)
			    (setq whitespace-indent-tabs-mode nil)
			    (add-hook 'before-save-hook 'whitespace-cleanup nil t)
			    (auto-complete-mode 0)
			    ))


(setq common-lisp-hyperspec-root "/Users/vz/HyperSpec-7-0/HyperSpec/")
 
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
 
(setq lisp-indent-function 'common-lisp-indent-function
      slime-complete-symbol-function 'slime-fuzzy-complete-symbol)

(defun my-customize-slime-keys () 
;;;; Scratch
  (defvar slime-scratch-mode-map
    (let ((map (make-sparse-keymap)))
      (set-keymap-parent map slime-mode-map)
      map))
  (slime-define-keys slime-scratch-mode-map
		     ("C-j" 'slime-eval-print-last-expression)))

(add-hook 'slime-lisp-mode-hook #'my-customize-slime-keys)

(defun slime-scratch-buffer ()
  "Return the scratch buffer, create it if necessary."
  (or (get-buffer "*slime-scratch*")
      (with-current-buffer (get-buffer-create "*slime-scratch*")
	(lisp-mode)
	(use-local-map slime-scratch-mode-map)
	(slime-mode t) 
	(current-buffer))))


(slime-setup '(slime-fancy slime-tramp))

;; (defun slime-php/macroexpand (&optional repeatedly) 
;;   "Display the macro expansion of the form at point.  The form is
;; expanded with CL:MACROEXPAND-1 or, if a prefix argument is given, with
;; CL:MACROEXPAND."
;;   (interactive "P")
;;   (slime-eval-macroexpand 'php:php/macroexpand))

(load "yb.el")

(load "/Users/vz/gbbopen/browse-hyperdoc.el")
;; (load "/Users/vz/quicklisp/dists/quicklisp/software/gbbopen-20110619-svn/gbbopen-indent.el")


(defadvice slime-quit-lisp (around alert-sbcl activate)
  (let ((process (slime-inferior-process (slime-connection))))
    ad-do-it (process-send-eof process)))
