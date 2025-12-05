local lsp = require('lsp-zero')
local cmp = require('cmp')

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
        'clangd',
        'bashls',
        'jsonls',
        'yamlls',
    },
})

vim.lsp.config.bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
}
vim.lsp.enable 'bashls'
vim.diagnostic.config({
    virtual_text = {
        prefix = false,
        source = "always",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
})

vim.lsp.config.jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
}

vim.lsp.enable("jsonls")

vim.lsp.config.yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yml" },
    settings = {
        keyOrdering = false,
        format = { enable = true },
        hover = true,
        schemastore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json"
        },
    },
}

vim.lsp.enable("yamlls")

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

	vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
	vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
end)

lsp.setup()

