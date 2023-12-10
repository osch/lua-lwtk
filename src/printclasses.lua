#!/usr/bin/lua

os.setlocale("C")

local option = ...

local format = string.format
local lwtk   = require("lwtk")
local lfs    = require("lfs")

lwtk.NDEBUG = true

local moduleNames = {}

local function collect(dir)
    for entry in lfs.dir(dir) do
        local n = entry:match("^([^.]+)%.lua$")
        if n and n ~= "init" then
            moduleNames[#moduleNames + 1] = (dir.."/"..n):gsub("/", ".")
        end
    end
end

collect("lwtk")
collect("lwtk/internal")
collect("lwtk/lpugl")
collect("lwtk/love")

table.sort(moduleNames)

local maxl = 0
local classes = {}
local classpaths = {}
local stylepaths = {}
for i = 1, #moduleNames do
    local n = moduleNames[i]
    local m = require(n)
    if lwtk.type(m) == "lwtk.Class" then
        classes[n] = m
        if #n > maxl then
            maxl = #n
        end
        classpaths[#classpaths + 1] = m:getReverseClassPath():gsub("([/#])lwtk%.", "%1")
        stylepaths[#stylepaths + 1] = lwtk.get.stylePath[m]
    end
end

--[[
for _, n in ipairs(moduleNames) do
    if classes[n] then
        --print(n, lwtk.get.stylePath[m])
        print(format("%-"..maxl.."s: %s", n, getFullPath(classes[n])))    
    end
end
--]]

table.sort(classpaths)
table.sort(stylepaths)

for _, p in ipairs(option == "style" and stylepaths or classpaths) do
    print(p)
end
