require("chrfesche.remap")

return {
            'terrortylor/nvim-comment',
            config = function()
                require('nvim_comment').setup({
                    -- Add any specific configuration options you want here
                    marker_padding = true,   -- adds padding between comment and text
                    comment_empty = false,   -- whether to comment out empty or whitespace-only lines
                    create_mappings = false,  -- allows gc (comment) mappings to be created
                })
                vim.keymap.set('n', keymaps.comment_toggle, ':CommentToggle<CR>', { noremap = true, silent = true })

                -- Visual mode: Toggle comment for the selected lines
                vim.keymap.set('v', keymaps.comment_toggle, ':CommentToggle<CR>', { noremap = true, silent = true })
            end,
        }


