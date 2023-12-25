current_folder=$(dirname "$(readlink -f "$0")")
cp -r "$current_folder"/binaries/* $HOME/bin

echo "#Adds user custom binaries to PATH variable \n export PATH="\${HOME}/bin:\${PATH}"" >> $HOME/.zshrc

