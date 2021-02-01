-- helpers
cmd = vim.cmd
fn = vim.fn
g = vim.g
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

require 'plugins'

-----OPTIONS-----
-- TODO: Check status: https://github.com/neovim/neovim/pull/13479

g.mapleader = " "
local ident = 4
local width = 80

-- Local

opt('b', 'expandtab',     true)     -- use spaces instead of tabs
opt('b', 'smartindent',   true)     -- automatically indent in functions
opt('b', 'shiftwidth',    ident)    -- tab length
opt('b', 'tabstop',       ident)    -- tab length
opt('b', 'softtabstop',   ident)    -- tab length
opt('b', 'textwidth',     80)       -- maximum text width
opt('b', 'wrapmargin',    80)       -- when to start wrapping
opt('b', 'formatoptions', 'jcroql') -- format options
opt('b', 'spelllang',     'en_us')  -- language for spell checker
opt('b', 'syntax',        'on')     -- enable syntax highlighting
opt('b', 'undofile',      true)     -- undofile

-- Global

opt('o', 'termguicolors', true)                    -- use rgb colors in the tui
opt('o', 'clipboard',     'unnamedplus')           -- use system clipboard register
opt('o', 'inccommand',    'nosplit')               -- shows the effects of search as you type
opt('o', 'lazyredraw',    true)                    -- don't redraw while executing macros
opt('o', 'mouse',         'a')                     -- mouse control
opt('o', 'smarttab',      true)                    -- backspace deletes 'shiftwidth' spaces
opt('o', 'ignorecase',    true)                    -- ignore capitalization while searching
opt('o', 'smartcase',     true)                    -- override 'ignorecase' if there is a capital letter
opt('o', 'hlsearch',      false)                   -- don't highlight previous search terms
opt('o', 'scrolloff',     20)                      -- screen lines to keep above and below cursor
opt('o', 'splitbelow',    true)                    -- split below
opt('o', 'splitbelow',    true)                    -- split right
opt('o', 'updatetime',    1000)                    -- how long CursorHold takes
opt('o', 'completeopt',   'menu,menuone,noselect') -- completion options
opt('o', 'shortmess',     'filnxtToOFc')           -- ui setting
opt('o', 'swapfile',      false)                   -- disable swap files
opt('o', 'backup',        false)                   

-- Window

opt('w', 'relativenumber', true)     -- relative line numbering
opt('w', 'number',         true)     -- line numbering
opt('w', 'wrap',           false)    -- line wrapping
opt('w', 'list',           true)     -- display a character for tabs
opt('w', 'lcs',            'tab:▏ ') -- display character for space tabs
opt('w', 'foldmethod',     'syntax') -- fold based on syntax
opt('w', 'signcolumn',     'yes')    -- enable sign column all the time
opt('w', 'foldlevel',      99)       -- don't fold files when opened

-----MAPPINGS-----

-- General
map('i', 'jj',    '<Esc>',       {silent = true, noremap = true})

-- Fuzzy Finding
map('n', '<C-p>',       '<cmd>Telescope find_files<CR>',            {silent = true, noremap = true})
map('n', '<leader>fl',  '<cmd>Telescope live_grep<CR>',             {silent = true, noremap = true})
map('n', '<leader>fL',  '<cmd>Telescope grep_string<CR>',           {silent = true, noremap = true})
map('n', '<leader>fs',  '<cmd>Telescope lsp_workspace_symbols<CR>', {silent = true, noremap = true})
map('n', '<leader>fr',  '<cmd>Telescope lsp_references<CR>',        {silent = true, noremap = true})
map('n', '<leader>fc',  '<cmd>Telescope commands<CR>',              {silent = true, noremap = true})
map('n', '<leader>fb',  '<cmd>Telescope buffers<CR>',               {silent = true, noremap = true})
map('n', '<leader>fgl', '<cmd>Telescope git_commits<CR>',           {silent = true, noremap = true})

-- vim lsp
cmd [[
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'       : pumvisible()                     ? '<C-n>'                      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'       : pumvisible()                     ? '<C-n>'                      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'       : pumvisible()                     ? '<C-p>'                      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'       : pumvisible()                     ? '<C-p>'                      : '<S-Tab>'
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'          : (&spell)                         ? '<C-G>u<Esc>[s1z=`]a<C-G>u'  : '<C-j>'
imap <expr> <CR>    pumvisible()        ? (complete_info().selected == -1 ? '<C-n><C-y><Plug>(vsnip-expand)' : '<C-y><Plug>(vsnip-expand)') : '<CR>'

inoremap <silent><expr> <C-Space> compe#complete()
]]

-- compe#confirm(\'<CR>\')
map('n', '<c-]>',      ':lua vim.lsp.buf.definition()<CR>',         {silent = true, noremap = true})
map('n', 'K',          ':lua vim.lsp.buf.hover()<CR>',              {silent = true, noremap = true})
map('n', 'gD',         ':lua vim.lsp.buf.implementation()<CR>',     {silent = true, noremap = true})
map('n', 'I',          ':lua vim.lsp.buf.signature_help()<CR>',     {silent = true, noremap = true})
map('n', 'gr',         ':lua vim.lsp.buf.references()<CR>',         {silent = true, noremap = true})
map('n', 'gR',         ':lua vim.lsp.buf.rename()<CR>',             {silent = true, noremap = true})
map('n', 'g0',         ':lua vim.lsp.buf.document_symbol()<CR>',    {silent = true, noremap = true})
map('n', 'gW',         ':lua vim.lsp.buf.workspace_symbol()<CR>',   {silent = true, noremap = true})
map('n', 'gd',         ':lua vim.lsp.buf.definition()<CR>',         {silent = true, noremap = true})
map('n', '<leader>do', ':lua vim.lsp.diagnostic.set_loclist()<CR>', {silent = true, noremap = true})

-- window navigation
-- map('n', '<leader>h',   '<C-w>h',     {silent = true, noremap = true})
-- map('n', '<leader>j',   '<C-w>j',     {silent = true, noremap = true})
-- map('n', '<leader>k',   '<C-w>k',     {silent = true, noremap = true})
-- map('n', '<leader>l',   '<C-w>l',     {silent = true, noremap = true})
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
map('n', '<leader>gs', ':G<CR>',       {silent = true, noremap = true})
map('n', '<leader>gc', ':Gcommit<CR>', {silent = true, noremap = true})
map('n', '<leader>gp', ':Gpush<CR>',   {silent = true, noremap = true})
map('n', '<leader>gb', ':Gblame<CR>',  {silent = true, noremap = true})
map('n', '<leader>gl', ':Glog<CR>',    {silent = true, noremap = true})

-- easyalign
map('x', 'ga', '<Plug>(EasyAlign)')
map('n', 'ga', '<Plug>(EasyAlign)')

-----COMMANDS------

cmd [[

filetype plugin indent on

command! -bang -nargs=* WikiRg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': '/home/kilometers/vimwiki'}), <bang>0)

" autocmd BufWritePre * :%s/\s\+$//e -- remove trailing spaces on file save

]]
