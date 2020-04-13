;; init.el --- Emacs configuration

(add-to-list 'load-path "~/.emacs.d/personal")

;; ------------------------------------------------------------
;; INSTALL PACKAGES
;; ------------------------------------------------------------

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
    auctex
    org-journal))


(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; ------------------------------------------------------------
;; BASIC CUSTOMIZATION
;; ------------------------------------------------------------

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

;; ------------------------------------------------------------
;; ORG MODE
;; ------------------------------------------------------------
(setq org-log-done 'time)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)

;; Agenda files
(setq org-agenda-files '("~/Dropbox/org/agenda/"))

;; TODO dependencies
(add-hook 'org-mode-hook 'org-enforce-todo-dependencies)

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise"
  (let (org-log-done org-log-states)    ;turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; TODO faces
(setq org-todo-keyword-faces
      '(("TODO" . org-warning) ("STARTED" . "yellow")
        ("CANCELLED" . (:foreground "orange" :weight bold))))

;; Filtering functions
(defun air-org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))

(defun air-org-skip-subtree-if-habit ()
  "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (string= (org-entry-get nil "STYLE") "habit")
        subtree-end
      nil)))

;; Custom agenda views
(setq org-agenda-custom-commands
      '(("d" "Daily agenda and all TODOs"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (agenda "" ((org-agenda-ndays 1)))
          (alltodo ""
                   ((org-agenda-skip-function '(or (air-org-skip-subtree-if-habit)
                                                   (air-org-skip-subtree-if-priority ?A)
                                                   (org-agenda-skip-if nil '(scheduled deadline))))
                    (org-agenda-overriding-header "ALL normal priority tasks:")))))))

;; org-journal
(customize-set-variable 'org-journal-dir "~/Dropbox/org/journal/")

;; ------------------------------------------------------------
;; YASNIPPET
;; ------------------------------------------------------------
;; (require 'yasnippet)
(yas-global-mode 1)			;enable global mode
(setq yas/triggers-in-field t); Enable nested triggering of snippets

;; ------------------------------------------------------------
;; PROJECTILE
;; ------------------------------------------------------------
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; ------------------------------------------------------------
;; key-bindings
;; ------------------------------------------------------------
(global-set-key (kbd "C-x g") 'magit-status) ; magit
(global-set-key (kbd "C-c o") #'crux-open-with) ; open with external application

;; ------------------------------------------------------------
;; python CONFIGURATION
;; ------------------------------------------------------------

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

;; ------------------------------------------------------------
;; OCTAVE CONFIGURATION
;; ------------------------------------------------------------

(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

;; ------------------------------------------------------------
;; C CONFIGURATION
;; ------------------------------------------------------------

 (setq-default c-basic-offset 4)
;; init.el ends here
