local utils = require("utils")

require("neo-tree").setup({
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_normal_mode_for_inputs = false,
    open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
    sort_case_insensitive = false,

    -- Window configuration
    window = {
        position = "left",
        width = 40,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            ["<space>"] = {
                "toggle_node",
                nowait = false,
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "cancel",
            ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = {
                "add",
                config = {
                    show_path = "none",
                },
            },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["i"] = "show_file_details",
        },
    },

    filesystem = {
        window = {
            mappings = {
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
                ["D"] = "fuzzy_finder_directory",
                ["#"] = "fuzzy_sorter",
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",
                ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
                ["oa"] = "avante_add_files",
                ["oc"] = { "order_by_created", nowait = false },
                ["od"] = { "order_by_diagnostics", nowait = false },
                ["og"] = { "order_by_git_status", nowait = false },
                ["om"] = { "order_by_modified", nowait = false },
                ["on"] = { "order_by_name", nowait = false },
                ["os"] = { "order_by_size", nowait = false },
                ["ot"] = { "order_by_type", nowait = false },
            },
            fuzzy_finder_mappings = {
                ["<down>"] = "move_cursor_down",
                ["<C-n>"] = "move_cursor_down",
                ["<up>"] = "move_cursor_up",
                ["<C-p>"] = "move_cursor_up",
            },
        },

        commands = {
            avante_add_files = function(state)
                local node = state.tree:get_node()
                local filepath = node:get_id()
                local relative_path = require("avante.utils").relative_path(filepath)

                local sidebar = require("avante").get()

                local open = sidebar:is_open()
                -- ensure avante sidebar is open
                if not open then
                    require("avante.api").ask()
                    sidebar = require("avante").get()
                end

                sidebar.file_selector:add_selected_file(relative_path)

                -- remove neo tree buffer
                if not open then
                    sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
                end
            end,
        },
    },

    buffers = {
        follow_current_file = {
            enabled = true,
        },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
            mappings = {
                ["bd"] = "buffer_delete",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
                ["oc"] = { "order_by_created", nowait = false },
                ["od"] = { "order_by_diagnostics", nowait = false },
                ["om"] = { "order_by_modified", nowait = false },
                ["on"] = { "order_by_name", nowait = false },
                ["os"] = { "order_by_size", nowait = false },
                ["ot"] = { "order_by_type", nowait = false },
            },
        },
    },

    git_status = {
        window = {
            position = "float",
            mappings = {
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
                ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
                ["oc"] = { "order_by_created", nowait = false },
                ["od"] = { "order_by_diagnostics", nowait = false },
                ["om"] = { "order_by_modified", nowait = false },
                ["on"] = { "order_by_name", nowait = false },
                ["os"] = { "order_by_size", nowait = false },
                ["ot"] = { "order_by_type", nowait = false },
            },
        },
    },
})

-- Key mapping to toggle Neo-tree (equivalent to Ctrl+N for NERDTree)
utils.map({ "", "<C-n>", ":Neotree toggle<CR>" })

-- Auto-commands to replicate NERDTree behavior
local autocmds = {
    NeoTree = {
        -- Auto-open Neo-tree on startup if no files were opened
        {
            "VimEnter",
            "*",
            [[lua if vim.fn.argc() == 0 and not vim.g.started_by_firenvim then vim.cmd('Startify | Neotree show') end]],
        },
    },
}

utils.create_augroups(autocmds)

-- File type highlighting setup for Neo-tree
-- Using highlight groups that work with Neo-tree
vim.cmd([[
  " Neo-tree file highlighting
  highlight NeoTreeFileNameJade guifg=green ctermfg=green
  highlight NeoTreeFileNameIni guifg=yellow ctermfg=yellow
  highlight NeoTreeFileNameMd guifg=#3366FF ctermfg=blue
  highlight NeoTreeFileNameYml guifg=yellow ctermfg=yellow
  highlight NeoTreeFileNameConfig guifg=yellow ctermfg=yellow
  highlight NeoTreeFileNameConf guifg=yellow ctermfg=yellow
  highlight NeoTreeFileNameJson guifg=yellow ctermfg=yellow
  highlight NeoTreeFileNameHtml guifg=yellow ctermfg=yellow
  highlight NeoTreeFileNameStyl guifg=cyan ctermfg=cyan
  highlight NeoTreeFileNameCss guifg=cyan ctermfg=cyan
  highlight NeoTreeFileNameCoffee guifg=red ctermfg=red
  highlight NeoTreeFileNameJs guifg=#ffa500 ctermfg=red
  highlight NeoTreeFileNamePhp guifg=#ff00ff ctermfg=magenta

  " Apply file type highlighting
  autocmd FileType neo-tree highlight clear NeoTreeFileName
  autocmd FileType neo-tree syntax match NeoTreeFileNameJade /.*\.jade$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameIni /.*\.ini$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameMd /.*\.md$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameYml /.*\.yml$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameYml /.*\.yaml$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameConfig /.*\.config$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameConf /.*\.conf$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameJson /.*\.json$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameHtml /.*\.html$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameStyl /.*\.styl$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameCss /.*\.css$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameCoffee /.*\.coffee$/
  autocmd FileType neo-tree syntax match NeoTreeFileNameJs /.*\.js$/
  autocmd FileType neo-tree syntax match NeoTreeFileNamePhp /.*\.php$/
]])
