local lwtk   = require"lwtk"

local match  = string.match
local lower  = string.lower
local gsub   = string.gsub
local errorf = lwtk.errorf

local StyleTypeAttributes = lwtk.StyleTypeAttributes

local TypeRule = {}

function TypeRule.toPattern(rule)
    local n = #rule
    assert(n >= 2, "array with at least one pattern and type entry expected")
    local result = {}
    for i = 1, n do
        local arg = rule[i]
        if StyleTypeAttributes[arg] then
            result[arg] = true
        else
            result[#result + 1] = arg
        end
    end
    for i = 1, #result - 1 do
        local patternString = result[i]
        if type(patternString) ~= "string" then
            errorf("Error in style type definition: unknown parameter %s", tostring(patternString))
        end
        local p = lower(patternString)
        local invalidChar = match(p, "[^a-zA-Z0-9_*]")
        if invalidChar then
            errorf("Error in type rule pattern %q: invalid character %q", patternString, invalidChar)
        end
        p = "^"..gsub(p, "%*", ".*").."$"
        result[i] = p
    end
    return result
end

return TypeRule
