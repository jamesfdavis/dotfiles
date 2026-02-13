-- Neovim configuration - fast edits + git commit authoring
-- Claude Code is the primary development tool; this adds comfort for direct use.

-- ── Options ─────────────────────────────────────────────────────────

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.showmode = false

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Editing
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.scrolloff = 8
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Use ripgrep for :grep
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Leader key
vim.g.mapleader = " "

-- ── Keymaps ─────────────────────────────────────────────────────────

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Split navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Center after jump
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Better Y
map("n", "Y", "y$")

-- Strip trailing whitespace
map("n", "<leader>ss", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd([[%s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, pos)
end, { desc = "Strip whitespace" })

-- ── Git commit authoring ────────────────────────────────────────────

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 72
    vim.opt_local.spell = true
    vim.opt_local.colorcolumn = "50,72"
    -- Start in insert mode on first line if empty
    if vim.fn.line("$") == 1 or vim.fn.getline(1) == "" then
      vim.cmd("startinsert")
    end
  end,
})

-- ── File type settings ──────────────────────────────────────────────

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

-- ── Bootstrap lazy.nvim ─────────────────────────────────────────────

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ─────────────────────────────────────────────────────────

require("lazy").setup({
  -- Theme (match Ghostty)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search buffer" },
    },
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "javascript", "typescript", "json", "yaml", "toml",
          "lua", "python", "markdown", "bash", "html", "css",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}, { ui = { border = "rounded" } })
