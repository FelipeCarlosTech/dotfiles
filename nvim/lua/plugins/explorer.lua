-- Snacks.nvim configuration (explorer + file picker)
-- LazyVim uses snacks.nvim by default for both sidebar and file finder
return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        -- Sidebar file explorer (leader+e)
        hidden = true, -- Show hidden files (.env, .gitignore, etc)
        ignored = false, -- Show git ignored files
      },
      picker = {
        -- File finder (leader+leader, leader+ff)
        sources = {
          files = {
            hidden = true,
            ignored = false,
          },
          explorer = {
            hidden = true,
            ignored = false,
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
