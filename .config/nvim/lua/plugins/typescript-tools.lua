return {
  -- Disable LazyVim's default TS server to avoid conflict
  { "neovim/nvim-lspconfig", opts = { servers = { vtsls = { enabled = false } } } },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {},
  },
}
