term.clear()
local button = require("api/button")
local screen = require("api/clear_exept")
os.pullEvent = os.pullEventRaw
local pos = {0, 0}
local w, h = term.getSize()

-- Time update flag
local keepUpdatingTime = true

-- Lookup table for movement
local LookupMove = {
    [keys.up] = {0, 1},
    [keys.down] = {0, -1},
    [keys.left] = {-1, 0},
    [keys.right] = {1, 0},
    [keys.w] = {0, 1},
    [keys.a] = {-1, 0},
    [keys.s] = {0, -1},
    [keys.d] = {1, 0},
    [keys.enter] = "Enter"
}

-- Define the menu system
local menu = {
    currentMenu = "start",  -- Start with the "start" menu
    menus = {
        start = {
            title = "Start Menu",
            options = {
                { label = "[System]", text = " System ", action = function() menu.currentMenu = "system" end },
                { label = "[Terminal]", text = " Terminal ", action = function() shell.run("programs/") end },
                { label = "[Programs]", text = " Programs ", action = function() shell.run("programs/") end },
                { label = "[Power]", text = " Power ", action = function() menu.currentMenu = "power" end }
            }
        },
        system = {
            title = "System Menu",
            options = {
                { label = "[Update]", text = " Update ", action = function() shell.run("os/install.lua") end },
                { label = "[Settings]", text = " Settings ", action = function() shell.run("os/Settings") end },
                { label = "[Uninstall]", text = " Uninstall ", action = function() shell.run("os/Uninstall") end },
                { label = "[Reboot api's]", text = " Reboot api's ", action = function() shell.run("os/Reboot") end },
                { label = "[<Back]", text = " <Back", action = function() menu.currentMenu = "start" end }
            }
        },
        power = {
            title = "Power",
            options = {
                { label = "[Shutdown]", text = " Shutdown ", action = function() os.shutdown() end },
                { label = "[reboot]", text = " reboot ", action = function() os.reboot() end },
                { label = "[<Back]", text = " <Back", action = function() menu.currentMenu = "start" end }
            }
        }
    }
}

-- Utility functions
local function compareVectors(v1, v2)
    return v1[1] == v2[1] and v1[2] == v2[2]
end

local function clampPosition(pos, maxOptions)
    if pos[1] < 0 then pos[1] = 0 end
    if pos[1] > 0 then pos[1] = 0 end
    if pos[2] > 0 then pos[2] = 0 end
    if pos[2] < 0 - (maxOptions - 1) then pos[2] = 0 - (maxOptions - 1) end
    return pos
end

local function addv(v1, v2)
    return {v1[1] + v2[1], v1[2] + v2[2]}
end

local function center()
    return math.floor(w / 2), math.floor(h / 2)
end

-- Time update function
local function updateTime()
    while true do
        local cx, cy = term.getCursorPos()
        local time = textutils.formatTime(os.time(), true) -- 24-hour format
        term.setCursorPos(1, 1)
        term.clearLine()
        term.write("singularity OS [v1.0b] " .. time)
        term.setCursorPos(cx, cy)
        sleep(1)
    end
end

-- Menu rendering function
local function renderMenu(menuId)
    local menuData = menu.menus[menuId]
    if not menuData then
        error("Menu not found: " .. menuId)
    end
    local x, y = center()
    term.setCursorPos(x - 4, y - 2)
    print(menuData.title)
    for i, option in ipairs(menuData.options) do
        button.make(option.label, option.text, {0, -(i - 1)}, pos, x - 4, y + i - 1)
    end
end

-- Main event loop
parallel.waitForAny(
    function()
        while true do
            term.setCursorPos(1, 1)
            screen.clearExcept()
            renderMenu(menu.currentMenu)
            local event, key = os.pullEvent("key")
            local move = LookupMove[key]
            if move ~= nil and move ~= "Enter" then
                pos = clampPosition(addv(pos, move), #menu.menus[menu.currentMenu].options)
            elseif move == "Enter" then
                local selectedOption = menu.menus[menu.currentMenu].options[math.abs(pos[2]) + 1]
                if selectedOption and selectedOption.action then
                    selectedOption.action()
                end
                pos = {0, 0}
            end
        end
    end,
    updateTime
)
