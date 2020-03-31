local get = {}

get.app            = setmetatable({}, { __mode = "k" })
get.root           = setmetatable({}, { __mode = "k" })
get.parent         = setmetatable({}, { __mode = "k" })
get.styleParams    = setmetatable({}, { __mode = "k" })
get.focusHandler   = setmetatable({}, { __mode = "k" })

get.wrapper           = setmetatable({}, { __mode = "k" })
get.wrappedChild      = setmetatable({}, { __mode = "k" })
get.wrappingParent    = setmetatable({}, { __mode = "k" })
get.focusableChildren = setmetatable({}, { __mode = "k" })
get.focusedChild      = setmetatable({}, { __mode = "k" })
get.hasFocus          = setmetatable({}, { __mode = "k" })
get.wantsFocus        = setmetatable({}, { __mode = "k" })
get.actions           = setmetatable({}, { __mode = "k" })
get.keyBinding        = setmetatable({}, { __mode = "k" })

return get
