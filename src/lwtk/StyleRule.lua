local lwtk   = require"lwtk"

local find   = string.find
local match  = string.match
local sub    = string.sub
local lower  = string.lower
local gsub   = string.gsub
local gmatch = string.gmatch
local sort   = table.sort
local concat = table.concat
local errorf = lwtk.errorf
local type   = lwtk.type

local StyleRule = {}

function StyleRule.checkValue(patternString, paramName, value, typeList)
    for i = #typeList, 1, -1 do
        local rule = typeList[i]
        for j = #rule-1, 1, -1 do
            if match(paramName, rule[j]) then
                local t = type(value)
                if t ~= "function" and t ~= rule[#rule] then
                    errof("Illegal type for style rule pattern %q: expected %q but %q was given",
                          patternString, type(rule[#rule]), t)
                end
                return rule
            end
        end
    end
    errorf("Cannot deduce parameter type for style rule pattern %q", patternString)
end

local checkValue = StyleRule.checkValue

function StyleRule.toPattern(rule, typeList)
    local n = #rule
    local value = rule[n]
    local result = {}
    for i = 1, n - 1 do
        local patternString = rule[i]
        local p = lower(patternString)
        local invalidChar = match(p, "[^a-zA-Z0-9_*@:+()]")
        if invalidChar then
            errorf("Error in style rule pattern %q: invalid character %q", patternString, invalidChar)
        end
        local paramName, classPath, statePath = match(p, "^([^@:]*)@([^@:]*):([^@:]*)$")
        if not paramName then
            paramName, classPath = match(p, "^([^@:]*)@([^@:]*)$")
        end
        if not paramName then
            paramName, statePath = match(p, "^([^@:]*):([^@:]*)$")
        end
        if not paramName then
            paramName = match(p, "^([^@:]*)$")
        end
        if not paramName then
            errorf("Invalid style rule pattern: %q", patternString)
        end
        if paramName == "" then
            errorf("Invalid style rule pattern %q: parameter name is empty", patternString)
        end
        local invalid = match(paramName, "[+()]")
        if invalid then
            errorf("Invalid style rule pattern %q: parameter name contains invalid character %q", 
                   patternString, invalid)
        end
        paramName = gsub(paramName, "%*", ".*")
        if classPath then
            if find(classPath, "%+") then
                errorf("Invalid style rule pattern %q: class name contains invalid character %q", 
                       patternString, "+")
            end
            classPath = gsub(classPath, "%*", ".*")
            classPath = gsub(classPath, "[()]", "%%%0")
            classPath = ".*<"..classPath..">.*"
        else
            classPath = ".*"
        end
        if statePath and #statePath > 0 then
            local stateNames = {}
            local hasWildcard = false
            for statePattern, sep in gmatch(statePath, "([^+]*)(%+?)") do
                if statePattern == "" then
                    if sep == "+" then
                        errorf("Invalid style rule pattern %q: contains empty state name", patternString)
                    end
                elseif find(statePattern, "^%*+$") then
                    hasWildcard = true
                elseif find(statePattern, "%*") then
                    errorf("Invalid style rule pattern %q: state name must not contain wildcard %q",
                           patternString, "*")
                else
                    stateNames[#stateNames + 1] = statePattern
                end
            end
            sort(stateNames)
            if hasWildcard then
                if #stateNames > 0 then
                    statePath = ".*<"..concat(stateNames, ">.*<")..">.*"
                else
                    statePath = ".*"
                end
            else
                if #stateNames > 0 then
                    statePath = "<"..concat(stateNames, "><")..">"
                else
                    statePath = ""
                end
            end
        else
            statePath = ""
        end
        result[i] = "^"..paramName.."@"..classPath..":"..statePath.."$"
        local t = checkValue(patternString, paramName, value, typeList)
    end
    result.type = t
    result[n] = value
    return result
end

return StyleRule
