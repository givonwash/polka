return {
    ---@return nil
    setup = function()
        require('dbtpal').setup {
            path_to_dbt_profiles_dir = vim.fn.environ().DBT_PROFILES_DIR,
        }
        require('core.keymaps').define {
            n = {
                ['<leader>fl'] = require('dbtpal.telescope').dbt_picker,
            },
        }
        require('telescope').load_extension 'dbtpal'
    end,
}
