(package-initialize)

(defun my/zoom-in ()
  "Increase font size by 10 points"
  (interactive)
  (set-face-attribute 'default nil
                      :height
                      (+ (face-attribute 'default :height)
                         10)))

(defun my/zoom-out ()
  "Decrease font size by 10 points"
  (interactive)
  (set-face-attribute 'default nil
                      :height
                      (- (face-attribute 'default :height)
                         10)))


(require 'package)
(customize-set-variable 'package-archives
                        `(,@package-archives
                          ("melpa" . "https://melpa.org/packages/")
                          ("org" . "https://orgmode.org/elpa/")
                           ("gnu" . "https://elpa.gnu.org/packages/")
                          ))
(customize-set-variable 'package-enable-at-startup nil)
(package-initialize)

(defalias 'yes-or-no-p 'y-or-n-p) 

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package delsel
  :bind
  (:map mode-specific-map
        ("C-g" . minibuffer-keyboard-quit)))


(use-package quelpa
  :ensure t
  :defer t
  :custom
  (quelpa-update-melpa-p nil "Don't update the MELPA git repo."))

(use-package quelpa-use-package
  :init
  (setq quelpa-use-package-inhibit-loading-quelpa t)
  :ensure t)

(use-package emacs
  :init
  (put 'narrow-to-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  :custom
  (default-frame-alist '((tool-bar-lines 0)
                         (vertical-scroll-bars)))
  (initial-frame-alist '((vertical-scroll-bars)))
  (scroll-step 1)
  (inhibit-startup-screen t "Don't show splash screen")
  (use-dialog-box nil "Disable dialog boxes")
  (x-gtk-use-system-tooltips nil)
  (enable-recursive-minibuffers t "Allow minibuffer commands in the minibuffer")
  (indent-tabs-mode nil "Spaces!")
  (tab-width 4)
  (debug-on-quit nil))

(use-package frame
  :bind
  ("C-z" . nil))

(use-package delsel
  :bind
  (:map mode-specific-map
        ("C-g" . minibuffer-keyboard-quit)))
(use-package ibuffer
  :bind
  ([remap list-buffers] . ibuffer))

(use-package tramp
  :defer t
  :config
  (put 'temporary-file-directory 'standard-value `(,temporary-file-directory))
  :custom
  (tramp-backup-directory-alist backup-directory-alist)
  (tramp-default-method "ssh")
  (tramp-default-proxies-alist nil))

(use-package sudo-edit
  :defer t
  :ensure t
  :bind (:map ctl-x-map
              ("M-s" . sudo-edit)))

(use-package em-smart
  :defer t
  :config
  (eshell-smart-initialize)
  :custom
  (eshell-where-to-jump 'begin)
  (eshell-review-quick-commands nil)
  (eshell-smart-space-goes-to-end t))

(use-package mule
  :defer 0.1
  :config
  (prefer-coding-system 'utf-8)
  (set-language-environment "UTF-8")
  (set-terminal-coding-system 'utf-8))


(use-package mwheel
  :custom
  (mouse-wheel-scroll-amount '(1
                               ((shift) . 5)
                               ((control))))
  (mouse-wheel-progressive-speed nil))

(use-package pixel-scroll
  :config
  (pixel-scroll-mode))

(use-package time
  :defer t
  :custom
  (display-time-default-load-average nil)
  (display-time-24hr-format t)
  (display-time-mode t))

;; counsel-M-x can use this one
(use-package amx :ensure t :defer t)

(use-package ivy
  :ensure t
  :custom
  ;; (ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (ivy-count-format "%d/%d " "Show anzu-like counter")
  (ivy-use-selectable-prompt t "Make the prompt line selectable")
  :custom-face
  (ivy-current-match ((t (:inherit 'hl-line))))
  :bind
  (:map mode-specific-map
        ("C-r" . ivy-resume))
  :config
  (ivy-mode t))

(use-package ivy-xref
  :ensure t
  :defer t
  :custom
  (xref-show-xrefs-function #'ivy-xref-show-xrefs "Use Ivy to show xrefs"))

(use-package counsel
  :ensure t
  :bind
  (([remap menu-bar-open] . counsel-tmm)
   ([remap insert-char] . counsel-unicode-char)
   ([remap isearch-forward] . counsel-grep-or-swiper)
   :map mode-specific-map
   :prefix-map counsel-prefix-map
   :prefix "c"
   ("a" . counsel-apropos)
   ("b" . counsel-bookmark)
   ("B" . counsel-bookmarked-directory)
   ("c w" . counsel-colors-web)
   ("c e" . counsel-colors-emacs)
   ("d" . counsel-dired-jump)
   ("f" . counsel-file-jump)
   ("F" . counsel-faces)
   ("g" . counsel-org-goto)
   ("h" . counsel-command-history)
   ("H" . counsel-minibuffer-history)
   ("i" . counsel-imenu)
   ("j" . counsel-find-symbol)
   ("l" . counsel-locate)
   ("L" . counsel-find-library)
   ("m" . counsel-mark-ring)
   ("o" . counsel-outline)
   ("O" . counsel-find-file-extern)
   ("p" . counsel-package)
   ("r" . counsel-recentf)
   ("s g" . counsel-grep)
   ("s r" . counsel-rg)
   ("s s" . counsel-ag)
   ("t" . counsel-org-tag)
   ("v" . counsel-set-variable)
   ("w" . counsel-wmctrl)
   :map help-map
   ("F" . counsel-describe-face))
  :custom
  (counsel-grep-base-command
  "rg -i -M 120 --no-heading --line-number --color never %s %s")
  (counsel-search-engines-alist
   '((google
      "http://suggestqueries.google.com/complete/search"
      "https://www.google.com/search?q="
      counsel--search-request-data-google)
     (ddg
      "https://duckduckgo.com/ac/"
      "https://duckduckgo.com/html/?q="
      counsel--search-request-data-ddg)))
  :init
  (counsel-mode))

;; counsel-M-x can use this one
(use-package amx :ensure t :defer t)

(use-package ivy
  :ensure t
  :custom
  ;; (ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (ivy-count-format "%d/%d " "Show anzu-like counter")
  (ivy-use-selectable-prompt t "Make the prompt line selectable")
  :custom-face
  (ivy-current-match ((t (:inherit 'hl-line))))
  :bind
  (:map mode-specific-map
        ("C-r" . ivy-resume))
  :config
  (ivy-mode t))

(use-package swiper :ensure t)

(use-package counsel-world-clock
  :ensure t
  :after counsel
  :bind
  (:map counsel-prefix-map
        ("C" .  counsel-world-clock)))

(use-package ivy-rich
  :ensure t
  :config
  (ivy-rich-mode 1))

(use-package helm-make
  :defer t
  :ensure t
  :custom (helm-make-completion-method 'ivy))


(use-package paren
  :config
  (show-paren-mode t))

(use-package hl-line
  :hook
  (prog-mode . hl-line-mode))

(use-package highlight-numbers
  :ensure t
  :hook
  (prog-mode . highlight-numbers-mode))

(use-package highlight-escape-sequences
  :ensure t
  :config (hes-mode))

(use-package hl-todo
  :ensure t
  :custom-face
  (hl-todo ((t (:inherit hl-todo :italic t))))
  :hook ((prog-mode . hl-todo-mode)
         (yaml-mode . hl-todo-mode)))

(use-package page-break-lines
  :ensure t
  :hook
  (prog-mode . page-break-lines-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-identifiers
  :ensure t
  :custom
  (rainbow-w-identifiers-cie-l*a*b*-choose-face)
  :hook
  (emacs-lisp-mode . rainbow-identifiers-mode) ; actually, turn it off
  (prog-mode . rainbow-identifiers-mode))

(use-package rainbow-mode
  :ensure t
  :hook prog-mode)

(use-package so-long
  :quelpa (so-long :url "https://raw.githubusercontent.com/emacs-mirror/emacs/master/lisp/so-long.el" :fetcher url)
  :config (global-so-long-mode))

(use-package lor-theme
  :config
  (load-theme 'lor t)
  :quelpa
  (lor-theme :repo "a13/lor-theme" :fetcher github :version original))

(setq default-frame-alist '((font . "Menlo-14")))

(global-unset-key (kbd "C-h"))
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-unset-key (kbd "C-x ."))
(global-set-key (kbd "C-x .") 'next-buffer)
(global-set-key (kbd "C-x ,") 'previous-buffer)
;; change font size, interactively
(global-set-key (kbd "C-+") 'my/zoom-in)
(global-set-key (kbd "C-_") 'my/zoom-out)
(setq mac-command-modifier 'meta)

(use-package avy
  :ensure t
  :bind
  (("C-:" .   avy-goto-char-timer)
   ("C-." .   avy-goto-word-1)))

(use-package avy-zap
  :ensure t
  :bind
  ([remap zap-to-char] . avy-zap-to-char))

