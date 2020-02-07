local get = {}

get.app           = setmetatable({}, { __mode = "k" })
get.root          = setmetatable({}, { __mode = "k" })
get.parent        = setmetatable({}, { __mode = "k" })
get.styleParams   = setmetatable({}, { __mode = "k" })

get.wrapper       = setmetatable({}, { __mode = "k" })
get.wrappedChild  = setmetatable({}, { __mode = "k" })
get.wrappedParent = setmetatable({}, { __mode = "k" })

return get
