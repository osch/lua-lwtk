#!/usr/bin/lua

local path = require("path")     -- https://luarocks.org/modules/xavier-wang/lpath
local fs   = require("path.fs")  -- https://luarocks.org/modules/xavier-wang/lpath

os.setlocale("C")

local args = {...}

local isfile  = require("path").isfile     -- https://luarocks.org/modules/xavier-wang/lpath
local scandir = require("path.fs").scandir -- https://luarocks.org/modules/xavier-wang/lpath
local sep     = require("path.info").sep

local function path(p)
    return p:gsub("/", sep)
end

if #args == 1 or #args == 0 then
    local dirName
    if #args == 0 then
        dirName = "./tests"
    else
        dirName = args[1]
    end
    local pattern = path("/test.*%.lua$")
    for n, t in scandir(path(dirName)) do
        if n:match(pattern) and t == "file" and isfile(n) then
            args[#args + 1] = n
        end
    end
    table.sort(args)
end

local counter = 0
local tryNext = true

local tests = {}

for argI = 1, #args do
    local testFileName = args[argI]
    counter = counter + 1
    local testname = testFileName:gsub("(test.*)%.lua$", "%1")
    local test = loadfile(testFileName)
    if type(test) == "function" then
        tests[#tests + 1] = testname
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        print("@@@@@@@@@@@", testname)
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        test()
    end
end
print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
for _, t in ipairs(tests) do
    print(t..": OK")
end
print("OK.")
    