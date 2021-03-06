---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by stira.
--- DateTime: 13.05.20 15:00
---
-- Grab environment
local awesome = awesome
local gdebug = require("gears.debug")

local utils = {}

local fallback = {
  --black
  color0 = '#000000',
  color8 = '#465457',
  --red
  color1 = '#cb1578',
  color9 = '#dc5e86',
  --green
  color2 = '#8ecb15',
  color10 = '#9edc60',
  --yellow
  color3 = '#cb9a15',
  color11 = '#dcb65e',
  --blue
  color4 = '#6f15cb',
  color12 = '#7e5edc',
  --purple
  color5 = '#cb15c9',
  color13 = '#b75edc',
  --cyan
  color6 = '#15b4cb',
  color14 = '#5edcb4',
  --white
  color7 = '#888a85',
  color15 = '#ffffff',
  --
  background  = '#0e0021',
  foreground  = '#bcbcbc',
  --
  focused_background  = '#0e0021',
  focused_foreground  = '#bcbcbc',
  --
  inactive_background  = '#0e0021',
  inactive_foreground  = '#bcbcbc',
}

function utils.get_current_theme()
  local keys = { 'background', 'foreground', 'focused_background', 'focused_foreground', 'inactive_background', 'inactive_foreground' }
  for i=0,15 do table.insert(keys, "color"..i) end
  local colors = {}
  for _, key in ipairs(keys) do
    local color = awesome.xrdb_get_value("", key)
    if color then
      if color:find("rgb:") then
        color = "#"..color:gsub("[a]?rgb:", ""):gsub("/", "")
      end
    else
      gdebug.print_warning(
        "beautiful: can't get colorscheme from xrdb for value '"..key.."' (using fallback)."
      )
      color = fallback[key]
    end
    colors[key] = color
  end
  return colors
end

return utils
