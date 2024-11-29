local screen = {}

-- API function to clear the screen except the current line
function screen.clearExcept()
    -- Get the current cursor position
    local x, y = term.getCursorPos()
    
    -- Get the size of the terminal
    local w, h = term.getSize()

    -- Clear all lines above the current line
    for i = 1, y - 1 do
        term.setCursorPos(1, i)
        term.clearLine()
    end

    -- Clear all lines below the current line
    for i = y + 1, h do
        term.setCursorPos(1, i)
        term.clearLine()
    end

    -- Move the cursor back to its original position
    term.setCursorPos(x, y)
end

return screen
