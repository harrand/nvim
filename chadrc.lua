---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")
local overrides = require("custom.configs.overrides")

M.plugins = "custom.plugins"

M.ui = overrides.ui

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
