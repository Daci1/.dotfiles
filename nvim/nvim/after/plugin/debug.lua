local dap = require "dap"
local dapui = require "dapui"
-- require("dapui").setup()
dapui.setup()
require("dap-go").setup()
require("nvim-dap-virtual-text").setup()

vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', numhl='DapBreakpoint' })
-- fixes all breakpoints getting highlighted as rejected (might cause problems but for now whatever does the trick i guess)
vim.fn.sign_define('DapBreakpointRejected', {text = '', texthl = 'DapBreakpoint', numhl='DapBreakpoint'})

vim.keymap.set("n", "<leader>dt", dapui.toggle, {noremap=true})
vim.keymap.set("n", "<leader>dr", function() dapui.open({reset=true}) end, {noremap=true})
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>?", function() 
	dapui.eval(nil, { enter = true })
end)
vim.keymap.set("n", '<F1>', dap.continue)


dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

