local exclude_file = vim.fn.stdpath("config") .. "/.state/excluded_projects"

local function load_excluded()
  local f = io.open(exclude_file, "r")
  if not f then return {} end
  local set = {}
  for line in f:lines() do
    if line ~= "" then set[line] = true end
  end
  f:close()
  return set
end

local function save_excluded(set)
  vim.fn.mkdir(vim.fn.fnamemodify(exclude_file, ":h"), "p")
  local f = io.open(exclude_file, "w")
  if not f then return end
  for path in pairs(set) do f:write(path .. "\n") end
  f:close()
end

return {
  "snacks.nvim",
  opts = function(_, opts)
    opts.picker = opts.picker or {}
    opts.picker.sources = opts.picker.sources or {}
    opts.picker.sources.projects = {
      dev = { "~/Documents", "~/dev", "~/projects" },
      patterns = { ".git", "package.json", "Makefile", "pyproject.toml", "Cargo.toml" },
      transform = function(item)
        local excluded = load_excluded()
        if excluded[item.file] then return false end
        return item
      end,
      win = {
        input = {
          keys = {
            ["<c-d>"] = { "remove_project", mode = { "n", "i" } },
          },
        },
      },
      actions = {
        remove_project = function(picker)
          local item = picker:current()
          if not item then return end
          local excluded = load_excluded()
          excluded[item.file] = true
          save_excluded(excluded)
          Snacks.notify("Removed: " .. item.file)
          picker:find({ refresh = true })
        end,
      },
    }
  end,
  keys = {
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
  },
}
