if status is-interactive
    # Commands to run in interactive sessions can go here
end

function on_cd --on-variable PWD
  status --is-command-substitution; and return
  load-nvmrc
  load-tfenv
end

function find_file
    # Start at current directory
    set file_name $argv[1]
    set dir (pwd)
    while test "$dir" != "/"
        if test -f "$dir/$file_name"
            echo "$dir/$file_name"
            return 0
        end
        set dir (dirname $dir)
    end
    return 1
end

function load-nvmrc
    set nvmrc_path (find_file '.nvmrc')
    set node_version (node --version)
    set major_version (string replace -r '^v([0-9]+).*' '$1' $nvm_current_version)
    if test -n "$nvmrc_path"
        set nvmrc_node_version (cat $nvmrc_path)
        if test "$nvmrc_node_version" != "$node_version" ; and test "$nvmrc_node_version" != "$major_version"
            nvm install
        end
    else if test "$node_version" != "$nvm_default_version"
        echo "Reverting to nvm default version"
        nvm use $nvm_default_version
    end
end

function load-tfenv
    set terraform_version_path (find_file '.terraform-version')
    if test -n "$terraform_version_path"
        set tfenv_version (cat $terraform_version_path)
        set current_version (terraform version | head -n1 | awk '{print $2}')

        # Remove 'v' prefix if present
        set current_version (string replace -r '^v' '' $current_version)

        if test "$tfenv_version" != "$current_version"
            tfenv use
        end
    end
end


# Add user custom binaries to PATH variable
set -gx PATH /opt/homebrew/bin $PATH
set -gx GOPATH $HOME/go
set -gx PATH /Users/dacianbarbu/bin $PATH
set -gx PATH $PATH $GOPATH/bin
set -gx PATH $PATH /opt/homebrew/bin/go
set -gx GO111MODULE on
set -gx PATH /Applications/IntelliJ\ IDEA.app/Contents/MacOS $PATH

# Remove greeting message
set fish_greeting

load-nvmrc
load-tfenv

oh-my-posh init fish --config ~/.config/oh-my-posh/daci-custom.toml | source

