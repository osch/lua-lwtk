local function extract(table, key)
    if table then
        local value = table[key]
        table[key] = nil
        return value
    end
end
return extract
