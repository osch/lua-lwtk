local lwtk  = require"lwtk"
local lpugl = require"lpugl"

assert(lwtk.MOD_SHIFT == lpugl.MOD_SHIFT)
assert(lwtk.MOD_CTRL  == lpugl.MOD_CTRL)
assert(lwtk.MOD_ALT   == lpugl.MOD_ALT)
assert(lwtk.MOD_SUPER == lpugl.MOD_SUPER)
assert(lwtk.MOD_ALTGR == lpugl.MOD_ALTGR)


local CairoLayoutContext = lwtk.lpugl.CairoLayoutContext
local CairoDrawContext   = lwtk.lpugl.CairoDrawContext

local extract = lwtk.extract

local Driver = lwtk.newClass("lwtk.lpugl.Driver")

function Driver:new(initParams)
    self.world = extract(initParams, "world")
    if not self.world then
        local appNname = extract(initParams, "appName")
        assert(appNname, "application name has to be specified in 'appName' attribute")
        self.world = require("lpugl_cairo").newWorld(appNname)
    end
end

function Driver:close()
    self.world:close()
    self.world = nil
end

function Driver:newView(window, initParams)
    return self.world:newView(initParams)
end

function Driver:hasViews()
    return self.world and self.world:hasViews()
end

function Driver:grabFocus(window)
    window.view:grabFocus()
end

function Driver:getTime()
    return self.world:getTime()
end

function Driver:handleNextEvents(timeout)
    return self.world:update(timeout)
end


function Driver:setNextProcessTime(t)
    return self.world:setNextProcessTime(t)
end

function Driver:setProcessFunc(f)
    return self.world:setProcessFunc(f)
end

function Driver:getScreenScale()
    return self.world:getScreenScale()
end

function Driver:getLayoutContext()
    if not self.layoutContext then
        local cairoCtx = self.world:getDefaultBackend():getLayoutContext()
        self.layoutContext = CairoLayoutContext(cairoCtx, require("lpugl").platform)
    end
    return self.layoutContext
end

function Driver:getDrawContext(view)
    local cairoCtx = view:getDrawContext()
    if not self.drawContext then
        self.drawContext = CairoDrawContext(cairoCtx, require("lpugl").platform)
    else
        self.drawContext:_setCairoContext(cairoCtx)
    end
    return self.drawContext
end


function Driver:setErrorFunc(...)
    return self.world:setErrorFunc(...)
end

return Driver
