os.setlocale("C")

local path   = require("path")     -- https://luarocks.org/modules/xavier-wang/lpath
local fs     = require("path.fs")  -- https://luarocks.org/modules/xavier-wang/lpath
local perf   = require("perf")

local format = string.format

---------------------------------------------------------------------------------------------------------------------------

local function fprintf(file, ...)
    file:write(format(...))
end

local function printf(...)
    io.write(format(...))
end

local function append(t, v)
    t[#t + 1] = v
end

local function addSet(t, v)
    assert(not t[v])
    t[v] = true
    t[#t + 1] = v
end
    
local function add(t, k, v)
    assert(not t[k], k)
    assert(not t[v])
    t[k] = v
    t[v] = true
    t[#t + 1] = v
end

local function addr(t, k, v, r)
    assert(not t[k])
    assert(not t[v])
    assert(not t[r])
    t[k] = v
    t[v] = true
    t[r] = v
    t[#t + 1] = v
end

---------------------------------------------------------------------------------------------------------------------------

local ARGS = { ... }
local TRACE = (ARGS[1] == "trace") or false

fs.removedirs("../doc/gen")
fs.makedirs("../doc/gen/lwtk")

---------------------------------------------------------------------------------------------------------------------------

perf.start"directoryScan"

local moduleFileNames = {}
for n, t in fs.scandir("lwtk") do
    if t == "file" and path.isfile(n) then
        moduleFileNames[#moduleFileNames + 1] = n
    end
end

perf.stop"directoryScan"

---------------------------------------------------------------------------------------------------------------------------

perf.start"requireModules"

local reverseLookup = {}
local isPackage = {}
local toModuleFileName = {}
local packageInfos = {}
local moduleInfos = {}
local classInfos = {}
local mixinInfos = {}
local metaInfos = {}
local functionInfos = {}
local otherInfos = {}
local classMixinInfos = {}
local depOrderedModuleNames = {}
local modules = {}

---------------------------------------------------------------------------------------------------------------------------

local original_require = _G.require
do
    local moduleNames = {}
    
    for i, moduleFileName in ipairs(moduleFileNames) do
        local moduleName = moduleFileName:gsub("^(.*)%.lua$", "%1"):gsub("/", "."):gsub("%.init$", "")
        isPackage[moduleName] =  moduleFileName:match("%/init%.lua$") and true or false
        moduleNames[i] = moduleName
        toModuleFileName[moduleName] = moduleFileName
    end

    function _G.require(moduleName)
        local module = original_require(moduleName)
        if not moduleName:match("^lwtk") then
            return module
        end
        if not reverseLookup[module] then
            --printf("Loading %s\n", moduleName, )
            append(depOrderedModuleNames, moduleName)
            local isP = isPackage[moduleName]
            local moduleType = type(module)
            local packageName = moduleName:gsub("^(.*)%.[^.]+$", "%1")
            local isInternal =  moduleName:match("^lwtk%.internal") and true or false
            local moduleInfo = {
                moduleName = moduleName,
                docFileName = toModuleFileName[moduleName]:gsub("%.lua", ".md"),
                packageName = packageName,
                isInternal = isInternal,
                isModule = true,
                isPackage = isP,
                moduleType = moduleType,
                memberInfos = {},
                referringInfos = {}
            }
            reverseLookup[module] = moduleInfo
            addr(moduleInfos, moduleName, moduleInfo, module)
            if isP then
                add(packageInfos, moduleName, moduleInfo)
            end
            modules[moduleName] = module
        end
        return module
    end
    
    for _, moduleName in ipairs(moduleNames) do
        --printf("Requiring %s\n", moduleName)
        require(moduleName)
    end
end
_G.require = original_require
    
perf.stop"requireModules"

---------------------------------------------------------------------------------------------------------------------------

local lpeg   = require "lpeglabel" -- https://luarocks.org/modules/sergio-medeiros/lpeglabel
local re     = require("relabel")  -- https://luarocks.org/modules/sergio-medeiros/lpeglabel

local pprint = require("mkdoc.pprint")            -- modified version from: https://github.com/jagt/pprint.lua
local parser = require("mkdoc.lua-parser.parser") -- modified version from: https://github.com/andremm/lua-parser
local comments = require("mkdoc.comments")
local util     = require("mkdoc.util")

local lwtk         = require("lwtk")
local getMixinBase = lwtk.get.mixinBase

---------------------------------------------------------------------------------------------------------------------------

local getClassModuleName = util.getClassModuleName

local function getClassModuleInfo(c)
    return moduleInfos[getClassModuleName(c)]
end

---------------------------------------------------------------------------------------------------------------------------


lpeg.locale(lpeg)

local P, S, V = lpeg.P, lpeg.S, lpeg.V
local C, Carg, Cb, Cc = lpeg.C, lpeg.Carg, lpeg.Cb, lpeg.Cc
local Cf, Cg, Cmt, Cp, Cs, Ct = lpeg.Cf, lpeg.Cg, lpeg.Cmt, lpeg.Cp, lpeg.Cs, lpeg.Ct
local Lc, T = lpeg.Lc, lpeg.T

local alpha, digit, alnum = lpeg.alpha, lpeg.digit, lpeg.alnum
local xdigit = lpeg.xdigit
local space = lpeg.space

---------------------------------------------------------------------------------------------------------------------------

perf.start"moduleScan"

do
    local function addMemberInfo(moduleInfo, memberName, member, class, parentInfo)
        -- for Mixins: class != module
        local moduleName = moduleInfo.moduleName
        local memberType = type(member)
        if memberType == "table" or memberType == "function" then
            local memberInfo = moduleInfo.memberInfos[memberName]
            local declared = class and class.declared[memberName] or moduleInfo.isMixin
            if not memberInfo then
                local memberInfo = {
                    moduleName = moduleName,
                    isModuleMember = true,
                    isModuleSubMember = (parentInfo ~= nil and true or nil),
                    isEntity = true,
                    memberName = memberName,
                    memberType = memberType,
                    member = member,
                    referringInfos = {},
                    declared = declared
                }
                if memberType == "function" then
                    local isObjMember = class and rawget(class.__index, memberName)
                    if declared and (not class or isObjMember) then
                        addr(moduleInfo.memberFunctions, memberName, memberInfo, member)
                    elseif class and isObjMember then
                        local inheritedMethods = moduleInfo.inheritedMethods -- TODO mixin
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
                end
                local existingInfo = reverseLookup[member]
                if not existingInfo then
                    reverseLookup[member] = memberInfo
                else
                    if existingInfo.moduleName == moduleName then
                        error(require"inspect"{memberName, moduleName, existingInfo})
                    end
                    add(existingInfo.referringInfos, moduleName, memberInfo)
                    memberInfo.originalMemberInfo = existingInfo
                end
                addr(moduleInfo.memberInfos, memberName, memberInfo, member)
        
                if memberType == "table" and not memberName:match("^__") and memberName ~= "implement"
                    and memberName ~= "override" and memberName ~= "declared" and memberName ~= "static"
                    and not getmetatable(member)
                then
                    --print("####", memberName)
                    local mt = getmetatable(member)
                    local _pairs = mt and mt.__pairs or pairs
                    for k, v in _pairs(member) do
                        --assert(type(k) == "string", require"inspect"{moduleName, memberName, k, v})
                        addMemberInfo(moduleInfo, memberName.."."..k, v, nil, memberInfo)
                    end
                end
            else
                assert(moduleInfo.isMixin)
                if memberType == "function" then
                    if declared then
                        if moduleInfo.memberFunctions[memberName] ~= memberInfo then
                            error(require"inspect"{moduleInfo.moduleName, memberName, memberInfo})
                        end
                    elseif class then
                        assert(moduleInfo.memberFunctions[memberName] == nil)
                    end
                end
                if memberType ~= memberInfo.memberType then
                    if memberInfo.memberType == "boolean" and memberInfo.member == false then
                        assert(memberType == "table" or memberType == "function")
                        memberInfo.memberType = memberType
                        memberInfo.isEntity = true
                        memberInfo.member = nil
                        memberInfo.memberRealisation = { member }
                    else 
                        error(require"inspect"{moduleName, memberName, memberType, memberInfo.memberType, memberInfo})
                    end
                end
            end
        else
            local memberInfo = moduleInfo.memberInfos[memberName]
            if not memberInfo then
                local memberInfo = {
                    moduleName = moduleName,
                    isModuleMember = true,
                    isValue = true,
                    memberName = memberName,
                    memberType = memberType,
                    member = member
                }
                add(moduleInfo.memberInfos, memberName, memberInfo)
            else
                assert(moduleInfo.isMixin)
                if memberType ~= memberInfo.memberType or member ~= memberInfo.member then
                    error(require"inspect"{moduleName, memberName, memberType, memberInfo.memberType, memberInfo})
                end
            end
        end
    end

    local function visitSuperClasses(thisModuleName, thisModule, thisModuleInfo)
        local thisClassPath = util.getReverseClassPathString(thisModule)
        local super = thisModule:getSuperClass()
        local mixinVisited = false
        while super do
            local superInfo = getClassModuleInfo(super)
            addSet(superInfo.subClassPaths, thisClassPath)
            if not mixinVisited and superInfo.isMixin then
                -- for Mixins: class != module, i.e. super != modules[superName]
                if superInfo.mixinRealisations[super] then
                    mixinVisited = true
                else
                    local list = util.getReverseClassPathList(super)
                    list.pathString = util.classPathListToString(list)
                    addr(superInfo.mixinRealisations, super, list, list.pathString)
                    for memberName, member in pairs(super.__index) do
                        if super.declared[memberName] then
                            addMemberInfo(superInfo, memberName, member, super)
                        end
                    end
                end
            end
            super = super:getSuperClass()
        end
    end

    for _, thisModuleName in ipairs(depOrderedModuleNames) do
        local thisModule     = modules[thisModuleName]
        local thisModuleInfo = moduleInfos[thisModuleName]
        local thisModuleType = type(thisModule)

        local isClass = lwtk.isInstanceOf(thisModule, lwtk.Class)
        local isMixin = lwtk.isInstanceOf(thisModule, lwtk.Mixin)
        local isMeta  = lwtk.isInstanceOf(thisModule, lwtk.Meta)
        local isFunction = (thisModuleType == "function")
        if isClass then
            thisModuleInfo.isClass = true
            thisModuleInfo.memberFunctions = {}
            thisModuleInfo.inheritedMethods = {}
        elseif isMixin then
            thisModuleInfo.isMixin = true
            thisModuleInfo.memberFunctions = {}
            thisModuleInfo.inheritedMethods = {}
        elseif isMeta then
            thisModuleInfo.isMeta = true
        elseif isFunction then
            thisModuleInfo.isFunction = true
        end
        
        if thisModuleType == "table" and not thisModuleInfo.isPackage then
            local mt = getmetatable(thisModule)
            local _pairs = mt and mt.__pairs or pairs
            local class = isClass and thisModule
            for memberName, member in _pairs(thisModule) do
                addMemberInfo(thisModuleInfo, memberName, member, class)
            end
        end

        if isClass --[[or isMixin]] then
            thisModuleInfo.subClassPaths = {}
        elseif isMixin then
            thisModuleInfo.subClassPaths = {}
            thisModuleInfo.mixinRealisations = {}
        end
        if not thisModuleInfo.isInternal then
            if isClass then
                add(classInfos,      thisModuleName, thisModuleInfo)
                add(classMixinInfos, thisModuleName, thisModuleInfo)
                visitSuperClasses(thisModuleName, thisModule, thisModuleInfo)
            elseif isMixin then
                add(mixinInfos,      thisModuleName, thisModuleInfo)
                add(classMixinInfos, thisModuleName, thisModuleInfo)
            elseif isMeta then
                add(metaInfos, thisModuleName, thisModuleInfo)
            elseif isFunction then
                add(functionInfos, thisModuleName, thisModuleInfo)
            else
                add(otherInfos, thisModuleName, thisModuleInfo)
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
                error(require"inspect"{thisModuleName, k})
            end
            if type(v) == "function" then
                if thisModule.declared[k] then
                    memberInfo.overrideList = util.getOverrideList(thisModule, k) -- TODO
                end
            end
        end
    end
end
perf.stop"moduleScan"


---------------------------------------------------------------------------------------------------------------------------

perf.start"totalparse"

local parseModule
do
    local function processExp(env, e)
        if e.tag == "Call" then
            local func = processExp(env, e[1])
            local args = {}
            for i = 2, #e do
                args[i-1] = processExp(env, e[i])
            end
            if func == require then
                --local rslt = require(args[1])
                local rslt = moduleInfos[args[1]]
                if not rslt then    
                    rslt = require(args[1])
                end
                return rslt
            elseif func == lwtk.newClass then
                --[[
                local class = lwtk.tryrequire(args[1])
                if class then
                    if classDocs[class] ~= nil then
                        lwtk.errorf("already found: lwtk.newClass(%q)", class.__name)
                    end
                    classDocs[class] = false
                    return class, NEW_CLASS
                else
                    print("ignoring class", args[1])
                end ]]
            end
        elseif e.tag == "Index" then
            local e1 = processExp(env, e[1])
            local e2 = processExp(env, e[2])
            if e1 then
                if moduleInfos[e1] == true then
                    return e1.memberInfos[e2]
                else
                    return e1[e2]
                end
            end
        elseif e.tag == "String" then
            return e[1]
        elseif e.tag == "Op" then
            local op = e[1]
            if op == "concat" then
                local e1 = processExp(env, e[2])
                local e2 = processExp(env, e[3])
                return e1..e2
            elseif op == "or" then
                local e1 = processExp(env, e[2])
                local e2 = processExp(env, e[3])
                return e1 or e2
            elseif op == "div" then
            elseif op == "not" then
            elseif op == "and" then
            else
                error(op)
            end
        elseif e.tag == "Id" then
            return env[e[1]]
        elseif e.tag == "Number" then
            return e[1]
        elseif e.tag == "Table" then
        elseif e.tag == "Function" then
        elseif e.tag == "Boolean" then
            return e[1]
        elseif e.tag == "Invoke" then
        elseif e.tag == "Paren" then
        elseif e.tag == "Nil" then
            return nil
        else
            error(require"inspect"({tag = e.tag, pos = e.pos, end_pos = e.end_pos}))
        end
    end
    
    local moduleOutDirs = {}
    
    function parseModule(thisModuleName, thisModule, thisModuleInfo)
        local moduleFileNameStem = thisModuleName:gsub("%.", "/")
        if thisModuleInfo.isPackage then
            moduleFileNameStem = moduleFileNameStem.."/init"
        end
        local moduleFileName = moduleFileNameStem..".lua"
        local traceFileName = path("../doc/gen", moduleFileNameStem..".trace")
        local outDir  = path.parent(traceFileName)
        if not moduleOutDirs[outDir] then
            moduleOutDirs[outDir] = true
            fs.makedirs(outDir)
        end
 
        local traceOut = TRACE and io.open(traceFileName, "w")
        do
            print("Processing", moduleFileName)
            local function trace(...)
                if traceOut then
                    local n = select("#", ...)
                    for i = 1, n do
                        traceOut:write(tostring(select(i, ...)))
                        if i < n then
                            traceOut:write("\t")
                        end
                    end
                    traceOut:write("\n")
                end
            end
    
            local file = assert(io.open(moduleFileName, "r"), moduleFileName)
            local content = file:read("*a")
            file:close()
    
            comments.init(content, trace)
            perf.start"parse"
            local ast, err = parser.parse(content, moduleFileName, comments)
            perf.stop"parse"
            comments.sort()
    
            ------------------------------------------------------------------------------------
            if TRACE then
                perf.start"trace"
                trace(pprint.pformat(ast))
                perf.stop"trace"
            end
            ------------------------------------------------------------------------------------
    
            local returnId   = nil
            local isClass    = thisModuleInfo.isClass
            local isMeta     = thisModuleInfo.isMeta
            local isMixin    = thisModuleInfo.isMixin
            local isFunction = thisModuleInfo.isFunction
    
            local last = ast[#ast]
            assert(last.tag == "Return" and #last == 1)
            if last[1].tag == "Id" then
                returnId = last[1][1]
            else
                local s = last
                local doc, argListDoc = comments.stripArgListDoc(comments.getBefore(s.pos))
                local shortDoc = comments.getShortDoc(doc)
                thisModuleInfo.fullDoc = doc
                thisModuleInfo.shortDoc = shortDoc
                local argListString, isMethod = util.getArgListString(s[1])
                if argListString and argListDoc then
                    assert(argListString == argListDoc)
                end
                if not argListString and argListDoc then
                    argListString, isMethod = comments.argListDocToMethod(argListDoc)
                end
                --assert(not isMethod)
                thisModuleInfo.argListString = argListString
                thisModuleInfo.isMethod = isMethod
            end
            local function processBlock(ast, env) 
                for _, s in ipairs(ast) do
                    trace("TTT", s.pos, s.tag)
                    local tag = s.tag
                    if tag == "Local" or tag == "Localrec" then
                        local s1 = s[1]; 
                        local s2 = s[2]; 
                        local isReturnId = false
                        if s.tag == "Local" then
                            assert(s1.tag == "NameList")
                            assert(not s2.tag or s2.tag == "ExpList", s2)
                            for i = 1, #s1 do
                                local n = s1[i]; assert(n.tag == "Id")
                                if n[1] == returnId then
                                    assert(#s1 == 1 and #s2 == 1)
                                    isReturnId = true
                                    break
                                end
                            end
                        else
                            assert(#s1 == 1 and s1.tag == nil and s1[1].tag == "Id")
                            isReturnId = (s1[1][1] == returnId)
                        end
                        if isReturnId then
                            trace("NEW_MODULE", s.pos, s.end_pos)
                            local docb = comments.getBefore(s.pos)
                            local doca = comments.getAfter(s.end_pos)
                            if docb then
                                trace("FOUNDBEFORE", docb)--require"inspect"(doc))
                            end
                            if doca then
                                trace("FOUNDAFTER", doca)
                            end
                            if doca and docb then
                                lwtk.errorf("Ambiguous class comment in line %d of file %q", re.calcline(content, s.pos), moduleFileName)
                            end
                            env[returnId] = thisModule
                            local doc, argListDoc = comments.stripArgListDoc(docb or doca)
                            local shortDoc = comments.getShortDoc(doc)
                            thisModuleInfo.fullDoc = doc
                            thisModuleInfo.shortDoc = shortDoc

                            if isFunction then
                                local argListString, isMethod
                                if tag == "Localrec" then
                                    argListString, isMethod = util.getArgListString(s2[1])
                                    --assert(not isMethod)
                                end
                                if not argListString and argListDoc then
                                    argListString, isMethod = comments.argListDocToMethod(argListDoc)
                                end
                                thisModuleInfo.argListString = argListString
                                thisModuleInfo.isMethod = isMethod
                            end
                        elseif tag == "Localrec" then
                            assert(#s2 == 1 and s2.tag == nil and s2[1].tag == "Function")
                            local rslt = processExp(env, s2[1])
                            trace("setting", s1[1][1], rslt)
                            env[s1[1][1]] = rslt
                        else
                            for i = 1, #s1 do
                                local n = s1[i]; assert(n.tag == "Id")
                                local e = s2[i]
                                if e then
                                    local rslt = processExp(env, e)
                                    trace("setting", n[1], rslt)
                                    env[n[1]] = rslt
                                end
                            end
                        end
                    elseif tag == "Set" then
                        local lhsl = s[1];
                        local expl = s[2];
                        local memberInfo = nil
                        for i = 1, #lhsl do
                            local lhs = processExp(env, lhsl[i]);
                            memberInfo = thisModuleInfo.memberInfos[lhs]
                            if memberInfo then
                                assert(#lhsl == 1)
                                break
                            end
                        end
                        if memberInfo then
                            local exp = expl[1]
                            local argListString, isMethod = util.getArgListString(exp)
                            local fullDoc, argListDoc = comments.stripArgListDoc(comments.getBefore(s.pos))
                            if not argListString and argListDoc then
                                argListString, isMethod = comments.argListDocToMethod(argListDoc)
                            end
                            memberInfo.fullDoc       = fullDoc
                            memberInfo.shortDoc      = comments.getShortDoc(fullDoc)
                            memberInfo.argListString = argListString
                            memberInfo.isMethod      = isMethod
                             --trace("LLLLLLLLLLLL", require"inspect"{memberInfo.memberName, processExp(env, exp), lwtk.TextLabel.getMeasures })
                        end
                    elseif tag == "Invoke" then
                        local e1 = processExp(env, s[1])
                        local m  = processExp(env, s[2])
                        if isClass and e1 == thisModule then
                            trace("CCCCCCCCCCCCCCCCCCCC", e1)
                            if m == "declare" then
                                for i = 3, #s do
                                    local arg = processExp(env, s[i])
                                    trace("DDDDDDDDDDDDDDDDD", arg)
                                    assert(type(arg) == "string")
                                    --declared[arg] = declDoc
                                    local nextPos
                                    if i < #s then
                                        nextPos = s[i + 1].pos
                                    else
                                        nextPos = s.end_pos
                                    end
                                    local doca = comments.getAfter(s[i].end_pos, nextPos)
                                    local docb = comments.getBefore(s[i].pos)
                                    if doca then
                                        trace("FOUNDAFTER", doca)
                                    end
                                    if docb then
                                        trace("FOUNDBEFORE", docb)
                                    end
                                    if doca and docb then
                                        lwtk.errorf("Ambiguous comment for declaration in line %d of file %q", re.calcline(content, s[i].pos), moduleFileName)
                                    end
                                end
                            end
                        end
                    elseif tag == "Block" then
                        local nextEnv = setmetatable({}, { __index = env })
                        processBlock(s, nextEnv)
                    elseif tag == "If" then
                        local cond = processExp(env, s[1])
                        local nextEnv = setmetatable({}, { __index = env })
                        if cond then
                            processBlock(s[2], nextEnv)
                        elseif s[3] then
                            processBlock(s[3], nextEnv)
                        end
                    end
                end
            end
            local env = setmetatable({}, { __index = _G })
            processBlock(ast, env)
        end
        if traceOut then
            traceOut:close()
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------
do
    for _, thisModuleName in ipairs(depOrderedModuleNames) do

        local thisModule     = modules[thisModuleName]
        local thisModuleInfo = moduleInfos[thisModuleName]

        ---------------------------------------------------------------
        parseModule(thisModuleName, thisModule, thisModuleInfo)
        ---------------------------------------------------------------
        
        -- isMethod is only known after parsing the function declaration
        --
        if not thisModuleInfo.isInternal and thisModuleInfo.isClass --[[or thisModuleInfo.isMixin]] then
            local methods = {}
            local functions = {}
            if not thisModuleInfo.memberFunctions then
                error(require"inspect"{thisModuleName})
            end
            for _, f in ipairs(thisModuleInfo.memberFunctions) do
                local isMethod = f.isMethod
                if isMethod == nil then
                    if not f.originalMemberInfo then
                        error(require"inspect"{thisModuleName, f})
                    end
                    isMethod = f.originalMemberInfo.isMethod
                    assert(type(isMethod) == "boolean", f.memberName)
                elseif f.originalMemberInfo then
                    assert(isMethod == f.originalMemberInfo.isMethod)
                end
                if isMethod then
                    add(methods, f.memberName, f) 
                else
                    add(functions, f.memberName, f)
                end
            end
            thisModuleInfo.methods   = methods
            thisModuleInfo.functions = functions
        end
    end
end
---------------------------------------------------------------------------------------------------------------------------
do
    for _, info in ipairs(classMixinInfos) do
        local subClassPaths = info.subClassPaths
        table.sort(subClassPaths)
        local subClassTree = {}
        for _, p in ipairs(subClassPaths) do
            local r = subClassTree
            for n in p:gmatch("[^/]+") do
                local r2 = r[n]
                if not r2 then
                    r2 = { moduleName = n }
                    add(r, n, r2)
                end
                r = r2
            end
        end
        info.subClassTree = subClassTree
    end
end
---------------------------------------------------------------------------------------------------------------------------
do
    local function compareMixinRealisation(a, b)
        return a.pathString < b.pathString
    end
    for _, mixinInfo in ipairs(mixinInfos) do
        local reals = mixinInfo.mixinRealisations
        table.sort(reals, compareMixinRealisation)
        local mixinSupers = {}
        for _, r in ipairs(reals) do
            local s = mixinSupers
            for _, e in ipairs(r) do
                local s2 = s[e.moduleName]
                if not s2 then
                    s2 = { moduleName = e.moduleName, isMixin = e.isMixin }
                    add(s, e.moduleName, s2)
                end
                s = s2
            end
        end
        mixinInfo.mixinSupers = mixinSupers
    end
end

perf.stop"totalparse"

---------------------------------------------------------------------------------------------------------------------------

local function sortMembers(members)
    if members then
        table.sort(members, function(a,b) 
            local an, bn = a.memberName, b.memberName
            local am, bm = an:match("^_"), bn:match("^_")
            if (am and bm) or (not am and not bm) then
                return an < bn 
            else
                return not am
            end
        end)
    end
end

local function sortInheritedMembers(superClassList)
    if superClassList then
        for i = #superClassList, 1, -1 do
            local methods = superClassList[i]
            if #methods > 0 then
                sortMembers(methods)
            else
                table.remove(superClassList, i)
            end
        end
    end
end

local function sortModules(modules, deep)
    table.sort(modules, function(a,b) return a.moduleName < b.moduleName end)
    if deep then
        for _, module in ipairs(modules) do
            if module.methods then
                sortMembers(module.methods)
            end
            if module.functions then
                sortMembers(module.functions)
            end
            if module.inheritedMethods then
                sortInheritedMembers(module.inheritedMethods)
            end
        end
    end
end

sortModules(moduleInfos, true)
sortModules(packageInfos)

local function newSubstLinks(genDirPrefix)

    local linkFormat = "[%s]("..genDirPrefix.."%s.md)"
    local linkPattern = (     C(  (S'["' * P"lwtk.")
                                + (-(S'["' * P"lwtk.") * -P"lwtk." * P(1))^1
                               )
                            + ((P"lwtk." * (alnum + P".")^1) / 
                                function(m)
                                    if lwtk.tryrequire(m) then
                                        return format(linkFormat, m, m:gsub("%.", "/"))
                                    else
                                        return m
                                    end
                                end 
                              )
                        )^0 / function(...) return table.concat { ... } end

    return function(docString)
        return lpeg.match(linkPattern, docString)
    end
end

---------------------------------------------------------------------------------------------------------------------------
perf.start"output"

do
    local substLinks = newSubstLinks("")
    
    local sections = {
        { "Classes",   classInfos },
        { "Mixins",    mixinInfos },
        { "Metas",     metaInfos },
        { "Functions", functionInfos },
        { "Other",     otherInfos }
    }
    for _, s in ipairs(sections) do
        sortModules(s[2])
        for _, info in ipairs(s[2]) do
            if not info.isPackage then
                local packInfo = moduleInfos[info.packageName]
                local infos = packInfo[s[2]]
                if not infos then
                    infos = {}
                    packInfo[s[2]] = infos
                end
                add(infos, info.moduleName, info)
            end
        end
    end
    
    local outName = "../doc/gen/modules.md"
    local out = io.open(outName, "w")
    do
        local function pr(...)
            fprintf(out, ...)
        end
        pr("# Module Index\n\n")
        for _, p in ipairs(packageInfos) do
            if not p.isInternal then
                pr("   * [%s](#%s)", p.moduleName, p.moduleName:gsub("%.",""))
                if p.shortDoc then
                    pr(" - %s", substLinks(p.shortDoc))
                end
                pr("\n")
            end
        end    
        for _, p in ipairs(packageInfos) do
            local packageName = p.moduleName
            if not p.isInternal then
                pr("\n## %s\n", packageName)
                pr("\n")
                for _, s in ipairs(sections) do
                    local infos = p[s[2]]
                    if infos then
                        pr("### %s\n", s[1])
                        for _, m in ipairs(infos) do
                            if m.packageName == packageName then
                                local b = m.isClass and "**" or ""
                                pr("   * %s[%s](%s)%s", b, m.moduleName, m.docFileName, b)
                                if m.shortDoc then
                                    pr(" - %s", substLinks(m.shortDoc))
                                end
                                pr("\n")
                            end
                        end
                    end
                end
            end
        end
    end
    out:close()
end
---------------------------------------------------------------------------------------------------------------------------
do
    for _, m in ipairs(moduleInfos) do
        if not m.isInternal then
            local genDirPrefix = string.rep("../", #m.moduleName:gsub("[^.]*(%.?)[^.]*", "%1"))
            local substLinks = newSubstLinks(genDirPrefix)
            local shortModuleName = m.moduleName:gsub("^lwtk%.", "")
            local out = assert(io.open(path("../doc/gen", m.docFileName), "w"))
            do
                local function pr(...)
                    fprintf(out, ...)
                end
                local function prind(n)
                    for i = 1, n do
                        out:write(" ")
                    end
                end
                local module = modules[m.moduleName]
                local tp
                if type(module) == "function" then
                    tp = "Function "
                elseif m.isClass then
                    tp = "Class "
                elseif m.isMixin then
                    tp = "Mixin "
                elseif m.isMeta then
                    tp = "Meta "
                elseif type(module) == "table" then
                    tp = "Table "
                elseif type(module) == "number" or type(module) == "string" then
                    tp = ""
                else 
                    error(m.moduleName)
                end
                pr("# %s%s\n\n", tp, m.moduleName)
                if m.moduleType == "function" then
                    local argListString = m.argListString
                    if m.isMethod and argListString then
                        argListString = "self, "..argListString
                    end
                    pr("   * **`%s(%s)`**\n\n", shortModuleName,
                                                 argListString or "?")
                    if m.fullDoc then
                        pr(util.indent(5, substLinks(m.fullDoc)))
                    end
                else
                    if m.fullDoc then
                        pr("%s\n", substLinks(m.fullDoc))
                    end
                end
                ------------------------------------------------------------------------
                local contentsTitlePrinted = false
                local function assureContentsTitle()
                    if not contentsTitlePrinted then
                        pr("\n")
                        pr("## Contents\n\n")
                        contentsTitlePrinted = true
                    end
                end
                local classPathList
                if m.isClass then
                    classPathList = util.getClassPathList(module)
                    if #classPathList > 1 then
                        assureContentsTitle()
                        pr("   * [Inheritance](#inheritance)\n")
                    end
                elseif m.isMixin then
                    if #m.mixinRealisations > 0 then
                        assureContentsTitle()
                        pr("   * [Inheritance](#inheritance)\n")
                    end
                end
                local hasNewOk, hasNew = pcall(function() return module["new"] end)
                hasNew = hasNewOk and hasNew
                local hasConstructor = (m.isMeta or m.isClass) and hasNew
                if hasConstructor then
                    assureContentsTitle()
                    pr("   * [Constructor](#constructor)\n")
                end
                local methodFunctionSections = {
                    { "Methods",   "methods",   m.methods   },
                    { "Functions", "functions", m.functions }
                }
                for _, section in pairs(methodFunctionSections) do
                    if section[3] and #section[3] > 0 then
                        assureContentsTitle()
                        pr("   * [%s](#%s)\n", section[1], section[2])
                        for _, meth in ipairs(section[3]) do
                            pr("      * [%s()](#.%s)", meth.memberName, meth.memberName)
                            if meth.shortDoc then
                                pr(" - %s", meth.shortDoc)
                            else
                                local orig = meth.originalMemberInfo
                                if orig and orig.shortDoc then
                                    pr(" - %s", orig.shortDoc)
                                end
                            end
                            pr("\n")
                        end
                    end
                end
                if m.inheritedMethods and #m.inheritedMethods > 0 then
                    assureContentsTitle()
                    pr("   * [Inherited Methods](#inherited-methods)\n")
                end
                if (m.isClass or m.isMixin) and #m.subClassPaths > 0 then
                    assureContentsTitle()
                    pr("   * [Subclasses](#subclasses)\n")
                end
                ------------------------------------------------------------------------
                pr("\n")
                if m.isClass and #classPathList > 1 then
                    pr("\n## Inheritance\n")
                    --pr("   * Super class path:\n", #classPathList>2 and "es" or "")
                    pr("   * ")
                    for i = #classPathList, 1, -1 do
                        pr(" / ")
                        local c = classPathList[i]
                        local cname = c.moduleName
                        local b = c.isMixin and "" or "**"
                        if cname == m.moduleName then
                            pr("_%s`%s`%s_", b,
                                           cname:gsub("^lwtk%.",""), 
                                           b)
                        else
                            pr("%s[%s](%s%s.md#inheritance)%s", 
                                                b,
                                                cname:gsub("^lwtk%.",""), 
                                                genDirPrefix, 
                                                cname:gsub("%.","/"),
                                                b)
                        end
                    end
                    pr("\n")
                elseif m.isMixin and #m.mixinRealisations > 0 then
                    pr("\n## Inheritance\n")
                    local function prSup(indn, sup, top)
                        for _, s0 in ipairs(sup) do
                            local s = s0
                            prind(indn) pr("   * ")
                            if top then
                                pr("/ ")
                            end
                            while true do
                                if s ~= s0 then
                                    pr(" / ")
                                end
                                local sname = s.moduleName
                                local b = s.isMixin and "" or "**"
                                if sname == m.moduleName then
                                    pr("_%s`%s`%s_", b, sname:gsub("^lwtk%.",""), 
                                                 b)
                                else
                                    pr("%s[%s](%s%s.md#inheritance)%s", b, sname:gsub("^lwtk%.",""), 
                                                                           genDirPrefix,
                                                                           sname:gsub("%.","/"), 
                                                                           b)
                                end
                                if #s ~= 1 then
                                    break
                                end
                                s = s[1]
                            end
                            if #s > 1 then
                                pr(" /\n")
                                prSup(indn + 5, s)
                            else
                                pr("\n")
                            end
                        end
                    end
                    prSup(0, m.mixinSupers, true)
                end
                if hasConstructor then
                    pr("\n## Constructor\n")
                    if m.isMeta or module.declared["new"] then
                        local newInfo = assert(m.memberInfos["new"])
                        local argListString = newInfo.argListString
                        pr("   * <span id=%q>**`%s(%s)`**</span>\n\n", ".new", shortModuleName,
                                                                               argListString or "?")
                        if newInfo.fullDoc then
                            pr(util.indent(5, newInfo.fullDoc))
                            pr("\n")
                        end
                        local overrideList = m.isClass and util.getOverrideList(module, "new")
                        if overrideList then
                            local indent = "     "
                            --pr("%s   * Overrides:\n", indent)
                            for i, ov in ipairs(overrideList) do
                                local b = ov.isMixin and "" or "**"
                                pr("%s   * %s: %s[%s()](%s%s.md#constructor)%s\n", string.rep(indent, i), 
                                                           ov.overrideText,
                                                           b,
                                                           ov.moduleName:gsub("^lwtk%.", ""),
                                                           genDirPrefix,
                                                           ov.moduleName:gsub("%.", "/"),
                                                           b)
                            end
                            pr("\n")
                        end
                    else
                        local inheritedFrom = util.findDeclaratingSuperClass(module, "new")
                        local inheritedFromInfo = assert(moduleInfos[inheritedFrom])
                        local newInfo = assert(inheritedFromInfo.memberInfos["new"])
                        local argListString = newInfo.argListString
                        pr("   * <span id=%q>**`%s(%s)`**</span>\n\n", ".new", shortModuleName,
                                                                               argListString or "?")
                        local b = inheritedFromInfo.isClass and "**" or ""
                        pr("        * Inherited from: %s[%s()](%s%s.md#constructor)%s\n", b, inheritedFrom.__name:gsub("^lwtk%.",""),
                                                                                genDirPrefix,
                                                                                inheritedFrom.__name:gsub("%.", "/"), 
                                                                                b)
                    end
                    pr("\n")
                end
                for _, section in pairs(methodFunctionSections) do
                    if section[3] and #section[3] > 0 then
                        pr("\n## %s\n", section[1])
                        for _, meth in ipairs(section[3]) do
                            --print("#####################", require"inspect"{meth.methodName, moduleDoc.membersDoc})
                            local argListString = meth.argListString
                            local isMethod = meth.isMethod
                            local original = meth.originalMemberInfo
                            if not argListString and original then
                                argListString = original.argListString
                                isMethod = original.isMethod
                            end
                            local sep = isMethod and ":" or "."
                            pr("   * <span id=%q>**`%s%s%s(%s)`**</span>\n\n", "."..meth.memberName, shortModuleName, sep, meth.memberName,
                                                                                                     argListString or "?")
                            if meth.fullDoc then
                                pr(util.indent(5, meth.fullDoc))
                                pr("\n")
                            elseif original and original.fullDoc then
                                pr(util.indent(5, original.fullDoc))
                                pr("\n")
                            end 
                            if original then
                                if original.isModule then
                                    pr("        * Implementation: [%s()](%s%s.md)\n", 
                                                                        original.moduleName,
                                                                        genDirPrefix,
                                                                        original.moduleName:gsub("%.","/"))
                                else
                                    pr("        * Implementation: [%s:%s()](%s%s.md#%s)\n", 
                                                                        original.moduleName:gsub("^lwtk%.",""),
                                                                        original.memberName,
                                                                        genDirPrefix,
                                                                        original.moduleName:gsub("%.","/"),
                                                                        original.memberName)
                                end
                            end
                            if meth.overrideList then
                                local indent = "     "
                                for i, ov in ipairs(meth.overrideList) do
                                    pr("%s   * %s: [%s:%s()](%s%s.md#.%s)\n", string.rep(indent, i), 
                                                               ov.overrideText,
                                                               ov.moduleName:gsub("^lwtk%.", ""),
                                                               meth.memberName,
                                                               genDirPrefix,
                                                               ov.moduleName:gsub("%.", "/"),
                                                               meth.memberName)
                                end
                                pr("\n")
                            end
                            pr("\n")
                        end
                    end
                end
                if m.inheritedMethods and #m.inheritedMethods > 0 then
                    pr("\n## Inherited Methods\n")
                    for _, fromList in ipairs(m.inheritedMethods) do
                        local b = fromList.isMixin and "" or "**"
                        local fromFile = format("%s%s.md", genDirPrefix, fromList.moduleName:gsub("%.", "/"))
                        pr("   * %s[%s](%s)%s:\n", b, fromList.moduleName:gsub("^lwtk%.",""), fromFile, b)
                        pr("      * ")
                        for i, fr in ipairs(fromList) do
                            if i > 1 then pr(", ") end
                            pr("[%s()](%s#.%s)", fr.memberName, fromFile, fr.memberName)
                        end
                        pr("\n")
                    end
                end
                if (m.isClass or m.isMixin) and #m.subClassPaths > 0 then
                    pr("\n## Subclasses\n")
                        --pr("   * Sub class path%s:\n", #m.subClassTree[1] > 1 and "s" or "")
                    local function prSub(indn, sub, top)
                        for _, s0 in ipairs(sub) do
                            local s = s0
                            prind(indn) pr("   * ")
                            if top then
                                pr("/ ")
                            end
                            while true do
                                if s ~= s0 then
                                    pr(" / ")
                                end
                                local sname = s.moduleName
                                local sinfo = moduleInfos[sname]
                                local b = sinfo.isMixin and "" or "**"
                                local hasSubclass = sinfo.subClassPaths and #sinfo.subClassPaths > 0
                                if m.moduleName == sname then
                                    pr("_%s`%s`%s_", b, sname:gsub("^lwtk%.",""),
                                                   b)
                                else
                                    pr("%s[%s](%s%s.md#%s)%s", b, sname:gsub("^lwtk%.",""),
                                                               genDirPrefix,
                                                               sname:gsub("%.","/"), 
                                                               hasSubclass and "subclasses" or "inheritance",
                                                               b)
                                end
                                if #s ~= 1 then
                                    break
                                end
                                s = s[1]
                            end
                            if #s > 1 then
                                pr(" /\n")
                                prSub(indn + 5, s)
                            else
                                pr("\n")
                            end
                        end
                    end
                    prSub(0, m.subClassTree, true)
                    --pr("%s", pprint.pformat(m.subClassTree))
                    pr("\n")
                end
            end
            out:close()
        end
    end
end
perf.stop"output"
---------------------------------------------------------------------------------------------------------------------------

perf.finish()
