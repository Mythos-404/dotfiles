require("ui"):setup()
require("folder-rules"):setup()

local mocha_palette = {
    rosewater = "#f5e0dc",
    flamingo = "#f2cdcd",
    pink = "#f5c2e7",
    mauve = "#cba6f7",
    red = "#f38ba8",
    maroon = "#eba0ac",
    peach = "#fab387",
    yellow = "#f9e2af",
    green = "#a6e3a1",
    teal = "#94e2d5",
    sky = "#89dceb",
    sapphire = "#74c7ec",
    blue = "#89b4fa",
    lavender = "#b4befe",
    text = "#cdd6f4",
    subtext1 = "#bac2de",
    subtext0 = "#a6adc8",
    overlay2 = "#9399b2",
    overlay1 = "#7f849c",
    overlay0 = "#6c7086",
    surface2 = "#585b70",
    surface1 = "#45475a",
    surface0 = "#313244",
    base = "#1e1e2e",
    mantle = "#181825",
    crust = "#11111b",
}

require("yatline"):setup({
    section_separator_open = "",
    section_separator_close = "",

    inverse_separator_open = "",
    inverse_separator_close = "",

    part_separator_open = "",
    part_separator_close = "",

    style_a = {
        fg = mocha_palette.mantle,
        bg_mode = {
            normal = mocha_palette.blue,
            select = mocha_palette.mauve,
            un_set = mocha_palette.red,
        },
    },
    style_b = { bg = mocha_palette.surface0, fg = mocha_palette.text },
    style_c = { bg = mocha_palette.mantle, fg = mocha_palette.text },

    permissions_t_fg = mocha_palette.green,
    permissions_r_fg = mocha_palette.yellow,
    permissions_w_fg = mocha_palette.red,
    permissions_x_fg = mocha_palette.sky,
    permissions_s_fg = mocha_palette.lavender,

    selected = { icon = "󰻭", fg = mocha_palette.yellow },
    copied = { icon = "", fg = mocha_palette.green },
    cut = { icon = "", fg = mocha_palette.red },

    total = { icon = "", fg = mocha_palette.yellow },
    succ = { icon = "", fg = mocha_palette.green },
    fail = { icon = "", fg = mocha_palette.red },
    found = { icon = "", fg = mocha_palette.blue },
    processed = { icon = "", fg = mocha_palette.green },

    prefix_color = mocha_palette.subtext0,
    branch_color = mocha_palette.sapphire,
    commit_color = mocha_palette.mauve,
    stashes_color = mocha_palette.pink,
    state_color = mocha_palette.maroon,
    staged_color = mocha_palette.yellow,
    unstaged_color = mocha_palette.peach,
    untracked_color = mocha_palette.teal,

    show_background = false,

    display_header_line = true,
    display_status_line = true,

    header_line = {
        left = {
            section_a = {
                { type = "line", custom = false, name = "tabs", params = { "left" } },
            },
            section_b = {},
            section_c = {},
        },
        right = {
            section_a = {},
            section_b = {
                { type = "coloreds", custom = false, name = "task_states" },
                { type = "coloreds", custom = false, name = "task_workload" },
            },
            section_c = {
                { type = "coloreds", custom = false, name = "count" },
            },
        },
    },

    status_line = {
        left = {
            section_a = {
                { type = "string", custom = false, name = "tab_mode" },
            },
            section_b = {
                { type = "string", custom = false, name = "hovered_size" },
            },
            section_c = {
                { type = "string", custom = false, name = "hovered_mime" },
            },
        },
        right = {
            section_a = {
                { type = "string", custom = false, name = "cursor_position" },
            },
            section_b = {
                { type = "string", custom = false, name = "cursor_percentage" },
            },
            section_c = {
                { type = "string", custom = false, name = "hovered_file_extension", params = { true } },
                { type = "coloreds", custom = false, name = "permissions" },
            },
        },
    },
})
