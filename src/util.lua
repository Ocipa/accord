

local util = {}

function util.isEqual<T, S>(v1: T, v2: S): boolean
    if typeof(v1) ~= typeof(v2) then return false end
    if typeof(v1) ~= "table" then return v1 == v2 end

    local v1Key, _ = next(v1)
    local v2Key, _ = next(v2)

    repeat
        local key1Equal = util.isEqual(v1[v1Key], v2[v1Key])
        local key2Equal = util.isEqual(v2[v2Key], v1[v2Key])

        if key1Equal == false or key2Equal == false then return false end

        v1Key, _ = next(v1, v1Key)
        v2Key, _ = next(v2, v2Key)
    until not v1Key and not v2Key

    return true
end

return util