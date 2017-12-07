(require 'org)
(add-hook 'org-mode-hook
	  (lambda () (imenu-add-to-menubar "Imenu")))

;; adding ticket numbers with links for Trac

(defun str-ticket (ticket-num)
  (if (boundp 'ticket-url-template)
      (concat "[[" (format ticket-url-template ticket-num)
		  "][#" (int-to-string ticket-num) "]]")
      (error "ticket-url-template not defined")))

(defun ticket (ticket-num)
  "insert the RVS ticket number as a hyperlink to Org mode"
  (interactive "nEnter ticket number: ")
  (insert (str-ticket ticket-num)))

(defun org-set-ticket (ticket-num)
  "insert the RVS ticket number as a hyperlink to Org mode"
  (interactive "nEnter ticket number: ")
  (org-set-property "ticket" (str-ticket ticket-num)))

(define-key org-mode-map (kbd "C-c C-x t") 'org-set-ticket)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-iswitchb)


(setq org-special-ctrl-a/e t)
(setq org-log-done t)

(setq org-insert-mode-line-in-empty-file t)

(setq org-directory "~/org")
(setq org-agenda-files (mapcar (lambda (fname) (concat org-directory "/" fname))
			       '("TASKS.org" "pycon.org" "shop.org" "think.org" "KGP.org" "GOALS.org"
				 "projects.org")))

(setq org-mobile-checksum-binary "/sbin/md5")

;; (org-remember-insinuate)
(setq org-default-notes-file (concat org-directory "/" "notes.org"))
(define-key global-map "\C-cr" 'org-remember)

;; MobileOrg
(setq org-mobile-inbox-for-pull "~/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/MobileOrg")


(defun my-feed-parse-entry (entry)
  "parse the feed entry and provide a nice description"
  (let ((entry (org-feed-parse-rss-entry entry))) ;; wrap Org Mode function
    (plist-put entry
	       :description
	       (url-insert-entities-in-string (plist-get entry :description)))))

;; (setq org-feed-alist
;;            '(("RVS" "https://dev-ng.zoral.com.ua/projects/rvs/report/9?format=rss&USER=vz"
;;               "~/org/RVS.org" "RVS Tickets" :parse-entry my-feed-parse-entry)
;; 	     ("kgp" "https://dev-ng.zoral.com.ua/projects/kgp/report/1?format=rss&USER=vz"
;; 		   "~/org/KGP.org" "KGP Tickets" :parse-entry my-feed-parse-entry)))

;; (setq org-link-abbrev-alist
;;       '(("rvs" . "https://dev-ng.zoral.com.ua/projects/rvs/ticket/")))

;; (setq org-refile-targets '(("TASKS.org" . (:regexp . "RVS Tasks"))))

;; (setq org-ditaa-jar-path "/Users/vz/Downloads/ditaa0_9/dita0_9.jar")
