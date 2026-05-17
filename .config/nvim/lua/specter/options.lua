vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.showmode = false

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.smartindent = true
vim.o.breakindent = true

vim.o.swapfile = false
vim.o.undofile = true

vim.o.hlsearch = true
vim.o.incsearch = true

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.colorcolumn = '80'

vim.o.updatetime = 50

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.cursorline = true
-- vim.o.guicursor = 'i:block'

vim.o.scrolloff = 10

vim.o.confirm = true

-- autoread: automatically reload files changed outside Neovim.
-- REQUIRED for xcodebuild.nvim preview hot-reload to work.
-- When Swift code changes trigger a preview rebuild, the preview image file
-- is updated on disk; autoread ensures the buffer refreshes without prompting.
vim.o.autoread = true
