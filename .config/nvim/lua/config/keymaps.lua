-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Ctrl+L in normal mode of terminal buffer: enter terminal mode and clear
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    vim.keymap.set("n", "<C-l>", function()
      vim.cmd("startinsert")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n", false)
    end, { buffer = args.buf, desc = "Clear terminal" })
  end,
})

vim.keymap.set("n", "<leader>cR", function()
  Snacks.rename.rename_file({
    on_rename = function()
      vim.cmd("silent! wa")
    end,
  })
end, { desc = "Rename File + Save imports" })
