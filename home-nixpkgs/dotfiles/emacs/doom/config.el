;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

(setq org-directory "~/org/my")
(setq org-default-notes-file "notes.org")
(setq org-journal-dir "~/Dropbox/jrn")
(setq org-journal-date-format "%Y-%m-%d %A")
(setq org-agenda-files (quote ("~/org/my")))
(setq evil-escape-key-sequence "hh")

(setq mocha-snippets-use-fat-arrows t)

(add-hook 'js2-mode-hook #'prettier-js-mode)
(add-hook 'typescript-mode-hook #'prettier-js-mode)
(add-hook 'python-mode-hook 'blacken-mode)

(load-theme 'doom-dracula t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)
(doom-themes-treemacs-config)

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

(require 'evil-easymotion)
(evilem-make-motion
 evilem-motion-forward-WORD-begin #'evil-forward-WORD-begin)
(evilem-make-motion
 evilem-motion-backward-WORD-begin #'evil-backward-WORD-begin)

;; Prevent +write-mode from causing variable pitch fonts in all buffers.
(defun fix-solaire-mode ()
  (mixed-pitch-mode -1)
  (solaire-mode -1)
  (solaire-mode +1)
  (mixed-pitch-mode +1))
(add-hook 'org-mode-hook #'fix-solaire-mode)

(add-hook 'after-save-hook 'magit-after-save-refresh-status)
(require 'org-protocol)

