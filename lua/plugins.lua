-- bootstrap packer
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  vim.api.nvim_command 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}

  use {
    'gruvbox-community/gruvbox',
    config = function()
      g.gruvbox_contrast_dark = 'hard'
      g.gruvbox_contrast_light = 'soft'
      g.gruvbox_invert_selection = 0
      g.gruvbox_italic = 1
      g.gruvbox_italicize_comments = 1

      cmd 'colorscheme gruvbox'

      cmd [[

      hi! link DiffAdd GruvboxGreenSign
      hi! link DiffChange GruvboxAquaSign
      hi! link DiffDelete GruvboxRedSign

      ]]
    end
  } 

  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      local lualine = require('lualine')
      lualine.theme = 'gruvbox'
      lualine.status()
    end
  }

  use {
    'norcalli/nvim-colorizer.lua',
    ft = {'html', 'css', 'javscript', 'typescript'},
    config = function() 
      require 'colorizer'.setup({
        RGB      = true, -- #RGB hex codes
        RRGGBB   = true, -- #RRGGBB hex codes
        names    = true, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn   = true, -- CSS rgb() and rgba() functions
        hsl_fn   = true, -- CSS hsl() and hsla() functions
      })
    end
  }

  use {
    'Yggdroot/indentLine',
    requires = {
      'lukas-reineke/indent-blankline.nvim',
      branch = 'lua',
    },
    config = function()
      g.indentLine_fileTypeExclude = { 'markdown', 'pandoc', 'vimwiki' }
      g.indentLine_char = '▏'
      g.indent_blankline_extra_indent_level = -1
    end
  }

  -- -- Intellisense
  use {
    'neovim/nvim-lspconfig',
    config = function()
      fn.sign_define("LspDiagnosticsSignError",       {text = "", texthl = "LspDiagnosticsSignError"})
      fn.sign_define("LspDiagnosticsSignWarning",     {text = "", texthl = "LspDiagnosticsSignWarning"})
      fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsSignInformation"})
      fn.sign_define("LspDiagnosticsSignHint",        {text = "", texthl = "LspDiagnosticsSignHint"})

      local lsp = require 'lspconfig'

      local on_attach = function(client)
        cmd 'autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()'
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lsp.html.setup{ on_attach=on_attach, capabilities=capabilities }
      lsp.cssls.setup{ on_attach=on_attach, capabilities=capabilities }
      lsp.rust_analyzer.setup{ on_attach=on_attach, capabilities=capabilities }
      lsp.clangd.setup{ on_attach=on_attach, capabilities=capabilities }
      lsp.tsserver.setup{ on_attach=on_attach, capabilities=capabilities }
      lsp.pyright.setup{ on_attach=on_attach, capabilities=capabilities }
    end

  }

  use {
    'hrsh7th/nvim-compe',
    requires = {'hrsh7th/vim-vsnip', opt = true},
    config = function()
      g.vsnip_snippet_dir = '/home/kilometers/.config/nvim/snippets'

      require'compe'.setup {
        enabled = true,
        debug = false,
        -- preselect = 'never',

        source = {
          buffer = { filetypes = {'vimwiki'}}, 
          spell = { filetypes = {'vimwiki'}},
          path = true,
          vsnip = true,
          nvim_lsp = true,
          nvim_lua = true,
        },
      }
    end
  }


  use {
    'nvim-treesitter/nvim-treesitter',
    event = 'VimEnter *',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = {},  -- list of languages that will be disabled
        },
      }
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      g.nvim_tree_indent_markers = 1
      g.nvim_tree_ignore = { '.git', 'node_modules', 'target' }
      g.nvim_tree_git_hl = 1
      g.nvim_tree_auto_close = 1
    end
  }

  use {
    'junegunn/goyo.vim',
    opt = true,
    cmd = 'Goyo',
    requires = {
      'junegunn/limelight.vim',
      cmd = { 'Limelight', 'Limelight!' },
      opt = true
    },
    config = function()
      g.goyo_width = 85
    end
  }

  use {
    'vimwiki/vimwiki',
    requires = {'tools-life/taskwiki', opt = true},
    config = function()
      g.vimwiki_table_mappings = 0
    end
  }

  -- Fuzzy find
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'nvim-treesitter/nvim-treesitter', opt = true}
    },
    config = function()
      require('telescope').setup {
        defaults = {
          file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
          grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
          qflist_preview = require'telescope.previewers'.vim_buffer_qflist.new
        }
      }
    end
  }

  use {
    'matze/vim-move',
    config = function()
      g.move_key_modifier = 'C'
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require('gitsigns').setup{}
    end
  }
  
  use {'sukima/xmledit', ft = 'xml'}
  use {'alvan/vim-closetag', ft = {'xml', 'html'}}
  use {'tmhedberg/SimpylFold', ft = 'python'}
  use {'KeitaNakamura/tex-conceal.vim', ft = 'tex'}

  -- use {'sheerun/vim-polyglot', event = 'VimEnter *'}

  use 'tjdevries/lsp_extensions.nvim'
  use 'b3nj5m1n/kommentary'
  use 'tpope/vim-surround'
  use 'jiangmiao/auto-pairs'
  use 'junegunn/vim-easy-align'
  use 'vimlab/split-term.vim'
  use 'tpope/vim-fugitive'
end)
