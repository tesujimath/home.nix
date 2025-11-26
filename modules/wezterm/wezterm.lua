local wezterm = require "wezterm"
local config = wezterm.config_builder()
local act = wezterm.action

--config.debug_key_events = true

config.front_end = "WebGpu"

-- default shell is Fish
config.default_prog = { "/bin/sh", "--login", "-c", "fish"}

config.font = wezterm.font_with_fallback {
  "SF Mono",
  "Consolas",
}
config.font_size = 10.0

--config.color_scheme = "Solarized Dark Higher Contrast"
-- config.color_scheme = "SpaceGray Eighties Dull"
config.color_scheme = "catppuccin-mocha"

local preferredSchemes = "Dark"
config.selection_word_boundary = " \t\n{}[]()\"'`│"

-- action to rename a tab
-- https://wezterm.org/config/lua/keyassignment/PromptInputLine.html
local rename_tab = wezterm.action_callback(function(window, pane)
  local current_title = window:active_tab():get_title()

  window:perform_action(
    act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'New tab name' },
      },
      --initial_value = current_title, -- only available in nightly builds
      action = wezterm.action_callback(function(win, p, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          win:active_tab():set_title(line)
        end
      end),
    },
    pane
  )
end)

---cycle through builtin dark schemes in dark mode,
---and through light schemes in light mode
local function themeCycler(window, offset)

  local allSchemes = wezterm.color.get_builtin_schemes()
  local currentMode = wezterm.gui.get_appearance()
  local currentScheme = window:effective_config().color_scheme
  local darkSchemes = {}
  local lightSchemes = {}

  local dark_count = 0
  local light_count = 0
  for name, scheme in pairs(allSchemes) do
    local bg = wezterm.color.parse(scheme.background or "#000") -- parse into a color object
    ---@diagnostic disable-next-line: unused-local
    local h, s, l, a = bg:hsla() -- and extract HSLA information
    if l < 0.4 then
      --wezterm.log_info("Found dark scheme " .. name)
      dark_count = dark_count + 1
      table.insert(darkSchemes, name)
    else
      --wezterm.log_info("Found light scheme " .. name)
      light_count = light_count + 1
      table.insert(lightSchemes, name)
    end
  end

  table.sort(darkSchemes)
  table.sort(lightSchemes)
  --wezterm.log_info("Total " .. dark_count .. " dark schemes and " .. light_count .. " light schemes ")

  -- currentMode doesn't seem to work, so we hard-code a preference in preferredSchemes
  local schemesToSearch = preferredSchemes:find("Dark") and darkSchemes or lightSchemes

  local count = 0
  for i = 1, #schemesToSearch, 1 do
    if schemesToSearch[i] == currentScheme then
      wezterm.log_info("Found " .. currentScheme .. " at " .. i)
      local overrides = window:get_config_overrides() or {}

      i_next = (i + #schemesToSearch + offset) % #schemesToSearch
      overrides.color_scheme = schemesToSearch[i_next]
      wezterm.log_info("Switched to: " .. schemesToSearch[i_next] .. " at " .. i_next)

      window:set_config_overrides(overrides)
      return
    end
    count = count + 1
  end
  wezterm.log_info("Failed to find current theme: " .. currentScheme .. " in " .. count .. " themes")
end

local function themeUpCycler(window, _)
  themeCycler(window, 1)
end

local function themeDownCycler(window, _)
  themeCycler(window, -1)
end

config.keys = {

  -- toggle fullscreen with standard macOS shortcut key, and remove default binding for this
  { key = 'f', mods = 'CTRL|SUPER', action = act.ToggleFullScreen },
  { key = 'Enter', mods = 'ALT', action = act.DisableDefaultAssignment },

  -- rename tab, keybinding like tmux
  { key = '<', mods = 'SHIFT|CTRL', action = rename_tab },

  -- Theme Cycler
  -- Look up scheme you switched to with CTRL-SHIFT-L
  { key = 't', mods = 'ALT', action = wezterm.action_callback(themeUpCycler) },
  { key = 't', mods = 'ALT|SHIFT', action = wezterm.action_callback(themeDownCycler) },

  -- don't steal Emacs undo
  { key = '-', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
  { key = '_', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
}

return config
