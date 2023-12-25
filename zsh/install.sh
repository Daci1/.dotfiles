current_folder=$(dirname "$(readlink -f "$0")")
cp -r "$current_folder/programming-languages" $HOME/.config/programming-languages 

echo "source \${HOME}/.config/programming-languages/languages.sh" >> $HOME/.zshrc
