return {
        "williamboman/mason.nvim",
        dependencies = {
                "williamboman/mason-lspconfig.nvim",
                "neovim/nvim-lspconfig",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path",
                { "hrsh7th/nvim-cmp", commit = "04e0ca376d6abdbfc8b52180f8ea236cbfddf782" },
                { "L3MON4D3/LuaSnip", tag = "v2.2.0" },
        },
        config = function()
                -- Serveurs par défaut
                local servers_list = {
                        "cssls",
                        "html",
                        "jsonls",
                        "lua_ls",
                        "phpactor",
                        "tailwindcss",
                        "tsserver",
                        "volar",
                        "yamlls",
                }

                require("mason").setup()
                require("mason-lspconfig").setup({
                        ensure_installed = servers_list,
                })
                local lsp_config = require("lspconfig")
                local cmp = require("cmp")
                local capabilities = require("cmp_nvim_lsp").default_capabilities()
                local luasnip = require("luasnip")

                -- Configuration du moteur de completion
                cmp.setup({
                        snippet = {
                                expand = function(args)
                                        luasnip.lsp_expand(args.body)
                                end,
                        },
                        window = {
                                completion = cmp.config.window.bordered(),
                                documentation = cmp.config.window.bordered(),
                        },
                        mapping = cmp.mapping.preset.insert({
                                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                                ["<C-Space>"] = cmp.mapping.complete(),
                                ["<C-e>"] = cmp.mapping.abort(),
                                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                                ["<Tab>"] = cmp.mapping(function(fallback)
                                        if cmp.visible() then
                                                cmp.select_next_item()
                                        elseif luasnip.expand_or_jumpable() then
                                                luasnip.expand_or_jump()
                                        else
                                                fallback()
                                        end
                                end, { "i", "s" }),
                                ["<S-Tab>"] = cmp.mapping(function(fallback)
                                        if cmp.visible() then
                                                cmp.select_prev_item()
                                        elseif luasnip.jumpable(-1) then
                                                luasnip.jump(-1)
                                        else
                                                fallback()
                                        end
                                end, { "i", "s" }),
                        }),
                        sources = cmp.config.sources({
                                { name = "nvim_lsp" },
                                { name = "path" },
                                { name = "luasnip" },
                        }, {
                                { name = "buffer" },
                        }),
                })

                -- Configuration des implementations de LSP
                for _, server_name in pairs(servers_list) do
                        local server_setup = lsp_config[server_name]
                        server_setup.setup({
                                capabilities = capabilities,
                                on_attach = function(client, buffer)
                                        vim.keymap.set("n", "ge", vim.diagnostic.open_float, { desc = "Open diagnostic popup" })
                                        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = buffer })
                                        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", buffer = buffer })
                                        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = buffer })
                                        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation", buffer = buffer })
                                        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename", buffer = buffer })
                                        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Go to type definition", buffer = buffer })
                                        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action", buffer = buffer })
                                        vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Check references", buffer = buffer })
                                end
                        })
                end
        end,
}
