function ed
    emacsclient -c $argv &
    disown
end
