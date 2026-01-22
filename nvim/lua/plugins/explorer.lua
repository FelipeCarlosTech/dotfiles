-- File explorer and finder settings
return {
  -- Neo-tree: Show hidden files by default
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false, -- When false, hidden files are completely shown (not dimmed)
          hide_dotfiles = false, -- Show dotfiles (.gitignore, .env, etc)
          hide_gitignored = false, -- Show git ignored files
          hide_hidden = false, -- Show hidden files (Windows attribute)
          hide_by_name = {
            ".DS_Store",
          },
          never_show = {
            ".DS_Store",
          },
        },
      },
    },
  },

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
