local MENUMANAGER = {}
dofile("os/api/helper.lua")
local json = dofile("os/packages/json.lua")
local button = dofile("os/api/button.lua")
local screen = dofile("os/api/clear_exept.lua")
local w, h = term.getSize()
local pos = {0, 0}
os.pullEvent = os.pullEventRaw
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

function MENUMANAGER.make(jsonString)
    local decoded = json.decode(jsonString)

    local result = {
        active = true,
        run = nil,
        currentMenu = "start",
        menus = {}
    }

    for menuName, menuData in pairs(decoded.menus) do
        local options = {}
        for _, option in ipairs(menuData.options) do
            table.insert(options, {
                label = "[" .. option.text .. "]",
                text = " " .. option.text .. " ",
                action = assert(load(option.action))()
            })
        end

        result.menus[menuName] = {
            title = menuData.title,
            options = options
        }
    end
    return result
end

local function renderMenu(menu, menuId)
    local menuData = menu.menus[menuId]
    if not menuData then
        error("Menu not found: " .. menuId)
    end
    local x, y = center(w, h)
    term.setCursorPos(x - 4, y - 2)
    print(menuData.title)
    for i, option in ipairs(menuData.options) do
        button.make(option.label, option.text, {0, -(i - 1)}, pos, x - 4, y + i - 1)
    end
end

function MENUMANAGER.update(menu)
    term.setCursorPos(1, 1)
    screen.clearExcept()
    renderMenu(menu, menu.currentMenu)
    local event, key = os.pullEvent("key")
    local move = LookupMove[key]
    if move and move ~= "Enter" then
        pos = clampPosition(addv(pos, move), #menu.menus[menu.currentMenu].options)
    elseif move == "Enter" then
        local selectedOption = menu.menus[menu.currentMenu].options[math.abs(pos[2]) + 1]
        if selectedOption and selectedOption.action then
            selectedOption.action(menu)
        end
        pos = {0, 0}
    end
end

return MENUMANAGER