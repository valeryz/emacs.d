;; .emacs for valeryz

(setq inhibit-splash-screen t)
(tool-bar-mode 0)
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setenv "YB_DEV" "1")

(load "~/.emacs.d/el-get/el-get/el-get.el")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (goto-char (point-max))
     (eval-print-last-sexp))))

(setq el-get-sources
      '((:name jslint-v8
	       :type git
	       :url "http://github.com/valeryz/jslint-v8.git"
	       :features flymake-jslint)))


(el-get 'sync)

;; fix lack of redisplay on scroll
(setq redisplay-dont-pause t)

;; Column numbering, width and 79 column limit
(setq fill-column 79)
(column-marker-1 79)
(column-number-mode 1)

;; Highlight parenthesis
(show-paren-mode t)
(setq show-paren-style 'parenthesis)

;; Language environment
(setenv "LANG" "ru_RU.UTF-8")
(set-language-environment "UTF-8")
(setq default-input-method "russian-computer")
;; All UTF-8
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; Uniquify
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
;;(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers)

;; Some scrolling settings
(setq scroll-preserve-screen-position t)
(setq scroll-margin 2)
(setq isearch-allow-scroll t)

;; Start Emacs Server
(server-start)

;; display current function name in the modeline
(which-function-mode)

;; Where to look for info files
(add-to-list 'Info-default-directory-list "/opt/local/share/info")

(setq dired-isearch-filenames 'dwim)

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

(require 'auto-complete-config)
(global-auto-complete-mode t)

(require 'ido)
(ido-mode t)

;; shortcut for markdown mode files
(add-to-list 'auto-mode-alist
             '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist
             '("\\.pl\\'" . prolog-mode))

;;; a shortcut to kill all tramp buffers at once
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

;; Load mode specific settings
(add-to-list 'load-path "~/.emacs.d/")
(load "c-settings")
(load "common-lisp")
(load "org-settings")
(load "js-settings")
(load "python-settings")

;; (add-to-list 'load-path "/usr/local/Cellar/erlang/R15B02/lib/erlang/lib/tools-2.6.8/emacs")
;; (require 'erlang)

(setq custom-file "~/.emacs.d/custom.el")

(load custom-file)
