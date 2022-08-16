local function tryrequire(name)
    local ok, rslt1, rslt2 = pcall(function() return require(name) end)
    if ok then
        return rslt1, rslt2
    end
end

return tryrequire
