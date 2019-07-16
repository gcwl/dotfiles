local os    = os
local math  = math
local lfs   = require("lfs")      -- $ pacman -S lua-filesystem
local gears = require("gears")

--module("random-wallpaper")

math.randomseed(os.time())

local wallpaper = {}
wallpaper.new = function(dirpath, ttl)
    local self = {}

    local dirpath = dirpath or os.getenv("HOME") .. "/Wallpaper"
    local ttl     = ttl or 300

    -- put collection of wallpapers into table
    local wallpapers = {}
    for f in lfs.dir(dirpath) do
        local filepath = dirpath .. "/" .. f
        if lfs.attributes(filepath).mode == "file" then
            table.insert(wallpapers, filepath)
        end
    end

    self.filepath = ""
    self.screen   = nil

    -- set wallpaper to given screen
    self.set_screen = function(screen)
        screen = screen or self.screen
        gears.wallpaper.maximized(self.filepath, screen)
    end

    -- randomly pick next wallpaper from collection
    self.next_wallpaper = function(screen)
        self.filepath = wallpapers[math.random(1, #wallpapers)]
        self.set_screen(screen)
    end

    -- periodic timer for switching wallpaper
    self.timer = gears.timer({ timeout = ttl })
    self.timer:connect_signal("timeout", function() self.next_wallpaper(nil) end)

    self.start = function(screen)
        self.screen = screen
        self.next_wallpaper(screen)
        self.timer:start()
    end

    return self
end

return wallpaper

-- local wallpaper = {}
-- wallpaper.new = function(dirpath, ttl)
--     local self = {}

--     local dirpath = dirpath or os.getenv("HOME") .. "/Wallpaper"
--     local ttl     = ttl or 300
--     local curr    = ""

--     -- put collection of wallpapers into table
--     local wallpapers = {}
--     for f in lfs.dir(dirpath) do
--         local filepath = dirpath .. "/" .. f
--         if lfs.attributes(filepath).mode == "file" then
--             table.insert(wallpapers, filepath)
--         end
--     end

    -- -- randomly pick a wallpaper and set to given screen
    -- local set_wallpaper = function(s)
    --     curr = wallpapers[math.random(1, #wallpapers)]
    --     gears.wallpaper.maximized(curr, s)
    -- end

    -- -- periodic timer for switching wallpaper
    -- local t = gears.timer({ timeout = ttl })
    -- t:connect_signal("timeout", function() set_wallpaper(s); t:again() end)

    -- self.set_screen = function(s)   -- set wallpaper for the given screen
    --     set_wallpaper(s)
    --     t:start()
    -- end

    -- self.currpath = function()      -- get current wallpaper's file path
    --     return curr
    -- end

    -- return self
-- end

-- return wallpaper
