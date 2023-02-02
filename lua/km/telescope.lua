local M = {}

function M.lsp_references()
  require('telescope.builtin').lsp_references(require('telescope.themes').get_dropdown{
    initial_mode = "insert",
  })
end

function M.project_files()
  local opts = require('telescope.themes').get_dropdown{}
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

function M.password_store(opts)
  local globbed_files = vim.fn.globpath("~/.password-store", '**/*', true, true)
  local entry_list = {}
  for _, v in ipairs(globbed_files) do
    table.insert(entry_list, vim.fn.fnamemodify(v, ':s?.*.password-store/??:r'))
  end

  require('telescope.pickers').new(opts, {
    prompt_title = "Passwords",
    finder = require('telescope.finders').new_table {
      results = entry_list,
      entry_maker = function(line)
        return {
          ordinal = line,
          display = line,
        }
      end
    },
    sorter = require('telescope.config').values.generic_sorter(opts),
    previewer = require('telescope.previewers').new_termopen_previewer {
      get_command = function(entry)
        return { 'pass', 'show', entry.display }
      end
    },
    attach_mappings = function(prompt_bufnr)
      require('telescope.actions').select_default:replace(function()
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)

        vim.cmd(string.format("te pass show '%s'", selection.display))
      end)
      return true
    end
  }):find()
end

function M.directory(opts)
  local globbed_files = vim.fn.globpath(opts.directory, '*', true, true)
  local project_list = {}
  for _, v in ipairs(globbed_files) do
    table.insert(project_list, vim.fn.fnamemodify(v, ':t'))
  end

  require('telescope.pickers').new(opts, {
    finder = require('telescope.finders').new_table {
      results = project_list,
      entry_maker = function(line)
        return {
          ordinal = line,
          display = line,
        }
      end
    },
    sorter = require('telescope.config').values.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      require('telescope.actions').select_default:replace(function()
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)

        vim.cmd("cd " .. opts.directory .. selection.display)
      end)
      return true
    end
  }):find()
end

return M
