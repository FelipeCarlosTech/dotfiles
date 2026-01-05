-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.scrolloff = 8
opt.linebreak = true

-- Spell checker con inglés y español
opt.spelllang = { "en", "es" }
