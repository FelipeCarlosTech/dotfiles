return {
  -- Ayu Dark theme
  { "Shatur/neovim-ayu" },

  -- Configure LazyVim to load ayu-dark
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ayu-dark",
    },
  },

  -- BACKUP: Nightfox/Carbonfox theme (descomenta para volver)
  -- { "EdenEast/nightfox.nvim" },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "carbonfox",
  --   },
  -- },
}
