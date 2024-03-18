return {
        "nvim-lualine/lualine.nvim",
        commit = "3c55675a7bc170d21d7ea70874ae66fbf5cfb0dc",
        dependencies = {
                "nvim-tree/nvim-web-devicons"
        },
        config = function()
                local lualine = require("lualine")

                lualine.setup({
                        options = {
                                icons_enabled = true,
                                theme = "catppuccin",
                        },
                })
        end
}
