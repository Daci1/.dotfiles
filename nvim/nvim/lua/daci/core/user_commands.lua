vim.api.nvim_create_user_command("AwsLogin", function()
	-- Run aws-sso-util login
	vim.fn.system("aws-sso-util login")

	-- Check if command succeeded
	if vim.v.shell_error ~= 0 then
		print("AWS SSO login failed")
		return
	end

	print("AWS SSO login complete.")
end, {})
