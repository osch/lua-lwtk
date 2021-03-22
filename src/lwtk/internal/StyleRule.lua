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
                    errorf("Illegal type for style rule pattern %q: expected %q but %q was given",
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
    local j = 1
    for i = 1, n - 1 do
        local patternString = rule[i]
        local p = lower(patternString)
        local invalidChar = match(p, "[^a-zA-Z0-9_*@:+().]")
        if invalidChar then
            errorf("Error in style rule pattern %q: invalid character %q", patternString, invalidChar)
        end
        local paramName, classPath, statePath, stateEnd = match(p, "^([^@:]*)@([^@:]*):([^@:]*)(:?)$")
        if not paramName then
            paramName, classPath = match(p, "^([^@:]*)@([^@:]*)$")
        end
        if not paramName then
            paramName, statePath, stateEnd = match(p, "^([^@:]*):([^@:]*)(:?)$")
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
        local classPathWithDot = false
        if classPath then
            if find(classPath, "%+") then
                errorf("Invalid style rule pattern %q: class name contains invalid character %q", 
                       patternString, "+")
            end
            local packageName, className = match(classPath, "^(.*)%.([^.]*)$")
            if packageName then
                classPathWithDot = true
                packageName = gsub(packageName,  "[.()]", "%%%0")
                className   = gsub(className,    "[()]",  "%%%0")
                packageName = gsub(packageName,  "%*", ".*")
                className   = gsub(className,    "%*", "[^.]*")
                if #packageName > 0 then
                    classPath   = packageName.."%."..className
                else
                    classPath   = className
                end
            else
                classPath = gsub(classPath, "[()]", "%%%0")
                classPath = gsub(classPath, "%*", "[^.]*")
            end
        end
        if statePath then
            if  #statePath > 0 then
                local stateNames = {}
                for statePattern, sep in gmatch(statePath, "([^+]*)(%+?)") do
                    if statePattern == "" then
                        if sep == "+" then
                            errorf("Invalid style rule pattern %q: contains empty state name", patternString)
                        end
                    elseif find(statePattern, "%*") then
                        errorf("Invalid style rule pattern %q: state name must not contain wildcard %q",
                               patternString, "*")
                    else
                        stateNames[#stateNames + 1] = statePattern
                    end
                end
                sort(stateNames)
                if stateEnd == "" then
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
            elseif stateEnd == ":" then
                statePath = ""
            else
                statePath =".*"
            end
        else
            statePath =".*"
        end
        if classPath then
            if not classPathWithDot then
                result[j] = "^"..paramName.."@.*<.*%."..classPath..">.*:"..statePath.."$"
                j = j + 1
            end
            result[j] = "^"..paramName.."@.*<"..classPath..">.*:"..statePath.."$"
        else
            result[j] = "^"..paramName.."@.*:"..statePath.."$"
        end
        j = j + 1
        local t = checkValue(patternString, paramName, value, typeList)
    end
    result.type = t
    result[j] = value
    return result
end

return StyleRule
