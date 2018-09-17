;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
(add-hook 'js2-mode-hook #'prettier-js-mode)
(add-hook 'typescript-mode-hook #'prettier-js-mode)

(setq mocha-snippets-use-fat-arrows t)
;; coulnd't get this to work yet
;; (with-eval-after-load 'flycheck
;;  (flycheck-jest-setup))

;; fish creates problems with indium does't seem to have desired effect
;; (setq-default explicit-shell-file-name "/run/current-system/sw/bin/bash")
;; (setenv "SHELL" "/run/current-system/sw/bin/bash")
