return {
  "snacks.nvim",
  opts = {
    terminal = {
      win = {
        keys = {
          -- Disable LazyVim's <C-l> = "Go to Right Window" in terminal mode
          -- so Ctrl+L passes through to shell for clear
          nav_l = false,
        },
      },
    },
  },
}
