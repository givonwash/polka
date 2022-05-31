return {
    ---@return nil
    setup = function()
        require("project_nvim").setup()
        require("telescope").load_extension "projects"
    end
}
