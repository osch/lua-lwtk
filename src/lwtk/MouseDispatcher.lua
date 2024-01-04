local lwtk = require("lwtk")

local call = lwtk.call

local MouseDispatcher = lwtk.newMixin("lwtk.MouseDispatcher", lwtk.Styleable.NO_STYLE_SELECTOR,
    
    function(MouseDispatcher, Super)

        MouseDispatcher:declare(
            "mouseButtonChild",
            "mouseChildButtons",
            "mouseHoverChild",
            "mouseX",
            "mouseY"
        )
    
        function MouseDispatcher.override:new(initParams)
            self.mouseChildButtons = {}
            Super.new(self, initParams)
        end
        
        function MouseDispatcher.override:removeChild(child)
            if Super.removeChild then
                local removedChild = Super.removeChild(self, child)
                if self.mouseHoverChild ==  removedChild then
                    self.mouseHoverChild = false
                end
                if self.mouseButtonChild ==  removedChild then
                    self.mouseButtonChild = false
                end
                return removedChild
            end
        end
        
    end
)


local function findChildAt(self, mx, my)
    for i = #self, 1, -1 do
        local child = self[i]
        if child.visible then
            local x, y, w, h = child.x, child.y, child.w, child.h
            if     x <= mx and mx < x + w 
               and y <= my and my < y + h 
            then
                return child
            end
        end
    end
end


local function processMouseMove(self, entered, mx, my)

    self.mouseX = mx
    self.mouseY = my
    
    local uChild = entered and findChildAt(self, mx, my)
    
    local bChild = self.mouseButtonChild
    if bChild then
        if bChild ~= self then
            local x, y = bChild.x, bChild.y
            if bChild == uChild then
                if self.mouseHoverChild ~= bChild then
                    self.mouseHoverChild = bChild
                    bChild:_processMouseEnter(mx - x, my - y)
                else
                    bChild:_processMouseMove(entered, mx - x, my - y)
                end
            else
                if self.mouseHoverChild == bChild then
                    self.mouseHoverChild = nil
                    bChild:_processMouseLeave(mx - x, my - y)
                else
                    bChild:_processMouseMove(false, mx - x, my - y)
                end
            end
        else
            if entered then
                if self.mouseHoverChild == self then
                    call("onMouseMove", self, mx, my)
                else
                    self.mouseHoverChild = self
                    local onMouseEnter = self.onMouseEnter
                    if onMouseEnter then
                        onMouseEnter(self, mx, my)
                    else
                        call("onMouseMove", self, mx, my)
                    end
                end
            else
                if self.mouseHoverChild == self then
                    self.mouseHoverChild = nil
                    self:_processMouseLeave(mx, my)
                else
                    call("onMouseMove", self, mx, my)
                end
            end
        end
    else
        if uChild then
            local x, y = uChild.x, uChild.y
            local hChild = self.mouseHoverChild
            if hChild ~= uChild then
                if hChild then
                    if hChild ~= self then
                        hChild:_processMouseLeave(mx - hChild.x, my - hChild.y)
                    else
                        call("onMouseLeave", self, mx, my)
                    end
                end
                self.mouseHoverChild = uChild
                uChild:_processMouseEnter(mx - x, my - y)
            else
                uChild:_processMouseMove(entered, mx - x, my - y)
            end
        else
            local hChild = self.mouseHoverChild
            local justEntered
            if hChild ~= self then
                justEntered = entered
                if hChild then
                    hChild:_processMouseLeave(mx - hChild.x, my - hChild.y)
                end
                self.mouseHoverChild = self
            end
            if justEntered then
                local onMouseEnter = self.onMouseEnter
                if onMouseEnter then
                    onMouseEnter(self, mx, my)
                else
                    call("onMouseMove", self, mx, my)
                end
            else
                call("onMouseMove", self, mx, my)
            end
        end
    end
end

function MouseDispatcher.override:_processMouseEnter(mx, my)
    processMouseMove(self, true, mx, my)
end

function MouseDispatcher.override:_processMouseMove(mouseEntered, mx, my)
    processMouseMove(self, mouseEntered, mx, my)
end

function MouseDispatcher.override:_processMouseScroll(dx, dy)
    local hChild = self.mouseHoverChild
    if hChild and hChild ~= self then
        hChild:_processMouseScroll(dx, dy)
    end
end

function MouseDispatcher.override:_processMouseLeave(mx, my)
    self.mouseX = mx
    self.mouseY = my
    local bChild = self.mouseButtonChild
    if bChild then
        if bChild ~= self then
            bChild:_processMouseLeave(mx - bChild.x, my - bChild.y)
        else
            call("onMouseLeave", self, mx, my)
        end
    else
        local hChild = self.mouseHoverChild
        if hChild then
            self.mouseHoverChild = nil
            if hChild ~= self then
                hChild:_processMouseLeave(mx - hChild.x, my - hChild.y)
            else
                call("onMouseLeave", hChild, mx, my)
            end
        end
    end
end

function MouseDispatcher.override:_processMouseDown(mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    local bChild = self.mouseButtonChild
    if bChild then
        self.mouseChildButtons[button] = true
        local received, handled = false, false -- luacheck: ignore 231/received 311/handled
        if self ~= bChild then
            received, handled = bChild:_processMouseDown(mx - bChild.x, my - bChild.y,
                                                         button, modState)
        else
            handled = call("onMouseDown", self, mx, my, button, modState)
        end
        return true, handled
    else
        local uChild = findChildAt(self, mx, my)
        if uChild then
            local x, y = uChild.x, uChild.y
            self.mouseButtonChild = uChild
            self.mouseChildButtons[button] = true
            call("onMouseDown", self, mx, my, button, modState)
            local received, handled = uChild:_processMouseDown(mx - x, my - y, button, modState) -- luacheck: ignore 211/received
            return true, handled
        else
            self.mouseButtonChild = self
            self.mouseChildButtons[button] = true
            local handled = call("onMouseDown", self, mx, my, button, modState)
            return false, handled
        end
    end
end

local function hasButtons(buttons)
    for k, v in pairs(buttons) do
        if v then return true end
    end
end

function MouseDispatcher.override:_processMouseUp(mouseEntered, mx, my, button, modState)
    self.mouseX = mx
    self.mouseY = my
    local bChild = self.mouseButtonChild
    if bChild then
        local buttons = self.mouseChildButtons
        buttons[button] = false
        local uChild = mouseEntered and findChildAt(self, mx, my)
        if self ~= bChild then
            bChild:_processMouseUp(uChild == bChild, mx - bChild.x, my - bChild.y, button, modState)
        else
            call("onMouseUp", self, mx, my, button, modState)
        end
        if not hasButtons(buttons) then
            self.mouseButtonChild = nil
        end
        self:_processMouseMove(mouseEntered, mx, my)
    end
end

return MouseDispatcher
