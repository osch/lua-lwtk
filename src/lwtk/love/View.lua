local lwtk = require"lwtk"

local floor  = math.floor
local unpack = unpack or table.unpack

local getWindow = lwtk.WeakKeysTable()

local View = lwtk.newClass("lwtk.love.View")

View:declare(
    "x", "y", "w", "h",
    "damagedArea",
    "canvas",
    "closed"
)

function View:new(window, initParams)
    getWindow[self] = window
    self.damagedArea = lwtk.Area()
    local size = initParams.size
    local frame = initParams.frame
    if size and frame then
        error("only one parameter 'size' or 'frame' is allowed")
    elseif not size and not frame then
        error("intial 'size' or 'frame' must be given")
    end
    if not frame then
        local w, h = size[1], size[2]
        local W, H = love.graphics.getDimensions()
        frame = { floor((W-w)/2 + 0.5), 
                  floor((H-h)/2 + 0.5), w, h }
    end
    if #frame ~= 4 then
        error("lwtk.Window frame not set")
    end
    self.x, self.y, self.w, self.h = unpack(frame)
    self.damagedArea:addRect(0, 0, self.w, self.h)
    self.canvas = love.graphics.newCanvas(self.w, self.h)
end

function View:postRedisplay(x, y, w, h)
    self.damagedArea:addRect(x, y, w, h)
end

function View:setMinSize()

end

function View:setMaxSize()

end

function View:setFrame(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.damagedArea:clear()
    self.damagedArea:addRect(0, 0, w, h)
    self.canvas = love.graphics.newCanvas(w, h)
    local window = getWindow[self]
    window:_handleConfigure(x, y, w, h)
end

function View:setSize(w, h)
    local W, H = love.graphics.getDimensions()
    local x, y = floor((W-w)/2 + 0.5), 
                 floor((H-h)/2 + 0.5)
    self:setFrame(x, y, w, h)
end

function View:show()

end

function View:isClosed() 
    return self.closed
end

function View:close()
    self.closed = true
end
return View


