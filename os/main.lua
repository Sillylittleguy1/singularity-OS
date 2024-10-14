term.clear()
local m = 1
local button = require("button")
os.pullEvent = os.pullEventRaw
local pos = {0, 0}
w, h = term.getSize()

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

local function compareVectors(v1, v2)
    return v1[1] == v2[1] and v1[2] == v2[2]
end

local function clampPosition(pos)
    if pos[1] < 0 then
        pos[1] = 0
    elseif pos[1] > 0 then
        pos[1] = 0
    end
    if pos[2] > 0 then
        pos[2] = 0
    elseif pos[2] < -3 - (m - 1) then
        pos[2] = -3 - (m - 1)
    end
    return pos
end

local function addv(v1, v2)
    return {v1[1] + v2[1], v1[2] + v2[2]}
end

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


local function center()
    x = w / 2
    y = h / 2
end

local function menus(n)
    if n == 1 then
        center()
        term.setCursorPos(x - 4, y - 2)
        print("Start Menu ")
        button.make("[System]", " System ", {0, 0}, pos, x - 4, y)
        button.make("[Terminal]", " Terminal ", {0, -1}, pos, x - 4, y + 1)
        button.make("[Programs]", " Programs ", {0, -2}, pos, x - 4, y + 2)
        button.make("[Shutdown]", " Shutdown    ", {0, -3}, pos, x - 4, y + 3)
        print("                                                          ")
      elseif n == 2 then
        center()
        term.setCursorPos(x - 4, y - 2)
        print("System Menu")
        button.make("[Update]", " Update ", {0, 0}, pos, x - 4, y)
        button.make("[Settings]", " Settings ", {0, -1}, pos, x - 4, y + 1)
        button.make("[Uninstall]", " Uninstall ", {0, -2}, pos, x - 4, y + 2)
        button.make("[Reboot api's]", " Reboot api's ", {0, -3}, pos, x - 4, y + 3)
        button.make("[<Back]", " <Back  ", {0, -4}, pos, x - 3, y + 4)
    end
end
parallel.waitForAny(
    function()
        while true do
            menus(m)
            local event, key = os.pullEvent("key")
            local move = LookupMove[key]
            if move ~= nil and move ~= "Enter" then
                pos = clampPosition(addv(pos, move))
            elseif move == "Enter" then
                if m == 1 then
                    if compareVectors(pos, {0, 0}) then
                        m = 2
                    elseif compareVectors(pos, {0, -1}) then
                        term.clear()
                        term.setCursorPos(1, 1)
                        break
                    elseif compareVectors(pos, {0, -2}) then
                        shell.run("programs/")
                    elseif compareVectors(pos, {0, -3}) then
                        os.shutdown()
                    end
                elseif m == 2 then
                    if compareVectors(pos, {0, 0}) then
                        shell.run("install.lua")
                    elseif compareVectors(pos, {0, -1}) then
                        shell.run("os/Settings")
                    elseif compareVectors(pos, {0, -2}) then
                        shell.run("os/Uninstall")
                    elseif compareVectors(pos, {0, -3}) then
                        shell.run("os/Reboot")
                    elseif compareVectors(pos, {0, -4}) then
                        m = 1
                    end
                end
                pos = {0, 0}
            end
        end
    end,
    updateTime
)
