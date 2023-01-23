return {
    ---@param opts { vault: string }
    ---@return nil
    setup = function(opts)
        local obsidian = require 'obsidian'
        local keymaps = require 'core.keymaps'

        opts.vault = vim.fs.normalize(opts.vault)

        obsidian.setup {
            dir = opts.vault,
            completion = { nvim_cmp = true },
            ---@param title string
            ---@return string
            note_id_func = function(title)
                if title ~= nil then
                    if title:find '/' ~= nil then
                        local dirname = vim.fs.dirname(title)
                        local filename = (
                            vim.fs.basename(title):gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
                        )
                        return string.format('%s/%s', dirname, filename)
                    else
                        return title
                    end
                else
                    local date = os.date '%Y%m%d'
                    return date .. '-untitled'
                end
            end,
            notes_subdir = 'canvas',
        }

        keymaps.define {
            n = {
                ['<leader>fn'] = '<cmd>ObsidianSearch<cr>',
                ['<leader>nn'] = { cmd = ':ObsidianNew<space>', opts = { silent = false } },
            },
        }

        require('core.autocmds').define_group('ObsidianVaultSetup', {
            {
                event = 'BufEnter',
                opts = {
                    ---@param args { file: string }
                    callback = function(args)
                        local file = args.file

                        if file:find('^' .. opts.vault) ~= nil then
                            keymaps.define {
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
                                    ['<leader>nb'] = '<cmd>ObsidianBacklinks<cr>',
                                },
                                v = {
                                    ['<leader>nl'] = {
                                        cmd = ':ObsidianLink<space>',
                                        opts = { silent = false },
                                    },
                                    ['<leader>nn'] = {
                                        cmd = ':ObsidianLinkNew<space>',
                                        opts = { silent = false },
                                    },
                                },
                            }
                        end

                        vim.opt_local.linebreak = true
                        vim.opt_local.wrap = true
                    end,
                    pattern = '*.md',
                },
            },
        })
    end,
}
