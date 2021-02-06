-- helpers
cmd = vim.cmd
fn = vim.fn
g = vim.g

local map = vim.api.nvim_set_keymap

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

require 'plugins'

-----OPTIONS-----
-- TODO: Check status: https://github.com/neovim/neovim/pull/13479

g.mapleader = " "
local ident = 4
local width = 80

-- Local

vim.bo.expandtab = true         -- use spaces instead of tabs
vim.bo.smartindent = true       -- automatically indent in functions
vim.bo.shiftwidth = ident       -- tab length
vim.bo.tabstop = ident          -- tab length
vim.bo.softtabstop = ident      -- tab length
vim.bo.textwidth = width        -- maximum text width
vim.bo.wrapmargin = width       -- when to start wrapping
vim.bo.formatoptions = 'jcroql' -- format options
vim.bo.spelllang = 'en_us'      -- language for spell checker
vim.bo.syntax = 'on'            -- enable syntax highlighting
vim.bo.undofile = true          -- undofile

vim.o.expandtab = true         -- use spaces instead of tabs
vim.o.smartindent = true       -- automatically indent in functions
vim.o.shiftwidth = ident       -- tab length
vim.o.tabstop = ident          -- tab length
vim.o.softtabstop = ident      -- tab length
vim.o.textwidth = width        -- maximum text width
vim.o.wrapmargin = width       -- when to start wrapping
vim.o.formatoptions = 'jcroql' -- format options
vim.o.spelllang = 'en_us'      -- language for spell checker
vim.o.syntax = 'on'            -- enable syntax highlighting
vim.o.undofile = true          -- undofile

-- Global

vim.o.termguicolors = true                  -- use rgb colors in the tui
vim.o.clipboard = 'unnamedplus'             -- use system clipboard register
vim.o.inccommand = 'nosplit'                -- shows the effects of search as you type
vim.o.lazyredraw = true                     -- don't redraw while executing macros
vim.o.mouse = 'a'                           -- mouse control
vim.o.smarttab = true                       -- backspace deletes 'shiftwidth' spaces
vim.o.ignorecase = true                     -- ignore capitalization while searching
vim.o.smartcase = true                      -- override 'ignorecase' if there is a capital letter
vim.o.hlsearch = false                      -- don't highlight previous search terms
vim.o.scrolloff = 20                        -- screen lines to keep above and below cursor
vim.o.splitbelow = true                     -- split below
vim.o.splitbelow = true                     -- split right
vim.o.updatetime = 1000                     -- how long CursorHold takes
vim.o.completeopt = 'menu,menuone,noselect' -- completion options
vim.o.shortmess = 'filnxtToOFc'             -- ui setting
vim.o.swapfile = false                      -- disable swap files
vim.o.backup = false                        --
vim.o.hidden = true
vim.o.fillchars = 'fold: ,vert:│,eob: ,msgsep:‾'

-- Window

vim.wo.relativenumber = true -- relative line numbering
vim.wo.number = true         -- line numbering
vim.wo.wrap = false          -- line wrapping
vim.wo.list = true           -- display a character for tabs
vim.wo.lcs = 'tab:▏ '        -- display character for space tabs
vim.wo.foldmethod = 'syntax' -- fold based on syntax
vim.wo.signcolumn = 'yes'    -- enable sign column all the time
vim.wo.foldlevel = 99        -- don't fold files when opened

vim.o.relativenumber = true -- relative line numbering
vim.o.number = true         -- line numbering
vim.o.wrap = false          -- line wrapping
vim.o.list = true           -- display a character for tabs
vim.o.lcs = 'tab:▏ '        -- display character for space tabs
vim.o.foldmethod = 'syntax' -- fold based on syntax
vim.o.signcolumn = 'yes'    -- enable sign column all the time
vim.o.foldlevel = 99        -- don't fold files when opened

-----MAPPINGS-----
_G.completion_confirm = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] == -1 then
      return t'<C-n>' .. vim.fn["compe#confirm"]()
    else
      return vim.fn["compe#confirm"]()
    end
  else
    return require'nvim-autopairs'.check_break_line_char()
  end
end

_G.tab = function()
  if vim.fn.pumvisible() ~= 0 then
    return t'<C-n>'
  elseif vim.fn['vsnip#jumpable'](1) ~= 0 then
    -- For whatever reason the nvim api doesn't escape <Plug>
    cmd [[ call feedkeys("\<Plug>(vsnip-jump-next)") ]]
    return ''
  else
    return t'<Tab>'
  end
end

_G.s_tab = function()
  if vim.fn.pumvisible() ~= 0 then
    return t'<C-p>'
  elseif vim.fn['vsnip#jumpable'](1) ~= 0 then
    cmd [[ call feedkeys("\<Plug>(vsnip-jump-prev)") ]]
    return ''
  else
    return t'<S-Tab>'
  end
end

_G.snippet_completion = function()
  if vim.fn['vsnip#expandable']() ~= 0 then
    cmd [[ call feedkeys("\<Plug>(vsnip-expand)") ]]
    return ''
  elseif vim.fn.pumvisible() ~= 0 then
    return vim.fn["compe#confirm"]()
  elseif vim.wo.spell then
    return t'<C-G>u<Esc>[s1z=`]a<C-G>u'
  else
    return t'<C-j>'
  end
end

-- general
map('i', 'jj', '<Esc>', {silent = true, noremap = true})

-- completion
map('i', '<Tab>',     'v:lua.tab()',                {expr = true, noremap = true})
map('s', '<Tab>',     'v:lua.tab()',                {expr = true, noremap = true})
map('i', '<S-Tab>',   'v:lua.s_tab()',              {expr = true, noremap = true})
map('s', '<S-Tab>',   'v:lua.s_tab()',              {expr = true, noremap = true})
map('i', '<C-Space>', 'compe#complete()',           {expr = true, noremap = true})
map('i', '<CR>',      'v:lua.completion_confirm()', {expr = true, noremap = true})
map('i', '<C-j>',     'v:lua.snippet_completion()', {expr = true, noremap = true})

-- langauge server protocol
map('n', '<c-]>',      ':lua vim.lsp.buf.definition()<CR>',         {silent = true, noremap = true})
map('n', 'K',          ':lua vim.lsp.buf.hover()<CR>',              {silent = true, noremap = true})
map('n', 'gD',         ':lua vim.lsp.buf.implementation()<CR>',     {silent = true, noremap = true})
map('n', 'gd',         ':lua vim.lsp.buf.definition()<CR>',         {silent = true, noremap = true})
map('n', 'I',          ':lua vim.lsp.buf.signature_help()<CR>',     {silent = true, noremap = true})
map('n', 'gr',         ':Telescope lsp_references<CR>',             {silent = true, noremap = true})
map('n', 'ga',         ':lua vim.lsp.buf.code_action()<CR>',        {silent = true, noremap = true})
map('n', 'gs',         ':Telescope lsp_workspace_symbols<CR>',      {silent = true, noremap = true})
map('n', 'gS',         ':Telescope lsp_document_symbols<CR>',       {silent = true, noremap = true})
map('n', 'gR',         ':lua vim.lsp.buf.rename()<CR>',             {silent = true, noremap = true})
map('n', '<leader>do', ':lua vim.lsp.diagnostic.set_loclist()<CR>', {silent = true, noremap = true})

-- fuzzy finding
map('n', '<C-p>',       '<cmd>Telescope find_files theme=get_dropdown<CR>',  {silent = true, noremap = true})
map('n', '<leader>fl',  '<cmd>Telescope live_grep<CR>',                      {silent = true, noremap = true})
map('n', '<leader>fL',  '<cmd>Telescope grep_string theme=get_dropdown<CR>', {silent = true, noremap = true})
map('n', '<leader>fc',  '<cmd>Telescope commands theme=get_dropdown<CR>',    {silent = true, noremap = true})
map('n', '<leader>fb',  '<cmd>Telescope buffers theme=get_dropdown<CR>',     {silent = true, noremap = true})
map('n', '<leader>fgl', '<cmd>Telescope git_commits theme=get_dropdown<CR>', {silent = true, noremap = true})

-- window navigation
map('n', '<leader>wh',  '<C-w>h',     {silent = true, noremap = true})
map('n', '<leader>wj',  '<C-w>j',     {silent = true, noremap = true})
map('n', '<leader>wk',  '<C-w>k',     {silent = true, noremap = true})
map('n', '<leader>wl',  '<C-w>l',     {silent = true, noremap = true})
map('n', '<leader>wq',  '<C-w>q',     {silent = true, noremap = true})
map('n', '<leader>ws',  '<C-w>s',     {silent = true, noremap = true})
map('n', '<leader>wv',  '<C-w>v',     {silent = true, noremap = true})
map('n', '<leader>wtv', ':VTerm<CR>', {silent = true, noremap = true})
map('n', '<leader>wts', ':Term<CR>',  {silent = true, noremap = true})

-- tree
map('n', '<leader>l', ':NvimTreeToggle<CR>', {silent = true})

-- indentation
map('v', '<Tab>', '>gv',   {silent = true, noremap = true})
map('v', '<S-Tab>', '<gv', {silent = true, noremap = true})

-- git
map('n', '<leader>gs', ':lua require"neogit".status.create("split")<CR>', {silent = true, noremap = true})

-----COMMANDS------

cmd [[

filetype plugin indent on

command! -bang -nargs=* WikiRg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': '/home/kilometers/vimwiki'}), <bang>0)

autocmd BufWritePre * :%s/\s\+$//e -- remove trailing spaces on file save

]]
