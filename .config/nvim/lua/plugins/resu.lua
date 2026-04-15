return {
  {
    "koushikxd/resu.nvim",
    dependencies = {
      "sindrets/diffview.nvim",
    },
    config = function()
      require("resu").setup({
        use_diffview = false, -- disabled to use mini.diff for inline diff overlay
      })
    end,
  },
}
