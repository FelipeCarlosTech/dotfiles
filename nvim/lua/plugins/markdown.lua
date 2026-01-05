-- Markdown preview and rendering
return {
  -- render-markdown.nvim - Modern markdown rendering in Neovim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      preset = "lazy", -- Use LazyVim optimized preset
      file_types = { "markdown", "norg", "rmd", "org" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- Toggle markdown rendering with <leader>um
      vim.keymap.set("n", "<leader>um", function()
        require("render-markdown").toggle()
      end, { desc = "Toggle Markdown Rendering" })
    end,
  },

  -- markdown-preview.nvim - Browser preview (comes with LazyVim)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview in Browser",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
