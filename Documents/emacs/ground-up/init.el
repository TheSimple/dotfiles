;; Package Manager: straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq inhibit-startup-screen t)
;; (setq initial-buffer-choice t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; Generic keybindings:
;; (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Handy Functions
(defun kill-all-buffers ()
  (delete-other-windows)
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(defun color-hex-to-float (color)
  "Converts a 3 component 8-bit RGB color to 32-bit normalized floats"
  (interactive "X8-bit color: ")
  (let ((rr (/ (logand (lsh color -16) #xff) (float #xff)))
	(gg (/ (logand (lsh color -8) #xff) (float #xff)))
	(bb (/ (logand (lsh color -0) #xff) (float #xff))))
    (message "%f, %f, %f" rr gg bb)))

;; Setup straight.el
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Packages
(use-package gcmh)
(use-package magit)
(use-package all-the-icons
  :config (setq all-the-icons-scale-factor 1.0))
;; (use-package vterm)

(defun set-default-variable-pitch-font ()
  (set-face-attribute 'variable-pitch nil :font "Clear Sans" :height 170))

(use-package w3m
  :config
  (setq w3m-default-display-inline-images t
        w3m-use-favicon nil))

;; Setup newsticker feed reader
(setq newsticker-url-list
      '(;; Person
        ("Drew Devault" "https://drewdevault.com/blog/index.xml")
        ("Richard Stallman's Political Notes" "https://stallman.org/rss/rss.xml")
        ("Boomer In The Woods" "https://lukesmith.xyz/rss.xml")

        ;; Magazine/Booklet
        ("Opensource.com" "https://opensource.com/feed")
        ("Fedora Magazine" "https://fedoramagazine.org/feed/")
        ("Phoronix" "https://www.phoronix.com/rss.php")

        ;; Software development
        ("Freedesktop Planet" "https://planet.freedesktop.org/rss20.xml")

        ;; Kernel
        ("LWN Headlines" "https://lwn.net/headlines/rss")
        ("LWN Featured" "https://lwn.net/headlines/Features")
        ("Kernel Planet" "https://planet.kernel.org/rss20.xml"))

      newsticker-retrieval-method 'intern
      )

;; (use-package bongo
;;   :config (setq bongo-enabled-backends '(vlc mpv))

;; (use-package dap-mode)

;; (use-package treemacs
;;   :config (setq
;;            treemacs-width 25
;;            treemacs-show-hidden-files nil
;;            treemacs-indentation 1
;;            treemacs-indentation-string " ")
;;   :bind
;;   (:map global-map
;;         ("M-[" . treemacs-select-window)
;;         ("M-]" . treemacs)
;;         ("C-x t i" . treemacs-find-file)))

(use-package projectile
  :config
  (projectile-mode 1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package lsp-mode
  :hook
  (c++-mode . lsp-deferred)
  (c-mode . lsp-deferred)
  (objc-mode . lsp-deferred)
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  :commands (lsp lsp-deferred))
;; (use-package lsp-ui
;;   :config
;;   (lsp-ui-doc-enable nil))
(add-hook 'c++-mode-hook (lambda () (hs-minor-mode) (hide-ifdef-mode)))

(use-package rust-mode
  :config
  (add-hook 'rust-mode-hook
	    (lambda () (setq indent-tabs-mode nil))))

(use-package counsel
  :bind
  ("C-x C-r" . counsel-recentf)
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("M-y" . counsel-yank-pop)
  ("<f1> f" . counsel-describe-function)
  ("<f1> v" . counsel-describe-variable)
  ("<f1> l" . counsel-find-library)
  ("<f2> i" . counsel-info-lookup-symbol)
  ("<f2> u" . counsel-unicode-char)
  ("<f2> j" . counsel-set-variable))
(use-package swiper
  :bind
  ("C-s" . swiper-isearch)
  ("C-r" . swiper-isearch-backward))
(use-package ivy
  :bind
  ("C-x b" . ivy-switch-buffer)
  ("C-c v" . ivy-push-view)
  ("C-c V" . ivy-pop-view)
  :config
  (setq ivy-initial-inputs-alist nil)
  (ivy-mode 1))
(use-package lsp-ivy)

(use-package company
  :config
  (setq company-minimum-prefix-length 2)
  company-idle-delay 0.300)
(add-hook 'after-init-hook 'global-company-mode)

(use-package flycheck
  :init (global-flycheck-mode))

;; (use-package evil
;;   :init
;;   (setq evil-want-keybinding nil)
;;   :config
;;   (evil-mode 1))
;; (use-package evil-collection
;;   :after evil
;;   :config
;;   (evil-collection-init))
;; (use-package evil-nerd-commenter)
;; (global-set-key (kbd "C-c l") 'evilnc-comment-or-uncomment-lines)

(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
(use-package tree-sitter-langs)

(use-package which-key
  :config
  (which-key-mode))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("◉" "⁑" "⁂" "❖" "✮" "✱" "✸")))

(use-package amx) ;; recently used commands

;; Modeline

;; (use-package doom-modeline
;;   :hook (after-init . doom-modeline-mode))

;; (use-package powerline
;;   :config
;;   (powerline-center-theme))

;; (setq-default mode-line-format
;;       '("%e"
;;         mode-line-front-space
;;         " "
;;         mode-line-mule-info
;;         mode-line-client
;;         mode-line-modified
;;         mode-line-remote
;;         mode-line-frame-identification
;;         mode-line-buffer-identification
;;         mode-line-position
;;         mode-line-modes
;;         mode-line-misc-info
;;         mode-line-end-spaces))

(defun simple-mode-line-render (left right)
  "Return a string of `window-width' length.
Containing LEFT, and RIGHT aligned respectively."
  (let ((available-width
         (- (window-total-width)
            (+ (length (format-mode-line left))
               (length (format-mode-line right))))))
    (append left
            (list (format (format "%%%ds" available-width) ""))
            right)))

(setq-default
 mode-line-format
 '((:eval
    (simple-mode-line-render
     ;; Left.
     '("%e "
       mode-line-buffer-identification
       " "
       mode-line-mule-info
       " %l : %c "
       evil-mode-line-tag
       "[%*] ")
     ;; Right.
     '("%p"
       mode-line-frame-identification
       mode-name
       " "
       mode-line-misc-info)))))

(use-package diminish
  :config
  (diminish 'eldoc-mode)
  (diminish 'gcmh-mode)
  (diminish 'ivy-mode)
  (diminish 'which-key-mode)
  (diminish 'company-mode)
  (diminish 'auto-revert-mode)
  (diminish 'projectile-mode)
  (diminish 'hide-ifdef-mode)
  (diminish 'hs-minor-mode)
  (diminish 'flycheck-mode)
  (diminish 'tree-sitter-mode)
  (diminish 'abbrev-mode)
  (diminish 'lsp-mode)
  (diminish 'page-break-lines-mode)
  )

;; Themes
(use-package doom-themes
  :config (doom-themes-org-config))
(use-package kaolin-themes)
(use-package gruvbox-theme)

(load-theme 'doom-monokai-classic t)

(defun hour-minute-between (hour-start minute-start hour-end minute-end hour minute)
  "Checks whether (HOUR, MINUTE) are between (inclusive) the ranges 
(HOUR-START, MINUTE-START) and (HOUR-END, MINUTE-END)"
  (message "(%d, %d), (%d, %d)" hour-start minute-start hour-end minute-end)
  (message "%d, %d" hour minute)
  (and (>= hour hour-start) (<= hour hour-end)
       (or (/= hour hour-start) (>= minute minute-start))
       (or (/= hour hour-end) (<= minute minute-end))))

(defun greet-other-lang ()
  "Greet based on the time of the day"
  (let ((hour (string-to-number (format-time-string "%H")))
        (minute (string-to-number (format-time-string "%M"))))
    (if (hour-minute-between 6 0 11 59 hour minute)
        (concat "𑀰𑀼 𑀪 𑀧𑁆𑀭𑀪𑀸𑀢 " user-full-name)
      (if (and (= hour 12) (= minute 0))
          (concat "𑀅𑀩 𑀤𑁄𑀧𑀳𑀭 𑀳𑁄 𑀕𑀈 𑀳𑁃, " user-full-name)
        (if (hour-minute-between 12 1 17 0 hour minute)
            (concat "𑀦𑀫𑀲𑁆𑀓𑀸𑀭 " user-full-name)
          (if (hour-minute-between 17 1 20 0 hour minute)
              (concat "𑀲𑀼𑀲𑀁𑀥𑁆𑀬𑀸 " user-full-name)
            (concat "𑀰𑀼 𑀪 𑀭𑀸𑀢𑁆𑀭𑀺 " user-full-name)))))))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner '1
        dashboard-center-content nil
        dashboard-items '((recents . 5)
                          (projects . 5)
                          (agenda . 5))
        dashboard-set-heading-icons t
        dashboard-set-file-icons nil
        dashboard-set-init-info t
        initial-buffer-choice (lambda () (get-buffer "*dashboard*"))))
(add-hook 'dashboard-after-initialize-hook (lambda () (setq dashboard-init-info (greet-other-lang))
                                             (dashboard-refresh-buffer)))

;; Easily toggle between a readable font and a basic font
(setq is-readable-font nil)
(defun toggle-readable-font ()
  "Toggles between the specified default variable pitch font and a more readable font"
  (interactive)
  (if is-readable-font
      (progn
        (set-default-variable-pitch-font)
	(message "Variable pitch font toggled to the default one")
	(setq is-readable-font nil))
    (set-face-attribute 'variable-pitch nil :font "OpenDyslexicAlta Nerd Font" :height 170)
    (message "Variable pitch font toggled to the readable one")
    (setq is-readable-font t))
  )

;; Fix copy-paste in Wayland
;; I only use Wayland based WMs/DEs so not a problem
(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process)) nil
    (shell-command-to-string "wl-paste -t text -n 2>/dev/null")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)
(setq confirm-kill-processes nil)

;; When running in daemon mode, the font is not set since there is no frame
(defun my-frame-init ()
  (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height 160)
  (set-default-variable-pitch-font)
  ;; To display unicodes in the range
  (set-fontset-font t '(#x11000 . #x1107f) (font-spec :family "Noto Sans Brahmi"))
  (setq doom-modeline-icon t)
  (toggle-scroll-bar -1))
(if (daemonp)
    (add-hook 'after-make-frame-functions
	      (lambda (frame)
		(select-frame frame)
		(my-frame-init)))
  (my-frame-init))

;; Set tab or spaces
(defun my-setup-indent (n)
  ;; java/c/c++
  (setq-default c-basic-offset n)
  ;; rust
  (setq-default rust-indent-offset n)
  ;; web development
  (setq-default coffee-tab-width n) ; coffeescript
  (setq-default javascript-indent-level n) ; javascript-mode
  (setq-default js-indent-level n) ; js-mode
  (setq-default js2-basic-offset n) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
  (setq-default web-mode-markup-indent-offset n) ; web-mode, html tag in html file
  (setq-default web-mode-css-indent-offset n) ; web-mode, css in html file
  (setq-default web-mode-code-indent-offset n) ; web-mode, js code in html file
  (setq-default css-indent-offset n) ; css-mode
  )
(defun my-personal-code-style ()
  (interactive)
  ;; use space instead of tab
  (setq-default indent-tabs-mode nil)
  (my-setup-indent 4))
(my-personal-code-style)

;; Org mode
;; Ability to set image width from within the org document
(setq org-image-actual-width nil)

;; Optimizations, most are stolen from DOOM Emacs
(global-so-long-mode 1)
(setq-default bidi-display-reordering 'left-to-right
	      bidi-paragraph-direction 'left-to-right
	      bidi-inhibit-bpa t)

;; Don't render cursors or regions in in non-focused windows
(setq-default cursor-in-non-selected-windows nil
	      highlight-nonselected-windows nil)

;; Rapid scrolling over unfontified regions
(setq fast-but-imprecise-scrolling t)

;; Don't ping things that look like domain names
(setq ffap-machine-p-known 'reject)

;; Resizing the Emacs frame can be terribly expensive
(setq frame-inhibit-implied-resize t)

;; Wait until idle time to gc
(gcmh-mode 1)
(setq gcmh-idle-delay 5
      gcmh-high-cons-threshold (* 256 1024 1024) ;; 256 MB
      gcmh-verbose nil)

;; Update the UI less often
(setq idle-update-delay 1.0)

;; Font compacting is expensive. Increases memory usage
(setq inhibit-compacting-font-caches t)

;; Inhibit fontification while receiving input, helps in scrolling performace
(setq redisplay-skip-fontification-on-input t)

;; Remove irrelevent command line options
(setq command-line-ns-option-alist nil)

;; Others
;; Relative line numbers
(global-display-line-numbers-mode -1)
(setq display-line-numbers-type 'relative)

;; Smooth scroll
;; (setq scroll-step 1
;;       scroll-conservatively 10000)

;; Line folding
(setq-default truncate-lines nil)

;; Highlight matched bracket
(show-paren-mode 1)

;; Automatically pair parens
(electric-pair-mode 1)

;; Disable some annoyances
(blink-cursor-mode 1)
(setq-default cursor-type 'box)
(tool-bar-mode -1)
(menu-bar-mode -1)
(fringe-mode 0)
(global-flycheck-mode -1)

;; The menubar is more or less useless in terminal mode
(defun contextual-menubar (&optional frame)
  "Display the menubar in FRAME (default: selected frame) if on a
    graphical display, but hide it if in terminal."
  (interactive)
  (set-frame-parameter frame 'menu-bar-lines 
                       (if (display-graphic-p frame)
                           1 0)))
;; (add-hook 'after-make-frame-functions 'contextual-menubar)

;; Sane scrolling so it doesn't feel like emacs is having manic disorders
(setq mouse-wheel-scroll-amount '(2 ((shift) . hscroll) ((meta) . nil) ((control) . text-scale)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-tilt-scroll nil)

;; Make mouse work in the terminal
(xterm-mouse-mode 1)

;; All backup files are stored in one direcctory
(let ((backup-dir "~/.cache/my_emacs/backup/")
      (auto-saves-dir "~/.cache/my_emacs/save/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))
(setq delete-old-versions t  ; Clean up the backups
      version-control nil    ; Use version numbers on backups
      kept-new-versions 2    ; keep some new versions
      kept-old-versions 2)   ; and some old ones, too

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#282b33" "#e1c1ee" "#5b94ab" "#cfcf9c" "#819cd6" "#a6c1e0" "#7289bc" "#c6c6c6"])
 '(custom-safe-themes
   '("8f5a7a9a3c510ef9cbb88e600c0b4c53cdcdb502cfe3eb50040b7e13c6f4e78e" "fd22c8c803f2dac71db953b93df6560b6b058cb931ac12f688def67f08c10640" "f94110b35f558e4c015b2c680f150bf8a19799d775f8352c957d9d1054b0a210" "95d0ed21bb0e919be7687a25ad59a1c2c8df78cbe98c9e369d44e65bfd65b167" "1623aa627fecd5877246f48199b8e2856647c99c6acdab506173f9bb8b0a41ac" "79278310dd6cacf2d2f491063c4ab8b129fee2a498e4c25912ddaa6c3c5b621e" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "7a994c16aa550678846e82edc8c9d6a7d39cc6564baaaacc305a3fdc0bd8725f" "6b80b5b0762a814c62ce858e9d72745a05dd5fc66f821a1c5023b4f2a76bc910" "6c3b5f4391572c4176908bb30eddc1718344b8eaff50e162e36f271f6de015ca" "7b3d184d2955990e4df1162aeff6bfb4e1c3e822368f0359e15e2974235d9fa8" "54cf3f8314ce89c4d7e20ae52f7ff0739efb458f4326a2ca075bf34bc0b4f499" "7546a14373f1f2da6896830e7a73674ef274b3da313f8a2c4a79842e8a93953e" "0e2a7e1e632dd38a8e0227d2227cb8849f877dd878afb8219cb6bcdd02068a52" "7d708f0168f54b90fc91692811263c995bebb9f68b8b7525d0e2200da9bc903c" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "730a87ed3dc2bf318f3ea3626ce21fb054cd3a1471dcd59c81a4071df02cb601" "2cdc13ef8c76a22daa0f46370011f54e79bae00d5736340a5ddfe656a767fddf" "93ed23c504b202cf96ee591138b0012c295338f38046a1f3c14522d4a64d7308" "77113617a0642d74767295c4408e17da3bfd9aa80aaa2b4eeb34680f6172d71a" "4f01c1df1d203787560a67c1b295423174fd49934deb5e6789abd1e61dba9552" "b5fff23b86b3fd2dd2cc86aa3b27ee91513adaefeaa75adc8af35a45ffb6c499" "3c2f28c6ba2ad7373ea4c43f28fcf2eed14818ec9f0659b1c97d4e89c99e091e" "fce3524887a0994f8b9b047aef9cc4cc017c5a93a5fb1f84d300391fba313743" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "d5a878172795c45441efcd84b20a14f553e7e96366a163f742b95d65a3f55d71" "0fe24de6d37ea5a7724c56f0bb01efcbb3fe999a6e461ec1392f3c3b105cc5ac" "5b809c3eae60da2af8a8cfba4e9e04b4d608cb49584cb5998f6e4a1c87c057c4" "c086fe46209696a2d01752c0216ed72fd6faeabaaaa40db9fc1518abebaf700d" "cae81b048b8bccb7308cdcb4a91e085b3c959401e74a0f125e7c5b173b916bf9" "01cf34eca93938925143f402c2e6141f03abb341f27d1c2dba3d50af9357ce70" "0685ffa6c9f1324721659a9cd5a8931f4bb64efae9ce43a3dba3801e9412b4d8" "ff3c57a5049010a76de8949ddb629d29e2ced42b06098e046def291989a4104a" "56d10d2b60685d112dd54f4ba68a173c102eacc2a6048d417998249085383da1" "74ba9ed7161a26bfe04580279b8cad163c00b802f54c574bfa5d924b99daa4b9" "e27556a94bd02099248b888555a6458d897e8a7919fd64278d1f1e8784448941" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "188fed85e53a774ae62e09ec95d58bb8f54932b3fd77223101d036e3564f9206" "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" "0a41da554c41c9169bdaba5745468608706c9046231bbbc0d155af1a12f32271" "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" "990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37" "a4395e069de3314001de4e139d6a3b1a83dcf9c3fdc68ee7b13eef6c2cba4ae3" "8f54cfa3f010d83d782fbcdc3a34cdc9dfe23c8515d87ba22d410c033160ad7e" "d14f3df28603e9517eb8fb7518b662d653b25b26e83bd8e129acea042b774298" "78c4238956c3000f977300c8a079a3a8a8d4d9fee2e68bad91123b58a4aa8588" "f2927d7d87e8207fa9a0a003c0f222d45c948845de162c885bf6ad2a255babfd" "6b5c518d1c250a8ce17463b7e435e9e20faa84f3f7defba8b579d4f5925f60c1" "c9415c9f5a5ed67914d1d64a0ea7d743ef93516f1f2c8501bc5ffb87af2066d3" "d74c5485d42ca4b7f3092e50db687600d0e16006d8fa335c69cf4f379dbd0eee" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "2c49d6ac8c0bf19648c9d2eabec9b246d46cb94d83713eaae4f26b49a8183fc4" "ca70827910547eb99368db50ac94556bbd194b7e8311cfbdbdcad8da65e803be" "7661b762556018a44a29477b84757994d8386d6edee909409fabe0631952dad9" "f4876796ef5ee9c82b125a096a590c9891cec31320569fc6ff602ff99ed73dca" "e3c64e88fec56f86b49dcdc5a831e96782baf14b09397d4057156b17062a8848" "08a27c4cde8fcbb2869d71fdc9fa47ab7e4d31c27d40d59bf05729c4640ce834" "e58e0bd0ca1f1a8c1662aeb17c92b7fb49ed564aced96435c64df608ee6ced6d" "98db748f133d9bb82adf38f8ae7834eefa9eefd6f7ea30909213164e1aa36df6" "6f895d86fb25fac5dd4fcce3aec0fe1d88cf3b3677db18a9607cf7a3ef474f02" "6bdcff29f32f85a2d99f48377d6bfa362768e86189656f63adbf715ac5c1340b" "4eb6fa2ee436e943b168a0cd8eab11afc0752aebb5d974bba2b2ddc8910fca8f" "4a8d4375d90a7051115db94ed40e9abb2c0766e80e228ecad60e06b3b397acab" "7236acec527d58086ad2f1be6a904facc9ca8bf81ed1c19098012d596201b3f1" "4e9e56ec06ede9857c876fea2c44b75dd360cd29a7fe927b706c45f804f7beff" "7e5d400035eea68343be6830f3de7b8ce5e75f7ac7b8337b5df492d023ee8483" "b9e406b52f60a61c969f203958f406fed50b5db5ac16c127b86bbddd9d8444f7" "d9a28a009cda74d1d53b1fbd050f31af7a1a105aa2d53738e9aa2515908cac4c" "73320ccc14ab4987fe2e97cfd810b33a1f4a115f5f056c482c3d38a4429e1705" "78c01e1b7f3dc9e47bdd48f74dc98dc1a345c291f83b68ac8a1b40191f24d658" "0c6a36393d5782839b88e4bf932f20155cb4321242ce75dc587b4f564cb63d90" "aaa4c36ce00e572784d424554dcc9641c82d1155370770e231e10c649b59a074" "620b9018d9504f79344c8ef3983ea4e83d209b46920f425240889d582be35881" "d6603a129c32b716b3d3541fc0b6bfe83d0e07f1954ee64517aa62c9405a3441" "83e0376b5df8d6a3fbdfffb9fb0e8cf41a11799d9471293a810deb7586c131e6" default))
 '(default-input-method "devanagari-itrans")
 '(fci-rule-color "#888395")
 '(jdee-db-active-breakpoint-face-colors (cons "#222228" "#819cd6"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#222228" "#5b94ab"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#222228" "#515462"))
 '(objed-cursor-color "#e1c1ee")
 '(pdf-view-midnight-colors (cons "#c6c6c6" "#282b33"))
 '(pos-tip-background-color "#F3E7D3")
 '(pos-tip-foreground-color "#79716c")
 '(rustic-ansi-faces
   ["#282b33" "#e1c1ee" "#5b94ab" "#cfcf9c" "#819cd6" "#a6c1e0" "#7289bc" "#c6c6c6"])
 '(vc-annotate-background "#282b33")
 '(vc-annotate-color-map
   (list
    (cons 20 "#5b94ab")
    (cons 40 "#81a7a6")
    (cons 60 "#a8bba1")
    (cons 80 "#cfcf9c")
    (cons 100 "#c1cab2")
    (cons 120 "#b3c5c9")
    (cons 140 "#a6c1e0")
    (cons 160 "#a6c1e0")
    (cons 180 "#a6c1e0")
    (cons 200 "#a6c1e0")
    (cons 220 "#b9c1e4")
    (cons 240 "#cdc1e9")
    (cons 260 "#e1c1ee")
    (cons 280 "#bda5cb")
    (cons 300 "#998aa8")
    (cons 320 "#756f85")
    (cons 340 "#888395")
    (cons 360 "#888395")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
