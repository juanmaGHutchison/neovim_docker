local lsp = require('lsp-zero')
local cmp = require('cmp')

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {'clangd'},
})

local cmp_select = {behaviour = cmp.SelectBehavior.Select}
local cmp_mappings = cmp.mapping.preset.insert({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

cmp.setup({
	mapping = cmp_mappings,
})

for _, type in ipairs({"Error", "Warn", "Hint", "Info"}) do
	vim.fn.sign_define("DiagnosticSign" .. type, { text = "", numhl = "" })
end

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", gcvim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>vws", gcvim.lsp.workspace_symbol, opts)
	vim.keymap.set("n", "<leader>vd", gcvim.lsp.open_float, opts)
	vim.keymap.set("n", "[d", gcvim.lsp.goto_next, opts)
	vim.keymap.set("n", "]d", gcvim.lsp.goto_prev, opts)
	vim.keymap.set("n", "<leader>vca", gcvim.lsp.code_action, opts)
	vim.keymap.set("n", "<leader>vrr", gcvim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>vrn", gcvim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<C-h>", gcvim.lsp.signature_help, opts)
end)

lsp.setup()

