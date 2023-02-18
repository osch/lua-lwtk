local lwtk = require"lwtk"

local getSuperClass = lwtk.get.superClass

local function isInstanceOf(obj, T)
  local mt = getmetatable(obj)
  while mt do
    if mt == T then
      return true
    end
    mt = getSuperClass[mt]
  end
  return false
end

return isInstanceOf
