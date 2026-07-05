local perf = require("perf")

local util       = require("mkdoc.util")
local class_util = require("mkdoc.class_util")

local append     = util.append
local addSet     = util.addSet
local addSetKey  = util.addSetKey
local addSetKey2 = util.addSetKey2

local lwtk          = require("lwtk")
local getMixinBase  = lwtk.get.mixinBase
local getObjectMeta = lwtk.get.objectMeta

local getClassModuleName = class_util.getClassModuleName

local member_scanner = {}

function member_scanner.scan(depOrderedModuleNames, moduleInfos, modules, classInfos, reverseLookup)

    perf.start"memberScan"

    do
        local function addMemberInfo(moduleInfo, memberName, member, class)
            -- for Mixins: class != module
            local moduleName = moduleInfo.moduleName
            local memberType = type(member)
            if memberType == "table" or memberType == "function" then
                local memberInfo = moduleInfo.memberInfos[memberName]
                if not memberInfo then
                    memberInfo = {
                        moduleName = moduleName,
                        isEntity = true,
                        memberName = memberName,
                        memberType = memberType,
                        member = member,
                        referringInfos = {},
                    }
                    if memberType == "function" then
                        if moduleInfo.memberFunctions then
                            addSetKey2(moduleInfo.memberFunctions, memberName, member, memberInfo)
                        end
                    end
                    local existingInfo = reverseLookup[member]
                    if not existingInfo then
                        reverseLookup[member] = memberInfo
                    else
                        if existingInfo.moduleName == moduleName then
                            error(require"inspect"{memberName, moduleName, existingInfo})
                        end
                        addSetKey(existingInfo.referringInfos, moduleName, memberInfo)
                        memberInfo.originalMemberInfo = existingInfo
                    end
                    addSetKey2(moduleInfo.memberInfos, memberName, member, memberInfo)
            
                    if memberType == "table" and not memberName:match("^__") and memberName ~= "implement"
                        and memberName ~= "override" and memberName ~= "declared" and memberName ~= "static"
                        and not getmetatable(member)
                    then
                        for k, v in pairs(member) do
                            -- members of the extra subtable are offered
                            -- implementations that subclasses adopt
                            -- explicitly under the plain member name
                            local nestedName = (memberName == "extra") and k or (memberName.."."..k)
                            addMemberInfo(moduleInfo, nestedName, v, nil)
                            if memberName == "extra" then
                                local info = moduleInfo.memberInfos[nestedName]
                                if info then
                                    info.isExtra = true
                                end
                            end
                        end
                    end
                else
                    assert(moduleInfo.isMixin)
                end
            else
                local memberInfo = moduleInfo.memberInfos[memberName]
                if not memberInfo then
                    memberInfo = {
                        moduleName = moduleName,
                        isValue = true,
                        memberName = memberName,
                        memberType = memberType,
                        member = member
                    }
                    addSetKey(moduleInfo.memberInfos, memberName, memberInfo)
                else
                    assert(moduleInfo.isMixin)
                    if memberType ~= memberInfo.memberType or member ~= memberInfo.member then
                        error(require"inspect"{moduleName, memberName, memberType, memberInfo.memberType, memberInfo})
                    end
                end
            end
        end
        local function addToInheritedMethods(inheritedMethods, memberName, class)
            local i = 0
            local s = class:getSuperClass()
            while s do
                i = i + 1
                local fromList = inheritedMethods[i]
                if not fromList then
                    fromList = { moduleName = getClassModuleName(s), isMixin = getMixinBase[s] }
                    inheritedMethods[i] = fromList
                end
                if s.declared[memberName] then
                    append(fromList, { moduleName = getClassModuleName(s),
                                       memberName = memberName })
                    break
                end
                s = s:getSuperClass()
            end
        end
        -- fields on the object metatable that do not denote static members
        local isReservedObjMetaName = util.SetFromList {
            "new", "declared", "static", "extra", "override", "implement"
        }
        for _, thisModuleName in ipairs(depOrderedModuleNames) do
            local thisModule     = modules[thisModuleName]
            local thisModuleInfo = moduleInfos[thisModuleName]
            local thisModuleType = type(thisModule)

            if thisModuleType == "table" and not thisModuleInfo.isPackage then
                local class = thisModuleInfo.isClass and thisModule
                if class then
                    local declared = class.declared
                    local inheritedMethods = thisModuleInfo.inheritedMethods
                    for memberName, member in pairs(thisModule) do
                        if declared[memberName] then
                            addMemberInfo(thisModuleInfo, memberName, member, class)
                        else
                            if type(member) == "function" and rawget(class.__index, memberName) then
                                addToInheritedMethods(inheritedMethods, memberName, class)
                            end
                        end
                    end
                    -- static members are only available in the class object
                    -- (e.g. MyClass:declare(...)), not in derived objects:
                    -- they are stored as fields directly on the object
                    -- metatable, outside of its __index table (see
                    -- staticMeta.__newindex in lwtk/Class.lua); statics
                    -- inherited from super classes are copied fields that
                    -- are not declared in this class
                    local objMeta = getObjectMeta[class]
                    if objMeta then
                        for k, v in pairs(objMeta) do
                            if type(k) == "string" and v ~= false
                               and not isReservedObjMetaName[k] and not k:match("^__")
                               and rawget(objMeta.__index, k) == nil
                            then
                                if declared[k] then
                                    local info = thisModuleInfo.memberInfos[k]
                                    if not info then
                                        addMemberInfo(thisModuleInfo, k, v, class)
                                        info = thisModuleInfo.memberInfos[k]
                                    end
                                    if info then
                                        info.isStatic = true
                                    end
                                else
                                    local inheritedStatics = thisModuleInfo.inheritedStatics
                                    if not inheritedStatics then
                                        inheritedStatics = {}
                                        thisModuleInfo.inheritedStatics = inheritedStatics
                                    end
                                    addToInheritedMethods(inheritedStatics, k, class)
                                end
                            end
                        end
                    end
                else
                    for memberName, member in pairs(thisModule) do
                        addMemberInfo(thisModuleInfo, memberName, member, nil)
                    end
                end
            elseif thisModuleType == "table" and thisModuleInfo.isPackage then
                -- packages cache lazily loaded submodules in their module table:
                -- collect only scalar members that are not modules themselves
                -- (e.g. lwtk.MOD_SHIFT, but not the cached lwtk._VERSION module)
                for memberName, member in pairs(thisModule) do
                    local memberType = type(member)
                    if memberType ~= "table" and memberType ~= "function"
                       and not moduleInfos[thisModuleName.."."..memberName]
                    then
                        addMemberInfo(thisModuleInfo, memberName, member, nil)
                    end
                end
            end

        end
    end
    do
        for _, thisModuleInfo in ipairs(classInfos) do
            local thisModuleName = thisModuleInfo.moduleName
            local thisModule     = modules[thisModuleName]
            for k, v in pairs(thisModule.__index) do
                local memberInfo = thisModuleInfo.memberInfos[k]
                if not memberInfo then
    --                error(require"inspect"{thisModuleName, k})
                end
                if type(v) == "function" then
                    if thisModule.declared[k] then
                        memberInfo.overrideList = class_util.getOverrideList(thisModule, k) -- TODO
                    end
                end
            end
        end
    end
    perf.stop"memberScan"
end

return member_scanner
