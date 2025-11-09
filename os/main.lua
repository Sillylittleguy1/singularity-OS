local menu = dofile("os/api/menu.lua")

local jsonString = [[
    {
        "menus": {
            "start": {
                "title": "Start Menu",
                "options": [
                    {
                        "text": "System",
                        "action": "return function(menu) menu.currentMenu = \"system\" end"
                    },
                    {
                        "text": "Terminal",
                        "action": "return function(menu) menu.active = false end"
                    },
                    {
                        "text": "Programs",
                        "action": "return function(menu) menu.run = \"programs\" end"
                    },
                    {
                        "text": "Power",
                        "action": "return function(menu) menu.currentMenu = \"power\" end"
                    }
                ]
            },
            "system": {
                "title": "System Menu",
                "options": [
                    {
                        "text": "Update",
                        "action": "return function(menu) menu.run = \"os/install.lua\" end"
                    },
                    {
                        "text": "Settings",
                        "action": "return function(menu) menu.run = \"os/Settings\" end"
                    },
                    {
                        "text": "Uninstall",
                        "action": "return function(menu) menu.run = \"os/Uninstall\" end"
                    },
                    {
                        "text": "Reboot api's",
                        "action": "return function(menu) menu.run = \"reboot\" end"
                    },
                    {
                        "text": "<Back",
                        "action": "return function(menu) menu.currentMenu = \"start\" end"
                    }
                ]
            },
            "power": {
                "title": "Power",
                "options": [
                    {
                        "text": "Sutdown",
                        "action": "return function(menu) os.shutdown() end"
                    },
                    {
                        "text": "Reboot",
                        "action": "return function(menu) os.reboot() end"
                    },
                    {
                        "text": "Log out",
                        "action": "return function(menu) os.shutdown() end"
                    },
                    {
                        "text": "<Back",
                        "action": "return function(menu) menu.currentMenu = \"start\" end"
                    }
                ]
            }
        }
    }
]]
-- Time update function
local function updateTime()
    while true do
        local cx, cy = term.getCursorPos()
        local time = textutils.formatTime(os.time(), true) -- 24-hour format
        term.setCursorPos(1, 1)
        term.clearLine()
        term.write("singularity OS [v1.1b] " .. time)
        term.setCursorPos(cx, cy)
        sleep(1)
    end
end

local menu1 = menu.make(jsonString)
parallel.waitForAny(
    function()
        while menu1.active and menu1.run == nil do
            menu.update(menu1)
        end
    end,
    updateTime
)
shell.run("clear")
shell.run(menu1.run)
