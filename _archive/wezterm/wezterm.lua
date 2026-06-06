local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

config = {
    font = wezterm.font("MesloLGS Nerd Font Mono"),
    -- font = wezterm.font("MesloLGS NF"),
    font_size = 16,
    enable_tab_bar = false,
    window_decorations = "RESIZE",
    window_close_confirmation = "NeverPrompt",
    automatically_reload_config = true,
    window_background_opacity = 0.9,
    macos_window_background_blur = 10,
    keys = {
        { key = "c", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
        { key = 'Space', mods = 'SHIFT|ALT', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
        { key = '!', mods = 'ALT', action = act.ActivateTab(4) },
        { key = '-', mods = 'ALT', action = act.DecreaseFontSize },
        { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
        { key = '1', mods = 'SHIFT|ALT', action = act.ActivateTab(4) },
        { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
        { key = '2', mods = 'SHIFT|ALT', action = act.ActivateTab(5) },
        { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
        { key = '3', mods = 'SHIFT|ALT', action = act.ActivateTab(6) },
        { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
        { key = '4', mods = 'SHIFT|ALT', action = act.ActivateTab(7) },
        { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
        { key = '5', mods = 'SHIFT|ALT', action = act.ActivateTab(8) },
        { key = '6', mods = 'ALT', action = act.ActivateTab(5) },
        { key = '6', mods = 'SHIFT|ALT', action = act.ActivateTab(9) },
        { key = '7', mods = 'ALT', action = act.ActivateTab(6) },
        { key = '7', mods = 'SHIFT|ALT', action = act.ActivateTab(10) },
        { key = '8', mods = 'ALT', action = act.ActivateTab(7) },
        { key = '8', mods = 'SHIFT|ALT', action = act.ActivateTab(11) },
        { key = '=', mods = 'ALT', action = act.IncreaseFontSize },
        -- { key = 'C', mods = 'ALT', action = act.ActivateCopyMode },
        { key = 'H', mods = 'ALT', action = act.SplitPane{ command = { domain =  'CurrentPaneDomain' }, direction =  'Left', size = { Percent = (50) }, top_level = false } },
        { key = 'J', mods = 'ALT', action = act.SplitPane{ command = { domain =  'CurrentPaneDomain' }, direction =  'Down', size = { Percent = (50) }, top_level = false } },
        { key = 'K', mods = 'ALT', action = act.SplitPane{ command = { domain =  'CurrentPaneDomain' }, direction =  'Up', size = { Percent = (50) }, top_level = false } },
        { key = 'L', mods = 'ALT', action = act.SplitPane{ command = { domain =  'CurrentPaneDomain' }, direction =  'Right', size = { Percent = (50) }, top_level = false } },
        { key = 'V', mods = 'ALT', action = act.PasteFrom 'PrimarySelection' },
        { key = 'W', mods = 'ALT', action = act.CloseCurrentTab{ confirm = false } },
        { key = '[', mods = 'ALT', action = act.ActivateTabRelative(-1) },
        { key = ']', mods = 'ALT', action = act.ActivateTabRelative(1) },
        { key = '_', mods = 'ALT', action = act.ResetFontSize },
        { key = 'c', mods = 'ALT', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
        { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
        { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
        { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
        { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
        { key = 'p', mods = 'ALT', action = act.ActivateCommandPalette },
        { key = 'q', mods = 'ALT', action = act.QuitApplication },
        { key = 'r', mods = 'ALT', action = act.ResetTerminal },
        { key = 't', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'v', mods = 'ALT', action = act.PasteFrom 'Clipboard' },
        { key = 'w', mods = 'ALT', action = act.CloseCurrentPane{ confirm = false } },
    },
    key_tables = {
        copy_mode = {
            { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
            { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
            -- { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
            { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
            { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
            { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
            { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
            { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
            { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
            { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
            { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
            { key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
            { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
            { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
            { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
            { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
            { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
            { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
            { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
            { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
            { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
            { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
            { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
            { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
            { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
            { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
            { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
            { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
            { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
            { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
            { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
            { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
            { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
            { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
            { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
            { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
            { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
            { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
            { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
            { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
            { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
            { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
            { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
            { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
            { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
            { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
            { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
            { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
            { key = 's', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
            { key = 's', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
            { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
            { key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
            { key = 'Enter', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
            { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
            { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
            { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
            { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
            { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
            { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
            { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
            { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
            { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
            { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
        },   
        search_mode = {
            { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
            { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
            { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
            { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
            { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
            { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
            { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
            { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
            { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
            { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
        },   
    },
}

--- Color scheme

config.color_scheme = "Dracula"
config.colors = {
    foreground = "#c0c0c0",
    background = "#1c1c1c",
    cursor_bg = "#ffffff",
    cursor_border = "#ffffff",
    cursor_fg = "#000000",
    selection_bg = "#444444",
    selection_fg = "#ffffff",
    -- Define ANSI colors
    ansi = {
        "#000000", -- Color 0: Black
        "#ff5555", -- Color 1: Red
        "#50fa7b", -- Color 2: Green
        "#f1fa8c", -- Color 3: Yellow
        "#bd93f9", -- Color 4: Blue
        "#ff79c6", -- Color 5: Magenta
        "#8be9fd", -- Color 6: Cyan
        "#bbbbbb", -- Color 7: White
    },
    brights = {
        "#44475a", -- Color 8: Bright Black (Gray)
        "#ff6e6e", -- Color 9: Bright Red
        "#69ff94", -- Color 10: Bright Green
        "#ffffa5", -- Color 11: Bright Yellow
        "#d6acff", -- Color 12: Bright Blue
        "#ff92df", -- Color 13: Bright Magenta
        "#a4ffff", -- Color 14: Bright Cyan
        "#ffffff", -- Color 15: Bright White
    },
}

return config