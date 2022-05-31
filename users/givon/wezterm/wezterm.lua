-- NOTE:
-- 1. theme is defined in wezterm/default.nix
-- 2. enable_wayland is defined in wezterm/default.nix

local wezterm = require 'wezterm'

return {
    -- theming
    bold_brightens_ansi_colors = false,
    colors = theme.colors,
    default_cursor_style = 'SteadyBar',
    font = wezterm.font(theme.fonts.monospace),
    font_size = 13.0,
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
    hide_tab_bar_if_only_one_tab = true,
    window_frame = {
        font = wezterm.font(theme.fonts['sans-serif'], { weight = 'Bold' }),
        font_size = 13.0,
        active_titlebar_bg = theme.colors.tab_bar.active_tab.bg_color,
        inactive_titlebar_bg = theme.colors.tab_bar.inactive_tab.bg_color,
    },

    -- keybindings
    disable_default_key_bindings = true,
    leader = { key = 'Space', mods = 'CTRL' },
    keys = {
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
}
