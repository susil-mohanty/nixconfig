;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
(add-hook 'js2-mode-hook #'prettier-js-mode)
(add-hook 'typescript-mode-hook #'prettier-js-mode)
(add-hook 'python-mode-hook 'blacken-mode)

(setq org-journal-dir "~/Dropbox/jrn")
(setq org-journal-date-format "%Y-%m-%d %A")
(setq org-agenda-files (quote ("~/org/my")))

(setq mocha-snippets-use-fat-arrows t)
;; coulnd't get this to work yet
;; (with-eval-after-load 'flycheck
;;  (flycheck-jest-setup))

;; fish creates problems with indium does't seem to have desired effect
;; (setq-default explicit-shell-file-name "/run/current-system/sw/bin/bash")
;; (setenv "SHELL" "/run/current-system/sw/bin/bash")

(direnv-mode)

(set! :irc "chat.freenode.net"
    `(:tls t
      :nick "sveitser"
      :port 6697
      :sasl-username ,(+pass-get-user "freenode.net/sveitser@gmail.com")
      :sasl-password (lambda (&rest _) (+pass-get-secret "freenode.net/sveitser@gmail.com"))
      :channels ("#nixos")))


;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

(load-theme 'doom-dracula t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)
(doom-themes-treemacs-config)

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

(setq mocha-which-node "node")
(load! "local/jest")
(after! mocha
  (set-popup-rule! "^\\*mocha tests*"
                   :side 'right
                   :size 140
                   :select nil
                   :quit nil
                   :ttl t))

(setq evil-escape-key-sequence "hh")

(require 'lsp)
(require 'lsp-clients)
(add-hook 'js2-mode-hook #'lsp)
(add-hook 'python-mode 'lsp)

(load "~/r/pavpanchekha/keylogger.el/keylogger.el")
(setq keylogger-filename "~/r/pavpanchekha/keylogger.el/keys.el")
(keylogger-load)
(keylogger-start)
(keylogger-autosave)
