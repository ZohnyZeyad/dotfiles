return {
  "eatgrass/maven.nvim",
  cmd = { "Maven", "MavenExec" },
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    require('maven').setup({
      executable = "./mvnw",
      commands = {
        { cmd = { "clean", "compile" }, desc = "clean then compile" },
        { cmd = { "clean", "package" }, desc = "clean then package" },
        { cmd = { "clean", "install" }, desc = "clean then install" },
      },
    })
  end
}
