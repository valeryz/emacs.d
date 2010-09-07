;; (add-to-list 'load-path "~/.emacs.d/jslint-v8")
;; (require 'flymake-jslint)
;; (require 'js2-mode)

(require 'gjslint)
(add-hook 'js-mode-hook
	  (lambda () (flymake-mode t)))
;; (add-hook 'js2-mode-hook
;;	  (lambda () (flymake-mode t)))

;; (add-to-list 'auto-mode-alist
;; 	     '("\\.js\\'" . js2-mode))

