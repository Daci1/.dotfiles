local dap = require "dap"
local dapui = require "dapui"
-- require("dapui").setup()
dapui.setup()
require("dap-go").setup()

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
-- dap.listeners.before.event_terminated.dapui_config = function()
--     dapui.close()
-- end
-- dap.listeners.before.event_exited.dapui_config = function()
--     dapui.close()
-- end

-- require("dap-vscode-js").setup({
--     debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
--     adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
-- })

local function get_nearest_test_name()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()

  while node do
    if node:type() == "call_expression" then
      local fn_node = node:child(0)

      local name = nil

      -- Case 1: plain it() / describe() / test()
      if fn_node:type() == "identifier" then
        name = vim.treesitter.get_node_text(fn_node, 0)

      -- Case 2: it.each() / describe.each() / test.each()
      elseif fn_node:type() == "member_expression" then
        local object = fn_node:child(0)
        if object then
          name = vim.treesitter.get_node_text(object, 0)
        end
      end

      if name == "it" or name == "test" or name == "describe" then
        local args = node:child(1)
        if args then
          -- for .each, the real test name is inside the NEXT call
          -- so we need to dive one level deeper
          local first_arg = args:child(1)

          if first_arg then
            local text = vim.treesitter.get_node_text(first_arg, 0)
            return text:gsub("^['\"]", ""):gsub("['\"]$", "")
          end
        end
      end
    end

    node = node:parent()
  end

  return nil
end

local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "typescriptreact",
}

for _,language in ipairs(js_based_languages) do
  dap.configurations[language] = dap.configurations[language] or {}

  -- Launch configuration
  table.insert(dap.configurations[language], {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
  })

  -- Attach configuration with dynamic process picker
  table.insert(dap.configurations[language], {
    type = "pwa-node",
    request = "attach",
    name = "Attach to process",
    processId = require("dap.utils").pick_process, -- pick running Node/TS process
    cwd = "${workspaceFolder}",
    sourceMaps = true,
  })

  table.insert(dap.configurations[language], {
    type = "pwa-node",
    request = "launch",
    name = "Launch via npm",
    runtimeExecutable = "npm",
    runtimeArgs = { "run", "dev" }, 
    cwd = "${workspaceFolder}",
    sourceMaps = true,
  })

  table.insert(dap.configurations[language], {
      type = "pwa-node",                -- DAP type for Node.js
      request = "launch",               -- launch or attach
      name = "Debug offline:ci",        -- friendly name
      runtimeExecutable = "npm",        -- use npm
      runtimeArgs = { "run", "offline:ci" }, -- npm script to run
      cwd = "${workspaceFolder}",       -- working directory
      console = "externalTerminal",  -- optional, if supported
      -- internalConsoleOptions = "neverOpen", -- optional
      -- env = {
      --     NODE_ENV = "development",        -- environment variables
      --     DACI_TEST = "test"
      -- },
      sourceMaps = true                 -- enable source maps
  })

  table.insert(dap.configurations[language], {
      type = "pwa-node",                -- DAP type for Node.js
      request = "launch",               -- launch or attach
      name = "Debug neaerest",        -- friendly name
      runtimeExecutable = "${workspaceFolder}/node_modules/.bin/jest",        -- use npm
      runtimeArgs = {
          "${file}",
          "--runInBand",
          "--config", "jest.unit.config.ts",
          "--testNamePattern=^PatchAssignmentService unit tests Patch assignment cases without compensation Given status is updated from .* to COMPLETED calls expected methods and returns something$",
      }, -- npm script to run
      cwd = "${workspaceFolder}",       -- working directory
      console = "externalTerminal",  -- optional, if supported
      -- internalConsoleOptions = "neverOpen", -- optional
      env = {
        NODE_OPTIONS = "--experimental-vm-modules",
      },
      sourceMaps = true                 -- enable source maps
  })

  table.insert(dap.configurations[language], {
      type = "pwa-node",
      request = "launch",
      name = "Debug Nearest Jest Test",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "${workspaceFolder}/node_modules/.bin/jest",
      runtimeArgs = function()
          local fname = vim.fn.expand("%") -- current file
          local test_name = get_nearest_test_name() or ""
          print(test_name)
          return {
              fname,
              "--runInBand",
              "--config", "jest.unit.config.ts",
              "--testNamePattern=" .. test_name,
          }
      end,
      console = "externalTerminal",
      env = {
          NODE_OPTIONS = "--experimental-vm-modules",
      },
      sourceMaps = true,
  })


end

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node", -- Node binary
    args = {
      -- vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/out/src/vsDebugServer.js"),
      vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/dist/src/dapDebugServer.js"),
      "${port}",
    },
  },
}
