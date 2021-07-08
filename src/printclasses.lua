#!/usr/bin/lua

os.setlocale("C")

local format = string.format
local lwtk   = require("lwtk")
local lfs    = require("lfs")

local moduleNames = {}

for entry in lfs.dir("lwtk") do
    local n = entry:match("^([^.]+)%.lua$")
    if n and n ~= "init" then
        moduleNames[#moduleNames + 1] = n
    end
end


local function getFullPath(c)
    local s = c.super
    local p = s and getFullPath(s).."->" or ""
    return p..c.__name
end

table.sort(moduleNames)

local maxl = 0
local classes = {}
local paths = {}
for i = 1, #moduleNames do
    local n = moduleNames[i]
    local m = require("lwtk."..n)
    if lwtk.type(m) == "lwtk.Class" then
        classes[n] = m
        if #n > maxl then
            maxl = #n
        end
        paths[#paths + 1] = getFullPath(m)
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

table.sort(paths)
for _, p in ipairs(paths) do
    print(p)
end
