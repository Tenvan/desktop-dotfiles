---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by stira.
--- DateTime: 13.05.20 11:14
---

-- Standard Definitions
require("definitions")

-- Standard awesome library
local awful                             = require("awful")
awful.rules                             = require("awful.rules")
local tyrannical                        = require("tyrannical")

-- First, set some settings
tyrannical.settings.default_layout      = awful.layout.suit.tile.left
tyrannical.settings.master_width_factor = 0.66

-- Setup some tags
tyrannical.tags                         = {
  {
    name      = tag_Develop,
    init      = true,
    exclusive = false,
    screen    = 1,
    -- clone_on  = 2, -- Create a single instance of this tag on screen 1, but also show it on screen 2
    -- The tag can be used on both screen, but only one at once
    layout    = awful.layout.suit.max,
    class     = {
      "jetbrains-webstorm",
      "jetbrains-rider",
      "jetbrains-datagrip",
      "Kate",
      "KDevelop",
      "Codeblocks",
      "Code::Blocks",
      "DDD",
      "kate4",
      "geany",
      "kruler"
    }

  },
  {
    name      = tag_DevConsole,
    init      = true, -- Load the tag on startup
    exclusive = false, -- Refuse any other type of clients (by classes)
    screen    = 2,
    layout    = awful.layout.suit.tile, -- Use the tile layout
    selected  = true,
    exec_once = {  },
    class     = { --Accept the following classes, refuse everything else (because of "exclusive=true")
    }
  },
  {
    name      = tag_Teams,
    init      = true,
    exclusive = true,
    screen    = 1,
    layout    = awful.layout.suit.max, -- Use the max layout
    exec_once = { "teams" },
    class     = {
      "Microsoft Teams - Preview",
    }
  },
  {
    name      = tag_Web,
    init      = true,
    exclusive = false,
    --icon        = "~net.png",                 -- Use this icon for the tag (uncomment with a real path)
    screen    = 2,
    layout    = awful.layout.suit.max, -- Use the max layout
    class     = {
      "Opera",
      "Firefox",
      "Rekonq",
      "Dillo",
      "Arora",
      "Chromium",
      "Google-chrome",
      "nightly",
      "minefield",
    }
  },
  {
    name      = tag_Admin,
    init      = false, -- Load the tag on startup
    exclusive = false, -- Refuse any other type of clients (by classes)
    screen    = 2,
    layout    = awful.layout.suit.tile, -- Use the tile layout
    selected  = true,
    class     = { --Accept the following classes, refuse everything else (because of "exclusive=true")
      --"xterm",
      --"urxvt",
      --"aterm",
      --"URxvt", "XTerm",
      --"konsole",
      --"terminator",
      --"gnome-terminal",
      --"alacritty",
    }
  },
  {
    name      = tag_Files,
    init      = false,
    exclusive = false,
    --icon      = "~net.png", -- Use this icon for the tag (uncomment with a real path)
    screen    = 2, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
    layout    = awful.layout.suit.tile,
    exec_once = { "dolphin" }, --When the tag is accessed for the first time, execute this command
    class     = {
      "Thunar",
      "Konqueror",
      "Dolphin",
      "ark",
      "Nautilus",
      "emelfm",
      "Krusader",
    }
  },
  {
    name      = tag_Divers,
    init      = false,
    exclusive = false,
    layout    = awful.layout.suit.max,
    class     = {
      "Assistant",
      "Okular",
      "Evince",
      "EPDFviewer",
      "xpdf",
      "Xpdf",
    }
  },
  {
    name      = tag_Media,
    init      = false,
    exclusive = false,
    layout    = awful.layout.suit.tile,
    class     = {
      "Spotify"
    }
  },
  {
    name      = tag_VM,
    init      = false,
    exclusive = false,
    screen    = 2, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
    layout    = awful.layout.suit.tile,
    class     = {
      "VirtualBox Manager",
      "VirtualBox Machine",
    }
  }, {
    name      = tag_Status,
    init      = false,
    exclusive = false,
    screen    = 2, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
    layout    = awful.layout.suit.tile,
    class     = {
      "Gnome-system-monitor"
    }
  },
}

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive         = {
  --"ksnapshot", "pinentry", "gtksu", "kcalc", "xcalc",
  --"feh", "Gradient editor", "About KDE", "Paste Special", "Background color",
  --"kcolorchooser", "plasmoidviewer", "Xephyr", "kruler", "plasmaengineexplorer",
}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating          = {
  --"MPlayer", "pinentry", "ksnapshot", "pinentry", "gtksu",
  --"xine", "feh", "kmix", "kcalc", "xcalc",
  --"yakuake", "Select Color$", "kruler", "kcolorchooser", "Paste Special",
  --"New Form", "Insert Picture", "kcharselect", "mythfrontend", "plasmoidviewer"
}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop             = {
  --"Xephyr", "ksnapshot", "kruler"
}

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered          = {
  --"kcalc"
}

-- Do not honor size hints request for those classes
tyrannical.properties.size_hints_honor  = { xterm = false, URxvt = false, aterm = false, sauer_client = false, mythfrontend = false }

return tyrannical
