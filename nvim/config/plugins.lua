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
    {"navarasu/onedark.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1005, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme onedark]])
    end,
    },
    {"neovim/nvim-lspconfig", lazy = false}, -- Language Server Protocol config
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    {'nvim-lualine/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons'},
    {"ojroques/vim-oscyank", branch = "main"}, -- allows copies terminal (OSC52) to vim
    {"tpope/vim-fugitive"}, -- git on steroids
    {"tpope/vim-commentary"}, -- adds commentary (:gcc to comment line, :7,17Commentary to comment range, etc)
    {"roxma/vim-tmux-clipboard"}, -- copy from vim to tmux
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {"easymotion/vim-easymotion"}, -- vim steroids (:help easymotion.txt)
    {"junegunn/fzf"},
    {"junegunn/fzf.vim"},
    {'hrsh7th/nvim-cmp'}, -- Autocompletion plugin
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-buffer'},
    {'nvimtools/none-ls.nvim', dependencies = {'nvimtools/none-ls-extras.nvim', 'nvim-lua/plenary.nvim'}},
    {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    }
})

-- Vim-Oscyank
vim.api.nvim_set_keymap('n', '<leader>c', '<Plug>OSCYankOperator', {})
vim.api.nvim_set_keymap('n', '<leader>cc', '<leader>c_', {})
vim.api.nvim_set_keymap('v', '<leader>c', '<Plug>OSCYankVisual', {})
vim.g.oscyank_max_length = 0
vim.g.oscyank_silent = 0
vim.g.oscyank_trim = 1
vim.g.oscyank_osc52 = "\x1b]52;c;%s\x07"

-- Tree-sitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "vim", "bash", "lua", "python", "cuda", "html", "cmake", "make", "yaml", "vim"},
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- ** LSPConfig **
local lspconfig = require('lspconfig')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})


-- Nvim-Cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {'pyright'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
     settings = {
            python = {
                analysis = {
                    diagnosticSeverityOverrides = {reportGeneralTypeIssues = "warning"},
                }
            }
        }
    }
end


local cmp = require 'cmp'
cmp.setup {
     sorting = {
        comparators = {
          cmp.config.compare.exact,
          cmp.config.compare.offset,
          cmp.config.compare.locality,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        {
            name = 'path',
                option = {
                    get_cwd = function() return vim.fn.resolve(vim.fn.getcwd()) end

                },
        },
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-j>'] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
    }),
}

-- required for lsp to start automatically
vim.api.nvim_exec_autocmds("FileType", {})

-- None-ls
local null_ls = require("null-ls")

null_ls.setup({
  ensure_installed = { "black", "flake8"},
  sources = {
    null_ls.builtins.formatting.black.with({
        extra_args = {"--line-length", "100"}
    }),
    require('none-ls.diagnostics.flake8').with({
        extra_args = {"--max-line-length", "100"}
    }),

    null_ls.builtins.code_actions.refactoring,
    },
})

vim.keymap.set("n", "<leader>ft", function() vim.lsp.buf.format() end)


-- EasyMotion
vim.g.EasyMotion_smartcase = 1
vim.g.EasyMotion_use_smartsign_us = 1
vim.api.nvim_set_keymap('n', 's', '<Plug>(easymotion-overwin-f)', {})


vim.o.hidden = true
vim.o.updatetime = 300
vim.o.shortmess = vim.o.shortmess .. "c"


-- FzF
vim.api.nvim_set_keymap('n', '<C-p>', ':Files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-F>f', ':Ag!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-F>/', ':BLines<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-F>b', ':Buffers<CR>', { noremap = true })

-- BufferTabline
local bufferline = require('bufferline')
bufferline.setup({
    options = {
        style_preset = {
            bufferline.style_preset.no_italic,
            bufferline.style_preset.no_bold,
        },
        diagnostics = "nvim_lsp",

        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " "
              or (e == "warning" and " " or "󰌶 " )
            s = s .. n .. sym
          end
          return s
        end,
        numbers = "id",
    }
})

-- Onedark
require('onedark').setup  {
    -- Main options --
    style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = false,  -- Show/hide background
    term_colors = true, -- Change terminal color as per the selected theme style
    ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
    cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

    -- toggle theme style ---
    toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
    toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

    -- Change code style ---
    -- Options are italic, bold, underline, none
    -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
    code_style = {
        comments = 'none',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
    },
    -- Lualine options --
    lualine = {
        transparent = false, -- lualine center bar transparency
    },

    -- Custom Highlights --
    colors = {}, -- Override default colors
    highlights = {}, -- Override highlight groups

    -- Plugins Config --
    diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true,   -- use undercurl instead of underline for diagnostics
        background = true,    -- use background color for virtual text
    },
}

-- Lualine
require('lualine').setup()
require('lualine').setup {
      sections = { lualine_c = {{'filename', path = 1 } }}
    }
