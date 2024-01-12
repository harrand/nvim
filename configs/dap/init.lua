local dap = require("dap")

-- ui
require("custom.configs.dap.ui")

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '$USERPROFILE\\.vscode\\extensions\\ms-vscode.cpptools-1.18.5-win32-x64\\debugAdapters\\bin\\OpenDebugAD7.exe',
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
	-- note that program and cwd are empty here. this is because this configuration is blessed and has a __call metatable entry. see below.
    name = "Manual Launch",
    type = "lldb",
    request = "launch",
    program = dap.ABORT,
    cwd = dap.ABORT,
    stopAtEntry = true,
  },
  {
    name = "Last Program",
    type = "lldb",
    request = "launch",
    program = function()
		return dap.cache.last_program or dap.ABORT
    end,
    cwd = function()
		return dap.cache.last_cwd or dap.ABORT
    end,
    stopAtEntry = true,
  },
}

function on_manual_launch(par)
	local cur_cwd = vim.fn.getcwd()
	local prog = vim.fn.input('Path to executable: ', cur_cwd .. '/', 'file')
	local cwd = vim.fn.input('Working Directory: ', cur_cwd .. '/', 'file')
	par.program = prog
	par.cwd = cwd
	if prog ~= cur_cwd then
		-- if prog == cur_cwd then they skipped past the program bit, which is 100% a mistake or they want to early out.
		-- if not, we assume its a valid exe location.
		local new_config = {}
		new_config.name = prog
		new_config.type = "lldb"
		new_config.request = "launch"
		new_config.program = prog
		new_config.cwd = cwd
		dap.cache.last_program = prog
		dap.cache.last_cwd = cwd
		table.insert(dap.configurations.cpp, new_config)

		-- set last-program's config name to indicate what the last prog was.
		dap.configurations.cpp[2].name = "Last Program (" .. dap.cache.last_program .. ")"
	else
		-- user hasn't entered enough valid data. set the config to be abort (meaning nothing runs.)
		par.program = dap.ABORT
		par.cwd = dap.ABORT
	end
	return par
end

setmetatable(dap.configurations.cpp[1], {__call = on_manual_launch})
-- dap.configurations.NvimTree normally means the user accidentally invoked dap-continue when nvimtree was focused. As I'm a C++ developer, I'm gonna assume they're using c++.
dap.configurations.NvimTree = dap.configurations.cpp
