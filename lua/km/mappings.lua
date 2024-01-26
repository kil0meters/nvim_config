function builtin()
    return require("telescope.builtin")
end

function ivy()
    return require("telescope.themes").get_ivy({
        prompt_title = "",
        preview_title = "",
        borderchars = {
            prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
            results = { " " },
            preview = { "━", "┃", "━", "┃", "┏", "┓", "┛", "┗" },
        },
    });
end

-- general
vim.keymap.set("n", "Y", "y$");
vim.keymap.set("n", "Q", "<nop>");
vim.keymap.set("n", "<leader><leader>", "<cmd>noh<cr>");
vim.keymap.set("n", "G", "Gzz");
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- LSP stuff
vim.keymap.set("n", "gD", vim.lsp.buf.implementation);
vim.keymap.set("n", "gd", vim.lsp.buf.definition);
vim.keymap.set("n", "gr", vim.lsp.buf.rename);
vim.keymap.set("n", "gR", function() builtin().lsp_references(ivy()) end);
vim.keymap.set("n", "gs", function() builtin().lsp_document_symbols(ivy()) end);
vim.keymap.set("n", "ga", vim.lsp.buf.code_action);
vim.keymap.set("n", "U", function() vim.diagnostic.open_float(0, { scope = "cursor" }) end);
vim.keymap.set("n", "I", vim.lsp.buf.hover);

-- quickfix lists
vim.keymap.set("n", "<leader>;", vim.cmd.ToggleQuickfixList)
vim.keymap.set("n", "<leader>'", vim.cmd.ToggleLocationList)
vim.keymap.set("n", "<M-j>'", "<cmd>cn<cr>")
vim.keymap.set("n", "<M-k>'", "<cmd>cp<cr>")
vim.keymap.set("n", "<leader>j'", "<cmd>lne<cr>")
vim.keymap.set("n", "<leader>k'", "<cmd>lp<cr>")

-- telescope
vim.keymap.set("n", "<C-p>", function() builtin().find_files(ivy()) end)
vim.keymap.set("n", "<leader>fh", function() builtin().help_tags(ivy()) end)
vim.keymap.set("n", "<leader>fm", function() builtin().man_pages(ivy()) end)
vim.keymap.set("n", "<leader>fl", function() builtin().live_grep(ivy()) end)
vim.keymap.set("n", "<leader>fL", function() builtin().grep_string(ivy()) end)
vim.keymap.set("n", "<leader>fb", function() builtin().buffers(ivy()) end)
vim.keymap.set("n", "<leader>fs", function() builtin().lsp_dynamic_workspace_symbols(ivy()) end)
vim.keymap.set("n", "<leader>ff", function() builtin().git_files(ivy()) end)
vim.keymap.set("n", "<leader>gl", function() builtin().git_commits(ivy()) end)

vim.keymap.set("n", "<leader>fp",
    function() require("km.telescope").directory(require("telescope.themes").get_ivy({ directory = "~/Projects/" })) end)
vim.keymap.set("n", "<leader>fP",
    function() require("km.telescope").directory(require("telescope.themes").get_ivy({ directory = "~/Papers/" })) end)
vim.keymap.set("n", "<leader>fc",
    function() require("km.telescope").directory(require("telescope.themes").get_ivy({ directory = "~/.config/" })) end)

-- harpoon
vim.keymap.set("n", "T", function() require("harpoon.ui").toggle_quick_menu() end);
vim.keymap.set("n", "M", function() require("harpoon.mark").add_file() end);
vim.keymap.set("n", "<C-j>", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<C-k>", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<C-l>", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<C-;>", function() require("harpoon.ui").nav_file(4) end)

-- dap
vim.keymap.set("n", "<leader>b", function() require"dap".toggle_breakpoint() end)

