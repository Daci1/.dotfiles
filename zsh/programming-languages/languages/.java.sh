export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-14.jdk/Contents/Home

change_java_version() {
	local java_versions_location=/Library/Java/JavaVirtualMachines
	local version=$(ls "$java_versions_location" | fzf)
	if [ "${#version}" -ne 0 ]; then

		local new_first_line="export JAVA_HOME=$java_versions_location/$version/Contents/Home"
		local file_path="$HOME/.config/programming-languages/languages/.java.sh"
		# Read the content of the file into a temporary file
		tmp_file=$(mktemp)
		tail -n +2 "$file_path" > "$tmp_file"

	# Replace the first line with the new content
	echo "$new_first_line" | cat - "$tmp_file" > "$file_path"

	# Remove the temporary file
	rm "$tmp_file"

	source "$file_path"
	fi
}
