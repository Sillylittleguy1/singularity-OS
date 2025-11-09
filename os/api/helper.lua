function compareVectors(v1, v2)
            return v1[1] == v2[1] and v1[2] == v2[2]
end
function clampPosition(pos, maxOptions)
    if pos[1] < 0 then pos[1] = 0 end
    if pos[1] > 0 then pos[1] = 0 end
    if pos[2] > 0 then pos[2] = 0 end
    if pos[2] < 0 - (maxOptions - 1) then pos[2] = 0 - (maxOptions - 1) end
    return pos
end

function addv(v1, v2)
    return {v1[1] + v2[1], v1[2] + v2[2]}
end

function center(width, height)
    return math.floor(width / 2), math.floor(height / 2)
end
