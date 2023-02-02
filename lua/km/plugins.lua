local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "ellisonleao/gruvbox.nvim",
        event = "BufEnter",
        config = function()
            require("gruvbox").setup({
                -- contrast = "hard",
                italic = false,
                bold = false,
                overrides = {
                    WinBarNC = { fg = "#a89984", bg = "#282828" }
                }
            })

            vim.cmd [[ colorscheme gruvbox ]]
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        build = ":TSUpdate",
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { "c", "lua", "rust", "vim", "help", "python", "javascript", "html", "typescript",
                    "latex" },
                indent = {
                    enable = true,
                    disable = { "html", "python" }
                },
                highlight = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        node_incremental = "o",
                        node_decremental = "i",
                    },
                },
            }
        end
    },

    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzy-native.nvim" },
            { "nvim-telescope/telescope-ui-select.nvim" },
        },
        config = function()
            vim.cmd [[autocmd User TelescopePreviewerLoaded setlocal number]]

            require('telescope').setup {
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_cursor {}
                    }
                },
                defaults = {
                    theme = require("telescope.themes").get_ivy({
                        preview_title = ""
                    }),

                    results_title = "",

                    layout_config = {
                        preview_cutoff = 0,
                    },

                    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                    qflist_preview = require("telescope.previewers").vim_buffer_qflist.new,

                    extensions = {
                        fzy_native = {
                            override_generic_sorter = true,
                            override_file_sorter = true,
                        },
                    }
                }
            }

            require("telescope").load_extension("fzy_native")
            require("telescope").load_extension("ui-select")
        end
    },

    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        event = "VeryLazy",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        },
        config = function()
            local lsp = require('lsp-zero')
            local luasnip = require('luasnip')
            local cmp = require('cmp')

            lsp.preset('recommended')

            lsp.setup_nvim_cmp({
                window = nil,
                mapping = {
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            local entry = cmp.get_selected_entry()
                            if not entry then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                cmp.confirm()
                            end
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()

                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    -- ['<CR>'] = cmp.mapping.confirm({
                    --   behavior = cmp.ConfirmBehavior.Replace,
                    --   select = true,
                    -- }),
                    ['<C-j>'] = cmp.mapping(function(fallback)
                        if luasnip.expandable() then
                            luasnip.expand({})
                        else
                            fallback()
                        end
                    end, { 'i' })
                },
            })

            lsp.setup()
        end
    },

    {
        "kyazdani42/nvim-tree.lua",
        config = function() require("nvim-tree").setup() end,
        keys = {
            { "<leader>l", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
        },
    },

    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "UndoTree" },
        },
    },

    {
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup({
                input = {
                    border = "solid",
                    win_options = {
                        winblend = 5,
                    }
                }
            })
        end
    },

    {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    },

    "kyazdani42/nvim-web-devicons",
    "tpope/vim-surround",
    "nmac427/guess-indent.nvim",
})
