local lwtk = require"lwtk"

local call        = lwtk.call
local ChildLookup = lwtk.ChildLookup

local getParent         = lwtk.get.parent
local getChildLookup    = lwtk.get.childLookup
local getStyle          = lwtk.get.style

local Super = lwtk.MouseDispatcher(lwtk.Compound(lwtk.Widget))
local Group = lwtk.newClass("lwtk.Group", Super)

Group:declare(
    "_handleChildRequestsFocus"
)

function Group.override:new(initParams)
    Super.new(self)
    getChildLookup[self] = ChildLookup(self)
    local childList = {}
    if initParams then
        for i = 1, #initParams do
            childList[#childList + 1] = initParams[i]
            initParams[i] = nil
        end
    end
    for i = 1, #childList do
        self:addChild(childList[i])
    end
    self:setInitParams(initParams)
end

function Group:_clearChildLookup() 
    ChildLookup.clear(getChildLookup[self])
    local p = getParent[self]
    if p then
        p:_clearChildLookup()
    end
end

function Group:childById(id)
    local id1, id2 = id:match("^([^/]*)/(.*)$")
    if id1 then
        local c = getChildLookup[self][id1]
        if c and c.childById then 
            return c:childById(id2) 
        end
    else
        return getChildLookup[self][id]
    end
end

function Group.override:addChild(child, index)
    Super.addChild(self, child, index)
    self:_clearChildLookup()
    local style = getStyle[self]
    if style then
        call("_setStyleFromParent", child, style)
    end
    self:triggerLayout()
    return child
end

function Group.override:removeChild(child)
    child = Super.removeChild(self, child)
    self:_clearChildLookup()
    local style = getStyle[self]
    if style and child then
        call("_setStyleFromParent", child, nil)
    end
    self:triggerLayout()
    return child
end



return Group
