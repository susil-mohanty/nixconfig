set -e fish_greeting
set -gx EDITOR nvim
set -gx LESS '-R'

set -gx SSH_AUTH_SOCK {$XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh

eval (direnv hook fish)
