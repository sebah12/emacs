;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))


(defvar myPackages
  '(better-defaults
    ein
    elpy
    flycheck
    material-theme
    py-autopep8
    which-key
    yasnippet
    yasnippet-snippets
    projectile
    speedbar
    crux
    auctex))


(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally
(tool-bar-mode -1)    ;; disable toolbar
(menu-bar-mode -1)    ;; disable menubar
(setq column-number-mode t)				     ;; show column number
(add-to-list 'initial-frame-alist '(fullscreen . maximized)) ;; maximize frame at startup
(global-auto-revert-mode t) ; refresh buffer when changed by other source
(which-key-mode)	    ; enable which-key
(which-key-setup-side-window-bottom)	; set which-key on bottom window

;; LATEX PATHS
;; ----------------------------------------
;; (add-to-list 'exec-path "/Library/TeX/texbin/")

;; YASNIPPET
;; (require 'yasnippet)
(yas-global-mode 1)			;enable global mode

;; PROJECTILE
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)


;; key-bindings
;; --------------------------------------
(global-set-key (kbd "C-x g") 'magit-status) ; magit
(global-set-key (kbd "C-c o") #'crux-open-with) ; open with external application

;; python CONFIGURATION
;; --------------------------------------

(elpy-enable)

(setq elpy-rpc-python-command "python3")

;; use Jupyter console for interactive python
;; (setq python-shell-interpreter "jupyter"
;;       python-shell-interpreter-args "console --simple-prompt"
;;       python-shell-prompt-detect-failure-warning nil)
;; (add-to-list 'python-shell-completion-native-disabled-interpreters
;;              "jupyter")

;; use  the python standard interpreter
(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; OCTAVE CONFIGURATION
;; --------------------------------------

(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

;; init.el ends here
;; --------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (projectile which-key py-autopep8 material-theme magit flycheck elpy ein better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
