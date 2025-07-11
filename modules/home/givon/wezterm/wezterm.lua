-- NOTE:
-- 1. theme is defined in wezterm/default.nix
-- 2. enable_wayland is defined in wezterm/default.nix

local wezterm = require 'wezterm'

return {
    -- theming
    bold_brightens_ansi_colors = false,
    colors = theme.colors,
    command_palette_bg_color = theme.colors.background,
    command_palette_fg_color = theme.colors.foreground,
    command_palette_font_size = theme.fonts.default_size,
    default_cursor_style = 'SteadyBar',
    font = wezterm.font(theme.fonts.monospace),
    font_size = theme.fonts.default_size,
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
    hide_mouse_cursor_when_typing = false,
    hide_tab_bar_if_only_one_tab = true,
    ui_key_cap_rendering = 'UnixLong',
    use_fancy_tab_bar = false,
    window_decorations = theme.window_decorations,

    -- keybindings
    disable_default_key_bindings = true,
    leader = { key = 'Space', mods = 'CTRL' },
    keys = {
        -- activate command palette
        { key = 'p', mods = 'LEADER', action = 'ActivateCommandPalette' },

        -- system clipboard
        { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action { CopyTo = 'Clipboard' } },
        { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action { PasteFrom = 'Clipboard' } },
        { key = 'v', mods = 'LEADER', action = 'ActivateCopyMode' },
        { key = 'q', mods = 'LEADER', action = 'QuickSelect' },

        -- font re-sizing
        { key = '-', mods = 'CTRL', action = 'DecreaseFontSize' },
        { key = '=', mods = 'CTRL', action = 'IncreaseFontSize' },
        { key = '0', mods = 'CTRL', action = 'ResetFontSize' },

        -- tab management
        {
            key = 'n',
            mods = 'LEADER',
            action = wezterm.action { SpawnTab = 'CurrentPaneDomain' },
        },
        {
            key = 'c',
            mods = 'LEADER|SHIFT',
            action = wezterm.action { CloseCurrentTab = { confirm = true } },
        },
        { key = 'j', mods = 'LEADER|CTRL', action = wezterm.action { MoveTabRelative = -1 } },
        { key = 'k', mods = 'LEADER|CTRL', action = wezterm.action { MoveTabRelative = 1 } },

        -- pane management
        {
            key = 'c',
            mods = 'LEADER',
            action = wezterm.action { CloseCurrentPane = { confirm = true } },
        },
        {
            key = "'",
            mods = 'LEADER',
            action = wezterm.action { SplitVertical = { domain = 'CurrentPaneDomain' } },
        },
        {
            key = ';',
            mods = 'LEADER',
            action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' } },
        },
        {
            key = 'h',
            mods = 'LEADER',
            action = wezterm.action { ActivatePaneDirection = 'Left' },
        },
        {
            key = 'j',
            mods = 'LEADER',
            action = wezterm.action { ActivatePaneDirection = 'Down' },
        },
        {
            key = 'k',
            mods = 'LEADER',
            action = wezterm.action { ActivatePaneDirection = 'Up' },
        },
        {
            key = 'l',
            mods = 'LEADER',
            action = wezterm.action { ActivatePaneDirection = 'Right' },
        },
        {
            key = 'm',
            mods = 'LEADER',
            action = wezterm.action { PaneSelect = { mode = 'MoveToNewWindow' } },
        },
        {
            key = 'r',
            mods = 'LEADER',
            action = wezterm.action { RotatePanes = 'Clockwise' },
        },
        {
            key = 'r',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.PromptInputLine {
                description = 'Enter new name for tab',
                action = wezterm.action_callback(function(window, _, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end),
            },
        },
        {
            key = 'r',
            mods = 'LEADER|SHIFT',
            action = wezterm.action { RotatePanes = 'CounterClockwise' },
        },
        {
            key = 's',
            mods = 'LEADER',
            action = wezterm.action { PaneSelect = { mode = 'Activate' } },
        },

        -- tab navigation (absolute forward)
        { key = '1', mods = 'LEADER', action = wezterm.action { ActivateTab = 0 } },
        { key = '2', mods = 'LEADER', action = wezterm.action { ActivateTab = 1 } },
        { key = '3', mods = 'LEADER', action = wezterm.action { ActivateTab = 2 } },
        { key = '4', mods = 'LEADER', action = wezterm.action { ActivateTab = 3 } },
        { key = '5', mods = 'LEADER', action = wezterm.action { ActivateTab = 4 } },
        { key = '6', mods = 'LEADER', action = wezterm.action { ActivateTab = 5 } },
        { key = '7', mods = 'LEADER', action = wezterm.action { ActivateTab = 6 } },
        { key = '8', mods = 'LEADER', action = wezterm.action { ActivateTab = 7 } },
        { key = '9', mods = 'LEADER', action = wezterm.action { ActivateTab = 8 } },
        { key = '0', mods = 'LEADER', action = wezterm.action { ActivateTab = 9 } },

        -- tab navigation (absolute backwards)
        { key = '1', mods = 'LEADER|SHIFT', action = wezterm.action { ActivateTab = -1 } },
        { key = '2', mods = 'LEADER|SHIFT', action = wezterm.action { ActivateTab = -2 } },
        { key = '3', mods = 'LEADER|SHIFT', action = wezterm.action { ActivateTab = -3 } },
        { key = '4', mods = 'LEADER|SHIFT', action = wezterm.action { ActivateTab = -4 } },
        { key = '5', mods = 'LEADER|SHIFT', action = wezterm.action { ActivateTab = -5 } },
        { key = '6', mods = 'LEADER|SHIFT', action = wezterm.action { ActivateTab = -6 } },
        { key = '7', mods = 'LEADER|SHIFT', action = wezterm.action { ActivateTab = -7 } },
        { key = '8', mods = 'LEADER|SHIFT', action = wezterm.action { ActivateTab = -8 } },
        { key = '9', mods = 'LEADER|SHIFT', action = wezterm.action { ActivateTab = -9 } },
        { key = '0', mods = 'LEADER|SHIFT', action = wezterm.action { ActivateTab = -10 } },

        -- tab navigation (relative)
        {
            key = 'j',
            mods = 'LEADER|SHIFT',
            action = wezterm.action { ActivateTabRelative = -1 },
        },
        {
            key = 'k',
            mods = 'LEADER|SHIFT',
            action = wezterm.action { ActivateTabRelative = 1 },
        },

        -- scrollback navigation
        {
            key = '/',
            mods = 'LEADER',
            action = wezterm.action { Search = { Regex = '' } },
        },
        { key = 'f', mods = 'LEADER', action = wezterm.action { ScrollByPage = -1 } },
        { key = 'b', mods = 'LEADER', action = wezterm.action { ScrollByPage = 1 } },

        -- scrollback management
        {
            key = 'l',
            mods = 'LEADER|SHIFT',
            action = wezterm.action { ClearScrollback = 'ScrollbackAndViewport' },
        },
    },

    -- misc
    enable_wayland = enable_wayland,
    switch_to_last_active_tab_when_closing_tab = true,
    warn_about_missing_glyphs = false,
}
