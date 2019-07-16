local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local naughty   = require("naughty")
local wibox     = require("wibox")


local Timer = {}
Timer.new = function(parent, ttl, id)
    local self = {}

    local parent = parent
    local ttl    = tonumber(ttl)        -- time-to-live in minutes (str)
    if not ttl then return end
    local tau    = tonumber(ttl) * 60   -- time-to-live in seconds (float)
    local timer  = gears.timer({ timeout = 1 })

    self.id      = id
    self.textbox = wibox.widget.textbox()

    local done = function()
        if timer.started then
            timer:stop()
        end
        parent.remove_timer(self)
    end

    local textmsg = function(tau, style)
        local style = style or false
        local fmt = style and " <b><span color='#d24e57'>%d:%02d</span></b> |" or " %d:%02d |"      -- rose pink
        -- local fmt = style and " <b><span color='#f89406'>%d:%02d</span></b> |" or " %d:%02d |"   -- orange
        -- local fmt = style and " <b><span color='#6c7a89'>%d:%02d</span></b> |" or " %d:%02d |"   -- darkblue grey
        mm = math.floor(tau / 60)
        ss = math.floor(math.fmod(tau, 60))
        return string.format(fmt, mm, ss)
    end

    timer:connect_signal("timeout", function()
        if tau > 0 then
            self.textbox:set_markup(textmsg(tau))
            tau = tau - 1
        else
            -- awful.spawn("timeout .1s speaker-test -t sine -f 777 &>/dev/null")
            naughty.notify({ title   = "Timer",
                             text    = string.format("%g %s timeout", ttl, ttl > 1 and "minutes" or "minute"),
                             timeout = 0,                           -- doesnt go away until someone clicks on it
                             font    = "Ubuntu Bold:size=30",       -- make it noticable
                             fg      = "#ececec",
                             bg      = "#F62459", })
            done()
        end
    end)

    local stop = function()
        naughty.notify({ title = "Timer", text = "Cancelled" })
        done()
    end

    local pause = function()
        if timer.started then
            timer:stop()
            self.textbox:set_markup(textmsg(tau, true))
        else
            timer:start()
            self.textbox:set_markup(textmsg(tau))
            tau = tau - 1
        end
    end

    self.textbox:buttons(awful.util.table.join(
        awful.button({}, 1, pause), -- left click
        awful.button({}, 3, stop)   -- right click
    ))

    timer:start()
    return self
end


local Countdown = {}
Countdown.new = function()
    local self = {}

    local id = 0

    local checkbox = wibox.widget {
        widget       = wibox.widget.checkbox,
        shape        = gears.shape.circle,
        checked      = false,
        check_color  = beautiful.fg_normal,
        border_color = beautiful.fg_normal,
        border_width = 3,
        paddings     = 3,
    }

    local prompt = awful.widget.prompt()

    local countdowns = wibox.widget { layout = wibox.layout.fixed.horizontal }  -- a placeholder for timer textboxes

    -- self.timers = {}     -- FIXME

    self.remove_timer = function(t)
        -- self.timers[t] = nil
        -- self.timers[t.id] = nil
        local ok = countdowns:remove_widgets(t.textbox)    -- TODO report if not ok
        if #countdowns.children == 0 then
            checkbox.checked = false
        end
    end

    self.add_timer = function()
        id = id + 1
        local cb = function(arg)
            local t = Timer.new(self, arg, id)
            if not t then return end
            -- self.timers[t] = true
            -- self.timers[t.id] = t
            local ok = countdowns:insert(1, t.textbox)     -- TODO report if not ok
            if not checkbox.checked then
                checkbox.checked = true
            end
        end
        awful.prompt.run({ prompt       = " Countdown mins: ",
                           textbox      = prompt.widget,
                           exe_callback = cb })
    end

    checkbox:buttons(awful.util.table.join(
        awful.button({}, 1, function() self.add_timer() end)    -- left click
    ))

    self.widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        checkbox,
        prompt,
        countdowns,
    }

    return self
end

return Countdown
