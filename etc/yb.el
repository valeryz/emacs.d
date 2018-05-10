(setq files "'*.lisp'")
(setq dir "~/yb")

(defun yb-grep (pattern)
  (interactive (list
		(read-string (format "Pattern: (%s): " (thing-at-point 'symbol))
			     nil nil (thing-at-point 'symbol))))
  (vc-git-grep pattern files dir))

(defun find-git-repo-dir (dir)
  (if (directory-files dir nil "\.git$")
      dir
      (let ((parent-dir (file-name-directory (directory-file-name dir))))
	(when parent-dir
	  (find-git-repo-dir parent-dir)))))

(defun git-grep (pattern)
  (interactive (list
		(read-string (format "Pattern: (%s): " (thing-at-point 'symbol))
			     nil nil (thing-at-point 'symbol))))
  (vc-git-grep pattern files (find-git-repo-dir
			      (file-name-directory (buffer-file-name)))))

(defun enable-slime-translations ()
  (interactive)
  (push (slime-create-filename-translator :machine-instance "green4.yobetit.com"
					  :remote-host "internal4.yobetit.com"
					  :username "lisp")
	slime-filename-translations)
  (push (slime-create-filename-translator :machine-instance "green1.yobetit.com"
					  :remote-host "internal1.yobetit.com"
					  :username "lisp")
	slime-filename-translations))

(defun disable-slime-translations ()
  (interactive)
  (setq slime-filename-translations nil))




