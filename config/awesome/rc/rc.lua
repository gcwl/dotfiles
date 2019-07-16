-- https://awesomewm.org/apidoc/index.html



-- Context setup {{{
math.randomseed(os.time())
local home = os.getenv("HOME")

-- Numpad: [0-9] = [#90, #87-#89, #83-#85, #79-#81]
local numpad = { 87, 88, 89, 83, 84, 85, 79, 80, 81 }

local lfs  = require("lfs")                      -- $ pacman -S lua-filesystem

-- standard awesome libs
local gears = require("gears")
local gmath = require("gears.math")
local awful = require("awful")
require("awful.autofocus")

local wibox         = require("wibox")          -- widget and layout lib
local beautiful     = require("beautiful")      -- theme lib
local naughty       = require("naughty")        -- notification library
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys.vim")         -- enable VIM help for hotkeys widget when client with matching name is opened
-- local menubar       = require("menubar")        -- menubar
-- Context setup }}}



-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to another config
-- This code will only ever execute for the fallback config
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- Error handling }}}



-- {{{ Variable definitions
beautiful.init(home .. "/.config/awesome/themes/xresources/theme.lua")
require("remember-geometry")
local wallpaper = require("random-wallpaper").new(home .. "/Wallpaper")
local countdown = require("countdown").new()

-- Default modkey.
-- Mod4 : Super, Windows on PCs / Command ⌘ on Macs
-- Mod1 : Alt on PCs            / Option on Macs
modkey = "Mod4"

local fmt_datetime = "%a %Y-%m-%d | %H:%M:%S"

local term1    = "urxvt -fn 'xft:Ubuntu Mono:pixelsize=14'"
local term2    = "urxvt -fn 'xft:Ubuntu Mono:size=11' -g 120x60"
-- local term2    = "st -f 'Ubuntu Mono:size=12' -g 130x75"
local term3    = "st -f 'Monospace:size=14' -g 150x50"
local term4    = "xterm"
local terminal = term1

local screenlock = "i3lock -ef -c 148562"

local notepad     = "gedit"
local filemanager = "pcmanfm"
local fm_desktop  = "pcmanfm -n ~/Desktop"


-- layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
}
-- Variable definitions }}}



-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil
    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- Helper functions }}}



-- {{{ Menu
local menu_awesome = {{ "hotkeys", function() return false, hotkeys_popup.show_help end },
                      { "restart", awesome.restart },
                      { "logout", function() awesome.quit() end }}

local menu_wallpaper = {
    { "next", function() wallpaper.next_wallpaper(); wallpaper.timer:again()                end },
    { "info", function() naughty.notify({ title = "Wallpaper", text = wallpaper.filepath }) end },
}

local menu_screencapture = {
    { "rectangle", function () awful.spawn.with_shell("sleep 0.1 && screencapture --rect --no") end },
    { "window",    function () awful.spawn.with_shell("sleep 0.1 && screencapture --win  --no") end },
}

local menu_main = awful.menu({
    items = {{ "awesome", menu_awesome, beautiful.awesome_icon },
             { "terminal", terminal },
             { "file manager", filemanager },
             { "notepad", notepad },
             -- { "firefox", menu_firefox },
             -- { "chromium" , menu_chromium },
             -- { "jabber", "tkabber" },
             { "screenshot", menu_screencapture },
             { "screen recorder", "simplescreenrecorder" },
             { "wallpaper", menu_wallpaper },
             { "randr", "arandr" },
             { "sysinfo", "hardinfo" },

}})

local launcher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = menu_main })
-- Menu }}}



-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ textbox utils
local spacer = function(n, sep)             -- spacer
    local t = ""
    local sep = sep or " "
    for i = 1, n do t = t .. sep end
    return wibox.widget.textbox(t)
end

local separator = wibox.widget.textbox("|") -- separator
-- textbox utils }}}



-- {{{ Wibar

-- TODO https://awesomewm.org/apidoc/classes/wibox.widget.textclock.html
-- register mouse events for calendar popup
textclock = wibox.widget.textclock(fmt_datetime, 1)


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(awful.button({        }, 1, function(t) t:view_only() end),
                                         awful.button({ modkey }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
                                         awful.button({        }, 3, awful.tag.viewtoggle),
                                         awful.button({ modkey }, 3, function(t) if client.focus then client.focus:toggle_tag(t)  end end),
                                         awful.button({        }, 5, function(t) awful.tag.viewnext(t.screen) end),
                                         awful.button({        }, 4, function(t) awful.tag.viewprev(t.screen) end))


local tasklist_buttons = gears.table.join(
    awful.button({}, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end),
    awful.button({}, 3, client_menu_toggle_fn()),
    awful.button({}, 5, function () awful.client.focus.byidx( 1) end),
    awful.button({}, 4, function () awful.client.focus.byidx(-1) end))


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
if (wallpaper) then
    screen.connect_signal("property::geometry", wallpaper.set_screen)
end

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    if (wallpaper) then
        wallpaper.start(s)
    end

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(awful.button({}, 1, function () awful.layout.inc( 1) end),
                                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                                           awful.button({}, 5, function () awful.layout.inc( 1) end),
                                           awful.button({}, 4, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
            s.mytaglist,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            spacer(1),
            countdown.widget,
            spacer(1),
            textclock,
            spacer(1),
            launcher,
        },
    }
end)
-- Wibar}}}



-- {{{ Mouse bindings (on screen)
root.buttons(gears.table.join(awful.button({ }, 3, function () menu_main:toggle() end), -- right click
                              awful.button({ }, 4, awful.tag.viewprev),                 -- middle scroll up
                              awful.button({ }, 5, awful.tag.viewnext)))                -- middle scroll dn
-- Mouse bindings }}}



-- {{{ Key bindings
globalkeys = gears.table.join(

    --
    -- {{{{ group tag
    --
    awful.key({ modkey, "Control" }, "Right", awful.tag.viewnext,        {description = "view next tag", group = "tag"}),
    awful.key({ modkey, "Control" }, "Left",  awful.tag.viewprev,        {description = "view prev tag", group = "tag"}),
    awful.key({ modkey            }, "=",     awful.tag.viewnext,        {description = "view next tag", group = "tag"}),
    awful.key({ modkey            }, "-",     awful.tag.viewprev,        {description = "view prev tag", group = "tag"}),
    awful.key({ modkey            }, "`",     awful.tag.viewnext,        {description = "view next tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "`",     awful.tag.viewprev,        {description = "view prev tag", group = "tag"}),
    awful.key({ modkey, "Control" }, "`",     awful.tag.history.restore, {description = "jump to last viewed tag", group = "tag"}),
    awful.key({ modkey            }, "0",     awful.tag.history.restore, {description = "jump to last viewed tag", group = "tag"}),
    --
    -- group tag }}}}
    --

    --
    -- {{{{ group awesome
    --
    awful.key({ modkey            }, "Escape", function () menu_main:show() end, {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Control" }, "Delete", awesome.quit,                     {description = "quit awesome", group = "awesome"}),
    --
    -- group awesome }}}}
    --

    --
    -- {{{{ group launcher
    --
    awful.key({ modkey            }, "space",     function () awful.spawn("menubar")     end, {description = "show menubar", group = "launcher"}),
    awful.key({ modkey            }, "BackSpace", function () awful.spawn(screenlock)    end, {description = "screen lock", group = "launcher"}),
    awful.key({ modkey            }, "f", function () awful.spawn(notepad)               end, {description = "open notepad", group = "launcher"}),
    awful.key({ modkey            }, "d", function () awful.spawn.with_shell(fm_desktop) end, {description = "open file manager", group = "launcher"}),
    -- terminal emulator
    awful.key({ modkey            }, "a", function () awful.spawn(term1)                 end, {description = "open terminal", group = "launcher"}),
    awful.key({ modkey            }, "s", function () awful.spawn(term2)                 end, {description = "open terminal", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "a", function () awful.spawn(term4)                 end, {description = "open terminal", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "s", function () awful.spawn(term3)                 end, {description = "open terminal", group = "launcher"}),
    -- screencapture XXX sleep hack <<<<<<<<<<<<<<<<<
    awful.key({ modkey            }, "x", function () awful.spawn.with_shell("sleep 0.1 && screencapture --rect --no") end, {description = "screengrab rectangle", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "x", function () awful.spawn.with_shell("sleep 0.1 && screencapture --win  --no") end, {description = "screengrab window", group = "launcher"}),
    -- timer
    awful.key({ modkey            }, "c", function () countdown.add_timer()              end, {description = "countdown timer", group = "launcher"}),
    -- volume
    awful.key({ modkey            }, "v", function () awful.spawn("volume dn")           end, {description = "volume down", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "v", function () awful.spawn("volume up")           end, {description = "volume up", group = "launcher"}),
    awful.key({ modkey, "Control" }, "v", function () awful.spawn("volume toggle")       end, {description = "volume toggle", group = "launcher"}),
    --
    -- group launcher }}}}
    --

    --
    -- {{{{ group layout
    --
    awful.key({ modkey            }, ".", function () awful.tag.incmwfact( 0.01)          end, {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey            }, ",", function () awful.tag.incmwfact(-0.01)          end, {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, ".", function () awful.tag.incnmaster( 1, nil, true) end, {description = "increase number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, ",", function () awful.tag.incnmaster(-1, nil, true) end, {description = "decrease number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, ".", function () awful.tag.incncol( 1, nil, true)    end, {description = "increase number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, ",", function () awful.tag.incncol(-1, nil, true)    end, {description = "decrease number of columns", group = "layout"}),
    awful.key({ modkey            }, "/", function () awful.layout.inc( 1)                end, {description = "select next layout", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "/", function () awful.layout.inc(-1)                end, {description = "select prev layout", group = "layout"}),
    --
    -- group layout }}}}
    --

    --
    -- {{{{ group multihead (screen)
    --
    awful.key({ modkey            }, "q", function () awful.screen.focus_relative( 1) end, {description = "focus next screen", group = "multihead"}),
    awful.key({ modkey, "Shift"   }, "q", function () awful.screen.focus_relative(-1) end, {description = "focus prev screen", group = "multihead"}),
    --
    -- group multihead }}}}
    --

    --
    -- {{{{ group client
    --
    -- transparency/opacity (requires xcomgmgr)
    -- TODO see [client.opacity](https://awesomewm.org/apidoc/classes/client.html#client.opacity)
    awful.key({ modkey            }, "z",              function () awful.spawn("fade -d") end, {description = "increase opacity", group = "client"}),
    awful.key({ modkey, "Shift"   }, "z",              function () awful.spawn("fade -i") end, {description = "decrease opacity", group = "client"}),
    awful.key({ modkey, "Control" }, "z",              function () awful.spawn("fade -t") end, {description = "toggle opacity", group = "client"}),

    -- swap
    awful.key({ modkey, "Shift"   }, "k",              function () awful.client.swap.bydirection("up")    end, {description = "swap with client above", group = "client"}),
    awful.key({ modkey, "Shift"   }, "j",              function () awful.client.swap.bydirection("down")  end, {description = "swap with client below", group = "client"}),
    awful.key({ modkey, "Shift"   }, "h",              function () awful.client.swap.bydirection("left")  end, {description = "swap with client on left", group = "client"}),
    awful.key({ modkey, "Shift"   }, "l",              function () awful.client.swap.bydirection("right") end, {description = "swap with client on right", group = "client"}),
    awful.key({ modkey, "Shift"   }, "#" .. numpad[8], function () awful.client.swap.bydirection("up")    end, {description = "swap with client above", group = "client"}),
    awful.key({ modkey, "Shift"   }, "#" .. numpad[2], function () awful.client.swap.bydirection("down")  end, {description = "swap with client below", group = "client"}),
    awful.key({ modkey, "Shift"   }, "#" .. numpad[4], function () awful.client.swap.bydirection("left")  end, {description = "swap with client on left", group = "client"}),
    awful.key({ modkey, "Shift"   }, "#" .. numpad[6], function () awful.client.swap.bydirection("right") end, {description = "swap with client on right", group = "client"}),

    -- focus
    awful.key({ modkey            }, "k",              function () awful.client.focus.bydirection("up")    end, {description = "focus client above", group = "client"}),
    awful.key({ modkey            }, "j",              function () awful.client.focus.bydirection("down")  end, {description = "focus client below", group = "client"}),
    awful.key({ modkey            }, "h",              function () awful.client.focus.bydirection("left")  end, {description = "focus client on left", group = "client"}),
    awful.key({ modkey            }, "l",              function () awful.client.focus.bydirection("right") end, {description = "focus client on right", group = "client"}),
    awful.key({ modkey            }, "#" .. numpad[8], function () awful.client.focus.bydirection("up")    end, {description = "focus client above", group = "client"}),
    awful.key({ modkey            }, "#" .. numpad[2], function () awful.client.focus.bydirection("down")  end, {description = "focus client below", group = "client"}),
    awful.key({ modkey            }, "#" .. numpad[4], function () awful.client.focus.bydirection("left")  end, {description = "focus client on left", group = "client"}),
    awful.key({ modkey            }, "#" .. numpad[6], function () awful.client.focus.bydirection("right") end, {description = "focus client on right", group = "client"}),
    awful.key({ modkey            }, "Tab",            function () awful.client.focus.byidx( 1)            end, {description = "focus next client", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Tab",            function () awful.client.focus.byidx(-1)            end, {description = "focus prev client", group = "client"}),
    awful.key({ modkey, "Control" }, "Tab", function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end,
    {description = "jump to last focused", group = "client"}),

    -- restore minimized
    awful.key({ modkey, "Control" }, "n", function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            client.focus = c
            c:raise()
        end
    end,
    {description = "restore minimized", group = "client"})
    --
    -- group client }}}}
    --
)


local move_client_to_tag_by_offset = function(c, offset)
    local tags = c.screen.tags
    local tag0 = c.first_tag
    local tag1 = tags[gmath.cycle(#tags, tag0.index + offset)]
    c:move_to_tag(tag1)
    awful.tag.viewtoggle(tag0)   -- toggle OFF current tag
    awful.tag.viewtoggle(tag1)   -- toggle ON  next tag
    client.focus = c
    c:raise()
end


-- toggle maximize states: {normal, max-vertical, max-horizonal, max-both}
local toggle_maximize = function(c)
    if c.maximized then                 -- from max-both to normal
        c.maximized            = false
        c.maximized_vertical   = false
        c.maximized_horizontal = false
    elseif c.maximized_horizontal then  -- from max-hori to max-both
        c.maximized_horizontal = false
        c.maximized_vertical   = false
        c.maximized            = true
    elseif c.maximized_vertical then    -- from max-vert to max-hori
        c.maximized_vertical   = false
        c.maximized_horizontal = true
        c.maximized            = false
    else                                -- from normal to max-vert
        c.maximized_vertical   = true
        c.maximized_horizontal = false
        c.maximized            = false
    end
    c:raise()
end


clientkeys = gears.table.join(

    awful.key({ modkey            }, "m",    function (c) c.minimized = true end,                  {description = "minimize", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",    toggle_maximize,                                      {description = "toggle maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",    function (c) c.floating = not c.floating end,         {description = "toggle floating", group = "client"}),
    -- move floating client
    awful.key({ modkey          }, "Up",     function (c) c:relative_move(  0, -30, 0, 0) end,     {description = "move floater up", group = "client"}),
    awful.key({ modkey          }, "Down",   function (c) c:relative_move(  0,  30, 0, 0) end,     {description = "move floater down", group = "client"}),
    awful.key({ modkey          }, "Left",   function (c) c:relative_move(-30,   0, 0, 0) end,     {description = "move floater left", group = "client"}),
    awful.key({ modkey          }, "Right",  function (c) c:relative_move( 30,   0, 0, 0) end,     {description = "move floater right", group = "client"}),
    -- resize floating client
    awful.key({ modkey, "Shift" }, "Up",     function (c) c:relative_move(0, 0,   0, -30) end,     {description = "decrease floater height", group = "client"}),
    awful.key({ modkey, "Shift" }, "Down",   function (c) c:relative_move(0, 0,   0,  30) end,     {description = "increase floater height", group = "client"}),
    awful.key({ modkey, "Shift" }, "Left",   function (c) c:relative_move(0, 0, -30,   0) end,     {description = "decrease floater width", group = "client"}),
    awful.key({ modkey, "Shift" }, "Right",  function (c) c:relative_move(0, 0,  30,   0) end,     {description = "increase floater width", group = "client"}),
    -- move client to next/prev tag
    awful.key({ modkey, "Control" }, "Down", function (c) move_client_to_tag_by_offset(c,  1) end, {description = "move client to next tag", group = "client"}),
    awful.key({ modkey, "Control" }, "Up",   function (c) move_client_to_tag_by_offset(c, -1) end, {description = "move client to prev tag", group = "client"}),
    awful.key({ modkey, "Shift" }, "=",      function (c) move_client_to_tag_by_offset(c,  1) end, {description = "move client to next tag", group = "client"}),
    awful.key({ modkey, "Shift" }, "-",      function (c) move_client_to_tag_by_offset(c, -1) end, {description = "move client to prev tag", group = "client"})

)


-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end,
        { description = "view tag #"..i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
        { description = "move focused client to tag #"..i, group = "tag" }))
end


clientbuttons = gears.table.join(
    awful.button({        }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 2, toggle_maximize),
    awful.button({ modkey }, 3, awful.mouse.client.resize),
    awful.button({ modkey }, 4, function (c) move_client_to_tag_by_offset(c, -1) end),  -- bind to mouse scroll up
    awful.button({ modkey }, 5, function (c) move_client_to_tag_by_offset(c,  1) end))  -- bind to mouse scroll dn


-- Set keys
root.keys(globalkeys)

-- Key bindings }}}



-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule       = { },
        properties = { border_width = beautiful.border_width,
                       border_color = beautiful.border_normal,
                       focus        = awful.client.focus.filter,
                       raise        = true,
                       keys         = clientkeys,
                       buttons      = clientbuttons,
                       screen       = awful.screen.preferred,
                       placement    = awful.placement.no_overlap + awful.placement.no_offscreen }
    },

    -- rules for conky
    {
        rule       = { class     = "Conky" },
        properties = { sticky    = true,
                       -- opacity   = 0.4,
                       focusable = false,
                       ontop     = false },
    },

    -- -- Floating clients.
    -- { rule_any = {
    --     instance = {
    --       "DTA",  -- Firefox addon DownThemAll.
    --       "copyq",  -- Includes session name in class.
    --     },
    --     class = {
    --       "Arandr",
    --       "Gpick",
    --       "Kruler",
    --       "MessageWin",  -- kalarm.
    --       "Sxiv",
    --       "Wpa_gui",
    --       "pinentry",
    --       "veromix",
    --       "xtightvncviewer"},
    --     name = {
    --       "Event Tester",  -- xev.
    --     },
    --     role = {
    --       "AlarmWindow",  -- Thunderbird's calendar.
    --       "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
    --     }
    --   }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    {
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true },
    },
}
-- Rules }}}



-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(awful.button({}, 1, function() client.focus = c; c:raise(); awful.mouse.client.move(c) end),
                                     awful.button({}, 2, function() client.focus = c; c:raise(); toggle_maximize(c) end),
                                     awful.button({}, 3, function() client.focus = c; c:raise(); awful.mouse.client.resize(c) end),
                                     awful.button({}, 4, function() client.focus = c; c:raise(); move_client_to_tag_by_offset(c, -1) end),
                                     awful.button({}, 5, function() client.focus = c; c:raise(); move_client_to_tag_by_offset(c,  1) end))

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Signals }}}



-- {{{ autorun
awful.util.spawn_with_shell("~/.config/awesome/autorun.sh")
--- autorun }}}

