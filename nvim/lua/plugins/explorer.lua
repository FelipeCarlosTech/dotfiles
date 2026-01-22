-- File finder settings
return {
  -- Snacks.nvim: Show hidden files in file picker (leader+leader)
  -- LazyVim 14.x uses snacks by default instead of telescope
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
          },
        },
      },
    },
  },

  -- Telescope: Show hidden files (fallback if used)
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { "^.git/" },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = { "--hidden" },
        },
      },
    },
  },
}
