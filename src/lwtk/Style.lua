local lwtk   = require"lwtk"

local match  = string.match
local lower  = string.lower
local errorf = lwtk.errorf
local type   = lwtk.type
local floor  = math.floor

local TypeRule         = lwtk.internal.TypeRule
local StyleRule        = lwtk.internal.StyleRule
local StyleRuleContext = lwtk.internal.StyleRuleContext

local Style = lwtk.newClass("lwtk.Style", lwtk.Object)

local toTypePattern  = TypeRule.toPattern
local toStylePattern = StyleRule.toPattern

function Style:new(ruleList)
    self:setRules(ruleList)
end

local function clearCache(self)
    self.cache = {}
    self.animatable = {}
    self.scalable   = {}
end

function Style:setScaleFactor(scaleFactor)
    self.scaleFactor = scaleFactor
    clearCache(self)
end

function Style:_replaceParentStyle(parentStyle)
    if self.parent then
        clearCache(self)
    end
    self.parent = parentStyle
end 
function Style:_setParentStyle(parentStyle)
    assert(not self.parent, "style was already added to another parent")
    self.parent = parentStyle
end 

function Style:setRules(rules)
    local typeList = {}
    do
        local types = rules.types or lwtk.BuiltinStyleTypes()
        for i, t in ipairs(types) do
            typeList[i] = toTypePattern(t)
        end
    end
    self.typeList    = typeList
    self.scaleFactor = rules.scaleFactor or 1
    local ruleList = {}
    for i, rule in ipairs(rules) do
        ruleList[i] = toStylePattern(rule, typeList)
    end
    self.ruleList = ruleList
    clearCache(self)
end

function Style:addRules(rules)
    local typeList = self.typeList
    if rules.types then
        local types = rules.types
        local n = #typeList
        for i = 1, #types do
            typeList[n + i] = toTypePattern(types[i])
        end
    end
    local ruleList = self.ruleList
    local n = #ruleList
    for i, rule in ipairs(rules) do
        ruleList[n + i] = toStylePattern(rule, typeList)
    end
    clearCache(self)
end

local function findTypeRule(self, parName)
    local lowerName = lower(parName)
    local typeList = self.typeList
    for i = #typeList, 1, -1 do
        local rule = typeList[i]
        for j = #rule-1, 1, -1 do
            if match(lowerName, rule[j]) then
                self.animatable[parName] = rule.ANIMATABLE and true or false
                self.scalable[parName]   = rule.SCALABLE   and true or false
                return rule
            end
        end
    end
    local parent = self.parent
    if parent then
        return findTypeRule(parent, parName)
    end
end


function Style:isAnimatable(parName)
    local result = self.animatable[parName]
    if result == nil then
        findTypeRule(self, parName)
        return self.animatable[parName]
    else
        return result
    end
end

function Style:isScalable(parName)
    local result = self.scalable[parName]
    if result == nil then
        findTypeRule(self, parName)
        return self.scalable[parName]
    else
        return result
    end
end

local function _getStyleParam(self, selector, parName, classSelectorPath, stateSelectorPath, localStyle)
    local typeRule
    local context
    local function evalRule(rule)
        local n = #rule
        local matched = false
        for i = n - 1, 1, -1 do
            if match(selector, rule[i]) then
                matched = true
                break
            end
        end
        if matched then
            local param = rule[n]
            if type(param) == "function" then
                if not context then
                    context = StyleRuleContext(localStyle, classSelectorPath, stateSelectorPath)
                end
                param = param(context)
            end
            if not typeRule then
                typeRule = findTypeRule(localStyle, parName)
                if not typeRule then
                    errorf("Cannot deduce type for style parameter name %q", parName)
                end
            end
            if type(param) ~= typeRule[#typeRule] then
                errorf("Type mismatch for style parameter %q: expected %q but given %q", 
                      parName, tostring(typeRule[#typeRule]), type(param))
            end
            return param
        end
    end
    for i = #self.ruleList, 1, -1 do
        local rule = self.ruleList[i]
        local rslt = evalRule(rule)
        if rslt then
            --print(">>>>>>>>>2", selector, typeRule[#typeRule]) 
            return rslt, typeRule
        end
    end
    local parent = self.parent
    if parent then
        return _getStyleParam(parent, selector, parName, classSelectorPath, stateSelectorPath, localStyle)
    end
end

function Style:_getStyleParam2(parName, classSelectorPath, stateSelectorPath)
    local selector = lower(parName).."@"..classSelectorPath..":"..lower(stateSelectorPath)
    return _getStyleParam(self, selector, parName, classSelectorPath, stateSelectorPath, self)
end

function Style:_getStyleParam(parName, classSelectorPath, stateSelectorPath)
    local cache = self.cache
    local selector = lower(parName).."@"..classSelectorPath..":"..lower(stateSelectorPath)
    local cached = cache[selector]
    if cached then
        return cached
    else
        local rslt, typeRule = _getStyleParam(self, selector, parName, classSelectorPath, stateSelectorPath, self)
        
        if rslt then
            if typeRule.SCALABLE then
                local rslt0 = rslt
                rslt = floor(rslt0 * self.scaleFactor + 0.5)
                if rslt == 0 and rslt0 > 0 then
                    rslt = 1
                end
            end
            cache[selector] = rslt
            return rslt
        end
    end
end

function Style:getStyleParam(widget, parName)
    return widget:_getStyleParam(self, parName)
end

return Style
