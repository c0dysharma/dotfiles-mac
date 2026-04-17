-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Clean up stale [No Name] buffers left by claudecode.nvim diff tabs
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("cleanup_noname_buffers", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" and not vim.bo[buf].modified and vim.bo[buf].buftype == "" then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      if #lines <= 1 and (lines[1] or "") == "" then
        vim.bo[buf].bufhidden = "wipe"
      end
    end
  end,
})

