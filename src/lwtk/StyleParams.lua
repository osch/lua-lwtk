local lwtk   = require"lwtk"

local match  = string.match
local lower  = string.lower
local errorf = lwtk.errorf
local type   = lwtk.type

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

function StyleParams:getStyleParam(parName, classSelectorPath, stateSelectorPath, localStyleRules)
    local selector = lower(parName).."@"..classSelectorPath..":"..lower(stateSelectorPath)
    local typeRule
    local context
    local function evalRule(rule, cache)
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
            cache[selector] = param
            return param
        end
    end
    local cache
    if localStyleRules then
        cache = localStyleRules.cache
        if not cache then
            cache = {}
            localStyleRules.cache = cache
        end
        local cached = cache[selector]
        if cached then
            return cached
        else
            for i = #localStyleRules, 1, -1 do
                local rule = localStyleRules[i]
                local rslt = evalRule(rule, cache)
                if rslt then 
                    --print(localStyleRules, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>1", selector) 
                    return rslt 
                end
            end
        end
    else
        cache = self.cache
    end
    local cached = cache[selector]
    if cached then
        return cached
    else
        for i = #self.ruleList, 1, -1 do
            local rule = self.ruleList[i]
            local rslt = evalRule(rule, cache)
            if rslt then
                --print(localStyleRules, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2", selector) 
                return rslt 
            end
        end
    end
end

return StyleParams
