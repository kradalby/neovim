require("nix")
require("filetype")
require("completion")
require("format")
require("lint")
require("todo")
require("lsp")
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local keymap = vim.keymap

g.mapleader = " "

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 20

local indent = 4
require("tokyonight").setup({
  style = "night",
  transparent = true,
})
cmd "silent! colorscheme tokyonight"
cmd "set signcolumn=yes"

opt.expandtab = true    -- Use spaces instead of tabs
opt.shiftwidth = indent -- Size of an indent
opt.smartindent = true  -- Insert indents automatically
opt.tabstop = indent    -- Number of spaces tabs count for
opt.hidden = true                                                          -- Enable modified buffers in background
opt.ignorecase = true                                                      -- Ignore case
opt.joinspaces = false                                                     -- No double spaces with join after a dot
opt.scrolloff = 4                                                          -- Lines of context
opt.shiftround = true                                                      -- Round indent
opt.sidescrolloff = 8                                                      -- Columns of context
opt.smartcase = true                                                       -- Don't ignore case with capitals
opt.splitbelow = true                                                      -- Put new windows below current
opt.splitright = true                                                      -- Put new windows right of current
opt.termguicolors = true                                                   -- True color support
opt.wildmode = { "list", "longest" }                                       -- Command-line completion mode
opt.list = true                                                            -- Show some invisible characters (tabs...
opt.listchars = { tab = ">·", trail = "·", extends = ">", precedes = "<" } -- Show some invisible characters (tabs...
opt.number = true                                                          -- Print line number
opt.relativenumber = false                                                 -- Relative line numbers
opt.wrap = true                                                            -- Disable line wrap
opt.colorcolumn = "80"                                                     -- Show subtle line at 80 characters

keymap.set("n", "<leader>o", "m`o<Esc>``", {}) -- Insert a newline in normal mode

keymap.set('n', '<leader>ff', function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, {})

keymap.set("n", "<leader>h", vim.lsp.buf.hover, {})
keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
keymap.set("n", "<leader>a", vim.lsp.buf.code_action, {})
keymap.set("n", "<leader>f", vim.lsp.buf.references, {})
keymap.set("n", "<leader>s", vim.diagnostic.open_float, {})
keymap.set("n", "<leader>dn", function() vim.diagnostic.jump({ count = 1 }) end, {})
keymap.set("n", "<leader>dp", function() vim.diagnostic.jump({ count = -1 }) end, {})

keymap.set("n", "<leader>gc", "<cmd>:Coauth<cr>", {})

keymap.set("n", "<A-Up>", "<cmd>:tabnew<cr>", {})     -- Alt + Arrow Up, new tab
keymap.set("n", "<A-Left>", "<cmd>:tabprev<cr>", {})  -- Alt + Arrow Left, tab left
keymap.set("n", "<A-Right>", "<cmd>:tabnext<cr>", {}) -- Alt + Arrow Right, tab right
keymap.set("n", "<tab>", "<c-w>w", {})                -- tab, circular window shifting
keymap.set("n", "<S-tab>", "<c-w>W", {})              -- shift tab

keymap.set("i", "<D-c>", '<Esc>"+yi', {})
keymap.set("i", "<D-v>", '<Esc>"+pi', {})

require("tele")
require("plugins")
