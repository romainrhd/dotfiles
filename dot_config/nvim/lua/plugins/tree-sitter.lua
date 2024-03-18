return {
        "nvim-treesitter/nvim-treesitter",
        tag = "v0.9.2",
        main = "nvim-treesitter.configs",
        opts = {
                ensure_installed = {
                        "css",
                        "html",
                        "javascript",
                        "lua",
                        "php",
                        "typescript",
                        "tsx",
                        "vue",
                        "yaml"
                },
                auto_install = true,
                highlight = {
                        enable = true,
                }
        },
}
