(require 'package)
(setq package-archives
      `(,@package-archives
        ("melpa" . "https://melpa.org/packages/")
        ;; ("marmalade" . "https://marmalade-repo.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ;; ("user42" . "https://download.tuxfamily.org/user42/elpa/packages/")
        ;; ("emacswiki" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/emacswiki/")
        ;; ("sunrise" . "http://joseito.republika.pl/sunrise-commander/")
        ))
(package-initialize)




(setenv "IPY_TEST_SIMPLE_PROMPT" "1")
(setq python-shell-interpreter "ipython3"
      python-shell-interpreter-args "-i")

(setq package-enable-at-startup nil)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(put 'use-package 'lisp-indent-function 1)
(setq use-package-always-ensure t)

(use-package elpy)
(setq elpy-rpc-python-command "python3")
(setq python-check-command "pep8")
(elpy-enable)
(setq-default indent-tabs-mode nil)

(use-package system-packages
  :custom
  (system-packages-noconfirm t))

(use-package use-package-ensure-system-package)

;; :diminish keyword
(use-package diminish)

;; :bind keyword
(use-package bind-key)

;; :quelpa keyword
(use-package quelpa)
(use-package quelpa-use-package)

(use-package use-package-secrets
  :ensure nil
  :custom
  (use-package-secrets-default-directory "~/.emacs.d/secrets")
  :quelpa
  (use-package-secrets :repo "a13/use-package-secrets" :fetcher github :version original))

(use-package paradox
  :config
  (paradox-enable))

(use-package emacs
  :ensure nil
  :init
  (put 'narrow-to-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  :custom
  (scroll-step 1)
  (inhibit-startup-screen t "Don't show splash screen")
  (use-dialog-box nil "Disable dialog boxes")
  (enable-recursive-minibuffers t "Allow minibuffer commands in the minibuffer")
  (indent-tabs-mode nil "Spaces!"))

(use-package files
  :ensure nil
  :hook
  (before-save . delete-trailing-whitespace)
  :custom
  (require-final-newline t)
  ;; backup settings
  (backup-by-copying t)
  ;; (backup-directory-alist
  ;;  '(("." . "~/.cache/emacs/backups")))
  (delete-old-versions t)
  (kept-new-versions 6)
  (kept-old-versions 2)
  (version-control t))

(use-package autorevert
  :ensure nil
  :diminish auto-revert-mode)

(use-package iqa
  :custom
  (iqa-user-init-file (concat user-emacs-directory "init.org") "Edit init.org by default.")
  :config
  (iqa-setup-default))

(use-package cus-edit
  :ensure nil
  :custom
  ;; alternatively, one can use `(make-temp-file "emacs-custom")'
  (custom-file null-device "Don't store customizations"))

(use-package epa
  :ensure nil
  :custom
  (epg-gpg-program "gpg")
  (epa-pinentry-mode nil))

(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name-style 'forward))

(use-package tramp
  :ensure nil
  :custom
  (tramp-default-method "ssh")
  (tramp-default-proxies-alist nil))

(use-package sudo-edit
  :bind (:map ctl-x-map
              ("M-s" . sudo-edit)))

(use-package frame
  :ensure nil
  ;; disable suspending on C-z
  :bind
  ("C-z" . nil))

(use-package delsel
  :ensure nil
  ;; C-c C-g always quits minubuffer
  :bind
  ("C-c C-g" . minibuffer-keyboard-quit))

(use-package simple
  :ensure nil
  :diminish
  ((visual-line-mode . " ↩")
   (auto-fill-function . " ↵"))
  :config
  (column-number-mode t)
  (toggle-truncate-lines 1)
  :bind
  ;; remap ctrl-w/ctrl-h
  (("C-c h" . help-command)
   ("C-w" . backward-kill-word)
   ("C-x C-k" . kill-region)
   ("C-h" . delete-backward-char)))

(use-package ibuffer
  :ensure nil
  :bind
  ([remap list-buffers] . ibuffer))

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(use-package eshell
  :ensure nil)

(use-package em-smart
  :ensure nil
  :config
  (eshell-smart-initialize)
  :custom
  (eshell-where-to-jump 'begin)
  (eshell-review-quick-commands nil)
  (eshell-smart-space-goes-to-end t))

(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode)
  :ensure t)

(use-package eshell-toggle
  :ensure nil
  :quelpa
  (eshell-toggle :repo "4DA/eshell-toggle" :fetcher github :version original)
  :bind
  (("M-`" . eshell-toggle)))

(use-package ls-lisp
  :ensure nil
  :custom
  (ls-lisp-emulation 'MS-Windows)
  (ls-lisp-ignore-case t)
  (ls-lisp-verbosity nil))

(use-package dired
  :ensure nil
  :custom (dired-dwim-target t "guess a target directory")
  :bind
  ([remap list-directory] . dired)
  :hook
  (dired-mode . dired-hide-details-mode))

(use-package dired-x
  :ensure nil
  :custom
  ;; do not bind C-x C-j since it's used by jabber.el
  (dired-bind-jump nil))

(use-package dired-toggle)

(use-package dired-hide-dotfiles
  :bind
  (:map dired-mode-map
        ("." . dired-hide-dotfiles-mode))
  :hook
  (dired-mode . dired-hide-dotfiles-mode))

(use-package diredfl
  :hook
  (dired-mode . diredfl-mode))

(use-package dired-launch)

(use-package mule
  :ensure nil
  :config
  (prefer-coding-system 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-language-environment "UTF-8"))

(use-package ispell
  :ensure nil
  :custom
  (ispell-local-dictionary-alist
   '(("russian"
      "[АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюяіїєґ’A-Za-z]"
      "[^АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюяіїєґ’A-Za-z]"
      "[-']"  nil ("-d" "uk_UA,ru_RU,en_US") nil utf-8)))
  (ispell-program-name "hunspell")
  (ispell-dictionary "russian")
  (ispell-really-aspell nil)
  (ispell-really-hunspell t)
  (ispell-encoding8-command t)
  (ispell-silently-savep t))

(use-package flyspell
  :ensure nil
  :custom
  (flyspell-delay 1))

(use-package faces
  :ensure nil
  :custom
  (face-font-family-alternatives '(("Consolas" "Monaco" "Monospace")))
  :init
  (set-face-attribute 'default nil :family (caar face-font-family-alternatives) :weight 'regular :width 'semi-condensed)
  (set-fontset-font "fontset-default" 'cyrillic
                    (font-spec :registry "iso10646-1" :script 'cyrillic)))

(use-package custom
  :ensure nil
  :custom
  (custom-safe-themes t))

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-medium))

(use-package tool-bar
  :ensure nil
  :config
  (tool-bar-mode -1))

(use-package scroll-bar
  :ensure nil
  :config
  (scroll-bar-mode -1))

(use-package menu-bar
  :ensure nil
  :config
  (menu-bar-mode -1)
  :bind
  ([S-f10] . menu-bar-mode))

(use-package time
  :ensure nil
  :custom
  (display-time-default-load-average nil)
  (display-time-24hr-format t)
  :config
  (display-time-mode t))

(use-package fancy-battery
  :hook
  (after-init . fancy-battery-mode))

(use-package yahoo-weather
  :bind ("C-c w" . yahoo-weather-mode)
  :custom
  ;; TODO: autolocate
  (yahoo-weather-location "Minsk, BY"))

;(use-package spaceline
;  :config
;  (require 'spaceline-config))
;  (spaceline-spacemacs-theme))

(use-package font-lock+
  :ensure t
  :quelpa
  (font-lock+ :repo "emacsmirror/font-lock-plus" :fetcher github))

(use-package all-the-icons
  :config
  (add-to-list
   'all-the-icons-mode-icon-alist
   '(package-menu-mode all-the-icons-octicon "package" :v-adjust 0.0)))

(use-package all-the-icons-dired
  :hook
  (dired-mode . all-the-icons-dired-mode))

;(use-package spaceline-all-the-icons
;  :after spaceline
;  :config
;  (spaceline-all-the-icons-theme)
;  (spaceline-all-the-icons--setup-package-updates)
;  (spaceline-all-the-icons--setup-git-ahead)
;  (spaceline-all-the-icons--setup-paradox))

(use-package all-the-icons-ivy
  :after ivy projectile
  :custom
  (all-the-icons-ivy-buffer-commands '() "Don't use for buffers.")
  (all-the-icons-ivy-file-commands
   '(counsel-find-file
     counsel-file-jump
     counsel-recentf
     counsel-projectile-find-file
     counsel-projectile-find-dir) "Prettify more commands.")
  :config
  (all-the-icons-ivy-setup))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  :custom
  (initial-buffer-choice '(lambda ()
                            (setq initial-buffer-choice nil)
                            (get-buffer "*dashboard*")))
  (dashboard-items '((recents  . 5)
                     (bookmarks . 5)
                     (projects . 5)
                     ;; (agenda . 5)
                     (registers . 5))))

(use-package paren
  :ensure nil
  :config
  (show-paren-mode t))

(use-package hl-line
  :ensure nil
  :config
  (global-hl-line-mode 1))

(use-package page-break-lines
  :config
  (global-page-break-lines-mode))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-identifiers
  :hook
  (prog-mode . rainbow-identifiers-mode))

(use-package rainbow-mode
  :diminish rainbow-mode
  :hook prog-mode)

;; counsel-M-x can use this one
(use-package smex)

(use-package ivy
  :diminish ivy-mode
  :custom
  ;; (ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (ivy-count-format "%d/%d " "Show anzu-like counter")
  (ivy-use-selectable-prompt t "Make the prompt line selectable")
  :custom-face
  (ivy-current-match ((t (:background "gray1"))))
  :bind
  (("C-c C-r" . ivy-resume))
  :config
  (ivy-mode t))

(use-package ivy-xref
  :custom
  (xref-show-xrefs-function #'ivy-xref-show-xrefs "Use Ivy to show xrefs"))

(use-package counsel
  :bind
  (([remap menu-bar-open] . counsel-tmm)
   ([remap insert-char] . counsel-unicode-char)
   ([remap isearch-forward] . counsel-grep-or-swiper)
   :prefix-map counsel-prefix-map
   :prefix "C-c c"
   ("a" . counsel-apropos)
   ("b" . counsel-bookmark)
   ("d" . counsel-dired-jump)
   ("e" . counsel-expression-history)
   ("f" . counsel-file-jump)
   ("g" . counsel-org-goto)
   ("h" . counsel-command-history)
   ("i" . counsel-imenu)
   ("l" . counsel-locate)
   ("m" . counsel-mark-ring)
   ("o" . counsel-outline)
   ("p" . counsel-package)
   ("r" . counsel-recentf)
   ("s g" . counsel-grep)
   ("s r" . counsel-rg)
   ("s s" . counsel-ag)
   ("t" . counsel-org-tag)
   ("v" . counsel-set-variable)
   ("w" . counsel-wmctrl))
  :init
  (counsel-mode))

(use-package swiper)

(use-package counsel-extras
  :disabled t
  :ensure nil
  :quelpa
  (counsel-extras :repo "a13/counsel-extras" :fetcher github :version original)
  :bind
  (("s-p" . counsel-extras-xmms2-jump)))

(use-package ivy-rich
  :custom
  (ivy-rich-switch-buffer-name-max-length 60 "Increase max length of buffer name.")
  :config
  (dolist (cmd
           '(ivy-switch-buffer
             ivy-switch-buffer-other-window
             counsel-projectile-switch-to-buffer))
    (ivy-set-display-transformer cmd #'ivy-rich-switch-buffer-transformer)))

(use-package isearch
  :ensure nil
  :bind
  ;; TODO: maybe get a keybinding from global map
  (:map isearch-mode-map
        ("C-h" . isearch-delete-char)))

(use-package avy
  :config
  (avy-setup-default)
  :bind
  (("C-:" . avy-goto-char)
   ;; ("C-'" . avy-goto-char-2)
   ("M-g M-g" . avy-goto-line)
   ("M-s M-s" . avy-goto-word-1)))

(use-package avy-zap
  :bind
  ([remap zap-to-char] . avy-zap-to-char))

(use-package ace-jump-buffer
  :bind
  (("M-g b" . ace-jump-buffer)))

(use-package ace-window
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l) "Use home row for selecting.")
  (aw-scope 'frame "Highlight only current frame.")
  :bind
  (("M-o" . ace-window)))

(use-package ace-link
  :bind
  ("C-c l l" . counsel-ace-link)
  :config
  (ace-link-setup-default))

(use-package link-hint
  :ensure t
  :bind
  (("C-c l o" . link-hint-open-link)
   ("<XF86Search>" . link-hint-open-link)
   ("C-c l c" . link-hint-copy-link)
   ("S-<XF86Search>" . link-hint-copy-link)))

(use-package select
  :ensure nil
  :custom
  (x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
  (select-enable-clipboard t "Use the clipboard"))

(use-package expand-region
  :bind
  ("C-=" . er/expand-region))

(use-package edit-indirect
  :bind
  ("C-c e r" . edit-indirect-region))

(use-package clipmon
  :config
  (clipmon-mode))

(use-package copy-as-format
  :bind
  (:prefix-map copy-as-format-prefix-map
               :prefix "C-c f"
               ("f" . copy-as-format)
               ("a" . copy-as-format-asciidoc)
               ("b" . copy-as-format-bitbucket)
               ("d" . copy-as-format-disqus)
               ("g" . copy-as-format-github)
               ("l" . copy-as-format-gitlab)
               ("c" . copy-as-format-hipchat)
               ("h" . copy-as-format-html)
               ("j" . copy-as-format-jira)
               ("m" . copy-as-format-markdown)
               ("w" . copy-as-format-mediawiki)
               ("o" . copy-as-format-org-mode)
               ("p" . copy-as-format-pod)
               ("r" . copy-as-format-rst)
               ("s" . copy-as-format-slack)))

(use-package man
  :ensure nil
  :custom-face
  (Man-overstrike ((t (:inherit font-lock-type-face :bold t))))
  (Man-underline ((t (:inherit font-lock-keyword-face :underline t)))))

(use-package keyfreq
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode))

(use-package free-keys
  :commands free-keys)

(use-package helpful)

(use-package shr-color
  :ensure nil
  :custom
  (shr-color-visible-luminance-min 80 "Improve the contrast"))

(use-package eww
  :ensure nil
  :custom
  (shr-use-fonts nil)
  (eww-search-prefix "https://duckduckgo.com/html/?kd=-1&q="))

(use-package browse-url
  :ensure nil
  :bind
  ([f5] . browse-url)
  :config
  (setq browse-url-browser-function 'browse-url-generic
        browse-url-generic-program "x-www-browser")

  (defun feh-browse (url &rest ignore)
    "Browse image using feh."
    (interactive (browse-url-interactive-arg "URL: "))
    (start-process (concat "feh " url) nil "feh" url))

  (defun mpv-browse (url &rest ignore)
    "Browse video using mpv."
    (interactive (browse-url-interactive-arg "URL: "))
    (start-process (concat "mpv --loop-file=inf" url) nil "mpv" "--loop-file=inf" url))

  (defvar browse-url-images-re
    '("\\.\\(jpe?g\\|png\\)\\(:large\\|:orig\\)?\\(\\?.*\\)?$"
      "^https?://img-fotki\\.yandex\\.ru/get/"
      "^https?://pics\\.livejournal\\.com/.*/pic/"
      "^https?://l-userpic\\.livejournal\\.com/"
      "^https?://img\\.leprosorium\\.com/[0-9]+$")
    "Image URLs regular expressions list.")

  (defvar browse-url-videos-re
    '("\\.\\(gifv?\\|avi\\|AVI\\|mp[4g]\\|MP4\\|webm\\)$"
      "^https?://\\(www\\.youtube\\.com\\|youtu\\.be\\|coub\\.com\\|vimeo\\.com\\|www\\.liveleak\\.com\\)/"
      "^https?://www\\.facebook\\.com/.*/videos?/"))

  (setq browse-url-browser-function
        (append
         (mapcar (lambda (re)
                   (cons re #'eww-browse-url))
                 browse-url-images-re)
         (mapcar (lambda (re)
                   (cons re #'mpv-browse))
                 browse-url-videos-re)
         '(("." . browse-url-xdg-open)))))

(use-package webjump
  :bind
  (([S-f5] . webjump))
  :config
  (setq webjump-sites
        (append '(("debian packages" .
                   [simple-query "packages.debian.org" "http://packages.debian.org/" ""]))
                webjump-sample-sites)))

(use-package atomic-chrome
  :custom
  (atomic-chrome-url-major-mode-alist
   '(("reddit\\.com" . markdown-mode)
     ("github\\.com" . gfm-mode)
     ("redmine" . textile-mode))
   "Major modes for URLs.")
  :config
  (atomic-chrome-start-server))

(use-package shr-tag-pre-highlight
  :after shr
  :config
  (add-to-list 'shr-external-rendering-functions
               '(pre . shr-tag-pre-highlight))

  (when (version< emacs-version "26")
    (with-eval-after-load 'eww
      (advice-add 'eww-display-html :around
                  'eww-display-html--override-shr-external-rendering-functions))))

(use-package google-this
  :diminish google-this-mode
  :config
  (google-this-mode 1)
  :custom
  (google-this-keybind (kbd "C-c g")))

(use-package multitran)

(use-package calendar
  :ensure nil
  :custom
  (calendar-week-start-day 1))

(use-package org
  ;; to be sure we have latest Org version
  :ensure org-plus-contrib
  :custom
  (org-src-tab-acts-natively t))

(use-package org-bullets
  :custom
  ;; org-bullets-bullet-list
  ;; default: "◉ ○ ✸ ✿"
  ;; large: ♥ ● ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶
  ;; Small: ► • ★ ▸
  (org-bullets-bullet-list '("•"))
  ;; others: ▼, ↴, ⬎, ⤷,…, and ⋱.
  ;; (org-ellipsis "⤵")
  (org-ellipsis "…")
  :hook
  (org-mode . org-bullets-mode))

(use-package htmlize
  :custom
  (org-html-htmlize-output-type 'css)
  (org-html-htmlize-font-prefix "org-"))

(use-package org-password-manager
  :hook
  (org-mode . org-password-manager-key-bindings))

(use-package ibuffer-vc
  :config
  (define-ibuffer-column icon
    (:name "Icon" :inline t)
    (all-the-icons-ivy--icon-for-mode major-mode))
  :custom
  (ibuffer-formats
   '((mark modified read-only vc-status-mini " "
      (name 18 18 :left :elide)
      " "
      (size 9 -1 :right)
      " "
      (mode 16 16 :left :elide)
      " "
      filename-and-process)) "include vc status info")
  :hook
  (ibuffer . (lambda ()
               (ibuffer-vc-set-filter-groups-by-vc-root)
               (unless (eq ibuffer-sorting-mode 'alphabetic)
                 (ibuffer-do-sort-by-alphabetic)))))

(use-package magit
  :custom
  (magit-completing-read-function 'ivy-completing-read "Force Ivy usage.")
  :bind
  (:prefix-map magit-prefix-map
               :prefix "C-c m"
               (("a" . magit-stage-file) ; the closest analog to git add
                ("b" . magit-blame)
                ("B" . magit-branch)
                ("c" . magit-checkout)
                ("C" . magit-commit)
                ("d" . magit-diff)
                ("D" . magit-discard)
                ("f" . magit-fetch)
                ("g" . vc-git-grep)
                ("G" . magit-gitignore)
                ("i" . magit-init)
                ("l" . magit-log)
                ("m" . magit)
                ("M" . magit-merge)
                ("n" . magit-notes-edit)
                ("p" . magit-pull)
                ("P" . magit-push)
                ("r" . magit-reset)
                ("R" . magit-rebase)
                ("s" . magit-status)
                ("S" . magit-stash)
                ("t" . magit-tag)
                ("T" . magit-tag-delete)
                ("u" . magit-unstage)
                ("U" . magit-update-index))))

(use-package magithub
  :after magit
  :custom
  (magithub-clone-default-directory "~/git/")
  :config
  (magithub-feature-autoinject t))

(use-package browse-at-remote
  :bind
  ("C-c l r" . browse-at-remote))

(use-package smerge-mode
  :ensure nil
  :diminish smerge-mode)

(use-package diff-hl
  :hook
  ((magit-post-refresh . diff-hl-magit-post-refresh)
   (prog-mode . diff-hl-mode)
   (org-mode . diff-hl-mode)
   (dired-mode . diff-hl-dired-mode)))

(use-package projectile
  :custom
  (projectile-completion-system 'ivy)
  :config
  (projectile-mode))

(use-package counsel-projectile
  :after counsel projectile
  :config
  (counsel-projectile-mode))

(use-package ag
  :ensure-system-package (ag . silversearcher-ag)
  :custom
  (ag-highlight-search t "Highlight the current search term."))

(use-package dumb-jump
  :custom
  (dumb-jump-selector 'ivy)
  (dumb-jump-prefer-searcher 'ag))

(use-package company
  :diminish company-mode
  :hook
  (after-init . global-company-mode))

(use-package company-quickhelp
  :custom
  (company-quickhelp-delay 3)
  :config
  (company-quickhelp-mode 1))

(use-package company-shell
  :config
  (add-to-list 'company-backends 'company-shell))

(use-package company-emoji
  ;; :ensure-system-package fonts-symbola
  :config
  (add-to-list 'company-backends 'company-emoji)
  (set-fontset-font t 'symbol
                    (font-spec :family
                               (if (eq system-type 'darwin)
                                   "Apple Color Emoji"
                                 "Symbola"))
                    nil 'prepend))

(use-package autoinsert
  :hook
  (find-file . auto-insert))

(use-package yasnippet
  :diminish yas-minor-mode
  :custom
  (yas-prompt-functions '(yas-completing-prompt yas-ido-prompt))

  :config
  (yas-reload-all)
  :hook
  (prog-mode  . yas-minor-mode))

(use-package flycheck
  :diminish flycheck-mode
  :hook
  (prog-mode . flycheck-mode))

(use-package avy-flycheck
  :config
  (avy-flycheck-setup))

(use-package suggest)

(use-package ipretty
  :config
  (ipretty-mode 1))

(use-package nameless
  :hook
  (emacs-lisp-mode .  nameless-mode)
  :custom
  (nameless-private-prefix t))

;; bind-key can't bind to keymaps
(use-package erefactor)

(use-package flycheck-package
  :after flycheck
  (flycheck-package-setup))

(use-package geiser)

(use-package clojure-mode)
(use-package clojure-mode-extra-font-locking)
(use-package clojure-snippets)
(use-package cider
  :config
  ;; sadly, we can't use :diminish keyword here, yet
  (diminish 'cider-mode
            '(:eval (format " 🍏%s" (cider--modeline-info)))))

(use-package kibit-helper)

(use-package slime
  :disabled
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl"
        lisp-indent-function 'common-lisp-indent-function
        slime-complete-symbol-function 'slime-fuzzy-complete-symbol
        slime-startup-animation nil)
  (slime-setup '(slime-fancy))
  (setq slime-net-coding-system 'utf-8-unix))

(use-package scala-mode)

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))

(use-package ensime
  :bind (:map ensime-mode-map
              ("C-x C-e" . ensime-inf-eval-region)))

(use-package lua-mode)

(use-package fennel-mode
  :ensure nil
  :quelpa (fennel-mode :repo "technomancy/fennel-mode" :fetcher gitlab))

(use-package conkeror-minor-mode
  :hook
  (js-mode . (lambda ()
               (when (string-match "conkeror" (or (buffer-file-name) ""))
                 (conkeror-minor-mode 1)))))

(use-package json-mode)

(use-package graphql-mode
  :mode "\\.graphql\\'"
  :custom
  (graphql-url "http://localhost:8000/api/graphql/query"))

(use-package sh-script
  :ensure nil
  :mode (("zshecl" . sh-mode)
         ("\\.zsh\\'" . sh-mode))
  :custom
  ;; zsh
  (system-uses-terminfo nil))

(use-package apt-sources-list)

(use-package ssh-config-mode
  :init
  (autoload 'ssh-config-mode "ssh-config-mode" t)
  :mode
  (("/\\.ssh/config\\'"     . ssh-config-mode)
   ("/sshd?_config\\'"      . ssh-config-mode)
   ("/known_hosts\\'"       . ssh-known-hosts-mode)
   ("/authorized_keys2?\\'" . ssh-authorized-keys-mode))
  :hook
  (ssh-config-mode . turn-on-font-lock))

(use-package markdown-mode
  :ensure-system-package markdown
  :mode (("\\`README\\.md\\'" . gfm-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode))
  :init (setq markdown-command "markdown"))

(use-package restclient)

(use-package ob-restclient)

(use-package company-restclient
  :after (company restclient)
  :config
  (add-to-list 'company-backends 'company-restclient))

(use-package net-utils
  :ensure-system-package traceroute
  :bind
  (:prefix-map net-utils-prefix-map
               :prefix "C-c n"
               ("p" . ping)
               ("i" . ifconfig)
               ("w" . iwconfig)
               ("n" . netstat)
               ("p" . ping)
               ("a" . arp)
               ("r" . route)
               ("h" . nslookup-host)
               ("d" . dig)
               ("s" . smbclient)
               ("t" . traceroute)))

(use-package docker
  :config
  (docker-global-mode))

;; not sure if these two should be here
(use-package dockerfile-mode
  :mode "Dockerfile\\'")

(use-package docker-compose-mode)

(use-package emamux)

(use-package reverse-im
  :config
  (add-to-list 'load-path "~/.xkb/contrib")
  (add-to-list 'reverse-im-modifiers 'super)
  (add-to-list 'reverse-im-input-methods
               (if (require 'unipunct nil t)
                   "russian-unipunct"
                 "russian-computer"))
  (reverse-im-mode t))

;; Local Variables:
;; eval: (add-hook 'after-save-hook (lambda ()(org-babel-tangle)) nil t)
;; End:
