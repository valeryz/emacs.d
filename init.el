;; Basics
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq visible-bell nil)
(tool-bar-mode 0)
(scroll-bar-mode -1)
(recentf-mode 1)
(set-fringe-mode 2)

(load "/Users/vz/code/motoko/emacs/init.el")

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
(load-theme 'wombat)

;; Package setup
(require 'package)

(setenv "PATH" (concat "/Users/vz/.cargo/bin:" (getenv "PATH")))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

		      
(require 'use-package)
(setq use-package-always-ensure t)

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
         ("C-x b" . counsel-ibuffer)))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(setq-default indent-tabs-mode nil)


(defun rust-settings ()
  "Rust settings"
  (setq indent-tabs-mode nil)
  (setq rust-indent-unit 4))

(use-package lsp-mode
  :ensure t
  :defer t
  :hook (lsp-mode . (lambda ()
                      (let ((lsp-keymap-prefix "C-c l"))
                        (lsp-enable-which-key-integration))))
  :init
  (setq lsp-keep-workspace-alive nil
        lsp-signature-doc-lines 5
        lsp-idle-delay 0.5
        lsp-prefer-capf t
        lsp-client-packages nil)
  :config
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

(require 'lsp-rust)

(use-package yaml-mode)

(use-package rust-mode
  :hook
  (rust-mode . lsp-deferred)
  (rust-mode . rust-settings))

(use-package company
  :init (global-company-mode)
  :diminish company-mode)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :config (which-key-mode))

(use-package lsp-ivy)

(use-package solidity-mode)


(use-package yasnippet)

(use-package adoc-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yaml yaml-mode ivy-rich adoc-mode rainbow-delimiters company-lsp lsp-ui swift-mode motoko-mode yasnippet yasnippets solidity-mode company company-mode lsp-ivy which-key projectile rust-mode magit doom-modeline counsel ivy command-log-mode use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
