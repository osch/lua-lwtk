os.setlocale("C")
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
    local pre, m = line:match("^(%s*%-%-) MODULES ([A-Z_]+)")
    if m == "BEGIN" then 
        out[#out+1] = line
        out[#out+1] = pre
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
        table.sort(modules, function(a,b)
            local am, bm = a:match("^lwtk.internal"), b:match("^lwtk.internal")
            if (am and bm) or (not am and not bm) then
                return a < b 
            else
                return not am
            end
        end)
        local isInternal
        for _, module in ipairs(modules) do
            local file = files[module]
            if not isInternal and module:match("^lwtk.internal") then
                isInternal = true
                out[#out+1] = pre
            end
            out[#out+1] = string.format([[        ["%s"]%s = "src/lwtk/%s",]], 
                                        module:gsub("%/", "."),
                                        string.rep(" ", maxl - #module),
                                        file)
        end
    elseif m == "END" then 
        out[#out+1] = pre
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

