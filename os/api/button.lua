local button = {}

function button.make(True, False, Valset, Valin, x, y)
    term.setCursorPos(x, y)
    if type(Valset) ~= type(Valin) then
      print("error: types must match")
    elseif type(Valset) == "table" and type(Valin) == "table" then
        local function compareVectors(v1, v2)
            return v1[1] == v2[1] and v1[2] == v2[2]
        end
        if compareVectors(Valset, Valin) then
            print(True)
        else
            print(False)
        end
    elseif Valset == Valin then
      print(True)
    else
      print(False)
    end
end
return button
