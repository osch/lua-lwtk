local StyleTypeAttributes = {}

local attributeNames = { "SCALABLE", "ANIMATABLE" }

StyleTypeAttributes.toAttrName = {}

for _, n in ipairs(attributeNames) do
    local a = {}
    StyleTypeAttributes[n] = a
    StyleTypeAttributes.toAttrName[a] = n
end


return StyleTypeAttributes
