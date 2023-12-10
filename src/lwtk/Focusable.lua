local lwtk = require"lwtk"

local call            = lwtk.call
local getFocusHandler = lwtk.get.focusHandler

local handlePostponedStates

local Focusable = lwtk.newMixin("lwtk.Focusable",

    function(Focusable, Super)

        Focusable:declare(
            "_focusDisabled",
            "_wantsDefault",
            "_wantsFocus",
            "_wantsFocusDisabled",
            "disabled",
            "onHotkeyDown",
            "onKeyDown",
            "hasFocus",
            "onFocusIn",
            "onFocusOut",
            "handleHotkey"
        )
        
        function Focusable.override:_handleHasFocusHandler(focusHandler)
            if Super._handleHasFocusHandler then
                Super._handleHasFocusHandler(self, focusHandler)
            end
            if not self._hidden then
                handlePostponedStates(self, focusHandler)
            end
        end
    
        function Focusable.override:onEffectiveVisibilityChanged(hidden)
            local superCall = Super.onEffectiveVisibilityChanged
            if superCall then
                superCall(self, hidden)
            end
            if not hidden then
                local focusHandler = getFocusHandler[self]
                if focusHandler then
                    handlePostponedStates(self, focusHandler)
                end
            else
                local focusHandler = getFocusHandler[self]
                if focusHandler then
                    if self.hasFocus then
                        focusHandler:releaseFocus(self)
                    end
                    local isCurrentDefault, isPrincipalDefault = focusHandler:isDefault(self)
                    if isCurrentDefault or isPrincipalDefault then
                        focusHandler:setDefault(self, false)
                    end
                end
            end
        end
    
        local Super_onDisabled = Super.onDisabled
    
        function Focusable.override:onDisabled(disableFlag)
            local focusHandler = getFocusHandler[self]
            if focusHandler then
                focusHandler:setFocusDisabled(self, disableFlag)
            else
                self._wantsFocusDisabled = true
            end
            if Super_onDisabled then
                Super_onDisabled(self, disableFlag)
            end
        end
        
    end
)

handlePostponedStates = function(self, focusHandler)
    if self._wantsFocus then
        focusHandler:setFocusTo(self)
        self._wantsFocus = nil
    end
    if self._wantsFocusDisabled then
        focusHandler:setFocusDisabled(self, true)
        self._wantsFocusDisabled = nil
    end
    if self._wantsDefault then
        focusHandler:setDefault(self, self._wantsDefault)
    end
end

function Focusable.implement:_handleFocusIn()
    self.hasFocus = true
    call("onFocusIn", self)
    self:setState("focused", true)
end

function Focusable:_handleFocusOut()
    self.hasFocus = false
    self:setState("focused", false)
    call("onFocusOut", self)
end


function Focusable:setFocus(flag)
    if not self.disabled and (flag == nil or flag) then
        local focusHandler = getFocusHandler[self]
        if focusHandler and not self._hidden then
            focusHandler:setFocusTo(self)
        else
            self._wantsFocus = true
        end
    end
end

function Focusable.extra:setDefault(defaultFlag)
    self._wantsDefault = defaultFlag
    local focusHandler = getFocusHandler[self]
    if focusHandler and not self._hidden then
        focusHandler:setDefault(self, defaultFlag)
    end
end
    
return Focusable
