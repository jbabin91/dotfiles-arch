(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package t))
(setq-default
 use-package-always-defer t
 use-package-always-ensure t)

(setq-default
 ad-redefinition-action 'accept         ; Silence warnings for redefinition
 auto-save-list-file-prefix nil         ; Prevent tracking for auto-saves
 cursor-in-non-selected-windows nil     ; Hide the cursor in inactive windows
 cursor-type '(hbar . 2)                ; Underline-shaped cursor
 custom-unlispify-menu-entries nil      ; Prefer kebab-case for titles
 custom-unlispify-tag-names nil         ; Prefer kebab-case for symbols
 delete-by-moving-to-trash t            ; Delete files to trash
 fill-column 80                         ; Set width for automatic line breaks
 gc-cons-threshold (* 8 1024 1024)      ; We're not using Game Boys anymore
 help-window-select t                   ; Focus new help windows when opened
 indent-tabs-mode nil                   ; Stop using tabs to indent
 inhibit-startup-screen t               ; Disable start-up screen
 initial-scratch-message ""             ; Empty the initial *scratch* buffer
 mouse-yank-at-point t                  ; Yank at point rather than pointer
 read-process-output-max (* 1024 1024)  ; Increase read size per process
 recenter-positions '(5 top bottom)     ; Set re-centering positions
 scroll-conservatively 101              ; Avoid recentering when scrolling far
 scroll-margin 2                        ; Add a margin when scrolling vertically
 select-enable-clipboard t              ; Merge system's and Emacs' clipboard
 sentence-end-double-space nil          ; Use a single space after dots
 show-help-function nil                 ; Disable help text everywhere
 tab-always-indent 'complete            ; Tab indents first then tries completions
 tab-width 4                            ; Smaller width for tab characters
 uniquify-buffer-name-style 'forward    ; Uniquify buffer names
 warning-minimum-level :error           ; Skip warning buffers
 window-combination-resize t            ; Resize windows proportionally
 x-stretch-cursor t)                    ; Stretch cursor to the glyph width
(blink-cursor-mode 0)                   ; Prefer a still cursor
(delete-selection-mode 1)               ; Replace region when inserting text
(fset 'yes-or-no-p 'y-or-n-p)           ; Replace yes/no prompts with y/n
(global-subword-mode 1)                 ; Iterate through CamelCase words
(mouse-avoidance-mode 'exile)           ; Avoid collision of mouse with point
(put 'downcase-region 'disabled nil)    ; Enable downcase-region
(put 'upcase-region 'disabled nil)      ; Enable upcase-region
(set-default-coding-systems 'utf-8)     ; Default to utf-8 encoding

(put 'add-function 'lisp-indent-function 2)
(put 'advice-add 'lisp-indent-function 2)
(put 'plist-put 'lisp-indent-function 2)

(pcase window-system
  ('w32 (set-frame-parameter nil 'fullscreen 'fullboth))
  (_ (set-frame-parameter nil 'fullscreen 'maximized)))

(defun me/secret (&optional name fallback)
  "Read a Lisp structure from the secret file.
When NAME is provided, return the value associated to this key. If no value was
found for NAME, return FALLBACK instead which defaults to nil."
  (let ((file (expand-file-name ".secrets.eld")))
    (when (file-exists-p file)
      (with-demoted-errors "Error while parsing secret file: %S"
        (with-temp-buffer
          (insert-file-contents file)
          (if-let ((content (read (buffer-string)))
                   (name))
              (alist-get name content fallback)
            content))))))

(defconst me/cache-directory
  (expand-file-name ".cache/")
  "Directory where all cache files should be saved")

(defun me/cache-concat (name)
  "Return the absolute path of NAME under `me/cache-directory'."
  (let* ((directory (file-name-as-directory me/cache-directory))
         (path (convert-standard-filename (concat directory name))))
    (make-directory (file-name-directory path) t)
    path))

(with-eval-after-load 'request
  (setq-default request-storage-directory (me/cache-concat "request/")))
(with-eval-after-load 'tramp
  (setq-default tramp-persistency-file-name (me/cache-concat "tramp.eld")))
(with-eval-after-load 'url
  (setq-default url-configuration-directory (me/cache-concat "url/")))

(add-function :after after-focus-change-function
  (defun me/garbage-collect-maybe ()
    (unless (frame-focus-state)
      (garbage-collect))))

(setq-default custom-file null-device)

(defvar me/theme-known-themes '(zenmelt modus-operandi modus-vivendi)
  "List of themes to take into account with `me/theme-cycle'.
See `custom-available-themes'.")

(defun me/theme-disable-themes ()
  "Disable all themes found in `custom-enable-themes'."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))

(defun me/theme-cycle ()
  "Cycle through themes from `me/theme-known-themes' in succession."
  (interactive)
  (let* ((current (car custom-enabled-themes))
         (next (or (cadr (memq current me/theme-known-themes))
                   (car me/theme-known-themes))))
    (me/theme-disable-themes)
    (when next
      (load-theme next t))
    (message "%s" next)))

(define-fringe-bitmap 'left-curly-arrow [16 48 112 240 240 112 48 16])
(define-fringe-bitmap 'right-curly-arrow [8 12 14 15 15 14 12 8])

(set-fringe-bitmap-face 'left-curly-arrow 'shadow)
(set-fringe-bitmap-face 'right-curly-arrow 'shadow)

(set-face-attribute 'default nil
                    :font (me/secret 'font-default)
                    :height (me/secret 'font-size))
(set-face-attribute 'fixed-pitch nil :font (me/secret 'font-fixed))
(set-face-attribute 'variable-pitch nil :font (me/secret 'font-variable))

(use-package modus-themes
  :ensure nil
  :defer nil
  :custom
  (modus-themes-diffs 'fg-only)
  (modus-themes-mode-line 'borderless-accented)
  (modus-themes-operandi-color-overrides
   '((bg-main . "#FAFAFA")
     (bg-main . "#101010")
     (fg-window-divider-inner . "#FAFAFA")))
  (modus-themes-vivendi-color-overrides
   '((bg-main . "#101010")
     (fg-main . "#FAFAFA")
     (fg-window-divider-inner . "#101010")))
  (modus-themes-org-blocks 'tinted-background)
  :custom-face
  (web-mode-keyword-face ((t (:inherit font-lock-keyword-face))))
  :config
  (load-theme 'modus-operandi t t))

(use-package zenmelt-theme
  :load-path "lisp/zenmelt"
  :demand
  :config
  (load-theme 'zenmelt t))

(use-package css-mode
  :ensure nil
  :custom
  (css-indent-offset 2))

(use-package sgml-mode
  :ensure nil
  :hook
  (html-mode . (lambda () (setq me/pretty-print-function #'sgml-pretty-print)))
  (html-mode . sgml-electric-tag-pair-mode)
  (html-mode . sgml-name-8bit-mode)
  :custom
  (sgml-basic-offset 2))

(use-package js-doc)

(use-package js2-mode
  :ensure nil
  :mode (rx ".js" eos)
  :custom
  (js-indent-level 2)
  (js-switch-indent-offset 2)
  (js2-highlight-level 3)
  (js2-idle-timer-delay 0)
  (js2-mode-show-parse-errors nil)
  (js2-mode-show-strict-warnings nil))

(use-package rjsx-mode
  :mode
  (rx (or ".jsx" (and (or "components" "pages") "/" (* anything) ".js"))
      eos)
  :hook
  (rjsx-mode . (lambda () (setq me/pretty-print-function #'sgml-pretty-print)))
  (rjsx-mode . me/hydra-set-super)
  (rjsx-mode . sgml-electric-tag-pair-mode))

(use-package typescript-mode
  :init
  (define-derived-mode typescript-tsx-mode typescript-mode "TSX")
  (add-to-list 'auto-mode-alist `(,(rx ".tsx" eos) . typescript-tsx-mode))
  :config
  (add-hook 'typescript-tsx-mode-hook #'sgml-electric-tag-pair-mode)
  :custom
  (typescript-indent-level 2))

(use-package json-mode
  :mode (rx ".json" eos))

(use-package elisp-mode
  :ensure nil
  :bind
  (:map emacs-lisp-mode-map
   ("C-c C-c" . me/eval-region-dwim)
   :map lisp-interaction-mode-map
   ("C-c C-c" . me/eval-region-dwim))
  :hook
  (emacs-lisp-mode . outline-minor-mode))

(defun me/eval-region-dwim ()
  "When region is active, evaluate it and kill the mark. Else, evaluate the
whole buffer."
  (interactive)
  (if (not (region-active-p))
      (eval-buffer)
    (eval-region (region-beginning) (region-end))
    (setq-local deactivate-mark t)))

(use-package ielm
  :ensure nil
  :hook
  (ielm-mode . (lambda () (setq-local scroll-margin 0))))

(use-package lisp-mode
  :ensure nil
  :mode ((rx ".eld" eos) . lisp-data-mode))

(use-package markdown-mode
  :mode (rx (or "INSTALL" "CONTRIBUTORS" "LICENSE" "README" ".mdx") eos)
  :bind
  (:map markdown-mode-map
   ("M-n" . nil)
   ("M-p" . nil))
  :hook
  (markdown-mode . me/hydra-set-super)
  :custom
  (markdown-asymmetric-header t)
  (markdown-split-window-direction 'right)
  :config
  (unbind-key "M-<down>" markdown-mode-map)
  (unbind-key "M-<up>" markdown-mode-map))

(use-package org
  :ensure nil
  :bind
  (:map org-mode-map
   ("C-<return>" . nil)
   ("C-<tab>" . me/org-cycle-parent))
  :hook
  (org-mode . me/hydra-set-super)
  :custom
  (org-adapt-indentation nil)
  (org-confirm-babel-evaluate nil)
  (org-cycle-separator-lines 0)
  (org-descriptive-links nil)
  (org-edit-src-content-indentation 0)
  (org-edit-src-persistent-message nil)
  (org-fontify-done-headline t)
  (org-fontify-quote-and-verse-blocks t)
  (org-fontify-whole-heading-line t)
  (org-return-follows-link t)
  (org-src-preserve-indentation t)
  (org-src-tab-acts-natively t)
  (org-src-window-setup 'current-window)
  (org-startup-truncated nil)
  (org-support-shift-select 'always)
  :config
  (require 'ob-shell)
  (add-to-list 'org-babel-load-languages '(shell . t))
  (modify-syntax-entry ?' "'" org-mode-syntax-table)
  (advice-add 'org-src--construct-edit-buffer-name :override #'me/org-src-buffer-name)
  (with-eval-after-load 'evil
    (evil-define-key* 'motion org-mode-map
      (kbd "<tab>") #'org-cycle
      (kbd "C-j") #'me/org-show-next-heading-tidily
      (kbd "C-k") #'me/org-show-previous-heading-tidily)))

(defun me/org-cycle-parent (argument)
  "Go to the nearest parent heading and execute `org-cycle'."
  (interactive "p")
  (if (org-at-heading-p)
      (outline-up-heading argument)
    (org-previous-visible-heading argument))
  (org-cycle))

(defun me/org-show-next-heading-tidily ()
  "Show next entry, keeping other entries closed."
  (interactive)
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn (org-show-entry) (outline-show-children))
    (outline-next-heading)
    (unless (and (bolp) (org-at-heading-p))
      (org-up-heading-safe)
      (outline-hide-subtree)
      (user-error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (outline-show-children)))

(defun me/org-show-previous-heading-tidily ()
  "Show previous entry, keeping other entries closed."
  (interactive)
  (let ((pos (point)))
    (outline-previous-heading)
    (unless (and (< (point) pos) (bolp) (org-at-heading-p))
      (goto-char pos)
      (outline-hide-subtree)
      (user-error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (outline-show-children)))

(defun me/org-src-buffer-name (name &rest _)
  "Simple buffer name."
  (format "*%s*" name))

(use-package web-mode
  :mode (rx ".php" eos)
  :hook
  (web-mode . sgml-electric-tag-pair-mode)
  :custom
  (web-mode-code-indent-offset 2)
  (web-mode-enable-auto-opening nil)
  (web-mode-enable-auto-pairing nil)
  (web-mode-enable-auto-quoting nil)
  (web-mode-markup-indent-offset 2)
  (web-mode-enable-auto-indentation nil))

(use-package yaml-mode)

(global-set-key (kbd "s-w") #'delete-window)
(global-set-key (kbd "s-W") #'kill-this-buffer)

(use-package desktop
  :ensure nil
  :hook
  (after-init . desktop-read)
  (after-init . desktop-save-mode)
  :custom
  (desktop-base-file-name (me/cache-concat "desktop"))
  (desktop-base-lock-name (me/cache-concat "desktop.lock"))
  (desktop-restore-eager 4)
  (desktop-restore-forces-onscreen nil)
  (desktop-restore-frames t))

(use-package olivetti
  :bind
  ("<left-margin> <mouse-1>" . ignore)
  ("<right-margin> <mouse-1>" . ignore)
  :hook
  (window-configuration-change . me/olivetti-mode-maybe)
  :custom
  (olivetti-body-width 100))

(defvar me/olivetti-automatic t
  "Whether `olivetti-mode' should be enabled automatically.
See `me/olivetti-mode-maybe' for the heuristics used and details of
implementation.")

(defvar me/olivetti-whitelist-buffers '("*sratch*")
  "List of buffers for which `olivetti-mode' should be enabled automatically.")

(defvar me/olivetti-whitelist-modes '(Custom-mode
                                      Info-mode
                                      dired-mode
                                      erc-mode
                                      help-mode
                                      helpful-mode
                                      lisp-interaction-mode
                                      vterm-mode)
  "List of modes for which `olivetti-mode' should be enabled automatically.")

(defun me/olivetti-automatic-toggle ()
  "Toggle `me/olivetti-automatic'.
If enabled, turn on `olivetti-mode'. Otherwise disable it."
  (interactive)
  (setq me/olivetti-automatic (not me/olivetti-automatic))
  (olivetti-mode (if me/olivetti-automatic 1 -1)))

(defun me/olivetti-mode-maybe (&optional frame)
  "Turn on `olivetti-mode' for lone buffers in FRAME.

Doesn't count volatile windows unless the major-mode of their associated buffer
is found in `me/olivetti-whitelist-modes' or is derived from one of them.
Windows from buffers whose names are found in `me/olivetti-whitelist-buffers'
are also considered.

If FRAME shows exactly one window, turn on `olivetti-mode' for that window.
Otherwise, disable it everywhere."
  (when me/olivetti-automatic
    (let* ((predicate (lambda (window)
                        (with-selected-window window
                          (or (buffer-file-name)
                              (member (buffer-name) me/olivetti-whitelist-buffers)
                              (apply 'derived-mode-p me/olivetti-whitelist-modes)))))
           (windows (seq-filter predicate (window-list frame))))
      (if (length= windows 1)
          (with-selected-window (car windows)
            (olivetti-mode 1))
        (dolist (window windows)
          (with-selected-window window
            (olivetti-mode -1)))))))

(use-package shackle
  :hook
  (after-init . shackle-mode)
  :custom
  (shackle-inhibit-window-quit-on-same-windows t)
  (shackle-rules '((help-mode :same t)
                   (helpful-mode :same t)
                   (process-menu-mode :same t)))
  (shackle-select-reused-windows t))

(use-package windmove
  :ensure nil
  :bind
  ("s-h" . windmove-left)
  ("s-j" . windmove-down)
  ("s-k" . windmove-up)
  ("s-l" . windmove-right))

(use-package winner
  :ensure nil
  :hook
  (after-init . winner-mode))

(use-package consult
  :bind
  ([remap goto-line] . consult-goto-line)
  ([remap isearch-forward] . consult-line)
  ([remap switch-to-buffer] . consult-buffer)
  ("C-h M" . consult-minor-mode-menu)
  :custom
  (consult-line-start-from-top t)
  (consult-project-root-function #'me/project-root)
  :hook
  (org-mode . (lambda () (setq-local consult-fontify-preserve nil)))
  :init
  (with-eval-after-load 'evil
    (evil-global-set-key 'motion "gC" 'me/consult-faces)
    (evil-global-set-key 'motion "gm" 'consult-mark)
    (evil-global-set-key 'motion "gM" 'consult-imenu)
    (evil-global-set-key 'motion "go" 'consult-outline)))

(defun me/consult-faces ()
  "Search for faces.
Default to the face at point using `get-text-property'."
  (interactive)
  (let* ((candidates (mapcar 'symbol-name (face-list)))
         (faces (get-text-property (point) 'face))
         (face (if (listp faces) (car faces) faces)))
    (consult--read (consult--with-increased-gc candidates)
                   :category 'face
                   :default face
                   :lookup (lambda (_input _candidates match) (describe-face match))
                   :prompt "Face: ")))

(use-package corfu
  :hook
  (after-init . corfu-global-mode))

(use-package marginalia
  :hook
  (after-init . marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless))
  (orderless-component-separator 'orderless-escapable-split-on-space))

(use-package vertico
  :custom
  (vertico-resize nil)
  :hook
  (after-init . vertico-mode))

(use-package evil-commentary
  :hook
  (evil-mode . evil-commentary-mode))

(use-package newcomment
  :ensure nil
  :bind
  ("M-<return>" . comment-indent-new-line)
  :hook
  (prog-mode . (lambda () (setq-local comment-auto-fill-only-comments t)))
  :custom
  (comment-multi-line t))

(use-package embark
  :bind
  ("C-;" . embark-act)
  ([remap describe-bindings] . embark-bindings)
  :custom
  (embark-indicators
   '(embark-highlight-indicator
     embark-isearch-highlight-indicator
     embark-minimal-indicator))
  (prefix-help-command #'embark-prefix-help-command))

(use-package selected
  ;; :bind*
  :bind
  (:map selected-keymap
   ("<"           . mc/mark-previous-like-this)
   (">"           . mc/mark-next-like-this)
   ("C-<"         . mc/unmark-previous-like-this)
   ("C->"         . mc/unmark-next-like-this)
   ("M-<"         . mc/skip-to-previous-like-this)
   ("M->"         . mc/skip-to-next-like-this)
   ("C-c >"       . mc/edit-lines)
   ("C-b"         . me/browse-url-and-kill-mark)
   ("C-c c"       . capitalize-region)
   ("C-c k"       . me/kebab-region)
   ("C-c l"       . downcase-region)
   ("C-c u"       . upcase-region)
   ("C-d"         . define-word-at-point)
   ("C-f"         . fill-region)
   ("C-h h"       . hlt-highlight-region)
   ("C-h H"       . hlt-unhighlight-region)
   ("C-p"         . webpaste-paste-region)
   ("C-q"         . selected-off)
   ("C-s r"       . me/reverse-region)
   ("C-s s"       . sort-lines)
   ("C-s w"       . me/sort-words)
   ("C-<tab>"     . me/pretty-print)
   ("M-<left>"    . me/indent-rigidly-left-and-keep-mark)
   ("M-<right>"   . me/indent-rigidly-right-and-keep-mark)
   ("M-S-<left>"  . me/indent-rigidly-left-tab-and-keep-mark)
   ("M-S-<right>" . me/indent-rigidly-right-tab-and-keep-mark))
  :hook
  (after-init . selected-global-mode)
  :config
  (require 'browse-url)
  :custom
  (selected-minor-mode-override t))

(defvar-local me/pretty-print-function nil)

(defun me/pretty-print (beg end)
  (interactive "r")
  (if me/pretty-print-function
      (progn (funcall me/pretty-print-function beg end)
             (setq deactivate-mark t))
    (user-error "me/pretty-print: me/pretty-print-function is not set")))

(defun me/eval-region-and-kill-mark (begin end)
  "Execute the region as Lisp code.
Call `eval-region' and kill mark. Move back to the beginning of the region."
  (interactive "r")
  (eval-region begin end)
  (setq deactivate-mark t)
  (goto-char beg))

(defun me/browse-url-and-kill-mark (url &rest args)
  "Ask a WWW browser to load URL.
Call `browse-url' and kill mark."
  (interactive (browse-url-interactive-arg "URL: "))
  (apply #'browse-url url args)
  (setq deactivate-mark t))

(defun me/indent-rigidly-left-and-keep-mark (begin end)
  "Indent all lines between BEG and END leftward by one space.
Call `indent-rigidly-left' and keep mark."
  (interactive "*r")
  (indent-rigidly-left begin end)
  (setq deactivate-mark nil))

(defun me/indent-rigidly-left-tab-and-keep-mark (begin end)
  "Indent all lines between BEG and END leftward to a tab stop.
Call `indent-rigidly-left-to-tab-stop' and keep mark."
  (interactive "*r")
  (indent-rigidly-left-to-tab-stop begin end)
  (setq deactivate-mark nil))

(defun me/indent-rigidly-right-and-keep-mark (begin end)
  "Indent all lines between BEG and END rightward by one space.
Call `indent-rigidly-right' and keep mark."
  (interactive "*r")
  (indent-rigidly-right begin end)
  (setq deactivate-mark nil))

(defun me/indent-rigidly-right-tab-and-keep-mark (begin end)
  "Indent all lines between BEG and END rightward to a tab stop.
Call `indent-rigidly-right-to-tab-stop' and keep mark."
  (interactive "*r")
  (indent-rigidly-right-to-tab-stop beg end)
  (setq deactivate-mark nil))

(defun me/kebab-region (begin end)
  "Convert region to kebab-case."
  (interactive "*r")
  (downcase-region begin end)
  (save-excursion
    (perform-replace " +" "-" nil t nil nil nil begin end)))

(defun me/reverse-region (reverse begin end)
  "Reverse lines in region.
If region only has one line or when prefixed with \\[universal-argument],
reverse characters in region instead."
  (interactive "*r")
  (if (= (count-lines begin end) 1)
      (insert (nreverse (delete-and-extract-region begin end)))
    (reverse-region begin end)))

(defun me/sort-words (reverse beg end)
  "Sort words in region alphabetically.
Prefixed with \\[universal-argument], sort in REVERSE instead.

The variable `sort-fold-case' determines whether the case affects the sort. See
`sort-regexp-fields'."
  (interactive "*P\nr")
  (sort-regexp-fields reverse "\\w+" "\\&" beg end))

(use-package define-word)

(use-package ediff-wind
  :ensure nil
  :custom
  (ediff-split-window-function #'split-window-horizontally)
  (ediff-window-setup-function #'ediff-setup-windows-plain))

(use-package dired
  :ensure nil
  :hook
  (dired-mode . dired-hide-details-mode)
  :bind
  ("C-x C-g" . dired-jump)
  (:map dired-mode-map
   ("C-<return>" . me/dired-open-externally))
  :custom
  (dired-auto-revert-buffer t)
  (dired-dwim-target t)
  (dired-hide-details-hide-symlink-targets nil)
  (dired-listing-switches "-agho --group-directories-first")
  (dired-recursive-copies 'always))

(defun me/dired-open-externally (argument)
  "Open file under point with an external program.
With positive ARGUMENT, prompt for the command to use."
  (interactive "P")
  (let* ((file (dired-get-file-for-visit))
         (command (and (not argument)
                       (pcase system-type
                         ('darwin "open")
                         ((or 'gnu 'gnu/kfreebsd 'gnu/linux) "xdg-open"))))
         (command (or command (read-shell-command "Open with: "))))
    (call-process command nil 0 nil file)))

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
  (eldoc-idle-delay .1))

(use-package evil
  :bind
  (:map evil-inner-text-objects-map
   ("g" . me/evil-buffer)
   :map evil-outer-text-objects-map
   ("g" . me/evil-buffer))
  (:map evil-insert-state-map
   ("C-a" . nil)
   ("C-e" . nil)
   ("C-w" . nil)
   :map evil-motion-state-map
   ("gs" . avy-goto-char-timer)
   ("gS" . avy-goto-char)
   ("q" . nil)
   ("C-e" . nil)
   :map evil-normal-state-map
   ("gb" . switch-to-buffer)
   ("gD" . me/evil-goto-definition-other-window)
   ("gp" . project-switch-project)
   ("gr" . (lambda () (interactive) (revert-buffer nil t)))
   ("q" . nil)
   :map evil-visual-state-map
   ("f" . fill-region)
   :map evil-window-map
   ("u" . winner-undo)
   ("C-r" . winner-redo))
  :hook
  (after-init . evil-mode)
  (after-save . evil-normal-state)
  :custom
  (evil-echo-state nil)
  (evil-emacs-state-cursor (default-value 'cursor-type))
  (evil-undo-system 'undo-redo)
  (evil-visual-state-cursor 'hollow)
  (evil-want-keybinding nil)
  :config
  (add-to-list 'evil-emacs-state-modes 'exwm-mode)
  (add-to-list 'evil-emacs-state-modes 'dired-mode)
  (add-to-list 'evil-emacs-state-modes 'process-menu-mode)
  (add-to-list 'evil-emacs-state-modes 'profiler-report-mode)
  (add-to-list 'evil-emacs-state-modes 'vterm-mode)
  (add-to-list 'evil-insert-state-modes 'with-editor-mode)
  (add-to-list 'evil-motion-state-modes 'helpful-mode)
  (evil-define-text-object me/evil-buffer (_count &optional _begin _end type)
    "Text object to represent the whole buffer."
    (evil-range (point-min) (point-max) type))
  (advice-add 'evil-indent :around #'me/evil-indent))

(defun me/evil-indent (original &rest arguments)
  "Like `evil-indent' but save excursion."
  (save-excursion (apply original arguments)))

(defun me/evil-goto-definition-other-window ()
  "Like `evil-goto-definition' but use another window to display the result."
  (interactive)
  (switch-to-buffer-other-window (current-buffer))
  (goto-char (point))
  (evil-goto-definition))

(use-package evil-surround
  :hook
  (evil-mode . evil-surround-mode))

(defun me/evil-window-resize-continue (&optional _count)
  "Activate a sparse keymap for evil window resizing routines in order to
support repeated key strokes."
  (set-transient-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "-") #'evil-window-decrease-height)
     (define-key map (kbd "+") #'evil-window-increase-height)
     (define-key map (kbd "<") #'evil-window-decrease-width)
     (define-key map (kbd ">") #'evil-window-increase-width)
     map)))

(advice-add 'evil-window-decrease-height :after #'me/evil-window-resize-continue)
(advice-add 'evil-window-increase-height :after #'me/evil-window-resize-continue)
(advice-add 'evil-window-decrease-width :after #'me/evil-window-resize-continue)
(advice-add 'evil-window-increase-width :after #'me/evil-window-resize-continue)

(use-package emmet-mode
  :bind
  (:map emmet-mode-keymap
   ("C-<return>" . nil))
  :hook
  (css-mode . emmet-mode)
  (html-mode . emmet-mode)
  (rjsx-mode . emmet-mode)
  (typescript-tsx-mode . emmet-mode)
  (web-mode . emmet-mode)
  :custom
  (emmet-insert-flash-time .1)
  (emmet-move-cursor-between-quote t))

(use-package hippie-exp
  :ensure nil
  :preface
  (defun me/emmet-hippie-try-expand (args)
    "Try `emmet-expand-line' if `emmet-mode' is active. Else, does nothing."
    (interactive "P")
    (when emmet-mode (emmet-expand-line args)))
  :bind
  ("C-<return>" . hippie-expand)
  :custom
  (hippie-expand-try-functions-list '(yas-hippie-try-expand me/emmet-hippie-try-expand))
  (hippie-expand-verbose nil))

(use-package yasnippet
  :bind
  (:map yas-minor-mode-map
   ("TAB" . nil)
   ([tab] . nil))
  :hook
  (prog-mode . yas-minor-mode)
  (text-mode . yas-minor-mode)
  :custom
  (yas-verbosity 2)
  :config
  (yas-reload-all))

(use-package help-fns
  :ensure nil
  :bind
  ("C-h K" . describe-keymap))

(use-package help-mode
  :ensure nil
  :bind
  (:map help-mode-map
   ("<" . help-go-back)
   (">" . help-go-forward))
  :config
  (with-eval-after-load 'evil
    (evil-define-key* 'motion help-mode-map
      (kbd "<tab>") #'forward-button)))

(use-package helpful
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-callable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  ("C-h F" . helpful-function)
  :config
  (with-eval-after-load 'evil
    (evil-define-key* 'motion helpful-mode-map
      (kbd "<tab>") #'forward-button)))

(use-package hydra
  :bind
  ("C-c a" . hydra-applications/body)
  ("C-c d" . hydra-dates/body)
  ("C-c e" . hydra-eyebrowse/body)
  ("C-c g" . hydra-git/body)
  ("C-c o" . me/hydra-super-maybe)
  ("C-c p" . hydra-project/body)
  ("C-c s" . hydra-system/body)
  ("C-c u" . hydra-ui/body)
  :custom
  (hydra-default-hint nil))

(defvar-local me/hydra-super-body nil)

(defun me/hydra-heading (&rest headings)
  "Format HEADINGS to look pretty in a hydra docstring."
  (concat "\n "
          (mapconcat (lambda (heading)
                       (propertize (format "%-18s" heading) 'face 'shadow))
                     headings
                     nil)))

(defun me/hydra-set-super ()
  (when-let* ((suffix "-mode")
              (position (- (length suffix)))
              (mode (symbol-name major-mode))
              (name (if (string= suffix (substring mode position))
                        (substring mode 0 position)
                      mode))
              (body (intern (format "hydra-%s/body" name))))
    (when (functionp body)
      (setq me/hydra-super-body body))))

(defun me/hydra-super-maybe ()
  (interactive)
  (if me/hydra-super-body
      (funcall me/hydra-super-body)
    (user-error "me/hydra-super: me/hydra-super-body is not set")))

(defhydra hydra-applications (:color teal)
  (concat (me/hydra-heading "Applications" "Launch" "Shell") "
 _q_ quit            _i_ erc             _t_ vterm           ^^
 ^^                  ^^                  _T_ eshell          ^^
")
  ("q" nil)
  ("i" me/erc)
  ("t" vterm)
  ("T" (eshell t)))

(defhydra hydra-dates (:color teal)
  (concat (me/hydra-heading "Dates" "Insert" "Insert with Time") "
 _q_ quit            _d_ short           _D_ short           ^^
 ^^                  _i_ iso             _I_ iso             ^^
 ^^                  _l_ long            _L_ long            ^^
")
  ("q" nil)
  ("d" me/date-short)
  ("D" me/date-short-with-time)
  ("i" me/date-iso)
  ("I" me/date-iso-with-time)
  ("l" me/date-long)
  ("L" me/date-long-with-time))

(defhydra hydra-eyebrowse (:color teal)
  (concat (me/hydra-heading "Eyebrowse" "Do" "Switch") "
 _q_ quit            _c_ create          _1_-_9_ %s(eyebrowse-mode-line-indicator)
 ^^                  _k_ kill            _<_ previous        ^^
 ^^                  _r_ rename          _>_ next            ^^
 ^^                  ^^                  _e_ last            ^^
 ^^                  ^^                  _s_ switch          ^^
")
  ("q" nil)
  ("1" me/eyebrowse-switch-1)
  ("2" me/eyebrowse-switch-2)
  ("3" me/eyebrowse-switch-3)
  ("4" me/eyebrowse-switch-4)
  ("5" me/eyebrowse-switch-5)
  ("6" me/eyebrowse-switch-6)
  ("7" me/eyebrowse-switch-7)
  ("8" me/eyebrowse-switch-8)
  ("9" me/eyebrowse-switch-9)
  ("<" eyebrowse-prev-window-config :color red)
  (">" eyebrowse-next-window-config :color red)
  ("c" eyebrowse-create-window-config)
  ("e" eyebrowse-last-window-config)
  ("k" eyebrowse-close-window-config :color red)
  ("r" eyebrowse-rename-window-config)
  ("s" eyebrowse-switch-to-window-config))

(defhydra hydra-git (:color teal)
  (concat (me/hydra-heading "Git" "Do" "Gutter") "
 _q_ quit            _b_ blame           _p_ previous        ^^
 _m_ smerge...       _c_ clone           _n_ next            ^^
 ^^                  _g_ status          _r_ revert          ^^
 ^^                  _i_ init            _s_ stage           ^^
")
  ("q" nil)
  ("b" magit-blame)
  ("c" magit-clone)
  ("g" magit-status)
  ("i" magit-init)
  ("m" (progn (require 'smerge-mode) (hydra-git/smerge/body)))
  ("n" git-gutter:next-hunk :color red)
  ("p" git-gutter:previous-hunk :color red)
  ("r" git-gutter:revert-hunk)
  ("s" git-gutter:stage-hunk :color red))

(defhydra hydra-git/smerge
  (:color pink :pre (if (not smerge-mode) (smerge-mode 1)) :post (smerge-auto-leave))
  (concat (me/hydra-heading "Git / SMerge" "Move" "Keep" "Diff") "
 _q_ quit            _g_ first           _RET_ current       _<_ upper / base
 ^^                  _G_ last            _a_ all             _=_ upper / lower
 ^^                  _j_ next            _b_ base            _>_ base / lower
 ^^                  _k_ previous        _l_ lower           _E_ ediff
 ^^                  ^^                  _u_ upper           _H_ highlight
")
  ("q" nil :color blue)
  ("j" smerge-next)
  ("k" smerge-prev)
  ("<" smerge-diff-base-upper :color blue)
  ("=" smerge-diff-upper-lower :color blue)
  (">" smerge-diff-base-lower :color blue)
  ("RET" smerge-keep-current)
  ("a" smerge-keep-all)
  ("b" smerge-keep-base)
  ("E" smerge-ediff :color blue)
  ("g" (progn (goto-char (point-min)) (smerge-next)))
  ("G" (progn (goto-char (point-max)) (smerge-prev)))
  ("H" smerge-refine)
  ("l" smerge-keep-lower)
  ("u" smerge-keep-upper))

(defhydra hydra-markdown (:color pink)
  (concat (me/hydra-heading "Markdown" "Table Columns" "Table Rows") "
 _q_ quit            _c_ insert          _r_ insert          ^^
 ^^                  _C_ delete          _R_ delete          ^^
 ^^                  _M-<left>_ left     _M-<down>_ down     ^^
 ^^                  _M-<right>_ right   _M-<up>_ up         ^^
")
  ("q" nil)
  ("c" markdown-table-insert-column)
  ("C" markdown-table-delete-column)
  ("r" markdown-table-insert-row)
  ("R" markdown-table-delete-row)
  ("M-<left>" markdown-table-move-column-left)
  ("M-<right>" markdown-table-move-column-right)
  ("M-<down>" markdown-table-move-row-down)
  ("M-<up>" markdown-table-move-row-up))

(defhydra hydra-org (:color pink)
  (concat (me/hydra-heading "Org" "Links" "Outline") "
 _q_ quit            _i_ insert          _<_ previous        ^^
 ^^                  _n_ next            _>_ next            ^^
 ^^                  _p_ previous        _a_ all             ^^
 ^^                  _s_ store           _v_ overview        ^^
")
  ("q" nil)
  ("<" org-backward-element)
  (">" org-forward-element)
  ("a" outline-show-all :color blue)
  ("i" org-insert-link :color blue)
  ("n" org-next-link)
  ("p" org-previous-link)
  ("s" org-store-link)
  ("v" org-overview :color blue))

(defhydra hydra-project (:color teal)
  (concat (me/hydra-heading "Project" "Do" "Find" "Search") "
 _q_ quit            _K_ kill buffers    _b_ buffer          _r_ replace
 ^^                  _t_ forget project  _d_ directory       _s_ ripgrep
 ^^                  _T_ prune projects  _D_ root            ^^
 ^^                  ^^                  _f_ file            ^^
 ^^                  ^^                  _p_ project         ^^
")
  ("q" nil)
  ("b" project-switch-to-buffer)
  ("d" project-find-dir)
  ("D" project-dired)
  ("f" project-find-file)
  ("K" project-kill-buffers)
  ("p" project-switch-project)
  ("r" project-query-replace-regexp)
  ("s" me/project-search)
  ("t" project-forget-project)
  ("T" project-forget-zombie-projects))

(defhydra hydra-rjsx (:color teal)
  (concat (me/hydra-heading "RJSX" "JSDoc") "
 _q_ quit            _f_ function        ^^                  ^^
 ^^                  _F_ file            ^^                  ^^
")
  ("q" nil)
  ("f" js-doc-insert-function-doc-snippet)
  ("F" js-doc-insert-file-doc))

(defhydra hydra-system (:color teal)
  (concat (me/hydra-heading "System" "Buffer" "Packages" "Toggle") "
 _d_ clear compiled  _s_ revert          _i_ install         _g_ debug: %-3s`debug-on-error
 _D_ clear desktop   _v_ visit...        _I_ reinstall       ^^
 _l_ processes       ^^                  _p_ list            ^^
 _Q_ clear and kill  ^^                  _r_ refresh         ^^
")
  ("q" nil)
  ("d" me/byte-delete)
  ("D" desktop-remove)
  ("g" (setq debug-on-error (not debug-on-error)))
  ("i" package-install)
  ("I" package-reinstall)
  ("l" list-processes)
  ("p" package-list-packages)
  ("Q" (let ((desktop-save nil))
         (me/byte-delete)
         (desktop-remove)
         (save-buffers-kill-terminal)))
  ("r" package-refresh-contents :color red)
  ("s" (revert-buffer nil t))
  ("v" (hydra-system/visit/body)))

(defhydra hydra-system/visit (:color teal)
  (concat (me/hydra-heading "Visit" "Configuration") "
 _q_ quit            _e_ emacs           ^^                  ^^
 ^^                  _l_ linux           ^^                  ^^
 ^^                  _q_ qtile           ^^                  ^^
 ^^                  _z_ zsh             ^^                  ^^
")
  ("q" nil)
  ("e" (find-file (concat user-emacs-directory "dotemacs.org")))
  ("l" (find-file "~/Workspace/dot/LINUX.org"))
  ("q" (find-file "~/Workspace/dot/config/qtile.org"))
  ("z" (find-file "~/Workspace/dot/config/zsh.org")))

(defun me/byte-delete ()
  (interactive)
  (shell-command "find . -name \"*.elc\" -type f | xargs rm -f"))

(defhydra hydra-ui (:color pink)
  (concat (me/hydra-heading "Theme" "Windows" "Zoom" "Line Numbers") "
 _t_ cycle           _b_ balance         _-_ out             _n_ mode: %s`display-line-numbers
 _T_ cycle (noexit)  _m_ maximize frame  _=_ in              _N_ absolute: %s`display-line-numbers-current-absolute
 ^^                  _o_ olivetti: %-3s`me/olivetti-automatic   _0_ reset           ^^
 ^^                  ^^                  ^^                  ^^
 ^^                  ^^                  ^^                  ^^
")
  ("q" nil)
  ("-" default-text-scale-decrease)
  ("=" default-text-scale-increase)
  ("0" default-text-scale-reset :color blue)
  ("b" balance-windows :color blue)
  ("m" toggle-frame-maximized)
  ("n" me/display-line-numbers-toggle-type)
  ("N" me/display-line-numbers-toggle-absolute)
  ("o" me/olivetti-automatic-toggle :color blue)
  ("t" me/theme-cycle :color blue)
  ("T" me/theme-cycle))

(defun me/display-line-numbers-toggle-absolute ()
  "Toggle the value of `display-line-numbers-current-absolute'."
  (interactive)
  (let ((value display-line-numbers-current-absolute))
    (setq-local display-line-numbers-current-absolute (not value))))

(defun me/display-line-numbers-toggle-type ()
  "Cycle through the possible values of `display-line-numbers'.
Cycle between nil, t and 'relative."
  (interactive)
  (let* ((range '(nil t relative))
         (position (1+ (cl-position display-line-numbers range)))
         (position (if (= position (length range)) 0 position)))
    (setq-local display-line-numbers (nth position range))))

(use-package xref
  :ensure nil
  :config
  (with-eval-after-load 'consult
    (setq-default
     xref-show-definitions-function #'consult-xref
     xref-show-xrefs-function #'consult-xref))
  (with-eval-after-load 'evil
    (evil-define-key* 'motion xref--xref-buffer-mode-map
      (kbd "<backtab") #'xref-prev-group
      (kbd "<return") #'xref-goto-xref
      (kbd "<tab>") #'xref-next-group)))

(use-package eglot
  :commands (eglot)
  :custom
  (eglot-autoshutdown t)
  :init
  (put 'eglot-server-programs 'safe-local-variable 'listp)
  :config
  (add-to-list 'eglot-stay-out-of 'eldoc-documentation-strategy)
  :hook
  (typescript-mode . eglot-ensure))

(use-package flymake-eslint
  :custom
  (flymake-eslint-executable-name "npx"))

(use-package tree-sitter
  :hook
  (typescript-mode . tree-sitter-hl-mode)
  (typescript-tsx-mode . tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter
  :defer nil
  :config
  (tree-sitter-require 'tsx)
  (add-to-list 'tree-sitter-major-mode-language-alist
               '(typescript-tsx-mode . tsx)))

(use-package erc
  :ensure nil
  :bind
  (:map erc-mode-map
   ([remap erc-bol] . me/erc-bol-shifted)
   ("M-<down>" . erc-next-command)
   ("M-<up>" . erc-previous-command))
  :hook
  (erc-mode . (lambda () (setq-local scroll-margin 0)))
  :custom
  (erc-autojoin-channels-alist '(("freenode.net" "#emacs")))
  (erc-fill-function 'erc-fill-static)
  (erc-fill-static-center 20)
  (erc-header-line-format nil)
  (erc-insert-timestamp-function 'erc-insert-timestamp-left)
  (erc-lurker-hide-list '("JOIN" "PART" "QUIT"))
  (erc-prompt (format "%19s" ">"))
  (erc-timestamp-format nil)
  :config
  (erc-scrolltobottom-enable))

(defun me/erc ()
  "Connect to `me/erc-server' on `me/erc-port' as `me/erc-nick' with
  `me/erc-password'."
  (interactive)
  (erc :server (me/secret 'irc-server)
       :port (me/secret 'irc-port)
       :nick (me/secret 'irc-nick)
       :password (me/secret 'irc-password)))

(defun me/erc-bol-shifted ()
  "See `erc-bol'. Support shift."
  (interactive "^")
  (erc-bol))

(use-package erc-hl-nicks)

(add-hook 'conf-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(setq-default
 display-line-numbers-grow-only t
 display-line-numbers-type 'relative
 display-line-numbers-width 2)

(use-package prettier
  :config
  (add-to-list 'prettier-enabled-parsers 'json-stringify))

(use-package doom-modeline
  :demand t
  :custom
  (doom-modeline-bar-width 1)
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-height (me/secret 'mode-line-height 30))
  (doom-modeline-enable-word-count t)
  (doom-modeline-major-mode-icon nil)
  (doom-modeline-percent-position nil)
  (doom-modeline-vcs-max-length 28)
  :custom-face
  (doom-modeline-bar ((t (:inherit mode-line))))
  (doom-modeline-bar-inactive ((t (:background nil :inherit mode-line-inactive))))
  :config
  (doom-modeline-def-segment me/buffer
    "The buffer description and major mode icon."
    (concat (doom-modeline-spc)
            (doom-modeline--buffer-name)
            (doom-modeline-spc)))
  (doom-modeline-def-segment me/buffer-position
    "The buffer position."
    (let* ((active (doom-modeline--active))
           (face (if active 'mode-line 'mode-line-inactive)))
      (propertize (concat (doom-modeline-spc)
                          (format-mode-line "%l:%c")
                          (doom-modeline-spc))
                  'face face)))
  (doom-modeline-def-segment me/buffer-simple
    "The buffer name but simpler."
    (let* ((active (doom-modeline--active))
           (face (cond ((and buffer-file-name (buffer-modified-p)) 'doom-modeline-buffer-modified)
                       (active 'doom-modeline-buffer-file)
                       (t 'mode-line-inactive))))
      (concat (doom-modeline-spc)
              (propertize "%b" 'face face)
              (doom-modeline-spc))))
  (doom-modeline-def-segment me/default-directory
    "The buffer directory."
    (let* ((active (doom-modeline--active))
           (face (if active 'doom-modeline-buffer-path 'mode-line-inactive)))
      (concat (doom-modeline-spc)
              (propertize (abbreviate-file-name default-directory) 'face face)
              (doom-modeline-spc))))
  (doom-modeline-def-segment me/flymake
    "The error status with color codes and icons."
    (when (bound-and-true-p flymake-mode)
      (let ((active (doom-modeline--active))
            (icon doom-modeline--flymake-icon)
            (text doom-modeline--flymake-text))
        (concat
         (when icon
           (concat (doom-modeline-spc)
                   (if active icon (doom-modeline-propertize-icon icon 'mode-line-inactive))))
         (when text
           (concat (if icon (doom-modeline-vspc) (doom-modeline-spc))
                   (if active text (propertize text 'face 'mode-line-inactive))))
         (when (or icon text)
           (doom-modeline-spc))))))
  (doom-modeline-def-segment me/info
    "The topic and nodes in Info buffers."
    (let ((active (doom-modeline--active)))
      (concat
       (propertize " (" 'face (if active 'mode-line 'mode-line-inactive))
       (propertize (if (stringp Info-current-file)
                       (replace-regexp-in-string
                        "%" "%%"
                        (file-name-sans-extension (file-name-nondirectory Info-current-file)))
                     (format "*%S*" Info-current-file))
                   'face (if active 'doom-modeline-info 'mode-line-inactive))
       (propertize ") " 'face (if active 'mode-line 'mode-line-inactive))
       (when Info-current-node
         (propertize (concat (replace-regexp-in-string "%" "%%" Info-current-node)
                             (doom-modeline-spc))
                     'face (if active 'doom-modeline-buffer-path 'mode-line-inactive))))))
  (doom-modeline-def-segment me/major-mode
    "The current major mode, including environment information."
    (let* ((active (doom-modeline--active))
           (face (if active 'doom-modeline-buffer-major-mode 'mode-line-inactive)))
      (concat (doom-modeline-spc)
              (propertize (format-mode-line mode-name) 'face face)
              (doom-modeline-spc))))
  (doom-modeline-def-segment me/process
    "The ongoing process details."
    (let ((result (format-mode-line mode-line-process)))
      (concat (if (doom-modeline--active)
                  result
                (propertize result 'face 'mode-line-inactive))
              (doom-modeline-spc))))
  (doom-modeline-def-segment me/space
    "A simple space."
    (doom-modeline-spc))
  (doom-modeline-def-segment me/vcs
    "The version control system information."
    (when-let ((branch doom-modeline--vcs-text))
      (let ((active (doom-modeline--active))
            (text (concat ":" branch)))
        (concat (doom-modeline-spc)
                (if active text (propertize text 'face 'mode-line-inactive))
                (doom-modeline-spc)))))
  (doom-modeline-mode 1)
  (doom-modeline-def-modeline 'info
    '(bar modals me/buffer me/info me/buffer-position selection-info)
    '(irc-buffers matches me/process debug me/major-mode workspace-name))
  (doom-modeline-def-modeline 'main
    '(bar modals me/buffer remote-host me/buffer-position me/flymake selection-info)
    '(irc-buffers matches me/process me/vcs debug me/major-mode workspace-name))
  (doom-modeline-def-modeline 'message
    '(bar modals me/buffer-simple me/buffer-position selection-info)
    '(irc-buffers matches me/process me/major-mode workspace-name))
  (doom-modeline-def-modeline 'org-src
    '(bar modals me/buffer-simple me/buffer-position me/flymake selection-info)
    '(irc-buffers matches me/process debug me/major-mode workspace-name))
  (doom-modeline-def-modeline 'package
    '(bar modals me/space package)
    '(irc-buffers matches me/process debug me/major-mode workspace-name))
  (doom-modeline-def-modeline 'project
    '(bar modals me/default-directory)
    '(irc-buffers matches me/process debug me/major-mode workspace-name))
  (doom-modeline-def-modeline 'special
    '(bar modals me/buffer me/buffer-position selection-info)
    '(irc-buffers matches me/process debug me/major-mode workspace-name))
  (doom-modeline-def-modeline 'vcs
    '(bar modals me/buffer remote-host me/buffer-position selection-info)
    '(irc-buffers matches me/process debug me/major-mode workspace-name)))

(use-package avy
  :custom
  (avy-background t)
  (avy-style 'at-full)
  (avy-timeout-seconds .3)
  ;; :config
  ;; (set-face-italic 'avy-goto-char-timer-face nil)
  ;; (set-face-italic 'avy-lead-face nil)
)

(global-set-key [remap move-beginning-of-line] #'me/move-beginning-of-line-dwim)

(defun me/move-beginning-of-line-dwim ()
  "Move point to first non-whitespace character, or beginning of line."
  (interactive "^")
  (let ((origin (point)))
    (beginning-of-line)
    (and (= origin (point))
         (back-to-indentation))))

(use-package evil-snipe
  :hook
  (evil-mode . evil-snipe-mode)
  (evil-mode . evil-snipe-override-mode)
  :custom
  (evil-snipe-char-fold t)
  (evil-snipe-repeat-scope 'visible)
  (evil-snipe-smart-case t))

(global-set-key [remap backward-paragraph] #'me/backward-paragraph-dwim)
(global-set-key [remap forward-paragraph] #'me/forward-paragraph-dwim)

(defun me/backward-paragraph-dwim ()
  "Move backward to start of paragraph."
  (interactive "^")
  (skip-chars-backward "\n")
  (unless (search-backward-regexp "\n[[:blank:]]*\n" nil t)
    (goto-char (point-min)))
  (skip-chars-forward "\n"))

(defun me/forward-paragraph-dwim ()
  "Move forward to start of next paragraph."
  (interactive "^")
  (skip-chars-forward "\n")
  (unless (search-forward-regexp "\n[[:blank:]]*\n" nil t)
    (goto-char (point-max)))
  (skip-chars-forward "\n"))

(use-package pulse :ensure nil)

(use-package anzu
  :bind
  ([remap query-replace] . anzu-query-replace-regexp))

(use-package mwheel
  :ensure nil
  :custom
  (mouse-wheel-progressive-speed nil)
  (mouse-wheel-scroll-amount '(2 ((control) . 8)))
  :config
  (advice-add 'mwheel-scroll :around #'me/mwheel-scroll))

(defun me/mwheel-scroll (original &rest arguments)
  "Like `mwheel-scroll' but preserve screen position.
See `scroll-preserve-screen-position'."
  (let ((scroll-preserve-screen-position :always))
    (apply original arguments)))

(use-package isearch
  :ensure nil
  :bind
  (("C-S-r" . isearch-backward-regexp)
   ("C-S-s" . isearch-forward-regexp))
  :custom
  (isearch-allow-scroll t)
  (lazy-highlight-buffer t)
  (lazy-highlight-cleanup nil)
  (lazy-highlight-initial-delay 0)
  :hook
  (isearch-update-post . me/isearch-aim-beginning)
  :preface
  (defun me/isearch-aim-beginning ()
    "Move cursor back to the beginning of the current match."
    (when (and isearch-forward (number-or-marker-p isearch-other-end))
      (goto-char isearch-other-end))))

(use-package exec-path-from-shell
  :if (eq window-system 'ns)
  ;; :defer 1
  :hook
  (after-init . exec-path-from-shell-initialize))
  ;; :custom
  ;; (exec-path-from-shell-arguments '("-l")))

(when (eq system-type 'darwin)
  (setq-default
   ns-alternate-modifier 'super         ; Map Super to the Alt key
   ns-command-modifier 'meta            ; Map Meta to the Cmd key
   ns-pop-up-frames nil                 ; Always re-use the same frame
   ns-use-mwheel-momentum nil))         ; Disable smooth scroll

(when (eq system-type 'windows-nt)
  (defun me/bash ()
    (interactive)
    (let ((explicit-shell-file-name "C:/Windows/System32/bash.exe"))
      (shell))))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package smartparens
  :bind
  ("M-<backspace>" . sp-unwrap-sexp)
  ("M-<left>" . sp-forward-barf-sexp)
  ("M-<right>" . sp-forward-slurp-sexp)
  ("M-S-<left>" . sp-backward-slurp-sexp)
  ("M-S-<right>" . sp-backward-barf-sexp)
  :hook
  (after-init . smartparens-global-mode)
  :custom
  (sp-highlight-pair-overlay nil)
  (sp-highlight-wrap-overlay nil)
  (sp-highlight-wrap-tag-overlay nil)
  :config
  (show-paren-mode 0)
  (require 'smartparens-config))

(use-package webpaste
  :custom
  (webpaste-provider-priority '("paste.mozilla.org" "dpaste.org")))

(use-package expand-region
  :bind
  ("C-=" . er/expand-region))

(global-set-key (kbd "M-p") #'me/swap-up)
(global-set-key (kbd "M-n") #'me/swap-down)
(global-set-key (kbd "M-P") #'me/duplicate-backward)
(global-set-key (kbd "M-N") #'me/duplicate-forward)

(defun me/duplicate-line (&optional stay)
  "Duplicate current line.
With optional argument STAY true, leave point where it was."
  (save-excursion
    (move-end-of-line nil)
    (save-excursion
      (insert (buffer-substring (point-at-bol) (point-at-eol))))
    (newline))
  (unless stay
    (let ((column (current-column)))
      (forward-line)
      (forward-char column))))

(defun me/duplicate-backward ()
  "Duplicate current line upward or region backward.
If region was active, keep it so that the command can be repeated."
  (interactive)
  (if (region-active-p)
      (let (deactivate-mark)
        (save-excursion
          (insert (buffer-substring (region-beginning) (region-end)))))
    (me/duplicate-line t)))

(defun me/duplicate-forward ()
  "Duplicate current line downward or region forward.
If region was active, keep it so that the command can be repeated."
  (interactive)
  (if (region-active-p)
      (let (deactivate-mark (point (point)))
        (insert (buffer-substring (region-beginning) (region-end)))
        (push-mark point))
    (me/duplicate-line)))

(defun me/swap-down ()
  "Move down the line under point."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(defun me/swap-up ()
  "Move up the line under point."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(use-package evil-multiedit
  :after evil
  :defer nil
  :bind
  (:map evil-insert-state-map
   ("M-d". evil-multiedit-toggle-marker-here)
   :map evil-normal-state-map
   ("M-d". evil-multiedit-match-symbol-and-next)
   ("M-D". evil-multiedit-match-symbol-and-prev)
   :map evil-visual-state-map
   ("R" . evil-multiedit-match-all)
   ("M-d". evil-multiedit-match-symbol-and-next)
   ("M-D". evil-multiedit-match-symbol-and-prev)
   ("C-M-D". evil-multiedit-restore)
   :map evil-multiedit-state-map
   ("C-n". evil-multiedit-next)
   ("C-p". evil-multiedit-prev)
   ("RET". evil-multiedit-toggle-or-restrict-region)
   :map evil-multiedit-insert-state-map
   ("C-n". evil-multiedit-next)
   ("C-p". evil-multiedit-prev)))

(use-package multiple-cursors
  :bind*
  (:map mc/keymap
   ("M-a" . mc/vertical-align-with-space)
   ("M-h" . mc-hide-unmatched-lines-mode)
   ("M-l" . mc/insert-letters)
   ("M-n" . mc/insert-numbers))
  :init
  (setq-default mc/list-file (me/cache-concat "multiple-cursors.el"))
  :custom
  (mc/edit-lines-empty-lines 'ignore)
  (mc/insert-numbers-default 1))

(use-package project
  :custom
  (project-list-file (me/cache-concat "projects.eld"))
  (project-switch-commands '((project-dired "Root" "D")
                             (project-find-file "File" "f")
                             (magit-project-status "Git" "g")
                             (me/project-search "Search" "s")
                             (me/vterm-dwim "Terminal" "t"))))

(defun me/project-name (&optional project)
  "Return the name for PROJECT.
If PROJECT is not specified, assume current project root."
  (when-let (root (or project (me/project-root)))
    (file-name-nondirectory
     (directory-file-name
      (file-name-directory root)))))

(defun me/project-search ()
  "Run ripgrep against project root.
If ripgrep is not installed, use grep instead."
  (interactive)
  (let ((root (me/project-root)))
    (if (executable-find "rg")
        (consult-ripgrep root)
      (consult-grep root))))

(defun me/project-root ()
  "Return the current project root."
  (when-let (project (project-current))
    (project-root project)))

(dir-locals-set-class-variables 'prettier
 '((js-mode . ((eval . (prettier-mode))))
   (json-mode . ((eval . (prettier-mode))))
   (rjsx-mode . ((eval . (prettier-mode))))
   (scss-mode . ((eval . (prettier-mode))))
   (typescript-mode . ((eval . (prettier-mode))))
   (web-mode . ((eval . (prettier-mode))
                (prettier-parsers . (typescript))))))

(mapc (lambda (it) (dir-locals-set-directory-class it 'prettier))
      (me/secret 'project-prettier))

(add-to-list 'safe-local-eval-forms '(prettier-mode))
(add-to-list 'safe-local-eval-forms '(eglot-ensure))

(use-package aggressive-indent
  :hook
  (css-mode . aggressive-indent-mode)
  (emacs-lisp-mode . aggressive-indent-mode)
  (js-mode . aggressive-indent-mode)
  (lisp-mode . aggressive-indent-mode)
  (sgml-mode . aggressive-indent-mode)
  :custom
  (aggressive-indent-comments-too t)
  :config
  (add-to-list 'aggressive-indent-protected-commands 'comment-dwim))

(use-package conf-mode
  :ensure nil
  :mode
  (rx (or "CODEOWNERS" "rc"
          (and ".env" (? (or ".development" ".local" ".test"))))
      eos))

(defun me/date-iso ()
  "Insert the current date, ISO format, eg. 2016-12-09."
  (interactive)
  (insert (format-time-string "%F")))

(defun me/date-iso-with-time ()
  "Insert the current date, ISO format with time, eg. 2016-12-09T14:34:54+0100."
  (interactive)
  (insert (format-time-string "%FT%T%z")))

(defun me/date-long ()
  "Insert the current date, long format, eg. December 09, 2016."
  (interactive)
  (insert (format-time-string "%B %d, %Y")))

(defun me/date-long-with-time ()
  "Insert the current date, long format, eg. December 09, 2016 - 14:34."
  (interactive)
  (insert (capitalize (format-time-string "%B %d, %Y - %H:%M"))))

(defun me/date-short ()
  "Insert the current date, short format, eg. 2016.12.09."
  (interactive)
  (insert (format-time-string "%Y.%m.%d")))

(defun me/date-short-with-time ()
  "Insert the current date, short format with time, eg. 2016.12.09 14:34"
  (interactive)
  (insert (format-time-string "%Y.%m.%d %H:%M")))

(use-package default-text-scale)

(use-package files
  :ensure nil
  :custom
  (backup-by-copying t)
  (backup-directory-alist `(("." . ,(me/cache-concat "backups/"))))
  (delete-old-versions t)
  (version-control t))

(use-package highlight-indent-guides
  :hook
  (python-mode . highlight-indent-guides-mode)
  (scss-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character))

(use-package hl-line
  :ensure nil
  :hook
  (dired-mode . hl-line-mode)
  (prog-mode . hl-line-mode)
  (special-mode . hl-line-mode)
  (text-mode . hl-line-mode)
  :custom
  (hl-line-sticky-flag nil))

(use-package rainbow-mode
  :hook
  (prog-mode . rainbow-mode)
  :custom
  (rainbow-x-colors nil))

(use-package simple
  :ensure nil
  :hook
  (org-mode . auto-fill-mode)
  (prog-mode . auto-fill-mode)
  (text-mode . auto-fill-mode))

(advice-add 'message :after
  (defun me/message-tail (&rest _)
    (let* ((name "*Messages*")
           (buffer (get-buffer-create name)))
      (when (not (string= name (buffer-name)))
        (dolist (window (get-buffer-window-list name nil t))
          (with-selected-window window
            (goto-char (point-max))))))))

(use-package restclient
  :mode ((rx ".http" eos) . restclient-mode)
  :bind
  (:map restclient-mode-map
   ([remap restclient-http-send-current]
    . restclient-http-send-current-stay-in-window)
   ("C-n" . restclient-jump-next)
   ("C-p" . restclient-jump-prev))
  :hook
  (restclient-mode . display-line-numbers-mode))

(use-package vterm
  :commands (vterm vterm-other-window)
  :bind
  ("s-'" . me/vterm-dwim)
  ("s-\"" . me/vterm-close)
  (:map vterm-mode-map
   ("C-c C-c" . vterm-send-C-c)))

(defun me/vterm-close ()
  "Find and close the bottom `vterm-mode' window."
  (interactive)
  (walk-windows
   (lambda (window)
     (let ((windmove-wrap-around nil))
       (with-selected-window window
         (when (and (eq major-mode 'vterm-mode)
                    (window-in-direction 'up)
                    (not (window-in-direction 'down)))
           (delete-window)))))
   nil (selected-frame)))

(defvar me/vterm-shackles `(:align 'below :popup t :size ,(me/secret 'popup-height .33))
  "Shackle rules in the context of `me/vterm-dwim'.
To see the supported options, see the documentation for `shackle-rules'.")

(defun me/vterm-dwim (&optional argument)
  "Invoke `vterm' according to context and current location.

With a \\[universal-argument] prefix or if no project is found, invoke a dumb
`vterm' in place.

If existing, bring back the first vterm window following `me/vterm-shackles'
specifications. Otherwise create a new buffer with a unique name at the project
root."
  (interactive "P")
  (unless (require 'vterm nil :noerror)
    (error "Package 'vterm' not found"))
  (let ((project (me/project-root)))
    (if (or argument (not project))
        (vterm)
      (let* ((buffer (format "*vterm: %s*" (me/project-name project)))
             (replace (string= buffer (buffer-name)))
             (buffer (if replace (generate-new-buffer-name buffer) buffer))
             (shackle-rules (if replace shackle-rules
                              `((vterm-mode ,@me/vterm-shackles)))))
        (if (buffer-live-p (get-buffer buffer))
            (pop-to-buffer buffer)
          (let ((default-directory project))
            (vterm buffer)))))))

(use-package git-commit
  :hook
  (git-commit-mode . (lambda () (setq-local fill-column 72))))

(use-package git-gutter-fringe
  :preface
  (defun me/git-gutter-enable ()
    (when-let* ((buffer (buffer-file-name))
                (backend (vc-backend buffer)))
      (require 'git-gutter)
      (require 'git-gutter-fringe)
      (git-gutter-mode 1)))
  :hook
  (after-change-major-mode . me/git-gutter-enable)
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [240] nil nil '(center t))
  (define-fringe-bitmap 'git-gutter-fr:deleted [240 240 240 240] nil nil 'bottom)
  (define-fringe-bitmap 'git-gutter-fr:modified [240] nil nil '(center t)))

(use-package git-modes)

(use-package magit
  :bind
  (:map magit-file-section-map
   ("<return>" . magit-diff-visit-file-other-window)
   :map magit-hunk-section-map
   ("<return>" . magit-diff-visit-file-other-window)
   :map magit-status-mode-map
   ("M-1" . nil)
   ("M-2" . nil)
   ("M-3" . nil)
   ("M-4" . nil))
  :hook
  (magit-post-stage-hook . me/magit-recenter)
  :custom
  (epg-pinentry-mode 'loopback)
  (magit-display-buffer-function
   'magit-display-buffer-same-window-except-diff-v1)
  (magit-diff-highlight-hunk-region-functions
   '(magit-diff-highlight-hunk-region-using-face))
  (magit-diff-refine-hunk 'all)
  (magit-module-sections-nested nil)
  (magit-section-initial-visibility-alist
   '((modules . show) (stashes . show) (unpulled . show) (unpushed . show)))
  :config
  (magit-add-section-hook
   'magit-status-sections-hook
   'magit-insert-modules-overview
   'magit-insert-merge-log)
  (remove-hook 'magit-section-highlight-hook #'magit-section-highlight))

(defun me/magit-recenter ()
  "Recenter the current hunk at 25% from the top of the window."
  (when (magit-section-match 'hunk)
    (let ((top (max 0 scroll-margin (truncate (/ (window-body-height) 4)))))
      (message "%s" top)
      (save-excursion
        (magit-section-goto (magit-current-section))
        (recenter top)))))

(use-package pinentry
  :hook
  (after-init . pinentry-start))

(use-package transient
  :custom
  (transient-default-level 5)
  (transient-mode-line-format nil)
  :init
  (setq-default
   transient-history-file (me/cache-concat "transient/history.el")
   transient-levels-file (me/cache-concat "transient/levels.el")
   transient-values-file (me/cache-concat "transient/values.el")))

(use-package whitespace
  :ensure nil
  :hook
  (prog-mode . whitespace-mode)
  (text-mode . whitespace-mode)
  :custom
  (whitespace-style '(face empty indentation::space tab trailing)))

(use-package eyebrowse
  :bind
  ("M-0" . eyebrowse-last-window-config)
  ("M-1" . me/eyebrowse-switch-1)
  ("M-2" . me/eyebrowse-switch-2)
  ("M-3" . me/eyebrowse-switch-3)
  ("M-4" . me/eyebrowse-switch-4)
  ("M-5" . me/eyebrowse-switch-5)
  ("M-6" . me/eyebrowse-switch-6)
  ("M-7" . me/eyebrowse-switch-7)
  ("M-8" . me/eyebrowse-switch-8)
  ("M-9" . me/eyebrowse-switch-9)
  :hook
  (after-init . eyebrowse-mode)
  :custom
  (eyebrowse-mode-line-left-delimiter "")
  (eyebrowse-mode-line-right-delimiter "")
  (eyebrowse-new-workspace t))

(defun me/eyebrowse-switch (n)
  "Switch to configuration N or to the last visited."
  (if (eq (eyebrowse--get 'current-slot) n)
      (eyebrowse-last-window-config)
    (funcall (intern (format "eyebrowse-switch-to-window-config-%s" n)))))

(dotimes (n 9)
  (let* ((n (1+ n))
         (name (intern (format "me/eyebrowse-switch-%s" n)))
         (documentation (format "Switch to configuration %s or to the last visited." n)))
    (eval `(defun ,name ()
             ,documentation
             (interactive)
             (me/eyebrowse-switch ,n)))))
