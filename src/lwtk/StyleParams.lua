local lwtk   = require"lwtk"

local match  = string.match
local lower  = string.lower

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
    self.cache = {}
end

function StyleParams:addStyleRules(ruleList)
    local typeList = self.typeList
    local rules = self.ruleList
    local n = #rules
    for i, rule in ipairs(ruleList) do
        rules[n + i] = toStylePattern(rule[i], typeList)
    end
    self.cache = {}
end

function StyleParams:clearCache()
    self.cache = {}
end

function StyleParams:getStyleParam(parName, classSelectorPath, stateSelectorPath, localStyleRules)
    local selector = lower(parName).."@"..classSelectorPath..":"..lower(stateSelectorPath)
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
