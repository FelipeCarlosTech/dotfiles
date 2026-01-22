-- File explorer and finder settings
return {
  -- Neo-tree: Show hidden files by default
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- Show hidden files
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },

  -- Telescope: Show hidden files in file finder
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { ".git/" },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    },
  },
}
