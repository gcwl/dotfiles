-----------------------
-- Eve awesome theme --
-----------------------
local os = { getenv = os.getenv }

theme = {}

theme.font          = "ubuntu 9"

-- color resource
-- http://colllor.com/

--theme.bg_normal     = "#222222"
--theme.bg_normal     = "#f5f5f5"
--theme.bg_normal     = "#ebebeb"
theme.bg_normal     = "#e0e0e0"
--theme.bg_focus      = "#535d6c"
--theme.bg_focus      = "#e60e0e"
--theme.bg_focus      = "#f42815"
--theme.bg_focus      = "#d82818" -- red (*)
theme.bg_focus      = "#3A8DAB"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

--theme.fg_normal     = "#aaaaaa"
theme.fg_normal     = "#0a0a0a"
theme.fg_focus      = "#0a0a0a"
--theme.fg_focus      = "#e60e0e"
--theme.fg_focus      = "#e61c0b"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"




theme.border_width  = 2
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

local icon_dir   = os.getenv("HOME") .. "/.config/awesome/icons"
theme.icon_cpu   = icon_dir .. "/cpu_red.png"
theme.icon_temp  = icon_dir .. "/temp_red.png"
theme.icon_mem   = icon_dir .. "/mem_red.png"
theme.icon_fs    = icon_dir .. "/fs_red.png"
theme.icon_net   = icon_dir .. "/net_red.png"
theme.icon_netup = icon_dir .. "/netup_green.png"
theme.icon_netdn = icon_dir .. "/netdn_orange.png"
theme.icon_mail  = icon_dir .. "/mail_red.png"
theme.icon_chat  = icon_dir .. "/chat_red.png"
theme.icon_vol   = icon_dir .. "/vol_red.png"
theme.icon_cal   = icon_dir .. "/cal_red.png"
theme.icon_kb    = icon_dir .. "/kb_red.png"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- HACK: making bg/fg the same to hide titlebar text
theme.titlebar_bg_normal = "#e0e0e0"
theme.titlebar_bg_focus  = "#3A8DAB"
theme.titlebar_fg_normal = "#e0e0e0"
theme.titlebar_fg_focus  = "#3A8DAB"


-- Display the taglist squares
--theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
--theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"
theme.taglist_squares_sel   = icon_dir .. "/has_win.xbm"
theme.taglist_squares_unsel = icon_dir .. "/has_win_nv.xbm"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = 15
theme.menu_width  = 100

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"


-- Define the image to load
local titlebar_dir = os.getenv("HOME") .. "/.config/awesome/themes/eve/titlebar"

theme.titlebar_close_button_normal = titlebar_dir .. "/close_normal.png"
theme.titlebar_close_button_focus  = titlebar_dir .. "/close_focus.png"
--theme.titlebar_close_button_normal = icon_dir .. "/close.png"
--theme.titlebar_close_button_focus  = icon_dir .. "/close.png"

theme.titlebar_ontop_button_normal_inactive = titlebar_dir .. "/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = titlebar_dir .. "/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active   = titlebar_dir .. "/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active    = titlebar_dir .. "/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = titlebar_dir .. "/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = titlebar_dir .. "/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active   = titlebar_dir .. "/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active    = titlebar_dir .. "/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = titlebar_dir .. "/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = titlebar_dir .. "/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active   = titlebar_dir .. "/floating_normal_active.png"
theme.titlebar_floating_button_focus_active    = titlebar_dir .. "/floating_focus_active.png"
--theme.titlebar_floating_button_normal_inactive = icon_dir .. "/floating_inactive.png"
--theme.titlebar_floating_button_focus_inactive  = icon_dir .. "/floating_inactive.png"
--theme.titlebar_floating_button_normal_active   = icon_dir .. "/floating_active.png"
--theme.titlebar_floating_button_focus_active    = icon_dir .. "/floating_active.png"

theme.titlebar_maximized_button_normal_inactive = titlebar_dir .. "/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = titlebar_dir .. "/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = titlebar_dir .. "/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = titlebar_dir .. "/maximized_focus_active.png"

theme.wallpaper = "/usr/share/awesome/themes/default/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh      = "/usr/share/awesome/themes/default/layouts/fairh.png"
theme.layout_fairv      = "/usr/share/awesome/themes/default/layouts/fairv.png"
theme.layout_floating   = "/usr/share/awesome/themes/default/layouts/floating.png"
theme.layout_magnifier  = "/usr/share/awesome/themes/default/layouts/magnifier.png"
theme.layout_max        = "/usr/share/awesome/themes/default/layouts/max.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreen.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/default/layouts/tilebottom.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/default/layouts/tileleft.png"
theme.layout_tile       = "/usr/share/awesome/themes/default/layouts/tile.png"
theme.layout_tiletop    = "/usr/share/awesome/themes/default/layouts/tiletop.png"
theme.layout_spiral     = "/usr/share/awesome/themes/default/layouts/spiral.png"
theme.layout_dwindle    = "/usr/share/awesome/themes/default/layouts/dwindle.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
