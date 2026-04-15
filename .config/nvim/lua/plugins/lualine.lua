return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local icons = LazyVim.config.icons

    -- filesize helper
    local function filesize()
      local file = vim.fn.expand("%:p")
      if file == nil or #file == 0 then return "" end
      local size = vim.fn.getfsize(file)
      if size <= 0 then return "" end
      local suffixes = { "B", "k", "M", "G" }
      local i = 1
      while size > 1024 and i < #suffixes do
        size = size / 1024
        i = i + 1
      end
      return string.format(i == 1 and "%d%s" or "%.1f%s", size, suffixes[i])
    end

    opts.options = vim.tbl_extend("force", opts.options or {}, {
      theme = "auto",
      globalstatus = true,
      component_separators = { left = "│", right = "│" },
      section_separators = { left = "", right = "" },
    })

    opts.sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(str) return "▌ " .. str end,
          color = { fg = "#7aa2f7", bg = "#1a1b26", gui = "bold" },
          padding = { left = 0, right = 1 },
        },
      },

      lualine_b = {
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path() },
      },

      lualine_c = {},

      lualine_x = {
        -- noice command status
        {
          function() return require("noice").api.status.command.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          color = function() return { fg = Snacks.util.color("Statement") } end,
        },
        -- noice mode status (recording macros, etc.)
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = function() return { fg = Snacks.util.color("Constant") } end,
        },
        -- lazy updates
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = function() return { fg = Snacks.util.color("Special") } end,
        },
        { filesize, color = { fg = "#565f89" } },
        -- modified indicator + filename
        {
          function()
            if vim.bo.modified then return "✏ " .. vim.fn.expand("%:t") end
            return ""
          end,
          color = { fg = "#e0af68" },
        },
        -- git diff with ⊕/⊖/□ symbols
        {
          "diff",
          symbols = {
            added = "⊕ ",
            modified = "□ ",
            removed = "⊖ ",
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
      },

      lualine_y = {
        { "location", padding = { left = 1, right = 0 } },
        { "progress", separator = " ", padding = { left = 0, right = 1 } },
        { "encoding", color = { fg = "#565f89" } },
      },

      lualine_z = {
        { "branch", icon = "ψ" },
      },
    }

    return opts
  end,
}
