return {
    {
        'DrKJeff16/project.nvim',
        name = 'project.nvim',
        config = function()
            require('project_nvim').setup()
            require('telescope').load_extension 'projects'
        end,
    },
}
