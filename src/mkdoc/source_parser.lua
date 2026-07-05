local path   = require("path")     -- https://luarocks.org/modules/xavier-wang/lpath
local fs     = require("path.fs")  -- https://luarocks.org/modules/xavier-wang/lpath
local perf   = require("perf")

local util       = require("mkdoc.util")
local class_util = require("mkdoc.class_util")

local addSetKey  = util.addSetKey

local pprint   = require("mkdoc.pprint")            -- modified version from: https://github.com/jagt/pprint.lua
local parser   = require("mkdoc.lua-parser.parser") -- modified version from: https://github.com/andremm/lua-parser
local comments = require("mkdoc.comments")

local re = require("relabel")  -- https://luarocks.org/modules/sergio-medeiros/lpeglabel

local lwtk = require("lwtk")

local source_parser = {}

local numberOps  = { add  = true, sub = true, mul = true, div = true, idiv = true,
                     mod  = true, pow = true, unm = true, len = true,
                     band = true, bor = true, bxor = true, shl = true, shr = true, bnot = true }
local booleanOps = { eq = true, lt = true, le = true, gt = true, ge = true, ne = true,
                     ["not"] = true }

-- Returns the Lua type of an expression node if it can be statically
-- inferred from literals and operators, otherwise nil.
-- Literal false is ignored: declared attributes are initialized with
-- false as placeholder for "not set", so a false assignment carries
-- no type information.
-- The optional callType callback may infer a type for Call nodes
-- (e.g. constructor calls of lwtk classes).
local function literalTypeOfExp(e, callType)
    local tag = e.tag
    if tag == "Number" then
        return "number"
    elseif tag == "String" then
        return "string"
    elseif tag == "Boolean" then
        return e[1] == true and "boolean" or nil
    elseif tag == "Table" then
        return "table"
    elseif tag == "Function" then
        return "function"
    elseif tag == "Paren" then
        return literalTypeOfExp(e[1], callType)
    elseif tag == "Call" then
        return callType and callType(e)
    elseif tag == "Invoke" then
        -- lwtk idiom: addChild returns the added child
        if e[2].tag == "String" and e[2][1] == "addChild" and e[3] then
            return literalTypeOfExp(e[3], callType)
        end
    elseif tag == "Op" then
        local op = e[1]
        if op == "concat" then
            return "string"
        elseif numberOps[op] then
            return "number"
        elseif booleanOps[op] then
            return "boolean"
        elseif op == "or" then
            -- pattern: self.x = arg or default
            return literalTypeOfExp(e[3], callType) or literalTypeOfExp(e[2], callType)
        elseif op == "and" then
            return literalTypeOfExp(e[3], callType)
        end
    end
end

-- Walks the complete AST (including function bodies) and collects
-- statically inferrable types of assignments "self.<name> = <exp>"
-- for all declared attribute names in declList.
-- For function assignments (e.g. "function self.scale(...)") also
-- the preceding doc comment and the argument list are collected,
-- unless the attribute is already documented at its declare() call.
-- Other assignments are not considered for documentation: comments
-- before plain value assignments are usually implementation notes.
local function collectAttributeTypes(ast, declList, callType)
    local function walk(node)
        if type(node) ~= "table" then
            return
        end
        if node.tag == "Set" then
            local lhsl, expl = node[1], node[2]
            for i = 1, #lhsl do
                local lhs = lhsl[i]
                if lhs.tag == "Index"
                   and lhs[1].tag == "Id" and lhs[1][1] == "self"
                   and lhs[2].tag == "String"
                then
                    local entry = declList[lhs[2][1]]
                    local exp = entry and expl and expl[i]
                    local inferredType = exp and literalTypeOfExp(exp, callType)
                    if inferredType then
                        local types = entry.types
                        if not types then
                            types = {}
                            entry.types = types
                        end
                        if not types[inferredType] then
                            types[inferredType] = true
                            types[#types + 1] = inferredType
                        end
                    end
                    if exp and exp.tag == "Function" then
                        local fullDoc, argListDoc
                        if entry.fullDoc == nil then
                            fullDoc, argListDoc = comments.stripArgListDoc(comments.getBefore(node.pos))
                            if fullDoc then
                                entry.fullDoc  = fullDoc
                                entry.shortDoc = comments.getShortDoc(fullDoc)
                            end
                        end
                        if not entry.argListString then
                            local argListString = class_util.getArgListString(exp)
                            if not argListString and argListDoc then
                                argListString = comments.argListDocToMethod(argListDoc)
                            end
                            entry.argListString = argListString
                        end
                    end
                end
            end
        end
        for i = 1, #node do
            walk(node[i])
        end
    end
    walk(ast)
end

function source_parser.parseAllModules(TRACE, depOrderedModuleNames, moduleInfos, modules,
                                       classMixinInfos, mixinInfos)

    perf.start"totalparse"

    -- Infers the instance type of constructor calls for
    -- collectAttributeTypes: callees of the form lwtk.Foo(...) or
    -- Foo(...) (the usual alias "local Foo = lwtk.Foo") are matched
    -- against the known class and meta modules. Mixin calls are not
    -- constructor calls and yield no type.
    local function constructorTypeOf(callExp)
        local callee = callExp[1]
        local name
        if callee.tag == "Id" then
            name = callee[1]
        elseif callee.tag == "Index"
           and callee[1].tag == "Id" and callee[1][1] == "lwtk"
           and callee[2].tag == "String"
        then
            name = callee[2][1]
        end
        if name then
            local info = moduleInfos["lwtk."..name]
            if info and (info.isClass or info.isMeta) then
                return "lwtk."..name
            end
        end
    end

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

                if not thisModuleInfo.isInternal then
                    -- getStyleParam calls are expression level and not visited by
                    -- processBlock below, therefore scan the raw source text.
                    -- Only literal string arguments can be collected this way.
                    local seen, names
                    for _, pat in ipairs {
                        ':getStyleParam%s*%(%s*"([%w_%*]+)"',
                        ':getMandatoryStyleParam%s*%(%s*"([%w_%*]+)"',
                        '%f[%w_]getStyleParam%s*%(%s*[%a_][%w_%.]*%s*,%s*"([%w_%*]+)"',
                        '%f[%w_]getMandatoryStyleParam%s*%(%s*[%a_][%w_%.]*%s*,%s*"([%w_%*]+)"',
                    } do
                        for name in content:gmatch(pat) do
                            if not seen then
                                seen  = {}
                                names = {}
                            end
                            if not seen[name] then
                                seen[name] = true
                                names[#names + 1] = name
                            end
                        end
                    end
                    if names then
                        table.sort(names)
                        thisModuleInfo.usedStyleParams = names
                    end

                    -- default style rules: one parRule( "Selector", <value> )
                    -- per line (see lwtk/DefaultStyle.lua)
                    local rules
                    for line in content:gmatch("[^\n]+") do
                        local selector, valueText = line:match('parRule%(%s*"([^"]+)"%s*,%s*(.*)$')
                        if selector then
                            valueText = valueText:gsub("%-%-.*$", "")
                            valueText = valueText:gsub("%s*%),?%s*$", "")
                            rules = rules or {}
                            rules[#rules + 1] = { selector = selector, valueText = valueText }
                        end
                    end
                    thisModuleInfo.defaultStyleRules = rules

                    -- key bindings: lwtk.KeyBinding { { "Key", ..., "ActionName" }, ... }
                    -- (see lwtk/DefaultKeyBinding.lua)
                    local bindingTable = content:match("lwtk%.KeyBinding%s*(%b{})")
                    if bindingTable then
                        local bindings
                        for entry in bindingTable:sub(2, -2):gmatch("%b{}") do
                            local strings = {}
                            for s in entry:gmatch('"([^"]*)"') do
                                strings[#strings + 1] = s
                            end
                            if #strings >= 2 then
                                local action = table.remove(strings)
                                bindings = bindings or {}
                                bindings[#bindings + 1] = { keys = strings, action = action }
                            end
                        end
                        thisModuleInfo.keyBindings = bindings
                    end
                end

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
                    local argListString, isMethod = class_util.getArgListString(s[1])
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
                                        argListString, isMethod = class_util.getArgListString(s2[1])
                                        --assert(not isMethod)
                                    end
                                    if not argListString and argListDoc then
                                        argListString, isMethod = comments.argListDocToMethod(argListDoc)
                                    end
                                    thisModuleInfo.argListString = argListString
                                    thisModuleInfo.isMethod = isMethod
                                end
                                -- For Mixins: traverse the initMixin callback body.
                                -- Pattern: local M = lwtk.newMixin("name", ..., function(M, Super) ... end)
                                if isMixin and tag == "Local" then
                                    local rhs = s2[1]
                                    if rhs and rhs.tag == "Call" then
                                        -- Find the last Function argument (the initMixin callback)
                                        local funcArg
                                        for i = #rhs, 2, -1 do
                                            if rhs[i].tag == "Function" then
                                                funcArg = rhs[i]
                                                break
                                            end
                                        end
                                        if funcArg then
                                            -- funcArg[1] is the parameter list, funcArg[2] is the body block
                                            local callbackEnv = setmetatable({}, { __index = env })
                                            -- Set callback parameters: function(MixinObj, Super)
                                            local params = funcArg[1]
                                            if params and params[1] and params[1].tag == "Id" then
                                                callbackEnv[params[1][1]] = thisModule
                                            end
                                            -- Super parameter is runtime-only, set to nil
                                            local body = funcArg[2]
                                            if body then
                                                processBlock(body, callbackEnv)
                                            end
                                        end
                                    end
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
                            if not memberInfo then
                                -- memberInfos is keyed by member value which only works
                                -- for functions and tables: look up value members
                                -- (e.g. constants) by member name.
                                for i = 1, #lhsl do
                                    local lhsExp = lhsl[i]
                                    if lhsExp.tag == "Index" then
                                        local base = processExp(env, lhsExp[1])
                                        local key  = processExp(env, lhsExp[2])
                                        if base == thisModule and type(key) == "string" then
                                            local valueInfo = thisModuleInfo.memberInfos[key]
                                            if valueInfo and valueInfo.isValue then
                                                assert(#lhsl == 1)
                                                memberInfo = valueInfo
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                            if memberInfo then
                                local exp = expl[1]
                                local argListString, isMethod = class_util.getArgListString(exp)
                                local fullDoc, argListDoc = comments.stripArgListDoc(comments.getBefore(s.pos))
                                if not argListString and argListDoc then
                                    argListString, isMethod = comments.argListDocToMethod(argListDoc)
                                end
                                memberInfo.fullDoc       = fullDoc
                                memberInfo.shortDoc      = comments.getShortDoc(fullDoc)
                                memberInfo.argListString = argListString
                                memberInfo.isMethod      = isMethod
                                 --trace("LLLLLLLLLLLL", require"inspect"{memberInfo.memberName, processExp(env, exp), lwtk.TextLabel.getMeasures })
                            elseif isMixin and #lhsl == 1 then
                                local lhs = lhsl[1]
                                local memberName
                                local isMixinMember = false
                                local isStaticMember = false
                                if lhs.tag == "Index" and lhs[1].tag == "Index" then
                                    -- Pattern: Mixin.override:foo(args), Mixin.implement:foo(args),
                                    --          Mixin.extra:foo(args) or Mixin.static.foo(args)
                                    local base = processExp(env, lhs[1][1])
                                    local subTableName = processExp(env, lhs[1][2])
                                    memberName = processExp(env, lhs[2])
                                    if base == thisModule
                                       and (subTableName == "override" or subTableName == "implement"
                                            or subTableName == "extra" or subTableName == "static")
                                       and type(memberName) == "string"
                                    then
                                        isMixinMember = true
                                        isStaticMember = (subTableName == "static")
                                    end
                                elseif lhs.tag == "Index" then
                                    -- Pattern: Mixin:foo(args) or Mixin.foo = function(...)
                                    local base = processExp(env, lhs[1])
                                    memberName = processExp(env, lhs[2])
                                    if base == thisModule and type(memberName) == "string" then
                                        isMixinMember = true
                                    end
                                end
                                if isMixinMember then
                                    local exp = expl[1]
                                    local argListString, isMethod = class_util.getArgListString(exp)
                                    local fullDoc, argListDoc = comments.stripArgListDoc(comments.getBefore(s.pos))
                                    if not argListString and argListDoc then
                                        argListString, isMethod = comments.argListDocToMethod(argListDoc)
                                    end
                                    thisModuleInfo.mixinMemberDocs = thisModuleInfo.mixinMemberDocs or {}
                                    thisModuleInfo.mixinMemberDocs[memberName] = {
                                        fullDoc       = fullDoc,
                                        shortDoc      = comments.getShortDoc(fullDoc),
                                        argListString = argListString,
                                        isMethod      = isMethod,
                                        isStatic      = isStaticMember,
                                    }
                                end
                            end
                        elseif tag == "Invoke" then
                            local e1 = processExp(env, s[1])
                            local m  = processExp(env, s[2])
                            if (isClass or isMixin) and e1 == thisModule then
                                trace("CCCCCCCCCCCCCCCCCCCC", e1)
                                if m == "declare" then
                                    for i = 3, #s do
                                        local arg = processExp(env, s[i])
                                        trace("DDDDDDDDDDDDDDDDD", arg)
                                        assert(type(arg) == "string")
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
                                        local fullDoc, argListDoc = comments.stripArgListDoc(doca or docb)
                                        local declList = thisModuleInfo.declaredAttributes
                                        if not declList then
                                            declList = {}
                                            thisModuleInfo.declaredAttributes = declList
                                        end
                                        addSetKey(declList, arg, {
                                            memberName    = arg,
                                            fullDoc       = fullDoc,
                                            shortDoc      = comments.getShortDoc(fullDoc),
                                            argListString = argListDoc,
                                        })
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
                -- declaredAttributes is filled during processBlock above
                if thisModuleInfo.declaredAttributes then
                    collectAttributeTypes(ast, thisModuleInfo.declaredAttributes, constructorTypeOf)
                end
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
            if not thisModuleInfo.isInternal and (thisModuleInfo.isClass or thisModuleInfo.isMixin) then
                local methods = {}
                local functions = {}
                local extraMethods = {}
                local staticMethods = {}
                if not thisModuleInfo.memberFunctions then
                    error(require"inspect"{thisModuleName})
                end
                -- For Mixins, thisModule.__index is nil (Mixins are not classes).
                -- Use the first realised class as a proxy to check __index membership.
                local indexTable
                if thisModuleInfo.isClass then
                    indexTable = thisModule.__index
                elseif thisModuleInfo.isMixin and thisModuleInfo.mixinRealisations then
                    -- Use the realisation with the longest superclass chain (most members).
                    -- mixinRealisations is a hybrid list: integer indices hold list entries.
                    local bestProxy, bestLen
                    for k, v in pairs(thisModuleInfo.mixinRealisations) do
                        if type(k) == "table" and k.__index then
                            local idx = k.__index
                            local len = 0
                            for _ in pairs(idx) do len = len + 1 end
                            if not bestLen or len > bestLen then
                                bestProxy = idx
                                bestLen = len
                            end
                        end
                    end
                    indexTable = bestProxy
                end
                if indexTable then
                    -- First pass: classify members from memberFunctions
                    -- (these have source-parsed info: argListString, isMethod, fullDoc)
                    for _, f in ipairs(thisModuleInfo.memberFunctions) do
                        if f.isExtra then
                            -- extra members are not part of the realised
                            -- classes, subclasses adopt them explicitly
                            addSetKey(extraMethods, f.memberName, f)
                        elseif f.isStatic then
                            addSetKey(staticMethods, f.memberName, f)
                        elseif rawget(indexTable, f.memberName) then
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
                                addSetKey(methods, f.memberName, f)
                            else
                                addSetKey(functions, f.memberName, f)
                            end
                        end
                    end
                    -- Second pass (Mixins only): add members from memberInfos2
                    -- that were not found in memberFunctions (e.g. override/implement methods).
                    if thisModuleInfo.isMixin then
                        for _, f in ipairs(thisModuleInfo.memberInfos2) do
                            if f.isDeclared and f.memberType == "function"
                               and not methods[f.memberName]
                               and not functions[f.memberName]
                               and rawget(indexTable, f.memberName)
                            then
                                -- Look up source-parsed info from memberInfos
                                local memberInfo = thisModuleInfo.memberInfos[f.memberName]
                                if memberInfo and memberInfo.isMethod ~= nil then
                                    if memberInfo.isMethod then
                                        addSetKey(methods, f.memberName, memberInfo)
                                    else
                                        addSetKey(functions, f.memberName, memberInfo)
                                    end
                                else
                                    -- Check mixinMemberDocs for override/implement/extra
                                    -- source-parsed info collected during AST traversal.
                                    local docs = thisModuleInfo.mixinMemberDocs
                                                 and thisModuleInfo.mixinMemberDocs[f.memberName]
                                    local minInfo = {
                                        moduleName   = thisModuleInfo.moduleName,
                                        memberName   = f.memberName,
                                        memberType   = "function",
                                        isMethod     = docs and docs.isMethod or true,
                                        argListString = docs and docs.argListString,
                                        fullDoc      = docs and docs.fullDoc,
                                        shortDoc     = docs and docs.shortDoc,
                                    }
                                    if minInfo.isMethod or minInfo.isMethod == nil then
                                        addSetKey(methods, f.memberName, minInfo)
                                    else
                                        addSetKey(functions, f.memberName, minInfo)
                                    end
                                end
                            end
                        end
                    end
                end
                -- static members of mixins are defined per realisation in
                -- the initMixin callback (e.g. Styleable.static.newSubClass):
                -- they were collected from the source into mixinMemberDocs
                if thisModuleInfo.isMixin and thisModuleInfo.mixinMemberDocs then
                    for name, docs in pairs(thisModuleInfo.mixinMemberDocs) do
                        if docs.isStatic and not staticMethods[name] then
                            addSetKey(staticMethods, name, {
                                moduleName    = thisModuleInfo.moduleName,
                                memberName    = name,
                                memberType    = "function",
                                isMethod      = docs.isMethod,
                                argListString = docs.argListString,
                                fullDoc       = docs.fullDoc,
                                shortDoc      = docs.shortDoc,
                            })
                        end
                    end
                end
                thisModuleInfo.methods   = methods
                thisModuleInfo.functions = functions
                if #extraMethods > 0 then
                    thisModuleInfo.extraMethods = extraMethods
                end
                if #staticMethods > 0 then
                    thisModuleInfo.staticMethods = staticMethods
                end
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
                        addSetKey(r, n, r2)
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
                        addSetKey(s, e.moduleName, s2)
                    end
                    s = s2
                end
            end
            mixinInfo.mixinSupers = mixinSupers
        end
    end

    perf.stop"totalparse"
end

return source_parser
