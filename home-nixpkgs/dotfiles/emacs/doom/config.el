;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
(add-hook 'js2-mode-hook #'prettier-js-mode)
(add-hook 'typescript-mode-hook #'prettier-js-mode)
(add-hook 'python-mode-hook 'blacken-mode)

(setq org-journal-dir "~/Dropbox/jrn")
(setq org-journal-date-format "%Y-%m-%d %A")
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
