local button = require("button")
os.pullEvent = os.pullEventRaw
local pos = {0, 0}
w, h = term.getSize()

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

-- Function to compare vectors (tables)
local function compareVectors(v1, v2)
    return v1[1] == v2[1] and v1[2] == v2[2]
end

-- Function to clamp position so it stays within menu bounds
local function clampPosition(pos)
    -- Clamp the x-value (horizontal)
    if pos[1] < 0 then
        pos[1] = 0
    elseif pos[1] > w then
        pos[1] = w
    end

    -- Clamp the y-value (vertical)
    if pos[2] > 0 then
        pos[2] = 0
    elseif pos[2] < -3 then
        pos[2] = -3
    end

    return pos
end

-- Function to add vectors
local function addv(v1, v2)
    return {v1[1] + v2[1], v1[2] + v2[2]}
end

-- Function to update time display
local function updateTime()
    while true do
        local time = textutils.formatTime(os.time(), true)  -- 24-hour format
        term.setCursorPos(1, 1)
        term.clearLine()
        term.write("singularity OS [v1.0b] " .. time)
        sleep(1)  -- Sleep for 1 second before updating again
    end
end

-- Function to print centered text
local function center()
    x = w / 2
    y = h / 2
end

-- Function to draw the menu
local function drawMenu()
    term.setCursorPos(1, 2)
    shell.run("id")

    term.setCursorPos(w - 11, 1)
    if compareVectors(pos, {0, 0}) then
        term.write("System")
    elseif compareVectors(pos, {0, -1}) then
        term.write("Terminal")
    elseif compareVectors(pos, {0, -2}) then
        term.write("Programs")
    elseif compareVectors(pos, {0, -3}) then
        term.write("Shutdown")
    end
end

-- GUI
term.clear()
local function drawFrontend()
    center()
    term.setCursorPos(x - 4, y - 2)
    print("Start Menu")
    button.make("[System]", " System ", {0, 0}, pos, x - 4, y)
    button.make("[Terminal]", " Terminal ", {0, -1}, pos, x - 4, y + 1)
    button.make("[Programs]", " Programs ", {0, -2}, pos, x - 4, y + 2)
    button.make("[Shutdown]", " Shutdown ", {0, -3}, pos, x - 4, y + 3)
end

-- Start a parallel thread to update the time while drawing the menu
parallel.waitForAny(
    function()
        drawMenu()
        drawFrontend()

        while true do
            local event, key = os.pullEvent("key")
            local move = LookupMove[key]

            -- Add vectors if move is valid
            if move ~= nil and move ~= "Enter" then
                pos = clampPosition(addv(pos, move))
                drawMenu()
                drawFrontend()
            elseif move == "Enter" then
                break
            end
        end

        term.clear()

        -- Conditions
        if compareVectors(pos, {0, 0}) then
            shell.run("os/.programs")
        elseif compareVectors(pos, {0, -1}) then
            term.clear()
            term.setCursorPos(1,1)
        elseif compareVectors(pos, {0, -2}) then
            shell.run("os/.programs")
        else
            os.shutdown()
        end
    end,
    updateTime -- This function will run in parallel and continuously update the time
)
