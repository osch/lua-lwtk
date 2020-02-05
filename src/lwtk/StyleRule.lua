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

local StyleRule = {}

function StyleRule.checkValue(patternString, value)
    local t = type(value)
    if t ~= "number" and t ~= "string" and t ~= "boolean" and t ~= "function" then
        local ok = pcall(function()
            return 0.5 * value + value
        end)
        if not ok then
            errorf("Unsupported style value for rule pattern %q: %s", patternString, tostring(value))
        end
    end
    return value
end

local checkValue = StyleRule.checkValue

function StyleRule.toPattern(patternString, value)
    if find(patternString, "^%!") then
        return sub(patternString, 2), checkValue(patternString, value)
    else
        local p = lower(patternString)
        local invalidChar = match(p, "[^a-zA-Z0-9_*@:+]")
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
        if find(paramName, "%+") then
            errorf("Invalid style rule pattern %q: parameter name contains invalid character %q", 
                   patternString, "+")
        end
        paramName = gsub(paramName, "%*", ".*")
        if classPath then
            if find(classPath, "%+") then
                errorf("Invalid style rule pattern %q: class name contains invalid character %q", 
                       patternString, "+")
            end
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
        return "^"..paramName.."@"..classPath..":"..statePath.."$", checkValue(patternString, value)
    end
end

return StyleRule
