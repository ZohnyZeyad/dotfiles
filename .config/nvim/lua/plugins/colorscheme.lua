function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
end

return {

    -- {
    --     "Mofiqul/dracula.nvim",
    -- },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
--                disable_background = true,
                styles = {
                    italic = false,
                },
            })
            ColorMyPencils()
        end
    },

}
