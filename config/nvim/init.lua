-- Neovim configuration - kickstart.nvim features + personal customizations
-- Claude Code is the primary development tool; this adds comfort for direct use.

-- ── Nerd Font ─────────────────────────────────────────────────────
-- Fira Code Nerd Font is installed via Brewfile
vim.g.have_nerd_font = true

-- ── Leader key ────────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Options ───────────────────────────────────────────────────────

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.cursorline = true

-- Clipboard (scheduled for faster startup)
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split" -- live substitution preview

-- Editing
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.scrolloff = 8
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.confirm = true

-- Whitespace visualization
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Use ripgrep for :grep
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- ── Diagnostics ───────────────────────────────────────────────────

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
})

-- ── Keymaps ───────────────────────────────────────────────────────

local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Quick save/quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Diagnostics
map("n", "<leader>xq", vim.diagnostic.setloclist, { desc = "Diagnostic quickfix list" })

-- Split navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })

-- Center after jump
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Better Y
map("n", "Y", "y$")

-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Strip trailing whitespace
map("n", "<leader>xw", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd([[%s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, pos)
end, { desc = "Strip trailing whitespace" })

-- ── Autocommands ──────────────────────────────────────────────────

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Git commit authoring
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 72
    vim.opt_local.spell = true
    vim.opt_local.colorcolumn = "50,72"
    if vim.fn.line("$") == 1 or vim.fn.getline(1) == "" then
      vim.cmd("startinsert")
    end
  end,
})

-- File type indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "json", "yaml", "toml", "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- ── Bootstrap lazy.nvim ───────────────────────────────────────────

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then error("Error cloning lazy.nvim:\n" .. out) end
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ───────────────────────────────────────────────────────

require("lazy").setup({

  -- Auto-detect indentation
  { "NMAC427/guess-indent.nvim", opts = {} },

  -- Git signs in the gutter + hunk actions
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function bmap(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation between hunks
        bmap("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        bmap("n", "[h", function() gs.nav_hunk("prev") end, "Previous hunk")

        -- Hunk actions
        bmap("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        bmap("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        bmap("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        bmap("n", "<leader>hr", gs.reset_hunk, "Reset hunk")

        -- Visual mode stage/reset
        bmap("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selection")
        bmap("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selection")

        -- Buffer-level actions
        bmap("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        bmap("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        bmap("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        bmap("n", "<leader>hd", gs.diffthis, "Diff against index")
      end,
    },
  },

  -- Keybinding discovery
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { "<leader>s", group = "Search", mode = { "n", "v" } },
        { "<leader>t", group = "Toggle" },
        { "<leader>h", group = "Git Hunk", mode = { "n", "v" } },
        { "<leader>g", group = "Git" },
        { "<leader>x", group = "Diagnostics/Extras" },
      },
    },
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")

      -- Search keymaps (leader-s prefix)
      map("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
      map("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
      map("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
      map("n", "<leader>ss", builtin.builtin, { desc = "Search select Telescope" })
      map({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "Search current word" })
      map("n", "<leader>sg", builtin.live_grep, { desc = "Search by grep" })
      map("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
      map("n", "<leader>sr", builtin.resume, { desc = "Search resume" })
      map("n", "<leader>s.", builtin.oldfiles, { desc = "Search recent files" })
      map("n", "<leader>sc", builtin.commands, { desc = "Search commands" })
      map("n", "<leader><leader>", builtin.buffers, { desc = "Find buffers" })

      -- LSP-powered Telescope pickers (attached per buffer)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
        callback = function(event)
          local buf = event.buf
          map("n", "grr", builtin.lsp_references, { buffer = buf, desc = "Goto references" })
          map("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "Goto implementation" })
          map("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "Goto definition" })
          map("n", "grt", builtin.lsp_type_definitions, { buffer = buf, desc = "Goto type definition" })
          map("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Document symbols" })
          map("n", "gW", builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = "Workspace symbols" })
        end,
      })

      -- Search in current buffer
      map("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "Fuzzy search current buffer" })

      -- Live grep in open files
      map("n", "<leader>s/", function()
        builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
      end, { desc = "Search in open files" })

      -- Search neovim config files
      map("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "Search neovim files" })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "saghen/blink.cmp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local lsp_map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          lsp_map("grn", vim.lsp.buf.rename, "Rename")
          lsp_map("gra", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          lsp_map("grD", vim.lsp.buf.declaration, "Goto declaration")

          -- Highlight references on cursor hold
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/documentHighlight", event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- Toggle inlay hints
          if client and client:supports_method("textDocument/inlayHint", event.buf) then
            lsp_map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle inlay hints")
          end
        end,
      })

      -- Capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Language servers for the stack
      local servers = {
        ts_ls = {},
        pyright = {},
        eslint = {},
        svelte = {},
      }

      -- Ensure servers + tools are installed via Mason
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "lua_ls",    -- Lua language server
        "stylua",    -- Lua formatter
        "prettierd", -- JS/TS formatter
        "black",     -- Python formatter
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      -- Configure and enable servers
      for name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end

      -- Lua LS with Neovim runtime support
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath("config")
              and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
              return
            end
          end
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
          })
        end,
        settings = { Lua = {} },
      })
      vim.lsp.enable("lua_ls")
    end,
  },

  -- Auto-format on save
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then return nil end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        python = { "black" },
      },
    },
  },

  -- Autocompletion
  {
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then return end
          return "make install_jsregexp"
        end)(),
        opts = {},
      },
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
      },
      sources = { default = { "lsp", "path", "snippets" } },
      snippets = { preset = "luasnip" },
      fuzzy = { implementation = "lua" },
      signature = { enabled = true },
    },
  },

  -- Theme (match Ghostty)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        styles = { comments = {} }, -- no italics
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Side-by-side diff viewer and file history
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff view (working changes)" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history (current file)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "File history (repo)" },
      { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
    },
    opts = {},
  },

  -- Highlight TODO/FIXME/HACK in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Mini modules (textobjects, surround, statusline)
  {
    "nvim-mini/mini.nvim",
    config = function()
      -- Better around/inside textobjects (va), yinq, ci', etc.)
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (saiw), sd', sr)')
      require("mini.surround").setup()

      -- Toggle comments (gcc, gc + motion)
      require("mini.comment").setup()

      -- Auto-close brackets and quotes
      require("mini.pairs").setup()

      -- Statusline
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font })
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return "%2l:%-2v" end
    end,
  },

  -- Jump anywhere with s + 2 chars
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
    opts = {},
  },

  -- Syntax highlighting + code navigation
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "javascript", "typescript", "tsx", "svelte", "json", "yaml", "toml",
          "lua", "luadoc", "python", "markdown", "markdown_inline",
          "bash", "html", "css", "diff", "vim", "vimdoc", "query",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}, {
  ui = {
    border = "rounded",
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘", config = "🛠", event = "📅", ft = "📂",
      init = "⚙", keys = "🗝", plugin = "🔌", runtime = "💻",
      require = "🌙", source = "📄", start = "🚀", task = "📌", lazy = "💤 ",
    },
  },
})
