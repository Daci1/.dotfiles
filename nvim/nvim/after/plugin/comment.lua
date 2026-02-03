local lineCommentShortcut = '<c-/>'
require('Comment').setup({
    toggler = {
        ---Line-comment toggle keymap
        line = lineCommentShortcut,
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = lineCommentShortcut,
        ---Block-comment keymap
    }
})

