local error = error
local format = string.format

local function errorf(formatString, ...)
    error(format(formatString, ...), 2)
end

return errorf
