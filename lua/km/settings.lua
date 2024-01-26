vim.g.mapleader = " "
local ident = 4
local width = 80

vim.opt.backup         = false
vim.opt.clipboard      = 'unnamedplus' -- use system clipboard register
vim.opt.completeopt    = { 'menuone', 'noselect' } -- completion options
vim.opt.expandtab      = true -- use spaces instead of tabs
vim.opt.fillchars      = { fold = " ", vert = "│", eob = " ", msgsep = "‾" }
vim.opt.foldlevel      = 99 -- don't fold files when opened
vim.opt.foldmethod     = 'expr' -- fold based on indentation by default
vim.opt.foldexpr       = "nvim_treesitter#foldexpr()"
vim.opt.lazyredraw     = true -- don't redraw while executing macros
vim.opt.mouse          = 'nv' -- mouse control
vim.opt.pumheight      = 10
vim.opt.number         = true -- line numbering
vim.opt.relativenumber = true -- relative line numbering
vim.opt.scrolloff      = 10 -- screen lines to keep above and below cursor
vim.opt.shortmess      = 'filnxtToOFc' -- ui setting
vim.opt.showmode       = false --
vim.opt.signcolumn     = 'yes' -- enable sign in number line
vim.opt.smartcase      = true -- override 'ignorecase' if there is a capital letter
vim.opt.smartindent    = true -- automatically indent in functions vim.bo.shiftwidth = ident
vim.opt.smarttab       = true -- backspace deletes 'shiftwidth' spaces
vim.opt.shiftwidth     = ident
vim.opt.softtabstop    = ident -- tab length
vim.opt.spelllang      = 'en_us' -- language for spell checker
vim.opt.splitbelow     = true -- split below
vim.opt.swapfile       = false -- disable swap files
vim.opt.syntax         = 'on' -- enable syntax highlighting
vim.opt.tabstop        = ident -- tab length
vim.opt.termguicolors  = true -- use rgb colors in the tui
vim.opt.textwidth      = width -- maximum text width
vim.opt.undofile       = true -- undofile
vim.opt.wrap           = false -- line wrapping
vim.opt.wrapmargin     = width -- when to start wrapping
vim.opt.cmdheight      = 1
vim.opt.laststatus     = 0
vim.opt.title          = false
vim.opt.winbar         = '%f'

vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { '*' },
    callback = function()
        -- force format options regardless of what ftplugins try to do
        vim.opt.formatoptions = 'jrnq'
    end
})
