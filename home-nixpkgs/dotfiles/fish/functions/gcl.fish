function gcl
	set -l repo $argv
    set -l checkout_dir ~/r/$repo
	mkdir -p ~/r/(dirname $repo)
    git clone git@github.com:$repo $checkout_dir
    cd $checkout_dir
    ls
    echo Done!
end
