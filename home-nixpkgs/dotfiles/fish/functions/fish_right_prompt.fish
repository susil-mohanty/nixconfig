function fish_right_prompt --description 'Display right prompt'

	set PROMPT (set_color 777777)" "(date +%H:%M:%S)" "


    if test "$IN_NIX_SHELL" = "pure"
        set PROMPT (set_color 519F50)" ❄ "$PROMPT
    else if test "$IN_NIX_SHELL" = "impure"
        set PROMPT (set_color FBB829)" ❄ "$PROMPT
    end

    set git_prompt (__fish_git_prompt ' %s ')
    if test $status = 0
        set PROMPT (set_color 777777)$git_prompt$PROMPT
    end

    if set -q VIRTUAL_ENV
        set PROMPT (set_color 458588)" "(basename "$VIRTUAL_ENV")" "$PROMPT
    end

    if test "$CMD_DURATION" != 0
        set PROMPT (set_color 777777)" "(echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')" "$PROMPT
    end

    builtin echo -ns $PROMPT(set_color normal)
end
