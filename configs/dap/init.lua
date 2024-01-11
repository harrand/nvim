local dap = require("dap")

-- ui
require("custom.configs.dap.ui")

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = 'C:\\Users\\Harry\\.vscode\\extensions\\ms-vscode.cpptools-1.18.5-win32-x64\\debugAdapters\\bin\\OpenDebugAD7.exe',
  options = {
    detached = false
  }
}

dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode',
  name = 'lldb'
}

-- cache data for re-running last program
dap.cache = {}
dap.cache.last_program = nil
dap.cache.last_cwd = nil

dap.configurations.cpp = {
  {
    name = "Manual Launch",
    type = "lldb",
    request = "launch",
    program = function()
		local prog = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		dap.cache.last_program = prog
		return prog
    end,
    cwd = function()
		local cwd = vim.fn.input('Working Directory: ', vim.fn.getcwd() .. '/', 'file')
		dap.cache.last_cwd = cwd
		return cwd
    end,
    stopAtEntry = true,
  },
  {
    name = "Last Program",
    type = "lldb",
    request = "launch",
    program = function()
		return dap.cache.last_program
    end,
    cwd = function()
		return dap.cache.last_cwd
    end,
    stopAtEntry = true,
  },
}
