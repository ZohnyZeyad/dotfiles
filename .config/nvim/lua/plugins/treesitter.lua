return {
  "nvim-treesitter/nvim-treesitter",
  name = "treesitter",
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "vim", "vimdoc", "lua",
        "java", "scala",
        "json", "yaml", "xml", "toml", "tmux",
        "dockerfile", "terraform",
        "query", "sql",
        "markdown", "markdown_inline",
        "git_rebase", "diff", "gitcommit", "gitignore",
        "regex",
      },

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
      auto_install = true,
      sync_install = false,

      ignore_install = {},
      indent = { enable = true },

      highlight = {
        enable = true,
        use_languagetree = true,

        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        additional_vim_regex_highlighting = { "markdown" },
      },
    })
  end
}
