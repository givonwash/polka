return {
    ---@param opts { vault: string }
    ---@return nil
    setup = function(opts)
        local obsidian = require 'obsidian'

        opts.vault = vim.fs.normalize(opts.vault)

        obsidian.setup {
            dir = opts.vault,
            completion = { nvim_cmp = true },
            ---@param title string
            ---@return string
            note_id_func = function(title)
                local time = tostring(os.time())

                if title ~= nil then
                    return time .. title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
                else
                    return time .. 'untitled'
                end
            end,
        }

        require('core.autocmds').define_group('ObsidianVaultSetup', {
            {
                event = 'BufEnter',
                opts = {
                    ---@param args { file: string }
                    callback = function(args)
                        local file = args.file

                        if file:find('^' .. opts.vault) ~= nil then
                            require('core.keymaps').define {
                                n = {
                                    ['gf'] = {
                                        cmd = function()
                                            if obsidian.util.cursor_on_markdown_link() then
                                                return '<cmd>ObsidianFollowLink<cr>'
                                            else
                                                return 'gf'
                                            end
                                        end,
                                        opts = { buffer = true, expr = true, silent = false },
                                    },
                                },
                            }
                        end
                    end,
                    pattern = '*.md',
                },
            },
        })
    end,
}
