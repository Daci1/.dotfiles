if vim.v.servername ~= "" then
    vim.fn.setenv("NVIM_LISTEN_ADDRESS", vim.v.servername)
end
