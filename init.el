;;; init.el --- my emacs configuration.
;;; Commentary:
;;; This is for both work and home.
;;; 
;;; Code:
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq visible-bell nil)
(tool-bar-mode 0)
(scroll-bar-mode -1)
(recentf-mode 1)
(set-fringe-mode 2)

(load (concat (getenv "HOME") "/code/motoko/emacs/init.el"))

;; Backup files
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Mac Keyboard
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

;; Font
(set-face-attribute 'default nil :font "Menlo" :height 140)


;; Package setup
(require 'package)
(setq package-selected-packages
      '(rjsx-mode js-mode zenburn dap-mode json-mode yaml yaml-mode ivy-rich
                  adoc-mode rainbow-delimiters company-lsp lsp-ui swift-mode
                  motoko-mode yasnippet yasnippets solidity-mode company
                  company-mode lsp-ivy which-key projectile rust-mode magit
                  doom-modeline counsel ivy command-log-mode use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package zenburn-theme)
;;(load-theme 'wombat)
(load-theme 'zenburn t)


(setenv "PATH" (concat (getenv "HOME")
                       "/.cargo/bin:/usr/local/bin:/opt/homebrew/bin:" (getenv "PATH")))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))


(add-to-list 'load-path "/Users/vz/.opam/default/share/emacs/site-lisp/")


(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper))
  :config
  (ivy-mode t)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-wrap t)
  (setq ivy-count-format "(%d/%d)")
  (setq enable-recursive-minibuffers t))

(use-package ivy-rich
  :init (ivy-rich-mode 1))

(use-package counsel
  :diminish
  :bind (("M-x" . counsel-M-x)
         ("C-x f" . counsel-find-file)
         ("C-x b" . counsel-ibuffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))


(setq scilla-mode-path "/Users/vz/scilla/misc/emacs-mode/scilla-mode.el")
(setq scilla-bin-path "/Users/vz/scilla/scilla-checkers-and-runners/bin")
(setq scilla-stdlib-path "/Users/vz/scilla/stdlib")


(use-package scilla
  :load-path (lambda () scilla-mode-path))


(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired)
  (setq projectile-use-git-grep t))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(setq-default indent-tabs-mode nil)


(defun rust-settings ()
  "Rust settings."
  (setq indent-tabs-mode nil)
  (setq rust-indent-unit 4))


(use-package dap-mode
  :ensure t)

(use-package rjsx-mode
  :ensure t)

(use-package lsp-mode
  :ensure t
  :hook
  ((js-mode . lsp)
   (lsp-mode . (lambda ()
                      (let ((lsp-keymap-prefix "C-c l"))
                        (lsp-enable-which-key-integration)))))
  :init
  (progn
    (setq lsp-keep-workspace-alive nil
          lsp-signature-doc-lines 5
          lsp-idle-delay 0.5
          lsp-prefer-capf t
          lsp-client-packages nil)
    (require 'dap-chrome)
    (require 'lsp-rust)
    (require 'lsp-javascript)
    (require 'lsp-json)
    (yas-global-mode))
  :config
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

(use-package lsp-treemacs)


(use-package yaml-mode
  :ensure t)

(use-package rust-mode
  :hook
  (rust-mode . lsp-deferred)
  (rust-mode . rust-settings))

;;(use-package flycheck-rust)

;; (with-eval-after-load 'rust-mode
;;   (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package company
  :init (global-company-mode)
  :diminish company-mode)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :config (which-key-mode))

(use-package lsp-ivy)

(use-package solidity-mode)

(use-package dap-mode)

(use-package rjsx-mode)

(use-package yasnippet)

(use-package adoc-mode)

(use-package json-mode)

(use-package vue-mode)

(add-hook 'c-mode-hook 'counsel-gtags-mode)
(add-hook 'c++-mode-hook 'counsel-gtags-mode)

;; C. Add the following code in .emacs.d/init.el
;; js-comint                                                                                                    
(require 'js-comint)
(setq inferior-js-program-command "node2")
(add-hook 'js2-mode-hook '(lambda ()
                            (local-set-key "\C-x\C-e" 'js-send-last-sexp)
                            (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
                            (local-set-key "\C-cb" 'js-send-buffer)
                            (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
                            (local-set-key "\C-cl" 'js-load-file-and-go)
                            (local-set-key "\C-c\C-r" 'js-send-region)
                            ))

(with-eval-after-load 'counsel-gtags
  (define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-find-definition)
  (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
  (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
  (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward))

(defun copy-current-buffer-file-name ()
  (interactive)
  (shell-command (concat "echo " (buffer-file-name) " | pbcopy")))

(global-set-key (kbd "C-x M-f") 'copy-current-buffer-file-name)

;; Ocaml
(add-to-list 'load-path "/Users/vz/.opam/cs3110-2022fa/share/emacs/site-lisp")
 (load "/Users/vz/.opam/cs3110-2022fa/share/emacs/site-lisp/tuareg-site-file")`
(require 'ocp-indent)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3b8284e207ff93dfc5e5ada8b7b00a3305351a3fb222782d8033a400a48eca48" default))
 '(lsp-lens-enable t)
 '(package-selected-packages
   '(diffpdf ocamlformat nix-mode proof-general zzz-to-char js-comint counsel-gtags flycheck-rust vue-mode rjsx-mode js-mode zenburn dap-mode json-mode yaml yaml-mode ivy-rich adoc-mode rainbow-delimiters company-lsp lsp-ui swift-mode motoko-mode yasnippet yasnippets solidity-mode company company-mode lsp-ivy which-key projectile rust-mode magit doom-modeline counsel ivy command-log-mode use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
