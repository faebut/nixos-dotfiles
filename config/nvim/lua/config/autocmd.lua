-- Highlight yanked text on e.g. yy,yap etc.
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("weeheavy-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- https://github.com/LazyVim/LazyVim/discussions/654
vim.api.nvim_create_autocmd("FileType", {
	pattern = "terraform",
	callback = function()
		vim.bo.commentstring = "# %s"
	end,
})
