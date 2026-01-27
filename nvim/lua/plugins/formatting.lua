-- Disable auto-format on save, enable manual formatting only
return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Disable format on save
      format_on_save = false,
      format_after_save = false,
    },
  },
}
