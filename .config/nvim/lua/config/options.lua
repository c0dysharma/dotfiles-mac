-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.autowrite = true

-- Use blank space instead of diagonal hatching for diff filler lines
vim.opt.fillchars:append({ diff = " " })

-- Start listening on socket for MCP server integration
if not vim.env.NVIM then
  pcall(vim.fn.serverstart, "/tmp/nvim")
end


