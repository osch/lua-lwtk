local lwtk = require"lwtk"

local insert       = table.insert
local getMixinBase = lwtk.get.mixinBase

local util = {}

function util.findDeclaratingSuperClass(thisClass, memberName)
    local s = thisClass:getSuperClass()
    while s do
        if s.declared[memberName] then
            return s
        end
        s = s:getSuperClass()
    end
end


function util.getClassModuleName(class)
    local name = class.__name
    local mixinBase = getMixinBase[class]
    if mixinBase then
        return mixinBase.__name
    else
        return name
    end

end
local getModuleName = util.getClassModuleName

function util.getOverrideList(thisClass, memberName)
    local rslt = {}
    local s = thisClass:getSuperClass()
    while s do
        if s.declared[memberName] then
            local overrideText = (s[memberName] == false) and "Implements" or "Overrides"
            local entry = { moduleName = getModuleName(s), overrideText = overrideText, isMixin = getMixinBase[s] and true }
            rslt[s.__name] = entry
            rslt[#rslt + 1] = entry
        end
        s = s:getSuperClass()
    end
    if #rslt > 0 then
        return rslt
    end
end    

function util.getSuperClassList(thisClass, endClass)
    local rslt = {}
    local s = thisClass:getSuperClass()
    while s do
        local entry = { moduleName = getModuleName(s), isMixin = getMixinBase[s] and true }
        rslt[#rslt + 1] = entry
        if endClass and s == endClass then
            break
        end
        s = s:getSuperClass()
    end
    return rslt
end

function util.getNonMixinSuperClassWithList(thisClass)
    local list = {}
    local s = thisClass:getSuperClass()
    while s do
        list[#list + 1] = s.__name
        if getMixinBase[s] == nil then
            return s, list
        end
        s = s:getSuperClass()
    end
end

function util.getClassPathList(thisClass, endClass)
    local rslt = {}
    local s = thisClass
    while s do
        local entry = { moduleName = getModuleName(s), isMixin = getMixinBase[s] and true }
        rslt[s.__name] = entry
        rslt[#rslt + 1] = entry
        if endClass and s == endClass then
            break
        end
        s = s:getSuperClass()
    end
    return rslt
end

function util.getReverseClassPathList(thisClass, endClass)
    local list = util.getClassPathList(thisClass, endClass)
    local rslt = {}
    local n = #list
    for i, e in ipairs(list) do
        rslt[n-i+1] = e
    end
    return rslt
end

function util.getReverseClassPathString(thisClass, endClass)
    local list = util.getClassPathList(thisClass, endClass)
    local rslt = {}
    local n = #list
    for i, e in ipairs(list) do
        rslt[n-i+1] = e.moduleName
    end
    return table.concat(rslt, "/")
end

function util.classPathListToString(list)
    local rslt = {}
    for i, e in ipairs(list) do
        rslt[i] = e.moduleName
    end
    return table.concat(rslt, "/")
end


function util.indent(indent, comment)
    local indentSting = string.rep(" ", indent)
    return comment:gsub("^", indentSting):gsub("\n", "\n"..indentSting)
end

function util.getArgListString(exp)
    if exp and exp.tag == "Function" then
        local argl = exp[1]
        local isMethod = (#argl >= 1 and argl[1][1] == "self")
        local rslt = {}
        for i = isMethod and 2 or 1, #argl do
            if argl[i].tag == "Dots" then
                rslt[#rslt + 1] = "..."
            else
                assert(argl[i].tag == "Id", require"inspect"{argl[i]})
                rslt[#rslt + 1] = argl[i][1]
            end
        end
        return table.concat(rslt, ", "), isMethod
    end
end


return util
