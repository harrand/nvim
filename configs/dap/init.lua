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

dap.configurations.cpp = {
  {
    name = "Manual Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = function()
      return vim.fn.input('Working Directory: ', vim.fn.getcwd() .. '/', 'file')
    end,
    stopAtEntry = true,
  },
}