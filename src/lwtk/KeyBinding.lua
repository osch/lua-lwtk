local lwtk = require"lwtk"

local match  = string.match
local utf8   = lwtk.utf8
local upper  = utf8.upper
local lower  = utf8.lower

local KeyBinding = lwtk.newClass("lwtk.KeyBinding")

local function normalizeKeyName(key)
    key = string.gsub(key, "^ *(.-) *$", "%1")
    local isKP
    local m = match(key, "^KP_()")
    if m then
        isKP = true
        key = key:sub(m)
    end
    local a = upper(utf8.sub(key, 1, 1))
    local b = lower(utf8.sub(key, 2))
    b = utf8.gsub(b, "_(.)", function(arg) return "_"..upper(arg) end)
    return (isKP and "KP_" or "")..a..b
end

local function normalize(entry)
    entry = upper(entry)
    local isShift, isCtrl, isAlt, isAltGr, isSuper
    local p0 = 1
    local p  = p0
    while true do
        local m = match(entry, "^ *CTRL%+()", p)
        if m then
            isCtrl = true
            p = m
        end
        m = match(entry, "^ *CONTROL%+()", p)
        if m then
            isCtrl = true
            p = m
        end
        m = match(entry, "^ *ALT%+()", p)
        if m then
            isAlt = true
            p = m
        end
        m = match(entry, "^ *ALT_?GR%+()", p)
        if m then
            isAltGr = true
            p = m
        end
        m = match(entry, "^ *SHIFT%+()", p)
        if m then
            isShift = true
            p = m
        end
        m = match(entry, "^ *SUPER%+()", p)
        if m then
            isSuper = true
            p = m
        end
        if p == p0 then
            break
        else
            p0 = p
        end
    end
    local key = normalizeKeyName(entry:sub(p0))
    return   (isShift and "Shift+" or "")
           ..(isCtrl  and "Ctrl+"  or "")
           ..(isAlt   and "Alt+"   or "")
           ..(isAltGr and "AltGr+" or "")
           ..(isSuper and "Super+" or "")
           ..key
end

local function toKeyList(entry)
    local rslt = {}
    local p = 1
    while true do
        local m = match(entry, "(),", p)
        if m then
            rslt[#rslt + 1] = normalize(entry:sub(p, m - 1))
            p = m + 1
        else
            break
        end
    end
    if p <= #entry then
        rslt[#rslt + 1] = normalize(entry:sub(p))
    end
    return rslt
end

function KeyBinding:new(rules)
    for _, rule in ipairs(rules) do
        for i = 1, #rule-1 do
            local keyList = toKeyList(rule[i])
            if #keyList > 0 then
                local lookup = self
                for _, k in ipairs(keyList) do
                    local entries = lookup[k]
                    if not entries then 
                        local path = lookup[-1]
                        entries = { [0]  = false,
                                    [-1] = (path and (path..","..k) or k) }
                        lookup[0] = true
                        lookup[k] = entries
                    end
                    lookup = entries
                end
                lookup[#lookup + 1] = "onAction"..rule[#rule]
            end
        end
    end
end

return KeyBinding
