return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Esto hace que los filtros de ocultar se ignoren por defecto
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}
