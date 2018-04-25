(require 'company)
(require 'flycheck)
(require 'yasnippet)
(require 'multi-compile)
(require 'go-eldoc)
(require 'company-go)
(require 'go-guru)

(defun my-golang-hook ()
  (set (make-local-variable 'company-backends) '(company-go))
  (company-mode)
  (go-eldoc-setup)
  (setq-default gofmt-command "goimports")
  (yas-minor-mode)
  (flycheck-mode)
  (add-hook 'before-save-hook 'gofmt-before-save))

(add-hook 'go-mode-hook 'my-golang-hook)

(setq multi-compile-alist
      '((go-mode . (("go-build" "go build -v"
                     (locate-dominating-file buffer-file-name ".git"))
                    ("go-build-and-run" "go build -v && echo 'build finish' && eval ./${PWD##*/}"
                     (multi-compile-locate-file-dir ".git"))))))
