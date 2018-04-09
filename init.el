;;;
;;; .emacs for valeryz

(setq inhibit-splash-screen t)
(tool-bar-mode 0)
(scroll-bar-mode -1)
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

;; (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
;; (setenv "YB_DEV" "1")

(setenv "GOROOT" "/home/vz/go1.8")
(setenv "PATH" (concat (getenv "PATH") ":" (getenv "GOROOT") "/bin"))

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    material-theme))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; el-get
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(setq el-get-sources
      '((:name jslint-v8
	       :type git
	       :url "http://github.com/valeryz/jslint-v8.git"
	       :features flymake-jslint)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

(el-get 'sync)

;; ace jump
(require 'ace-jump-mode)
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)

;; fix lack of redisplay on scroll
(setq redisplay-dont-pause t)

;; customize file backup settings
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

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
(add-to-list 'auto-mode-alist
             '("\\.m\\'" . octave-mode))


(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(defun tramp-buffer-p (buf)
  "is this buffer tramp's one"
  (or (string-match "^\\*tramp" (buffer-name buf))
      (tramp-tramp-file-p (with-current-buffer buf
                            (ibuffer-buffer-file-name)))))

;; recent files
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;;; a shortcut to kill all tramp buffers at once
(defun kill-tramp-buffers ()
  "kill all TRAMP buffers"
  (interactive)
  (dolist (buf (buffer-list))
    (when (tramp-buffer-p buf)
      (kill-buffer buf))))

(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)


;; (load "google-settings")
(defun load-ext (ext)
  (load (concat (getenv "HOME") "/.emacs.d/" ext)))
(load-ext "c-settings")
;; (load "common-lisp")
(load-ext "org-settings")
(load-ext "js-settings")
(load-ext "python-settings")
;; G(load-ext "python-settings-elpy")

(setq TeX-auto-save t)
(setq TeX-parse-self t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(setq custom-file "~/.emacs.d/custom.el")

(load custom-file)
(put 'erase-buffer 'disabled nil)
