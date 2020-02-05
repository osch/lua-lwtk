local lwtk   = require"lwtk"

local match  = string.match
local lower  = string.lower

local StyleRule        = lwtk.StyleRule
local StyleRuleContext = lwtk.StyleRuleContext

local StyleParams = lwtk.newClass("lwtk.StyleParams", lwtk.Object)

local toPattern = StyleRule.toPattern

function StyleParams:new(ruleList)
    self:setStyleRules(ruleList)
end

function StyleParams:setStyleRules(ruleList)
    local rules = {}
    for i, rule in ipairs(ruleList) do
        rules[i] = { toPattern(rule[1], rule[2]) }
    end
    self.ruleList = rules
    self.cache = {}
end

function StyleParams:addStyleRules(ruleList)
    local rules = self.rules
    local n = #rules
    for i, rule in ipairs(ruleList) do
        rules[n + i] = { toPattern(rule[1], rule[2]) }
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
        if match(selector, rule[1]) then
            local param = rule[2]
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
