local lwtk = require"lwtk"

local rawget = rawget
local match  = string.match

local getObjectMeta = lwtk.get.objectMeta
local getSuperClass = lwtk.get.superClass
local getClass      = lwtk.get.class

local WeakKeysTable = lwtk.WeakKeysTable

local DO_CHECKS = not _G.LWTK_DISABLE_CHECKS

--[[
    Metatable for objects created by lwtk.newClass().
    
    See [lwtk.Class Usage](../../Class.md) for detailed documentation
    and usage examples.
]]
local Class = {}

Class.__name = "lwtk.Class"

function Class:__tostring()
    if self.__name then
        return "lwtk.Class<"..self.__name..">"
    else
        return "lwtk.Class"
    end
end


local metaCall = lwtk.Meta.__call

function Class:__call(...)
    local objMeta = getObjectMeta[self]
    return metaCall(objMeta, ...)
end

local staticMeta = {}
local overrideMeta = {}
local implementMeta = {}

function Class:__index(k)
    local objMeta = getObjectMeta[self]
    local v = objMeta[k]
    if v ~= nil then
        return v
    end
    if k == "extra" then
        local extra = {}
        objMeta[k] = extra
        return extra
    elseif k == "static" then
        local static = {}
        getObjectMeta[static] = objMeta
        objMeta[k] = static
        return setmetatable(static, staticMeta)
    elseif k == "override" then
        local override = {}
        getObjectMeta[override] = objMeta
        objMeta[k] = override
        return setmetatable(override, overrideMeta)
    elseif k == "implement" then
        local implement = {}
        getObjectMeta[implement] = objMeta
        objMeta[k] = implement
        return setmetatable(implement, implementMeta)
    end
    if DO_CHECKS then
        lwtk.errorf("no member %q in class %s", k, self:getClassPath())
    end
end

local function raiseAlreadyDeclaredError(class, objMeta, k, msg)
    local c = getSuperClass[class]
    local m = getObjectMeta[c]
    while c do
        if m.declared[k] then
            msg = msg or ""
            if objMeta[k] == false then
                lwtk.errorf("member %q from class %q is already declared%s in superclass %q in class path %s", k, objMeta.__name, msg, m.__name, class:getClassPath())
            else
                lwtk.errorf("member %q from class %q is already defined%s in superclass %q in class path %s", k, objMeta.__name, msg, m.__name, class:getClassPath())
            end
        end
        c = getSuperClass[c]
        m = getObjectMeta[c]
    end
end

function Class:__newindex(k, v)
    if k == "declared" or k == "static" or k == "override" or k == "implement" then
        lwtk.errorf("member name %q no allowed", k)
    end
    local objMeta = getObjectMeta[self]
    local declared = objMeta.declared
    if DO_CHECKS and declared[k] then
        if objMeta[k] == false then
            lwtk.errorf("member %q already declared in class %s ", k, self:getClassPath())
        else
            lwtk.errorf("member %q already defined in class %s ", k, self:getClassPath())
        end
    end
    if DO_CHECKS and k ~= "extra" and objMeta[k] ~= nil  then
        raiseAlreadyDeclaredError(self, objMeta, k)
    end
    declared[k] = true
    if match(k, "^__") or k == "extra" or k == "new" then
        assert(k ~= "__index" and k ~= "__newindex" and k ~= "__name")
        -- accessible only from class, not from object
        objMeta[k] = v
    else
        local index = objMeta.__index
        -- accessible from object and class
        index[k] = v
        objMeta[k] = v
    end
end

local function cnext(t, i)
    local k, v = next(t, i)
    if k == "__metatable" then
        return next(t, k)
    else
        return k, v
    end
end

function Class:__pairs()
    return cnext, getObjectMeta[self], nil
end

function staticMeta:__index(k)
    local objMeta = getObjectMeta[self]
    local v = objMeta[k]
    if v and rawget(objMeta.__index, k) == nil then
        return v
    end
end

function staticMeta:__newindex(k, v)
    local objMeta = getObjectMeta[self]
    if k == "declared" or k == "static" or k == "override" or k == "implement" then
        lwtk.errorf("member name %q no allowed", k)
    end
    local declared = objMeta.declared
    if DO_CHECKS and declared[k] then
        if objMeta[k] == false then
            lwtk.errorf("member %q already declared in class %s ", k, getClass[objMeta]:getClassPath())
        else
            lwtk.errorf("member %q already defined in class %s ", k, getClass[objMeta]:getClassPath())
        end
    end
    declared[k] = true
    assert(k ~= "__index" and k ~= "__newindex" and k ~= "__name")
    if DO_CHECKS and rawget(objMeta.__index, k) ~= nil then
        raiseAlreadyDeclaredError(getClass[objMeta], objMeta, k, " as non static")
    end
    objMeta[k] = v
end

function overrideMeta:__newindex(k, v)
    if k == "declared" or k == "static" or k == "override" or k == "implement" then
        lwtk.errorf("member name %q no allowed", k)
    end
    local objMeta = getObjectMeta[self]
    local declared = objMeta.declared
    if DO_CHECKS and declared[k] then
        if objMeta[k] == false then
            lwtk.errorf("member %q already declared in class %s ", k, getClass[objMeta]:getClassPath())
        else
            lwtk.errorf("member %q already defined in class %s ", k, getClass[objMeta]:getClassPath())
        end
    end
    if objMeta[k] == nil then
        lwtk.errorf("cannot override member %q in class %q because it is not declared in class path %s", k, objMeta.__name, getClass[objMeta]:getClassPath())
    end
    declared[k] = true
    if match(k, "^__") or k == "extra" or k == "new" then
        assert(k ~= "__index" and k ~= "__newindex" and k ~= "__name")
        -- accessible only from class, not from object
        objMeta[k] = v
    else
        local index = objMeta.__index
        if DO_CHECKS and rawget(index, k) == nil then
            raiseAlreadyDeclaredError(getClass[objMeta], objMeta, k, " as static")
        end
        -- accessible from object and class
        index[k] = v
        objMeta[k] = v
    end
end

function overrideMeta:__index(k)
    local objMeta = getObjectMeta[self]
    local v = objMeta[k]
    if v and objMeta.declared[k] then
        return v
    end
end

function implementMeta:__index(k)
    local objMeta = getObjectMeta[self]
    local v = objMeta[k]
    if v and objMeta.declared[k] then
        local s = getSuperClass[getClass[objMeta]]
        if not s or getObjectMeta[k] == nil then
            return v
        end
    end
end

function implementMeta:__newindex(k, v)
    if k == "declared" or k == "static" or k == "override" or k == "implement" then
        lwtk.errorf("member name %q no allowed", k)
    end
    local objMeta = getObjectMeta[self]
    local declared = objMeta.declared
    if DO_CHECKS and declared[k] then
        if objMeta[k] == false then
            lwtk.errorf("member %q already declared in class %s ", k, getClass[objMeta]:getClassPath())
        else
            lwtk.errorf("member %q already defined in class %s ", k, getClass[objMeta]:getClassPath())
        end
    end
    if DO_CHECKS and objMeta[k] ~= false then
        if objMeta[k] == nil then
            lwtk.errorf("cannot implement member %q in class %q because it is not declared in class path %s", k, objMeta.__name, getClass[objMeta]:getClassPath())
        else
            raiseAlreadyDeclaredError(getClass[objMeta], objMeta, k)
        end
    end
    declared[k] = true
    if match(k, "^__") or k == "extra" or k == "new" then
        assert(k ~= "__index" and k ~= "__newindex" and k ~= "__name")
        -- accessible only from class, not from object
        objMeta[k] = v
    else
        local index = objMeta.__index
        if rawget(index, k) == nil then
            raiseAlreadyDeclaredError(getClass[objMeta], objMeta, k, " as static")
        end
        -- accessible from object and class
        index[k] = v
        objMeta[k] = v
    end
end

function Class.discard(class)
    local objectMeta = getObjectMeta[class]
    if objectMeta then
        WeakKeysTable.discard(objectMeta)
        for k, v in next, objectMeta do
            objectMeta[k] = nil
        end
    end
    WeakKeysTable.discard(class)
    for k, v in next, class do
        class[k] = nil
    end
end

return Class
