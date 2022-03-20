return {
    ---@return nil
    setup = function()
        require("trouble").setup {
            mode = "document_diagnostics"
        }

        require("core.keymaps").define {
            n = {
                ["<leader>t"] = "<cmd>TroubleToggle<cr>"
            }
        }
    end
}
