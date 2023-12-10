#!/usr/bin/lua

os.setlocale("C")

local args = {...}

if #args == 0 then
    local path = require("path")     -- https://luarocks.org/modules/xavier-wang/lpath
    local fs   = require("path.fs")  -- https://luarocks.org/modules/xavier-wang/lpath

    for n, t in fs.scandir("../doc") do
        if n:match("%.md$") and not n:match("/gen/") and t == "file" and path.isfile(n) then
            args[#args + 1] = n
        end
    end
    table.sort(args)
end

local lwtk = require("lwtk")

function assertEq(a1, a2)
    if not (a1 == a2) then
        error("assertEq failed: "..tostring(a1).." <> "..tostring(a2), 2)
    end
end

for argI = 1, #args do
    local docFileName = args[argI]
    
    local docFile = io.open(docFileName, "r")
    local lines = {}
    for line in docFile:lines() do
        lines[#lines + 1] = line
    end
    docFile:close()
    
    local inLua       = false
    local inHiddenLua = false
    
    local script = {}
    for _, line in ipairs(lines) do
        local isComment = false
        if not inLua then
            isComment = true
            if line:match("^%s*%<%!%-%-%s*lua") then
                inLua = true
                inHiddenLua = true
            elseif line:match("^%s*%`%`%`%s*lua") then
                inLua = true
            end
        else
            if inHiddenLua then
                if line:match("^%s*%-%-%>") then
                    inLua = false
                    inHiddenLua = false
                    isComment = true
                end
            else
                if line:match("^%s*%`%`%`") then
                    inLua = false
                    isComment = true
                end
            end
        end
        if isComment then
            script[#script+1] = "-- "
        end
        if #line > 0 then script[#script+1] = line end
        script[#script+1] = "\n"
    end
    
    local loadFunc do
        local i = 0
        loadFunc = function() i = i + 1 return script[i] end
    end
    local scriptFunc, err = load(loadFunc, docFileName)
    if not scriptFunc then
        error(err)
    end
    
    scriptFunc()
end
