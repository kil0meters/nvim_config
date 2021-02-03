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
      require 'colorizer'.setup(
      {
        'html',
        'css',
        'javascript',
        'typescript'
      }, {
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

  use {
    'hrsh7th/nvim-compe',
    requires = {
      {'hrsh7th/vim-vsnip'},
      {'hrsh7th/vim-vsnip-integ'}
    },

    config = function()
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

      g.vsnip_snippet_dir = '/home/kilometers/.config/nvim/snippets'
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
        --[[ cmd "augroup lsp_commands"
        cmd "au!"
        cmd "au CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()"

        if client.resolved_capabilities.document_formatting == true then
          cmd "au BufWritePre <buffer> lua vim.lsp.buf.formatting()"
        end

        cmd "augroup END" ]]
      end

      local system_name
      if vim.fn.has("mac") == 1 then
        system_name = "macOS"
      elseif vim.fn.has("unix") == 1 then
        system_name = "Linux"
      elseif vim.fn.has('win32') == 1 then
        system_name = "Windows"
      else
        print("Unsupported system for sumneko")
      end

      -- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
      local sumneko_root_path = '/home/kilometers/Projects/lua-language-server'
      local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lsp.sumneko_lua.setup {
        cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Setup your lua path
              path = vim.split(package.path, ';'),
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {'vim'},
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = {
                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
              },
            },
          },
        },
      }

      local servers = {'html', 'cssls', 'rust_analyzer', 'clangd', 'pyright', 'gopls' }
      for _, server in ipairs(servers) do
        lsp[server].setup { on_attach=on_attach, capabilities=capabilities }
      end
    end
  }

  use {
    'RishabhRD/nvim-lsputils',
    requires = {'RishabhRD/popfix'},
    config = function()
      vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
      vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
      vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
      vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
      vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
      vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
      vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
      vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

      border_chars = {
        TOP_LEFT = '╭',
        TOP_RIGHT = '╮',
        MID_HORIZONTAL = '─',
        MID_VERTICAL = '│',
        BOTTOM_LEFT = '╰',
        BOTTOM_RIGHT = '╯',
      }

      g.lsp_utils_codeaction_opts = {
        list = {
          border_chars = border_chars,
        }
      }
    end
  }

  use {
    'kosayoda/nvim-lightbulb',
    config = function()
      fn.sign_define("LightBulbSign",       {text = "💡", texthl = "LspDiagnosticsSignWarning"})
      cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
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

  --[[ use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      g.nvim_tree_indent_markers = 1
      g.nvim_tree_ignore = { '.git', 'node_modules', 'target' }
      g.nvim_tree_git_hl = 1
      g.nvim_tree_auto_close = 1
    end
  } ]]

  --[[ use {
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
  } ]]

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
      cmd [[autocmd User TelescopePreviewerLoaded setlocal number]]

      require('telescope').setup {
        defaults = {
          file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
          grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
          qflist_preview = require'telescope.previewers'.vim_buffer_qflist.new,
          theme = require'telescope.themes'.get_dropdown({})
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
    -- '~/Projects/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require('gitsigns').setup{}
    end
  }

  use {
    'windwp/nvim-autopairs',
    config = function()
      require'nvim-autopairs'.setup{
        break_line_filetype = nil, -- enable this rule for all filetypes
        pairs_map = {
          ["'"] = "'",
          ['"'] = '"',
          ['('] = ')',
          ['['] = ']',
          ['{'] = '}',
          ['`'] = '`',
        },
        disable_filetype = { "TelescopePrompt" },
        html_break_line_filetype = {
          'html' , 'vue' , 'typescriptreact' , 'svelte' , 'javascriptreact'
        },
        -- ignore alphanumeric, operators, quote, curly brace, and square bracket
        ignored_next_char = "[%w%.%+%-%=%/%,\"'{}%[%]]"
      }
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
  use 'vimlab/split-term.vim'
  use 'tpope/vim-fugitive'
end)
