function fish_prompt --description 'Display prompt'

    set -l last_ret $status
    set -l green 5AF78E
    set -l red FF6ABF

    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    set PROMPT ''

    # Add User
    set PROMPT $PROMPT(set_color 888888)' '$USER' '

    # Add hostname
    set PROMPT $PROMPT(set_color 444444)' '$__fish_prompt_hostname' '

    # Add CWD (home|root) with colors
    switch (prompt_pwd)
        case '~*' # If in home, add a nice colored ~
            set PROMPT $PROMPT(set_color 0087af)' ~ '

        case '*' # If not in home, probably in or somewhere below /, add a nice colored /
            set PROMPT $PROMPT(set_color afa700)' / '
    end

    # Add the rest of the CWD
    if test (prompt_pwd | sed -e 's/^~//' -e 's:/::g') != ''
        set PROMPT $PROMPT(set_color 888888)(prompt_pwd | sed -e 's/^~//' -e 's:/: :g')' '
    end

    # Add colors depending on if previous command was successful or not
    if test $last_ret = 0
        set PROMPT $PROMPT(set_color --bold $green)
    else
        set PROMPT $PROMPT(set_color --bold $red)
    end

    # Add sign at end of prompt depending on user
    if test (id -u) -eq 0
        set PROMPT $PROMPT' # '
    else
        set PROMPT $PROMPT' $ '
    end

    # Print prompt, also reset color and put an extra space there
    builtin echo -ns $PROMPT (set_color normal) ' '
end
