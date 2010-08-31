;; Various Emacs-LISP Utilities

(defun hex-to-num (h)
  (cond ((and (>= h ?0)
	      (<= h ?9))
	 (- h ?0))
	((and (>= h ?A)
	      (<= h ?F))
	 (+ (- h ?A) 10))
	((and (>= h ?a)
	      (<= h ?f))
	 (+ (- h ?a) 10))
	(t (error "invalid hex"))))
      
(defun hex-to-bin (s)
  (let ((bin)
	(number))
    (dotimes (i (length s))
      (if number
	  (progn
	    (push (+ (hex-to-num (aref s i))
		     (ash number 4))
		  bin)
	    (setq number nil))
	  (setq number (hex-to-num (aref s i)))))
    (apply #'string (nreverse bin))))

(defun dima-hex-to-bin (&optional start end)
  "Convert the simple Dima's hexdump to binary buffer"
  (interactive "r")
  (save-excursion
    (goto-char start)
    (let ((str (buffer-substring start end)))
      (set-buffer (get-buffer-create "*binary-data*"))
      (set-buffer-file-coding-system 'latin-1)
      (erase-buffer)
      (insert (hex-to-bin str))
      (write-file "/tmp/hh.bin" nil)))
  (goto-char end)
  (newline)
  (shell-command (concat "hexdump -C /tmp/hh.bin"))
  (insert-buffer (get-buffer "*Shell Command Output*")))


(defun collect-case-labels (&optional start end)
  "Collect case labels from C/C++/Java code"
  (interactive "r")
  (save-excursion
    (goto-char start)
    (let (labels)
      (while (re-search-forward "case \\(.*\\):" end t)
	(push (match-string 1) labels))
      (set-buffer (get-buffer-create "*case-labels*"))
      (erase-buffer)
      (insert (mapconcat #'identity (nreverse labels) ",\n"))))
  (pop-to-buffer "*case-labels*"))

(defun aquo (&optional start end)
  "Quote with &laquo; / &raquo;"
  (interactive "r")
  (goto-char end)
  (insert "&raquo;")
  (goto-char start)
  (insert "&laquo;"))

(defun insert-date-string ()
  "Insert a nicely formated date string."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))

(global-set-key (kbd "C-c i") 'insert-date-string)

(defun file-to-c-array (filename)
  "convert a binary file into a C array of characters"
  (interactive "fFile Name: ")
  (let* ((buf (find-file-noselect filename nil t))
	 (oldbuf (current-buffer)))
	 (save-excursion
	   (insert "\nconst unsigned char key[] = {")
	   (set-buffer buf)
	   (beginning-of-buffer)
	   (let ((i 0))
	     (while (not (eobp))
	       (let* ((c (following-char)))
		 (forward-char)
		 (set-buffer oldbuf)
		 (when (zerop (mod i 8))
		   (insert "\n\t"))
		 (incf i)
		 (insert (format "0x%x, " c))
		 (set-buffer buf))))
	   (set-buffer oldbuf)
	   (delete-backward-char 2)
	   (insert "\n};\n"))))
