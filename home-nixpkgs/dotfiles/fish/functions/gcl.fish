function gcl
	set -l repo $argv
	mkdir -p ~/r/(dirname $repo)
    git clone git@github.com:$repo ~/r/$repo
end
