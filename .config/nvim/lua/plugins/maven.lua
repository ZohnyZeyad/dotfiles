return {
  "eatgrass/maven.nvim",
  cmd = { "Maven", "MavenExec" },
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    require('maven').setup({
      executable = "./mvnw",
      commands = {
        { cmd = { "clean", "package" }, desc = "clean then package" },
        { cmd = { "clean", "build" },   desc = "clean then build" },
        { cmd = { "clean", "install" }, desc = "clean then install" },
      },
    })
  end
}
