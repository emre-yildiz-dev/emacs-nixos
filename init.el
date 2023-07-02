(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
    ("elpa" . "https://elpa.gnu.org/packages/")
    ("org" . "https://orgmode.org/elpa/")))

;; Create a variable to indicate where emacs's configuration is installed
(setq EMACS_DIR "~/.emacs.d/")

;; keybinding for listing emacs packages
(global-set-key (kbd "C-c C-p") 'package-list-packages)

;; Disable toolbar, menu bar, scroll bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Disable annoying ring bell
(setq ring-bell-function 'ignore)

;; Do not show startup screen
(setq ring-bell-funtion 'ignore)

;; install some packages
(setq package-list
      '(company evil doom-themes projectile use-package lsp-metals pdf-tools vterm magit crontab-mode lsp-metals haskell-mode sicp eglot))
;; activate all the packages
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install some missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; In some  operating systems Emacs does not load environment variables properly..
(use-package exec-path-from-shell :ensure t)
(exec-path-from-shell-initialize)

;; company mode tweaks
(global-company-mode t)

(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

(setq company-idle-delay 0.0)

;; evil mode ready
(evil-mode 1)

;; line numbers
;; (global-linum-mode 1)

;; doom theme with "F6" to light switch
(load-theme 'doom-palenight t)

(use-package heaven-and-hell
      :ensure t
      :init
      (setq heaven-and-hell-theme-type 'dark)
      (setq heaven-and-hell-themes
     '((light . doom-palenight)))
      :hook (after-init . heaven-and-hell-init-hook)
      :bind (("<f6>" . heaven-and-hell-toggle-theme)))

;; Enable soft-wrap
(global-visual-line-mode 1)

;; Set language-environment UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Longer whitespace, otherwise syntax highlighting is limited to column
(setq whitespace-line-column 1000)

;; Maintain a list of recent files opened
(recentf-mode 1)
(setq recentf-max-saved-items 50)

;; Automatically add ending brackets and braces
(electric-pair-mode 1)

;; Make sure tab-width is 4 not 8
(setq-default tab-width 4)

;; Highlight matching braces and brackets
(show-paren-mode 1)

;; Fonts
 (set-face-attribute 'default nil
      :family "Inconsolata" :height  120 :weight 'normal)



;; Projectile helps us with easy navigation within the project
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; quickrun package  to execute code
(use-package quickrun
  :ensure t
  :bind ("C-c r" . quickrun))


;; Enable defer and ensure by default for use-package
;; Keep auto-save/backup files separate from source code:  https://github.com/scalameta/metals/issues/1027
(setq use-package-always-defer t
      use-package-always-ensure t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(defun switch-fullscreen nil
  (interactive)
  (let* ((modes '(nil fullboth fullwidth fullheight))
         (cm (cdr (assoc 'fullscreen (frame-parameters) ) ) )
         (next (cadr (member cm modes) ) ) )
    (modify-frame-parameters
     (selected-frame)
     (list (cons 'fullscreen next)))))

(define-key global-map [f7] 'switch-fullscreen)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes nil)
 '(initial-frame-alist '((fullscreen . maximized)))
 '(package-selected-packages
   '(eglot vterm use-package quickrun projectile pdf-tools magit lsp-metals heaven-and-hell exec-path-from-shell evil doom-themes crontab-mode company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package eglot
  :ensure t
  :config
  (add-hook 'haskell-mode-hook 'eglot-ensure)
  :config
  (setq-default eglot-workspace-configuration
                '((haskell
                   (plugin
                    (stan
                     (globalOn . :json-false))))))  ;; disable stan
  :custom
  (eglot-autoshutdown t)  ;; shutdown language server after closing last file
  (eglot-confirm-server-initiated-edits nil)  ;; allow edits without confirmation
  )
