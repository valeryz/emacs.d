(require 'flymake-jslint)
;; (require 'js2-mode)

;; (require 'gjslint)
(add-hook 'js-mode-hook
	  (lambda ()
	    (flymake-mode t)
	    (setq comment-start "/* " comment-end " */")
	    (setq comment-multi-line t)
	    (setq whitespace-indent-tabs-mode nil)
	    (setq indent-tabs-mode nil)))
;; (add-hook 'js2-mode-hook
;;	  (lambda () (flymake-mode t)))

;; (add-to-list 'auto-mode-alist
;; 	     '("\\.js\\'" . js2-mode))

