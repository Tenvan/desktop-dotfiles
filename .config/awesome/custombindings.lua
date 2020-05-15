---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by stira.
--- DateTime: 13.05.20 10:57
---
-- Standard Definitions
require("definitions")
require("launcher")

-- Standard awesome library
local gears         = require("gears")
local awful         = require("awful")

-- Notification library
local naughty       = require("naughty")

-- Notification library
local hotkeys_popup = require("awful.hotkeys_popup")

-- awesome-cyclefocus, see: https://github.com/blueyed/awesome-cyclefocus/
local cyclefocus    = require('awesome-cyclefocus')

-- {{{ Key bindings
mycustomkeys        = gears.table.join(
--- system tools
  awful.key({ "Control", "Shift" }, "Escape",
            function()
              awful.spawn(guard)
            end,
            { description = "systemmonitor", group = "system" }
  ),

  awful.key({ "Control" }, "Escape",
            function()
              awful.spawn(tasks)
            end,
            { description = "taskmanager", group = "system" }
  ),

  awful.key({ modkey, "Control" }, "l",
            function()
              awful.spawn(screenlook)
            end,
            { description = "bildschirm sperren", group = "system" }
  ),

  awful.key({ modkey, "Control" }, "x",
            function()
              awful.spawn("xkill")
            end,
            { description = "kill app", group = "system" }
  ),

  awful.key({ modkey, "Control" }, "b",
            function()
              awful.spawn(terminal .. " --title='BMenu' -e bmenu")
            end,
            { description = "start BMenu", group = "system" }
  ),

  awful.key({ modkey }, "b",
            function()
              myscreen                 = awful.screen.focused()
              myscreen.mywibox.visible = not myscreen.mywibox.visible
            end,
            { description = "toggle statusbas", group = "awesome" }
  ),

--- cyclefocus
-- modkey+Tab: cycle through all clients.
  awful.key({ modkey }, "Tab",
            function(c)
              cyclefocus.cycle({ modifier = "Super_L" })
            end,
            { description = "cycle through all clients", group = "awesome" }),

-- modkey+Shift+Tab: backwards
  awful.key({ modkey, "Shift" }, "Tab",
            function(c)
              cyclefocus.cycle({ modifier = "Super_L" })
            end,
            { description = "cycle through all clients backwards", group = "awesome" }),

--- applications
  awful.key({ modkey }, "z",
            function()
              awful.spawn("rofi -show combi")
            end,
            { description = "main menu", group = "apps" }
  ),

  awful.key({ modkey, "Control" }, "F2",
            function()
              awful.spawn("rofi -show drun -location 2")
            end,
            { description = "top menu", group = "apps" }
  ),

  awful.key({ modkey, "Control" }, "w",
            function()
              awful.spawn("bwmenu --show-password -- -location 2")
            end,
            { description = "bitwarden", group = "apps" }
  ),

  awful.key({ modkey }, "F6",
            function()
              awful.spawn(browser)
            end,
            { description = "browser", group = "apps" }
  ),

  awful.key({ modkey }, "F3",
            function()
              awful.spawn(filemanager)
            end,
            { description = "filemanager", group = "apps" }
  ),

  awful.key({ modkey, "Control" }, "F3",
            function()
              awful.spawn(filemanager_root)
            end,
            { description = "filemanager (root)", group = "apps" }
  ),

-- screenshots
  awful.key({ "Control" }, "Print",
            function()
              awful.spawn("spectacle -g")
            end,
            { description = "open screenshot tool", group = "screenshot" }
  ),

  awful.key({  }, "Print",
            function()
              awful.spawn("spectacle -t -g")
            end,
            { description = "screenshot window under cursor", group = "screenshot" }
  ),

  awful.key({ modkey, "Shift" }, "Print",
            function()
              awful.spawn("spectacle -m -g")
            end,
            { description = "screenshot current screen", group = "screenshot" }
  ),

  awful.key({ modkey, "Control" }, "Print",
            function()
              awful.spawn("spectacle -r -c")
            end,
            { description = "screenshot from rect", group = "screenshot" }
  ),

-- expert features
  awful.key({ modkey, "Control" }, "c",
            function()
              awful.spawn(editor_cmd .. " " .. awesome.conffile)
            end,
            { description = "edit config", group = "expert" }
  ),

  awful.key({ modkey, "Control" }, "t",
            function()
              awful.spawn.easy_async_with_shell(
                "killall " .. composite,
                function()
                  naughty.notify({
                                   preset = naughty.config.presets.normal,
                                   title  = "Info!",
                                   text   = " picom killed.."
                                 })
                end
              )
            end
  ),

  awful.key({ modkey }, "t",
            function()
              awful.spawn.easy_async_with_shell(
                "killall " .. composite .. "; sleep 1;",
                function()
                  awful.spawn.easy_async_with_shell(
                    composite .. " --config ~/.config/compton-awesome.conf -b",
                    function()
                      naughty.notify({
                                       preset = naughty.config.presets.normal,
                                       title  = "Info!",
                                       text   = " picom restarted.."
                                     })

                    end)
                end
              )
            end,
            { description = "picom restart", group = "expert" }
  )
)

-- }}}

