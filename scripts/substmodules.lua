local rockspecFilename, listFilename = ...
local inList = false
local rockspecFile = io.open(rockspecFilename, "r")
local lines = {}
for line in rockspecFile:lines() do
    lines[#lines + 1] = line
end
rockspecFile:close()
local out = {}
for _, line in ipairs(lines) do
    local m = line:match("^%s*%-%- MODULES ([A-Z_]+)")
    if m == "BEGIN" then 
        out[#out+1] = line
        inList = true 
        local list = {}
        local maxl = 0
        for file in io.lines(listFilename) do
            file = file:match("^(.*)%.lua$")
            if file then
                list[#list + 1] = file == "init" and "" or file
                if #file > maxl then maxl = #file end
            end
        end
        table.sort(list)
        maxl = maxl + 1
        for _, file in ipairs(list) do
            local module = file == "" and ""     or "."..file
                  file   = file == "" and "init" or file
            out[#out+1] = string.format([[        ["lwtk%s"]%s = "src/lwtk/%s.lua",]], 
                                        module,
                                        string.rep(" ", maxl - #module),
                                        file)
        end
    elseif m == "END" then 
        out[#out+1] = line
        inList = false 
    elseif not inList then
        out[#out+1] = line
    end
end
local rockspecFile = io.open(rockspecFilename, "w")
for _, line in ipairs(out) do
    rockspecFile:write(line.."\n")
end
rockspecFile:close()

