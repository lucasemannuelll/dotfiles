(setq max-lisp-eval-depth 10000)
(setq read-process-output-max (* 1024 1024)) ;; 1MB buffer for process output

(setq user-emacs-directory "~/.config/emacs/")

(setq custom-file (make-temp-file "emacs-custom"))
(setq-default custom-file null-device)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

(setq inhibit-startup-message t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode t)
(column-number-mode t)
(setq display-line-numbers-type 'visual)

(delete-selection-mode t)
(global-unset-key (kbd "C-z"))

(setq mouse-wheel-scroll-amount '(2 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse 't
      scroll-step 1)
(setq scroll-margin 8)

(load-theme 'wombat t)

(setq-default cursor-type 'bar)

(electric-pair-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)
(setq-default indent-tabs-mode nil)

(icomplete-vertical-mode 1)
(setq icomplete-show-matches-on-no-input t)

(setq-default tab-width 4)

(global-set-key (kbd "C-x C-b") 'ibuffer)
