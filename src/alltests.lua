#!/usr/bin/lua

local search = (package.searchers or package.loaders)[2]

local counter = 0
local tryNext = true

local tests = {}

while tryNext do
    counter = counter + 1
    local testname = string.format("test%02d", counter)
    local test = search("tests."..testname)
    if type(test) == "function" then
        tests[#tests + 1] = testname
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        print("@@@@@@@@@@@", testname)
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        test()
    else
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        for _, t in ipairs(tests) do
            print(t..": OK")
        end
        print("OK.")
        tryNext = false
    end
end
    