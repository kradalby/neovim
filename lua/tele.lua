local telescope = require("telescope")

telescope.load_extension('fzf')
telescope.load_extension('githubcoauthors')

require('neoclip').setup(
  {
    enable_persistent_history = true,
  }
)

local b = require("telescope.builtin")
local e = require('telescope').extensions
vim.keymap.set('n', '<leader><leader>', b.find_files, {})
vim.keymap.set('n', '<leader>fg', b.live_grep, {})
vim.keymap.set('n', '<leader>fb', b.buffers, {})
vim.keymap.set('n', '<leader>fh', b.help_tags, {})
vim.keymap.set('n', '<leader>ft', b.filetypes, {})
vim.keymap.set('n', '<leader>fk', b.keymaps, {})
vim.keymap.set('n', '<leader>p', e.neoclip.default, {})
vim.keymap.set('n', '<leader>ts', b.treesitter, {})

vim.api.nvim_create_user_command('Coauth', telescope.extensions.githubcoauthors.coauthors, {
  desc = 'Insert Co-authored-by lines from git authors'
})
