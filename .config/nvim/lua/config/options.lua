-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.autowrite = true
vim.opt.wrap = true
vim.opt.linebreak = true -- wrap at word boundary, not mid-word
vim.opt.breakindent = true -- wrapped lines keep indentation

-- Use blank space instead of diagonal hatching for diff filler lines
vim.opt.fillchars:append({ diff = " " })

-- Show absolute AND relative line numbers side-by-side
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.opt.statuscolumn = "%s%=%{v:lnum} %{v:relnum} "
  end,
})

-- Start listening on socket for MCP server integration
if not vim.env.NVIM then
  pcall(vim.fn.serverstart, "/tmp/nvim")
end
