require('copilot').setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 300,
    keymap = {
        accept = "<C-l>",
        
    }
  }
})
require('avante_lib').load()
require('avante').setup({
  provider = "copilot",
  mode = "legacy",
})

-- User command to reset local state of avante
-- useful when apply code doesn't work
local function avante_reset()
  local path = vim.fn.expand("~/.local/state/nvim/avante")
  if vim.fn.isdirectory(path) == 1 then
    vim.fn.delete(path, "rf")  -- "rf" = recursive + force
    print("Avante directory reset!")
  else
    print("Avante directory does not exist.")
  end
end

-- Create a custom command that calls this function
vim.api.nvim_create_user_command("AvanteReset", avante_reset, {})
