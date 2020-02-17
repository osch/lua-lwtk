local lwtk   = require"lwtk"

local match  = string.match
local lower  = string.lower
local errorf = lwtk.errorf
local type   = lwtk.type
local floor  = math.floor

local TypeRule         = lwtk.TypeRule
local StyleRule        = lwtk.StyleRule
local StyleRuleContext = lwtk.StyleRuleContext

local StyleParams = lwtk.newClass("lwtk.StyleParams", lwtk.Object)

local toTypePattern  = TypeRule.toPattern
local toStylePattern = StyleRule.toPattern

function StyleParams:new(typeList, ruleList)
    self:setTypeRules(typeList)
    self:setStyleRules(ruleList)
end

function StyleParams:setTypeRules(typeList)
    local types = {}
    for i, t in ipairs(typeList) do
        types[i] = toTypePattern(t)
    end
    self.typeList = types
    local ruleList = self.ruleList
    if ruleList then
        self.ruleList = nil
        self:setStyleRules(ruleList)
    end
end

function StyleParams:addTypeRules(newRules)
    local typeList = self.typeList
    local n = #typeList
    local types = self.typeList
    for i = 1, #newRules do
        types[n + i] = toTypePattern(newRules[i])
    end
    local ruleList = self.ruleList
    self.ruleList = nil
    self:setStyleRules(ruleList)
end

function StyleParams:setStyleRules(ruleList)
    self.scaleFactor = ruleList.scaleFactor or 1
    local typeList = self.typeList
    local rules = {}
    for i, rule in ipairs(ruleList) do
        rules[i] = toStylePattern(rule, typeList)
    end
    self.ruleList = rules
    self:clearCache()
end

function StyleParams:addStyleRules(ruleList)
    local typeList = self.typeList
    local rules = self.ruleList
    local n = #rules
    for i, rule in ipairs(ruleList) do
        rules[n + i] = toStylePattern(rule[i], typeList)
    end
    self:clearCache()
end

function StyleParams:clearCache()
    self.cache = {}
    self.animatable = {}
    self.scalable   = {}
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

end


function StyleParams:isAnimatable(parName)
    local result = self.animatable[parName]
    if result == nil then
        findTypeRule(self, parName)
        return self.animatable[parName]
    else
        return result
    end
end

function StyleParams:isScalable(parName)
    local result = self.scalable[parName]
    if result == nil then
        findTypeRule(self, parName)
        return self.scalable[parName]
    else
        return result
    end
end

local function _getStyleParam(self, selector, parName, classSelectorPath, stateSelectorPath, localStyleRules)
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
                    context = StyleRuleContext(self, classSelectorPath, stateSelectorPath, localStyleRules)
                end
                param = param(context)
            end
            if not typeRule then
                typeRule = findTypeRule(self, parName)
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
    if localStyleRules then
        for i = #localStyleRules, 1, -1 do
            local rule = localStyleRules[i]
            local rslt = evalRule(rule)
            if rslt then 
                --print(">>>>>>>>>1", selector, typeRule[#typeRule]) 
                return rslt, typeRule
            end
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
end

function StyleParams:_getStyleParam(parName, classSelectorPath, stateSelectorPath, localStyleRules)
    local selector = lower(parName).."@"..classSelectorPath..":"..lower(stateSelectorPath)
    return _getStyleParam(self, selector, parName, classSelectorPath, stateSelectorPath, localStyleRules)
end

function StyleParams:getStyleParam(parName, classSelectorPath, stateSelectorPath, localStyleRules)
    local cache
    if localStyleRules then
        cache = localStyleRules.cache
        if not cache then
            cache = {}
            localStyleRules.cache = cache
        end
    else
        cache = self.cache
    end
    local selector = lower(parName).."@"..classSelectorPath..":"..lower(stateSelectorPath)
    local cached = cache[selector]
    if cached then
        return cached
    else
        local rslt, typeRule = _getStyleParam(self, selector, parName, classSelectorPath, stateSelectorPath, localStyleRules)
        
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


return StyleParams
