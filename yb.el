(setq files "'*.lisp'")
(setq dir "~/yb")

(defun yb-grep (pattern)
  (interactive (list
		(read-string (format "Pattern: (%s): " (thing-at-point 'symbol))
			     nil nil (thing-at-point 'symbol))))
  (vc-git-grep pattern files dir))
