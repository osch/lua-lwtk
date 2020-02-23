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
        local modules = {}
        local files   = {}
        local maxl = 0
        for file in io.lines(listFilename) do
            if file:match("^.*%.lua$") then
                local module = "lwtk."..file:match("^(.*)%.lua$"):gsub("%/", ".")
                if module:match("%.init$") then
                    module = module:gsub("^(.*)%.init$", "%1")
                end
                modules[#modules + 1] = module
                if #module > maxl then maxl = #module end
                files[module] = file
            end
        end
        table.sort(modules)
        for _, module in ipairs(modules) do
            local file = files[module]
            out[#out+1] = string.format([[        ["%s"]%s = "src/lwtk/%s",]], 
                                        module:gsub("%/", "."),
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

