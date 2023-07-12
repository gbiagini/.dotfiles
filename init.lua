-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable',
        lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- Add plugins
require('lazy').setup({
	{'tpope/vim-fugitive', cond = not vim.g.vscode},        -- Git commands in nvim
	{'tpope/vim-rhubarb', cond = not vim.g.vscode},         -- Fugitive-companion to interact with github
	{'numToStr/Comment.nvim', cond = not vim.g.vscode},     -- "gc" to comment visual regions/lines
	{'stevearc/oil.nvim', cond = not vim.g.vscode},        -- More modern netrw
	{'nvim-lualine/lualine.nvim', cond = not vim.g.vscode}, -- Fancier statusline
    -- Add indentation guides even on blank lines
	{'lukas-reineke/indent-blankline.nvim', cond = not vim.g.vscode},
    -- Add git related info in the signs columns and popups
	{'lewis6991/gitsigns.nvim', cond = not vim.g.vscode},
	{'nvim-treesitter/nvim-treesitter', cond = not vim.g.vscode},             -- Highlight, edit, and navigate code
	{'nvim-treesitter/nvim-treesitter-textobjects', cond = not vim.g.vscode},  -- Additional textobjects for treesitter
	{'neovim/nvim-lspconfig', cond = not vim.g.vscode},                      -- Collection of configurations for built-in LSP client
	{'williamboman/mason.nvim', cond = not vim.g.vscode},                    -- Automatically install LSPs to stdpath for neovim
	{'williamboman/mason-lspconfig.nvim', cond = not vim.g.vscode},          -- ibid
    {                                              -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
	cond = not vim.g.vscode
    },
    -- Fuzzy Finder (files, lsp, etc)
    { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' }, cond = not vim.g.vscode },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you have trouble with this installation, refer to the README for telescope-fzf-native.
        build = 'make', cond = not vim.g.vscode
    },
}, {cond = not vim.g.vscode})

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

--Set colorscheme (order is important here)
vim.o.termguicolors = true
--vim.cmd.colorscheme("cyberpunk-neon")

--Set statusbar
if not vim.g.vscode then
    require('lualine').setup {
        options = {
            icons_enabled = false,
            component_separators = '|',
            section_separators = '',
        },
    }
end

--Enable Comment.nvim
if not vim.g.vscode then
    require('Comment').setup()
end

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

--Disable numbers in terminal mode
if not vim.g.vscode then
    require('indent_blankline').setup {
        char = '┊',
        filetype_exclude = { 'help' },
        buftype_exclude = { 'terminal', 'nofile' },
        show_trailing_blankline_indent = false,
    }
end

-- Gitsigns
if not vim.g.vscode then
    require('gitsigns').setup {
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
            vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr })
            vim.keymap.set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr })
        end,
    }
end

-- Oil
if not vim.g.vscode then
    require('oil').setup()
    vim.keymap.set('n', '-', function() require('oil').open() end, { desc = 'Open parent directory' })
end

-- Telescope
if not vim.g.vscode then
    require('telescope').setup {
        defaults = {
            mappings = {
                i = {
                    ['<C-u>'] = false,
                    ['<C-d>'] = false,
                },
            },
        },
    }
end

-- Enable telescope fzf native
if not vim.g.vscode then
    require('telescope').load_extension 'fzf'
end

--Add leader shortcuts
vim.keymap.set('n', '<leader><space>', function() require('telescope.builtin').buffers { sort_lastused = true } end)
vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files { previewer = false } end)
vim.keymap.set('n', '<leader>sb', function() require('telescope.builtin').current_buffer_fuzzy_find() end)
vim.keymap.set('n', '<leader>sh', function() require('telescope.builtin').help_tags() end)
vim.keymap.set('n', '<leader>st', function() require('telescope.builtin').tags() end)
vim.keymap.set('n', '<leader>sd', function() require('telescope.builtin').grep_string() end)
vim.keymap.set('n', '<leader>sp', function() require('telescope.builtin').live_grep() end)
vim.keymap.set('n', '<leader>?', function() require('telescope.builtin').oldfiles() end)

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
if not vim.g.vscode then
    require('nvim-treesitter.configs').setup {
        highlight = {
            enable = true, -- false will disable the whole extension
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<c-space>',
                node_incremental = '<c-space>',
                scope_incremental = '<c-s>',
                node_decremental = '<M-space>',
            },
        },
        indent = {
            enable = true,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = '@class.outer',
                },
                goto_next_end = {
                    [']M'] = '@function.outer',
                    [']['] = '@class.outer',
                },
                goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer',
                },
                goto_previous_end = {
                    ['[M'] = '@function.outer',
                    ['[]'] = '@class.outer',
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ['<leader>a'] = '@parameter.inner',
                },
                swap_previous = {
                    ['<leader>A'] = '@parameter.inner',
                },
            },
        },
    }
end

-- Diagnostic settings
vim.diagnostic.config {
    virtual_text = false,
    update_in_insert = true,
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist)

-- LSP settings
if not vim.g.vscode then
    require('mason').setup {}
    require('mason-lspconfig').setup()
end

-- Add nvim-lspconfig plugin
if not vim.g.vscode then
    local lspconfig = require 'lspconfig'
    local on_attach = function(_, bufnr)
        local attach_opts = { silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
        vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, attach_opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, attach_opts)
        vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            attach_opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
        vim.keymap.set('n', 'so', require('telescope.builtin').lsp_references, attach_opts)
    end
    
    -- nvim-cmp supports additional completion capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    
    -- Enable the following language servers
    local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end
    
    lspconfig.lua_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                completion = {
                    callSnippet = 'Replace',
                },
            },
        },
    }
    
    -- nvim-cmp setup
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    
    luasnip.config.setup {}
    
    cmp.setup {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert {
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete {},
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        },
    }
end
-- vim: ts=2 sts=2 sw=2 et
-- FIXME: Can't remember what this does
vim.opt.backspace = "indent,eol,start"
vim.opt.ruler = true


-- FIXME: Don't remember
vim.opt.laststatus = 0

-- Get a color column to denote the end of the PEP8 line length
vim.opt.colorcolumn = "80"

-- Transparent background
vim.cmd.highlight({ "normal", "guibg=NONE ctermbg=NONE" })

-- FIXME: Don't remember
vim.cmd.highlight({ "clear", "SignColumn" })
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Remap keys for split navigation
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

-- Enable folding
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

-- Enable folding with the spacebar
vim.keymap.set("n", "<Space>", "za")


-- Highlight bad whitespace
vim.cmd.highlight({ "BadWhitespace", "ctermbg=red guibg=red" })

-- Set tab/space/indent settings for each filetype
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "Snakefile,*.smk",
    command =
    "set filetype=snakemake"
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" },
    { pattern = "*.py,*.pyw,*.c,*.h", command = "match BadWhitespace /\\s\\+$/"
    })
vim.api.nvim_create_autocmd("FileType",
    { pattern = "python", command = "setlocal ts=4 sts=4 sw=4 tw=79 et ai ff=unix" })
vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "setlocal ts=2 sts=2 sw=2 et ai ff=unix" })
vim.api.nvim_create_autocmd("FileType",
    { pattern = "snakemake", command = "setlocal ts=4 sts=4 sw=4 tw=79 et ai ff=unix" })
vim.api.nvim_create_autocmd("FileType", { pattern = "html", command = "setlocal ts=2 sts=2 sw=2 et ai ff=unix" })
vim.api.nvim_create_autocmd("FileType", { pattern = "css", command = "setlocal ts=2 sts=2 sw=2 et ai ff=unix" })
vim.api.nvim_create_autocmd("FileType", { pattern = "sh", command = "setlocal ts=2 sts=2 sw=2 et ai ff=unix" })
vim.api.nvim_create_autocmd("FileType", { pattern = "yaml", command = "setlocal ts=2 sts=2 sw=2 et ai ff=unix" })

-- Autorun snakefmt on save
vim.api.nvim_create_autocmd("FileType",
    { pattern = "snakemake", command = "autocmd BufWritePre <buffer> execute ':Snakefmt'" })
