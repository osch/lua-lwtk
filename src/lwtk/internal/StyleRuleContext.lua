local lwtk = require"lwtk"

local match  = string.match
local lower  = string.lower
local errorf = lwtk.errorf

local StyleRuleContext = lwtk.newClass("lwtk.internal.StyleRuleContext")

StyleRuleContext:declare(
    "ctxRules",
    "style",
    "classSelectorPath",
    "stateSelectorPath",
    "localParams",
    "localInvolved"
)

function StyleRuleContext:new(ctxRules, style, classSelectorPath, stateSelectorPath, localParams)
    self.ctxRules          = ctxRules
    self.style             = style
    self.classSelectorPath = classSelectorPath
    self.stateSelectorPath = stateSelectorPath
    self.localParams       = localParams
end

function StyleRuleContext:get(paramRef)
    if type(paramRef) == "function" then
        return paramRef(self)
    else
        local invalidChar = match(paramRef, "[^a-zA-Z0-9_@:|]")
        if invalidChar then
            errorf("Error in style parameter reference %q: invalid character %q", paramRef, invalidChar)
        end
        local localParams = self.localParams
        local localValue = localParams and localParams[lower(paramRef)]
        if localValue then
            self.localInvolved = true
            return localValue
        else
            local name, statePath = match(paramRef, "^([^@]*)%:(.*)$") 
            if name then
                return self.style:_getStyleParam2(name, self.classSelectorPath, statePath, self.ctxRules)
            else
                return self.style:_getStyleParam2(paramRef, self.classSelectorPath, "", self.ctxRules)
            end
        end
    end
end

return StyleRuleContext
