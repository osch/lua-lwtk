local lwtk = require"lwtk"

local match  = string.match
local errorf = lwtk.errorf

local StyleRuleContext = lwtk.newClass("lwtk.StyleRuleContext")

function StyleRuleContext:new(style, classSelectorPath, stateSelectorPath, localStyleRules)
    self.style             = style
    self.classSelectorPath = classSelectorPath
    self.stateSelectorPath = stateSelectorPath
    self.localStyleRules   = localStyleRules
end

function StyleRuleContext:get(paramRef)
    if type(paramRef) == "function" then
        return paramRef(self)
    else
        local invalidChar = match(paramRef, "[^a-zA-Z0-9_@:|]")
        if invalidChar then
            errorf("Error in style parameter reference %q: invalid character %q", paramRef, invalidChar)
        end
        local name, statePath = match(paramRef, "^([^@]*)%:(.*)$") 
        if name then
            return self.style:_getStyleParam2(name, self.classSelectorPath, statePath, self.localStyleRules)
        else
            return self.style:_getStyleParam2(paramRef, self.classSelectorPath, "", self.localStyleRules)
        end
    end
end

return StyleRuleContext
