(setq my-tramp-host "localhost")

(defvar *my-box-tramp-path*
  "/ssh:vz@192.168.1.3:")
 
(defvar *current-tramp-path* nil)
(defun connect-to-host (path)
  (setq *current-tramp-path* path)
  (setq slime-translate-from-lisp-filename-function
    (lambda (f)
      (concat *current-tramp-path* f)))
  (setq slime-translate-to-lisp-filename-function
    (lambda (f)
      (substring f (length *current-tramp-path*))))
  (slime-connect "localhost" 4005))
 
(defun my-box-slime ()
  (interactive)
  (connect-to-host *my-box-tramp-path*))
 
(defun my-box-homedir ()
  (interactive)
  (find-file *my-box-tramp-path*))

(setq *HOME* "/Users/vz")

(defun emacs-save-layout ();TODO: handle eshell
  "save the frame and window layout to ~/.emacs-layout. Requires revive.el."
(interactive)
(let ((out-name (concat *HOME* "/.emacs-layout"))
      (frames (frame-list))
      (configs nil)
      (buffs (sorted-buffer-list))
      (filtered-buffs nil)
      (s-buffs nil))
  (dolist (b buffs)    
      (let ((file-name (buffer-file-name b)))
        (when (and file-name
                   (> (length file-name) 0))
          (setq filtered-buffs (cons file-name filtered-buffs)))))
  (when filtered-buffs (setq filtered-buffs (reverse filtered-buffs)))
  (dolist (frame frames)
    (select-frame frame)
    (setq configs (cons (current-window-configuration-printable) configs)))
  (setq configs (cons filtered-buffs configs))
  (write-region (with-output-to-string (prin1 configs)) nil out-name)))

(defun emacs-load-layout () ;TODO: handle eshell buffers.
  "Load the layout saved by emacs-save-layout. Requires revive.el."
(interactive)
(let* ((in-name (concat *HOME* "/.emacs-layout"))
      (config-count 0)
      (frames (frame-list))
      (configs nil)
      (frame-count (length frames))
      (buffs nil))
  (with-temp-buffer
    (insert-file-contents-literally in-name)
    (setq buffs (read (current-buffer)))
    (setq configs (rest buffs))
    (setq buffs (first buffs)))
  (dolist (b buffs)
    (find-file-noselect b)
    (message "Loading buffer %s" b))
  (setq config-count (length configs))
  (message "Config count is %s" config-count)
  (unless (>= frame-count config-count)
    (dotimes (i (- config-count frame-count))
      (make-frame))
    (setq frames (frame-list))
    (setq frame-count (length frames))
    (message "frame-count is %s" frame-count))
  (defun it (lconfigs lframes)
            (when (and lconfigs lframes)
              (select-frame (first lframes))
              (restore-window-configuration (first lconfigs))
              (it (rest lconfigs) (rest lframes))))
  (it configs frames)))

