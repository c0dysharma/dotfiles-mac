-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Force transparent bg on all relevant highlight groups (terminal, floats, etc.)
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("force_transparent", { clear = true }),
  callback = function()
    local groups = {
      "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
      "SignColumn", "EndOfBuffer", "TabLine", "TabLineFill",
      "SnacksDashboard", "SnacksDashboardNormal", "SnacksTerminal",
      "NeoTreeNormal", "NeoTreeNormalNC",
      "WhichKey", "WhichKeyFloat",
    }
    for _, g in ipairs(groups) do
      vim.api.nvim_set_hl(0, g, { bg = "NONE" })
    end
  end,
})

-- Trigger on startup too
vim.schedule(function()
  vim.cmd("doautocmd ColorScheme")
end)

-- Persist terminal height across sessions
local state_dir = vim.fn.stdpath("config") .. "/.state"
vim.fn.mkdir(state_dir, "p")
local term_state = state_dir .. "/term_height"
local function read_height()
  local f = io.open(term_state, "r")
  if not f then return nil end
  local h = tonumber(f:read("*a"))
  f:close()
  return h
end
local function write_height(h)
  local f = io.open(term_state, "w")
  if f then f:write(tostring(h)); f:close() end
end

vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("persist_term_height", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "terminal" then return end
    local h = read_height()
    if h and h > 0 then
      vim.defer_fn(function()
        local win = vim.fn.bufwinid(args.buf)
        if win ~= -1 and vim.api.nvim_win_is_valid(win) then
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative == "" then
            vim.api.nvim_win_set_height(win, h)
          end
        end
      end, 50)
    end
  end,
})

vim.api.nvim_create_autocmd("WinResized", {
  group = "persist_term_height",
  callback = function()
    for _, win in ipairs(vim.v.event.windows or {}) do
      if vim.api.nvim_win_is_valid(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "terminal" then
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative == "" then
            write_height(vim.api.nvim_win_get_height(win))
          end
        end
      end
    end
  end,
})

-- If terminal becomes only window, open blank buffer above so terminal doesn't fullscreen
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("keep_term_split", { clear = true }),
  callback = function()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    if #wins ~= 1 then return end
    local buf = vim.api.nvim_win_get_buf(wins[1])
    if vim.bo[buf].buftype ~= "terminal" then return end
    local term_win = wins[1]
    local saved_h = read_height() or 15
    vim.schedule(function()
      if not vim.api.nvim_win_is_valid(term_win) then return end
      vim.cmd("aboveleft new")
      local term_win_after = vim.fn.bufwinid(buf)
      if term_win_after ~= -1 then
        vim.api.nvim_win_set_height(term_win_after, saved_h)
      end
    end)
  end,
})

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

