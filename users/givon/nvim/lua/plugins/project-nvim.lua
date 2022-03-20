return {
    ---@return nil
    setup = function()
        require("project_nvim").setup { detection_methods = { "pattern", "lsp" } }
        require("telescope").load_extension "projects"
    end
}
