local lwtk = require"lwtk"

local getApp   = lwtk.get.app
local View     = lwtk.love.View

local Driver   = lwtk.newClass("lwtk.love.Driver")

function Driver:new(initParams)
    self.drawContext   = lwtk.love.DrawContext()
    self.layoutContext = lwtk.love.LayoutContext()
    self.newWindows    = {}
end

function Driver:close()
end

function Driver:newView(window, initParams)
    local view = View(window, initParams)
    local newWindows = self.newWindows
    newWindows[#newWindows + 1] = window
    return view
end

function Driver:setMinSize(window, minW, minH)

end

function Driver:grabFocus(window)
    getApp[self]:setFocusWindow(window)
end

function Driver:getTime()
    return love.timer.getTime()
end

function Driver:setNextProcessTime(t)
    self.nextProcessTime = t
end

function Driver:setProcessFunc(f)
    self.processFunc = f
end

function Driver:getScreenScale()
    return 1
end

function Driver:getLayoutContext()
    return self.layoutContext
end

function Driver:getDrawContext()
    return self.drawContext
end

function Driver:setErrorFunc(...)
end

return Driver
