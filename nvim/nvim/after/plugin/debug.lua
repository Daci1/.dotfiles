local dap = require "dap"
local dapui = require("dapui")
local dapView = require("dap-view")
require("dap-go").setup()

dapView.setup({
  winbar = {
    default_section = "scopes",
    controls = {
      enabled = true,
    },
  },
  windows = {
      size = 0.25,
      position = "below",
      terminal = {
          size = 0.5,
          position = "right",
      },
  }
})

dapui.setup({
  expand_lines = true,
  floating = { border = "rounded" },
  render = {
    max_type_length = 0,
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 1.0 },
      },
      size = 15, 
      position = "bottom",
    },
  },
})

local last_code_win = vim.api.nvim_get_current_win()

vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', numhl='DapBreakpoint' })
-- fixes all breakpoints getting highlighted as rejected (might cause problems but for now whatever does the trick i guess)
vim.fn.sign_define('DapBreakpointRejected', {text = '', texthl = 'DapBreakpoint', numhl='DapBreakpoint'})

vim.keymap.set("n", "<leader>dt", dapView.toggle, {noremap=true})
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>dw', '<cmd>DapViewWatch<CR>', { desc = 'Add variable to watch' })
vim.keymap.set("n", "<leader>?", function() 
	dapui.eval(nil, { enter = true })
end)
vim.keymap.set("n", '<F1>', dap.continue)


dap.listeners.before.attach.dapui_config = function()
    dapView.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapView.open()
end
dap.listeners.after.event_stopped["custom_jump"] = function(session, body)
  if vim.api.nvim_win_is_valid(last_code_win) then
    vim.api.nvim_set_current_win(last_code_win)
  end
end
-- dap.listeners.before.event_terminated.dapui_config = function()
--     dapui.close()
-- end
-- dap.listeners.before.event_exited.dapui_config = function()
--     dapui.close()
-- end

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
          local first_arg = args:child(1) -- first argument of the call

          if first_arg then
            local text = vim.treesitter.get_node_text(first_arg, 0)
            -- remove quotes
            text = text:gsub("^[`'\"]", ""):gsub("[`'\"]$", "")
            -- replace ${...} with .*
            text = text:gsub("%${.-}", ".*")
            return text
          end
        end
      end
    end

    node = node:parent()
  end

  return nil
end

local function get_jest_runtime_args(run_file_only)
    local fname = vim.fn.expand("%") -- current file

    -- Determine which Jest config to use
    local jest_config = "jest.unit.config.ts"
    if fname:match("integration%.test%.ts$") then
        jest_config = "jest.integration.config.ts"
    end

    local args = {
        fname,
        "--runInBand",
        "--config", jest_config,
    }

    -- Only get nearest test name if we're not running the whole file
    if not run_file_only then
        local test_name = get_nearest_test_name() or ""
        if test_name ~= "" then
            table.insert(args, "--testNamePattern=" .. test_name)
        end
    end

    print("Running Jest with args:", table.concat(args, " "))
    return args
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
      type = "pwa-node",
      request = "launch",
      name = "Debug Nearest Jest Test",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "${workspaceFolder}/node_modules/.bin/jest",
      runtimeArgs = function()
          return get_jest_runtime_args(false)
      end,
      console = "externalTerminal",
      env = {
          NODE_OPTIONS = "--experimental-vm-modules",
      },
      sourceMaps = true,
  })

  table.insert(dap.configurations[language], {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest File",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "${workspaceFolder}/node_modules/.bin/jest",
      runtimeArgs = function()
          return get_jest_runtime_args(true)
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
