local lpugl = require"lpugl.cairo"
local lwtk  = require"lwtk"

local Timer       = lwtk.Timer
local Window      = lwtk.Window
local Application = lwtk.newClass("lwtk.Application")

local getStyleParams  = lwtk.get.styleParams

function Application:new(appName, styleRules)

    getStyleParams[self] = lwtk.StyleParams(lwtk.DefaultStyleTypes(),
                                            styleRules or lwtk.DefaultStyleRules())
    self.appName       = appName
    self.windows       = {}
    self.damageReports = nil
    self.world         = lpugl.newWorld(appName)

    self:_createClosures()

    self.world:setProcessFunc(self.processFunc)
end

function Application:close()
    self.world:close()
end

function Application:setStyle(styleRules) 
    getStyleParams[self]:setStyleRules(styleRules)
end

function Application:addStyle(styleRules) 
    getStyleParams[self]:addStyleRules(styleRules)
end

function Application:newWindow(attributes)
    return Window(self, attributes)
end

function Application:_addWindow(win)
    self.windows[#self.windows + 1] = win
end

function Application:_removeWindow(win)
    for i = 1, #self.windows do
        if self.windows[i] == win then
            self.windows[i] = nil
        end
    end
end

function Application:_processAllChanges()
    if self.hasChanges then
        self.hasChanges = false
        local windows = self.windows
        for _, w in ipairs(windows) do
            if w.hasChanges then
                w.hasChanges = false
                w:_processChanges()
            end
        end
        assert(not self.hasChanges)
    end
end

function Application:runEventLoop()
    local world = self.world
    while world:hasViews() do
        local hasEvents = world:pollEvents()
        if hasEvents then
            world:dispatchEvents()
        end
        if not world:isClosed() then
            self:_processAllChanges()
        end
    end
end

local insert = table.insert
local remove = table.remove

local function unpack2(t, i, n)
    if i <= n then
        return t[i], unpack2(t, i + 1, n)
    end
end
local function unpack(t)
    return unpack2(t, 1, t.n)
end

function Application:_createClosures()
    
    local world  = self.world
    local timers = {}
    
    function self:getCurrentTime()
        return world:getTime() 
    end
    
    function self:setTimer(seconds, func, ...)
        local n = #timers
        local timer
        if type(func) == "table" then
            timer = func
            if timer.time then
                for i = 1, n do
                    if timers[i] == timer then
                        remove(timers, i)
                        n = n - 1
                        break
                    end
                end
            end
        else
            assert(type(func) == "function", "Timer object or function expected")
            timer = Timer(func, ...)
        end
        local now  = world:getTime()
        local time = now + seconds
        timer.time = time
        for i = 1, n do
            if timers[i].time > time then
                insert(timers, i, timer)
                local t = timers[1].time - now
                t = (t >= 0) and t or 0
                world:setNextProcessTime(t)
                return timer
            end
        end
        timers[n + 1] = timer
        local t = timers[1].time - now
        t = (t >= 0) and t or 0
        world:setNextProcessTime(t)
        return timer
    end
    
    function self.processFunc()
        local now = world:getTime()
        while true do
            local timer = timers[1]
            if not timer or timer.time > now then
                break
            end
            remove(timers, 1)
            timer.time = false
            timer.func(unpack(timer))
        end
        local timer = timers[1]
        if timer then
            local t = timer.time - now
            t = (t >= 0) and t or 0
            if not world:isClosed() then
                world:setNextProcessTime(t)
            end
        end
        self:_processAllChanges()
    end
    
    function self.eventFunc(window, event, ...)
        --print(event, ...)
        if event == "CONFIGURE" then
            window:_handleConfigure(...)
        elseif event == "EXPOSE" then
            window:_handleExpose(...)
        elseif event == "MOTION_NOTIFY" then
            window:_handleMouseMove(...)
        elseif event == "LEAVE_NOTIFY" then
            window:_handleMouseLeave(...)
        elseif event == "ENTER_NOTIFY" then
            window:_handleMouseEnter(...)
        elseif event == "KEY_PRESS" then
            window:_handleKeyDown(...)
        elseif event == "BUTTON_PRESS" then
            window:_handleMouseDown(...)
        elseif event == "BUTTON_RELEASE" then
            window:_handleMouseUp(...)
        elseif event == "FOCUS_IN" then
            window:_handleFocusIn(...)
        elseif event == "FOCUS_OUT" then
            window:_handleFocusOut(...)
        elseif event == "CLOSE" then
            window:_handleClose()
        end
        self:_processAllChanges()
    end
    
end



return Application
