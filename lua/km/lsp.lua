local lsp = require("lspconfig")
local forward_search

if vim.fn.has("mac") == 1 then
    forward_search = {
        executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
        args = { "%l", "%p", "%f" },
        onSave = true,
    }
elseif vim.fn.has("unix") == 1 then
    forward_search = {
        executable = "zathura",
        args = { "--synctex-forward", "%l:1:%f", "%p" },
        onSave = true,
    }
end

lsp.dartls.setup {}

lsp.texlab.setup {
    -- on_attach=default_on_attach,
    -- capabilities=default_capabilities,
    settings = {
        texlab = {
            auxDirectory = "build",
            build = {
                executable = "tectonic",
                args = {
                    "--outdir=build",
                    "--synctex",
                    "--print",
                    "--keep-logs",
                    "--keep-intermediates",
                    "%f",
                },
                forwardSearchAfter = true,
                onSave = true,
            },
            forwardSearch = forward_search,
        }
    }
}
