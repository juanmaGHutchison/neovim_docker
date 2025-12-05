local flash = require("flash")

flash.setup({
    modes = {
        search = { enabled = true },
        char = { jump_labels = true },
    },
})

vim.keymap.set( {"n","x","o"}, "<leader>/", function()
    flash.jump({
        search = { multi_line = true, forward = true, wrap = true },
        highlight = { backdrop = true },
    })
end, { desc = "Flash Search Whole Buffer" })

