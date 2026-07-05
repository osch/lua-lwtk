local path = require("path")     -- https://luarocks.org/modules/xavier-wang/lpath
local perf = require("perf")

local lpeg = require "lpeglabel" -- https://luarocks.org/modules/sergio-medeiros/lpeglabel
lpeg.locale(lpeg)
local P, S = lpeg.P, lpeg.S
local C = lpeg.C
local alnum = lpeg.alnum

local util       = require("mkdoc.util")
local class_util = require("mkdoc.class_util")

local format = string.format

local fprintf    = util.fprintf
local addSetKey  = util.addSetKey

local lwtk = require("lwtk")

local output = {}

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

local function isFunctionMember(m, memberName)
    if m.methods and m.methods[memberName] then
        return true
    end
    if m.functions and m.functions[memberName] then
        return true
    end
    local memberInfo = m.memberInfos and m.memberInfos[memberName]
    return (memberInfo and memberInfo.memberType == "function") or false
end

-- Splits the declared attributes into data attributes and event
-- callbacks (names matching "on%u"). Declared names that are
-- implemented as functions of this module are already documented
-- in the Methods/Functions sections and therefore skipped here.
-- Source order is preserved, underscore prefixed names come last.
local function splitDeclaredAttributes(m)
    local declared = m.declaredAttributes
    if not declared then
        return nil, nil
    end
    local attrs,        callbacks        = {}, {}
    local privateAttrs, privateCallbacks = {}, {}
    for _, a in ipairs(declared) do
        local memberName = a.memberName
        if not isFunctionMember(m, memberName) then
            local list
            if memberName:match("^on%u") then
                list = memberName:match("^_") and privateCallbacks or callbacks
            else
                list = memberName:match("^_") and privateAttrs or attrs
            end
            list[#list + 1] = a
        end
    end
    for _, a in ipairs(privateAttrs)     do attrs[#attrs + 1]         = a end
    for _, a in ipairs(privateCallbacks) do callbacks[#callbacks + 1] = a end
    return (#attrs > 0 and attrs or nil), (#callbacks > 0 and callbacks or nil)
end

-- Collects value members that are real constants: declared attribute
-- slots have the member value false and are handled by
-- splitDeclaredAttributes, static and extra values are documented in
-- their own sections. Members with "__" prefix (e.g. __name of mixins
-- and metas) belong to the class machinery and are skipped.
local function collectConstants(m)
    local constants
    if m.memberInfos then
        for _, info in ipairs(m.memberInfos) do
            if info.isValue and info.member ~= false
               and not info.isStatic and not info.isExtra
               and not info.memberName:match("^__")
            then
                constants = constants or {}
                constants[#constants + 1] = info
            end
        end
    end
    if constants then
        sortMembers(constants)
    end
    return constants
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
            if module.extraMethods then
                sortMembers(module.extraMethods)
            end
            if module.staticMethods then
                sortMembers(module.staticMethods)
            end
            if module.inheritedMethods then
                sortInheritedMembers(module.inheritedMethods)
            end
            if module.inheritedStatics then
                sortInheritedMembers(module.inheritedStatics)
            end
        end
    end
end

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

function output.generate(moduleInfos, modules, packageInfos,
                         classInfos, mixinInfos, metaInfos, functionInfos, otherInfos)

    sortModules(moduleInfos, true)
    sortModules(packageInfos)

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
                    addSetKey(infos, info.moduleName, info)
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
                    -- Section headings carry an explicit inline anchor:
                    -- some renderers (e.g. grip) place the implicit heading
                    -- anchor after the heading, so that fragment links would
                    -- scroll past it. The anchor must be inline within the
                    -- heading line, otherwise it would form an HTML block
                    -- that swallows the heading text.
                    local function prSection(title)
                        local anchor = title:lower():gsub(" ", "-")
                        pr("\n## <a id=%q></a>%s\n", anchor, title)
                    end
                    local function prValueEntry(info)
                        local v = info.member
                        local t = type(v)
                        if t == "string" then
                            pr("   * <span id=%q>**`%s`**</span> = `%s`\n\n", "."..info.memberName,
                                                                              info.memberName, format("%q", v))
                        elseif t == "number" or t == "boolean" then
                            pr("   * <span id=%q>**`%s`**</span> = `%s`\n\n", "."..info.memberName,
                                                                              info.memberName, tostring(v))
                        else
                            pr("   * <span id=%q>**`%s`**</span>\n\n", "."..info.memberName, info.memberName)
                        end
                        if info.fullDoc then
                            pr("%s", class_util.indent(5, substLinks(info.fullDoc)))
                            pr("\n")
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
                            pr(class_util.indent(5, substLinks(m.fullDoc)))
                        end
                    else
                        if m.fullDoc then
                            pr("%s\n", substLinks(m.fullDoc))
                        end
                    end
                    if m.moduleName == "lwtk.Style" or m.moduleName == "lwtk.DefaultStyle"
                       or m.moduleName == "lwtk.BuiltinStyleTypes"
                    then
                        pr("\nSee also the [Style Parameter Index](%sstyleparams.md) for all style\n", genDirPrefix)
                        pr("parameters with their default rules and using classes.\n")
                    end
                    ------------------------------------------------------------------------
                    local declAttrs, declCallbacks = splitDeclaredAttributes(m)
                    local constants = collectConstants(m)
                    -- static and extra members may also be non-function values
                    local staticValues, extraValues
                    if m.memberInfos then
                        for _, info in ipairs(m.memberInfos) do
                            if (info.isStatic or info.isExtra) and info.member ~= false
                               and info.memberType ~= "function"
                            then
                                if info.isStatic then
                                    staticValues = staticValues or {}
                                    staticValues[#staticValues + 1] = info
                                else
                                    extraValues = extraValues or {}
                                    extraValues[#extraValues + 1] = info
                                end
                            end
                        end
                        if staticValues then
                            sortMembers(staticValues)
                        end
                        if extraValues then
                            sortMembers(extraValues)
                        end
                    end
                    local fullClassPath = m.isClass and class_util.getClassPathList(module) or nil
                    -- style parameters used by super classes (nearest first),
                    -- without those already listed by this module or a closer super:
                    -- for classes the class path is walked, for mixins all
                    -- realisation paths (each from the mixin upwards to the root)
                    local inheritedStyleParams
                    do
                        local seenParams  = {}
                        local superEntries = {}
                        local function addSuperParams(superModuleName)
                            if superModuleName == m.moduleName then
                                return
                            end
                            local superInfo = moduleInfos[superModuleName]
                            if superInfo and not superInfo.isInternal and superInfo.usedStyleParams then
                                for _, p in ipairs(superInfo.usedStyleParams) do
                                    if not seenParams[p] then
                                        seenParams[p] = true
                                        local entry = superEntries[superModuleName]
                                        if not entry then
                                            entry = {
                                                moduleName = superInfo.moduleName,
                                                isMixin    = superInfo.isMixin,
                                                params     = {},
                                            }
                                            superEntries[superModuleName] = entry
                                            inheritedStyleParams = inheritedStyleParams or {}
                                            inheritedStyleParams[#inheritedStyleParams + 1] = entry
                                        end
                                        entry.params[#entry.params + 1] = p
                                    end
                                end
                            end
                        end
                        if m.usedStyleParams then
                            for _, p in ipairs(m.usedStyleParams) do
                                seenParams[p] = true
                            end
                        end
                        if m.isClass then
                            for i = 2, #fullClassPath do
                                addSuperParams(fullClassPath[i].moduleName)
                            end
                        elseif m.isMixin and m.mixinRealisations then
                            -- realisation paths are reverse class paths:
                            -- r[1] is the root class, r[#r] the mixin itself
                            for _, r in ipairs(m.mixinRealisations) do
                                for i = #r, 1, -1 do
                                    addSuperParams(r[i].moduleName)
                                end
                            end
                        end
                        if inheritedStyleParams then
                            for _, entry in ipairs(inheritedStyleParams) do
                                table.sort(entry.params)
                            end
                        end
                    end
                    -- init parameters: Object:setAttributes maps each
                    -- constructor init parameter key to the corresponding
                    -- setter method set<Key>, so the accepted parameters are
                    -- derived from the setters of the whole class path
                    local initParamSetters
                    local hasActionableInPath = false
                    if m.isClass then
                        local seenParams = {}
                        local function addSetter(memberName, fromModuleName)
                            if memberName == "setInitParams" or memberName == "setAttributes" then
                                return -- these implement the mechanism itself
                            end
                            local paramName = memberName:match("^set(%u[%w_]*)$")
                            if paramName then
                                paramName = paramName:sub(1, 1):lower()..paramName:sub(2)
                                if not seenParams[paramName] then
                                    seenParams[paramName] = true
                                    initParamSetters = initParamSetters or {}
                                    initParamSetters[#initParamSetters + 1] = {
                                        paramName  = paramName,
                                        setterName = memberName,
                                        moduleName = fromModuleName, -- nil for own setters
                                    }
                                end
                            end
                        end
                        if m.methods then
                            for _, meth in ipairs(m.methods) do
                                addSetter(meth.memberName, nil)
                            end
                        end
                        if m.functions then
                            for _, f in ipairs(m.functions) do
                                addSetter(f.memberName, nil)
                            end
                        end
                        if m.inheritedMethods then
                            for _, fromList in ipairs(m.inheritedMethods) do
                                for _, fr in ipairs(fromList) do
                                    addSetter(fr.memberName, fromList.moduleName)
                                end
                            end
                        end
                        if initParamSetters then
                            table.sort(initParamSetters, function(a, b)
                                return a.paramName < b.paramName
                            end)
                        end
                        for _, c in ipairs(fullClassPath) do
                            if c.moduleName == "lwtk.Actionable" then
                                hasActionableInPath = true
                                break
                            end
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
                        classPathList = class_util.getClassPathList(module)
                        -- also for the root class without super classes:
                        -- inheritance paths of other pages link to #inheritance
                        assureContentsTitle()
                        pr("   * [Inheritance](#inheritance)\n")
                    elseif m.isMixin then
                        if #m.mixinRealisations > 0 then
                            assureContentsTitle()
                            pr("   * [Inheritance](#inheritance)\n")
                        end
                    end
                    local hasNewOk, hasNew = pcall(function() return module["new"] end)
                    hasNew = hasNewOk and hasNew
                    local hasConstructor = (m.isMeta or m.isClass) and hasNew
                    if m.isMixin and not hasConstructor then
                        -- a mixin's new() lives on the realised classes, not
                        -- on the mixin table itself: only mixins whose own
                        -- source defines new() get a constructor section
                        -- (realisations may inherit new() from other mixins)
                        hasConstructor = (m.mixinMemberDocs and m.mixinMemberDocs["new"] ~= nil)
                    end
                    if hasConstructor then
                        assureContentsTitle()
                        pr("   * [Constructor](#constructor)\n")
                    end
                    if initParamSetters then
                        assureContentsTitle()
                        pr("   * [Init Parameters](#init-parameters)\n")
                    end
                    if declAttrs then
                        assureContentsTitle()
                        pr("   * [Attributes](#attributes)\n")
                        for _, a in ipairs(declAttrs) do
                            pr("      * [%s%s](#.%s)", a.memberName, a.argListString and "()" or "", a.memberName)
                            if a.shortDoc then
                                pr(" - %s", a.shortDoc)
                            end
                            pr("\n")
                        end
                    end
                    if declCallbacks then
                        assureContentsTitle()
                        pr("   * [Event Callbacks](#event-callbacks)\n")
                        for _, a in ipairs(declCallbacks) do
                            pr("      * [%s()](#.%s)", a.memberName, a.memberName)
                            if a.shortDoc then
                                pr(" - %s", a.shortDoc)
                            end
                            pr("\n")
                        end
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
                    if m.staticMethods or staticValues then
                        assureContentsTitle()
                        pr("   * [Static Members](#static-members)\n")
                        for _, meth in ipairs(m.staticMethods or {}) do
                            pr("      * [%s()](#.%s)", meth.memberName, meth.memberName)
                            if meth.shortDoc then
                                pr(" - %s", meth.shortDoc)
                            end
                            pr("\n")
                        end
                        for _, info in ipairs(staticValues or {}) do
                            pr("      * [%s](#.%s)\n", info.memberName, info.memberName)
                        end
                    end
                    if m.extraMethods or extraValues then
                        assureContentsTitle()
                        pr("   * [Extra Members](#extra-members)\n")
                        for _, meth in ipairs(m.extraMethods or {}) do
                            pr("      * [%s()](#.%s)", meth.memberName, meth.memberName)
                            if meth.shortDoc then
                                pr(" - %s", meth.shortDoc)
                            end
                            pr("\n")
                        end
                        for _, info in ipairs(extraValues or {}) do
                            pr("      * [%s](#.%s)\n", info.memberName, info.memberName)
                        end
                    end
                    if constants then
                        assureContentsTitle()
                        pr("   * [Constants](#constants)\n")
                    end
                    if m.defaultStyleRules then
                        assureContentsTitle()
                        pr("   * [Default Style Rules](#default-style-rules)\n")
                    end
                    if m.keyBindings then
                        assureContentsTitle()
                        pr("   * [Key Bindings](#key-bindings)\n")
                    end
                    if m.usedStyleParams or inheritedStyleParams then
                        assureContentsTitle()
                        pr("   * [Used Style Parameters](#used-style-parameters)\n")
                    end
                    if m.inheritedMethods and #m.inheritedMethods > 0 then
                        assureContentsTitle()
                        pr("   * [Inherited Methods](#inherited-methods)\n")
                    end
                    if m.inheritedStatics and #m.inheritedStatics > 0 then
                        assureContentsTitle()
                        pr("   * [Inherited Static Members](#inherited-static-members)\n")
                    end
                    if (m.isClass or m.isMixin) and #m.subClassPaths > 0 then
                        assureContentsTitle()
                        pr("   * [Subclasses](#subclasses)\n")
                    end
                    ------------------------------------------------------------------------
                    pr("\n")
                    if m.isClass then
                        prSection("Inheritance")
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
                        prSection("Inheritance")
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
                        prSection("Constructor")
                        if m.isMixin then
                            -- a mixin's new() is invoked while constructing
                            -- instances of the realised classes, the mixin
                            -- itself is not instantiated: use method syntax
                            local newInfo = m.memberInfos and m.memberInfos["new"]
                            local docs = m.mixinMemberDocs and m.mixinMemberDocs["new"]
                            local argListString = (newInfo and newInfo.argListString)
                                                  or (docs and docs.argListString)
                            local fullDoc = (newInfo and newInfo.fullDoc)
                                            or (docs and docs.fullDoc)
                            pr("   * <span id=%q>**`%s:new(%s)`**</span>\n\n", ".new", shortModuleName,
                                                                               argListString or "?")
                            if fullDoc then
                                pr("%s", class_util.indent(5, substLinks(fullDoc)))
                                pr("\n")
                            end
                        elseif m.isMeta or module.declared["new"] then
                            local newInfo = assert(m.memberInfos["new"])
                            local argListString = newInfo.argListString
                            pr("   * <span id=%q>**`%s(%s)`**</span>\n\n", ".new", shortModuleName,
                                                                                   argListString or "?")
                            if newInfo.fullDoc then
                                pr(class_util.indent(5, newInfo.fullDoc))
                                pr("\n")
                            end
                            local overrideList = m.isClass and class_util.getOverrideList(module, "new")
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
                            local inheritedFrom = class_util.findDeclaratingSuperClass(module, "new")
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
                    if initParamSetters then
                        prSection("Init Parameters")
                        pr("\n")
                        pr("The following parameters can be given to the constructor; each parameter\n")
                        pr("is handled by the corresponding setter method:\n\n")
                        for _, s in ipairs(initParamSetters) do
                            if s.moduleName then
                                local b = moduleInfos[s.moduleName]
                                          and moduleInfos[s.moduleName].isMixin and "" or "**"
                                pr("   * `%s` - %s[%s:%s()](%s%s.md#.%s)%s\n",
                                       s.paramName, b,
                                       s.moduleName:gsub("^lwtk%.", ""), s.setterName,
                                       genDirPrefix, s.moduleName:gsub("%.", "/"), s.setterName,
                                       b)
                            else
                                pr("   * `%s` - [%s()](#.%s)\n", s.paramName, s.setterName, s.setterName)
                            end
                        end
                        if hasActionableInPath then
                            pr("\n%s\n", substLinks("Additionally parameters matching `onAction<ActionName>` register "
                                                    .."action methods, see lwtk.Actionable for details."))
                        end
                    end
                    if declAttrs then
                        prSection("Attributes")
                        for _, a in ipairs(declAttrs) do
                            if a.argListString then
                                pr("   * <span id=%q>**`%s(%s)`**</span>\n\n", "."..a.memberName, a.memberName,
                                                                               a.argListString)
                            elseif a.types then
                                local typeParts = {}
                                for i, t in ipairs(a.types) do
                                    if t:find(".", 1, true) then
                                        -- class type: substLinks renders it as link
                                        typeParts[i] = substLinks(t)
                                    else
                                        typeParts[i] = format("`%s`", t)
                                    end
                                end
                                pr("   * <span id=%q>**`%s`**</span> : %s\n\n", "."..a.memberName, a.memberName,
                                                                                table.concat(typeParts, "|"))
                            else
                                pr("   * <span id=%q>**`%s`**</span>\n\n", "."..a.memberName, a.memberName)
                            end
                            if a.fullDoc then
                                pr("%s", class_util.indent(5, substLinks(a.fullDoc)))
                                pr("\n")
                            end
                        end
                    end
                    if declCallbacks then
                        prSection("Event Callbacks")
                        for _, a in ipairs(declCallbacks) do
                            if a.argListString then
                                pr("   * <span id=%q>**`%s(%s)`**</span>\n\n", "."..a.memberName, a.memberName, a.argListString)
                            else
                                pr("   * <span id=%q>**`%s`**</span>\n\n", "."..a.memberName, a.memberName)
                            end
                            if a.fullDoc then
                                pr("%s", class_util.indent(5, substLinks(a.fullDoc)))
                                pr("\n")
                            end
                        end
                    end
                    for _, section in pairs(methodFunctionSections) do
                        if section[3] and #section[3] > 0 then
                            prSection(section[1])
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
                                    pr(class_util.indent(5, meth.fullDoc))
                                    pr("\n")
                                elseif original and original.fullDoc then
                                    pr(class_util.indent(5, original.fullDoc))
                                    pr("\n")
                                end 
                                if original then
                                    if original.isModule then
                                        pr("        * Implementation: [%s()](%s%s.md)\n", 
                                                                            original.moduleName,
                                                                            genDirPrefix,
                                                                            original.moduleName:gsub("%.","/"))
                                    else
                                        pr("        * Implementation: [%s%s%s()](%s%s.md#.%s)\n",
                                                                            original.moduleName:gsub("^lwtk%.",""),
                                                                            original.isExtra and ".extra:" or ":",
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
                    if m.staticMethods or staticValues then
                        prSection("Static Members")
                        pr("\n")
                        pr("Static members are only available in the class object,\n")
                        pr("not in the derived objects:\n\n")
                        for _, meth in ipairs(m.staticMethods or {}) do
                            local sep = meth.isMethod and ":" or "."
                            pr("   * <span id=%q>**`%s%s%s(%s)`**</span>\n\n", "."..meth.memberName,
                                                                               shortModuleName, sep, meth.memberName,
                                                                               meth.argListString or "?")
                            if meth.fullDoc then
                                pr("%s", class_util.indent(5, substLinks(meth.fullDoc)))
                                pr("\n")
                            end
                        end
                        for _, info in ipairs(staticValues or {}) do
                            prValueEntry(info)
                        end
                    end
                    if m.extraMethods or extraValues then
                        prSection("Extra Members")
                        pr("\n")
                        pr("Members of the `extra` subtable are not inherited by subclasses and\n")
                        pr("are not available in derived objects: subclasses adopt them explicitly.\n\n")
                        for _, meth in ipairs(m.extraMethods or {}) do
                            local sep = meth.isMethod and ":" or "."
                            pr("   * <span id=%q>**`%s.extra%s%s(%s)`**</span>\n\n", "."..meth.memberName,
                                                                                     shortModuleName, sep, meth.memberName,
                                                                                     meth.argListString or "?")
                            if meth.fullDoc then
                                pr("%s", class_util.indent(5, substLinks(meth.fullDoc)))
                                pr("\n")
                            end
                        end
                        for _, info in ipairs(extraValues or {}) do
                            prValueEntry(info)
                        end
                    end
                    if constants then
                        prSection("Constants")
                        for _, c in ipairs(constants) do
                            local value = c.member
                            local valueString
                            if type(value) == "string" then
                                valueString = format("%q", value)
                            else
                                valueString = tostring(value)
                            end
                            pr("   * <span id=%q>**`%s.%s`**</span> = `%s`\n\n", "."..c.memberName, shortModuleName,
                                                                                 c.memberName, valueString)
                            if c.fullDoc then
                                pr("%s", class_util.indent(5, substLinks(c.fullDoc)))
                                pr("\n")
                            end
                        end
                    end
                    if m.defaultStyleRules then
                        prSection("Default Style Rules")
                        pr("\n")
                        pr("A rule name consists of the style parameter name with optional class and\n")
                        pr("state selectors, see [lwtk.Style](%slwtk/Style.md). All default values can be\n", genDirPrefix)
                        pr("overridden by constructor init parameters of the same name.\n\n")
                        pr("| Rule | Default Value |\n")
                        pr("|------|---------------|\n")
                        for _, r in ipairs(m.defaultStyleRules) do
                            pr("| `%s` | `%s` |\n", r.selector, r.valueText)
                        end
                        pr("\n")
                    end
                    if m.keyBindings then
                        prSection("Key Bindings")
                        pr("\n")
                        pr("| Keys | Action |\n")
                        pr("|------|--------|\n")
                        for _, b in ipairs(m.keyBindings) do
                            local keys = {}
                            for i, k in ipairs(b.keys) do
                                keys[i] = format("`%s`", k)
                            end
                            pr("| %s | `%s` |\n", table.concat(keys, ", "), b.action)
                        end
                        pr("\n")
                    end
                    if m.usedStyleParams or inheritedStyleParams then
                        prSection("Used Style Parameters")
                        pr("\n")
                        pr("%s\n", substLinks("See also lwtk.Style, lwtk.DefaultStyle and lwtk.BuiltinStyleTypes "
                                              .."for more information about style parameters."))
                        pr("The [Style Parameter Index](%sstyleparams.md) lists all style parameters.\n\n", genDirPrefix)
                        if m.usedStyleParams then
                            pr("The implementation uses the following style parameters:\n\n")
                            for _, paramName in ipairs(m.usedStyleParams) do
                                pr("   * `%s`\n", paramName)
                            end
                        end
                        if inheritedStyleParams then
                            if m.usedStyleParams then
                                pr("\n")
                            end
                            pr("Style parameters used in super classes:\n\n")
                            for _, sup in ipairs(inheritedStyleParams) do
                                local b = sup.isMixin and "" or "**"
                                pr("   * %s[%s](%s%s.md#used-style-parameters)%s: ", b,
                                                    sup.moduleName:gsub("^lwtk%.", ""),
                                                    genDirPrefix,
                                                    sup.moduleName:gsub("%.", "/"),
                                                    b)
                                for i, paramName in ipairs(sup.params) do
                                    if i > 1 then
                                        pr(", ")
                                    end
                                    pr("`%s`", paramName)
                                end
                                pr("\n")
                            end
                        end
                    end
                    if m.inheritedMethods and #m.inheritedMethods > 0 then
                        prSection("Inherited Methods")
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
                    if m.inheritedStatics and #m.inheritedStatics > 0 then
                        prSection("Inherited Static Members")
                        for _, fromList in ipairs(m.inheritedStatics) do
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
                        prSection("Subclasses")
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
    ---------------------------------------------------------------------------------------------------------------------------
    do
        -- style parameter index: reverse mapping parameter -> using classes,
        -- combined with the default rules from lwtk.DefaultStyle
        local substLinks = newSubstLinks("")
        local paramNames = {}
        local paramUsers = {}
        for _, mi in ipairs(moduleInfos) do
            if not mi.isInternal and mi.usedStyleParams then
                for _, p in ipairs(mi.usedStyleParams) do
                    local users = paramUsers[p]
                    if not users then
                        users = {}
                        paramUsers[p] = users
                        paramNames[#paramNames + 1] = p
                    end
                    users[#users + 1] = mi
                end
            end
        end
        local paramDefaults = {}
        local dsInfo = moduleInfos["lwtk.DefaultStyle"]
        if dsInfo and dsInfo.defaultStyleRules then
            for _, r in ipairs(dsInfo.defaultStyleRules) do
                local base = r.selector:match("^[%w_%*]+")
                if base then
                    local defs = paramDefaults[base]
                    if not defs then
                        defs = {}
                        paramDefaults[base] = defs
                        if not paramUsers[base] then
                            paramNames[#paramNames + 1] = base
                        end
                    end
                    defs[#defs + 1] = r
                end
            end
        end
        table.sort(paramNames)
        local out = assert(io.open("../doc/gen/styleparams.md", "w"))
        do
            local function pr(...)
                fprintf(out, ...)
            end
            pr("# Style Parameter Index\n\n")
            pr("%s\n\n", substLinks("All style parameters with their default rules from lwtk.DefaultStyle "
                                    .."and the classes whose implementation uses them. See lwtk.Style and "
                                    .."lwtk.BuiltinStyleTypes for more information about style parameters."))
            for _, p in ipairs(paramNames) do
                pr("   * <span id=%q>**`%s`**</span>\n", "."..p, p)
                local defs = paramDefaults[p]
                if defs then
                    for _, r in ipairs(defs) do
                        local suffix = r.selector:sub(#p + 1)
                        if suffix == "" then
                            pr("      * default: `%s`\n", r.valueText)
                        else
                            pr("      * default `%s`: `%s`\n", suffix, r.valueText)
                        end
                    end
                end
                local users = paramUsers[p]
                if users then
                    pr("      * used by: ")
                    for i, mi in ipairs(users) do
                        if i > 1 then
                            pr(", ")
                        end
                        local b = mi.isClass and "**" or ""
                        pr("%s[%s](%s#used-style-parameters)%s", b, mi.moduleName:gsub("^lwtk%.", ""),
                                                                 mi.docFileName, b)
                    end
                    pr("\n")
                end
            end
        end
        out:close()
    end
    perf.stop"output"
end

return output
