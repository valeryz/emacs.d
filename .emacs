;; .emacs
(setenv "PATH" "/Users/vz/bin:/opt/local/bin:/Library/Frameworks/Python.framework/Versions/2.6/bin:/opt/local/Library/Frameworks/Python.framework/Versions/2.6/bin:/usr/bin:/usr/local/bin")

(setq *settings-dir* "~/.emacs.d/")

(setq inhibit-splash-screen t)

(tool-bar-mode 0)

(setq set-mark-command-repeat-pop t)
(setq kill-read-only-ok t)

(add-to-list 'load-path *settings-dir*)

;; GNU global
(add-to-list 'load-path "/opt/local/share/gtags")
(require 'gtags)

;; HTML5
(add-to-list 'load-path "~/.emacs.d/html5-el/")
(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files "~/code/html5-el/schemas.xml"))

(require 'whattf-dt)

;; ECB
(add-to-list 'load-path "~/.emacs.d/ecb/")
(require 'cedet)
(require 'ecb)

(set-language-environment "UTF-8")
(setq default-input-method "russian-computer")

(require 'tramp)
(setq tramp-default-method "scpc")

;; set fill column and mark columns so that we don't exceed 79 width
(require 'column-marker)
(setq fill-column 79)
(column-marker-1 79)

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
;;(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers)

(require 'desktop-menu)

;; Some global EMACS Settings
(setq calendar-week-start-day 1)
(global-auto-composition-mode 1)

;; right 'option' is my Meta key
(setq ns-right-alternate-modifier 'meta)

;; color theme
;; (add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
;; (require 'color-theme) \
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-hober)))


;; set all UTF-8
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(load "utils")
(load "c-settings")
(load "common-lisp")
(load "org-settings")
(load "erlang-settings")
(load "misc")
(load "js-settings")

;; Use NXML Mode for XML 
(add-to-list 'auto-mode-alist '("\\.xml$" . nxml-mode))

;; Highlight parenthesis
(show-paren-mode t)
(setq show-paren-style 'mixed)

;; Some scrolling settings
(setq scroll-preserve-screen-position t)
(setq scroll-margin 2)
(setq isearch-allow-scroll t)
;; Start Emacs Server
(server-start)

;; display current function name in the modeline
(which-function-mode)

;; revive.el
(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe Emacs" t)

;; Where to look for info files
(add-to-list 'Info-default-directory-list "/opt/local/share/info")

;; Global Key Bindings

(when (fboundp 'ns-toggle-fullscreen)
  (global-set-key (kbd "<s-return>") 'ns-toggle-fullscreen))

(global-set-key (kbd "<f6>")   ;; F6 will stop the clock
                (lambda () (interactive) (org-clock-out)
                        (save-excursion
                          (set-buffer (get-buffer "TASKS.org"))
                          (save-buffer))))

(global-set-key (kbd "<f5>")   ;; F5 will start the clock
                (lambda ()
                  (interactive)
                  (org-clock-in '(4))))

(global-set-key (kbd "C-x P") (lambda ()
                                (interactive)
                                (find-file (concat *settings-dir*
                                                   "Preferences.el"))))

;; Start KGP project's Django shell
(defun py-django ()
  (interactive)
  (let ((py-which-shell (expand-file-name
                         "~/Desktop/projects/kgp/Src/portal/bin/django"))
        (py-which-args '("shell")))
    (cd "~/Desktop/projects/kgp/Src/portal/")
    (py-shell)))

(require 'imenu)

(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

(require 'auto-complete)
(global-auto-complete-mode t)

(add-to-list 'load-path (concat *settings-dir* "yasnippet-0.6.1c/"))
(require 'yasnippet)
(setq yas/trigger-key (kbd "C-c <kp-multiply>"))
(yas/initialize)
(yas/load-directory (concat *settings-dir* "yasnippet-0.6.1c/snippets"))

;; put python settings after autocomplete/yasnippet
(load "python-settings")

(require 'ido)
(ido-mode t)

(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)

(add-to-list 'auto-mode-alist
             '("\\.md\\'" . markdown-mode))


;;; a shortcut to kill all tramp buffers at once
;;;
(require 'ibuffer)

(defun tramp-buffer-p (buf)
  "is this buffer tramp's one"
  (or (string-match "^\\*tramp" (buffer-name buf))
      (tramp-tramp-file-p (with-current-buffer buf
                            (ibuffer-buffer-file-name)))))

(defun kill-tramp-buffers ()
  "kill all TRAMP buffers"
  (interactive)
  (dolist (buf (buffer-list))
    (when (tramp-buffer-p buf)
      (kill-buffer buf))))

(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(org-agenda-files (quote ("~/org/linuxhacking.org" "~/org/TASKS.org" "~/org/shop.org" "~/org/think.org" "~/org/KGP.org" "~/org/GOALS.org" "~/org/projects.org")))
 '(safe-local-variable-values (quote ((encoding . utf-8) (ticket-url-template . "http://sc-issuetracker.zoral.com.ua/ticket/%d") (ticket-url-template . http://sc-issuetracker\.zoral\.com\.ua/ticket/%s) (test-case-name . twisted\.web\.test\.test_webclient) (test-case-name . twisted\.test\.test_defer) (test-case-name . twisted\.test\.test_task\,twisted\.test\.test_cooperator) (test-case-name . twisted\.test\.test_twistd) (test-case-name . twisted\.conch\.test\.test_transport) (test-case-name . twisted\.conch\.test\.test_connection) (test-case-name . twisted\.conch\.test\.test_knownhosts) (test-case-name . twisted\.conch\.test\.test_manhole) (test-case-name . twisted\.conch\.test\.test_cftp))))
 '(visible-cursor nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "light salmon")))))
