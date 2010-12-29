;;;; trampelb.el --- User specific settings.

;; Save backups in one place
;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir
  (concat "~/tmp/emacs_autosaves/" (user-login-name)
           "/"))

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name
             (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

;; Commands
(require 'unbound)

;; Setup the color-theme to be taming-mr-arneson
(add-to-list 'load-path (concat dotfiles-dir "/trampelb/color-theme" ))
(require 'color-theme)
(color-theme-initialize)
(setq color-theme-is-global t)
(color-theme-taming-mr-arneson)

;; Functions
(require 'line-num)

;; Some Mac-friendly key counterparts
(global-set-key (kbd "M-s") 'save-buffer)
(global-set-key (kbd "M-z") 'undo)

;; Set the path to get git working
(setenv "PATH" "/Applications/liftweb-1.0/apache-maven/bin:/opt/local/bin:/opt/local/sbin:/opt/local/bin:/opt/local/sbin:/opt/local/bin:/opt/local/sbin:/Applications/liftweb-1.0/apache-maven/bin:/Users/trampelb/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin")

;; Scala mode
(add-to-list 'load-path "~/.emacs.d/trampelb/scala-mode")
(require 'scala-mode-auto)
(add-hook 'scala-mode-hook
          '(lambda ()
             (yas/minor-mode-on)))

;; Other

(prefer-coding-system 'utf-8)

(server-start)

;; Set the font
(modify-frame-parameters
     (selected-frame)
     '((font . "-*-inconsolata-*-*-*-*-12-*-*-*-*-*-*")))

(add-hook 'after-make-frame-functions
          (lambda (frame)
            (modify-frame-parameters
             frame
             '((font . "-*-inconsolata-*-*-*-*-12-*-*-*-*-*-*")))))

;; ========= Delete trailing whitespace on save =============

(add-hook 'python-mode-hook
    (lambda ()
        (setq show-trailing-whitespace t)
        (make-local-hook 'before-save-hook)
        (add-hook 'before-save-hook 'delete-trailing-whitespace)))
(add-hook 'scala-mode-hook
    (lambda ()
        (setq show-trailing-whitespace t)
        (make-local-hook 'before-save-hook)
        (add-hook 'before-save-hook 'delete-trailing-whitespace)))
(add-hook 'espresso-mode-hook
    (lambda ()
        (setq show-trailing-whitespace t)
        (make-local-hook 'before-save-hook)
        (add-hook 'before-save-hook 'delete-trailing-whitespace)))

;; ===== Turn off tab character =====

;;
;; Emacs normally uses both tabs and spaces to indent lines. If you
;; prefer, all indentation can be made from spaces only. To request this,
;; set `indent-tabs-mode' to `nil'. This is a per-buffer variable;
;; altering the variable affects only the current buffer, but it can be
;; disabled for all buffers.

;;
;; Use (setq ...) to set value locally to a buffer
;; Use (setq-default ...) to set value globally
;;

(setq-default indent-tabs-mode nil)

;; ========== Set the fill column ==========

(setq-default fill-column 79)

;; ===== Turn on Auto Fill mode automatically in all modes =====

;; Auto-fill-mode the the automatic wrapping of lines and insertion of
;; newlines when the cursor goes over the column limit.

;; This should actually turn on auto-fill-mode by default in all major
;; modes. The other way to do this is to turn on the fill for specific modes
;; via hooks.

(setq auto-fill-mode 1)

(add-to-list 'initial-frame-alist '(top . 0))
(add-to-list 'initial-frame-alist '(left . 0))
(add-to-list 'default-frame-alist '(height . 71))
(add-to-list 'default-frame-alist '(width . 80))
(add-to-list 'default-frame-alist '(top . 0))
(add-to-list 'default-frame-alist '(left . 0))

(scroll-bar-mode nil)

;; I'd like emacsclient to take stdin.
(defun fake-stdin-slurp (filename)
  "Emulate stdin slurp using emacsclient hack"
  (switch-to-buffer (generate-new-buffer "*stdin*"))
  (insert-file filename)
  (end-of-buffer))
