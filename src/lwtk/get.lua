local lwtk = require("lwtk")

local WeakKeysTable = lwtk.WeakKeysTable

local get = {}

get.app                = WeakKeysTable()
get.root               = WeakKeysTable()
get.parent             = WeakKeysTable()
get.styleParams        = WeakKeysTable()
get.focusHandler       = WeakKeysTable()

get.wrapper            = WeakKeysTable()
get.wrappedChild       = WeakKeysTable()
get.wrappingParent     = WeakKeysTable()
get.focusableChildren  = WeakKeysTable()
get.actions            = WeakKeysTable()
get.keyBinding         = WeakKeysTable()
get.hotKeys            = WeakKeysTable()
get.stylePath          = WeakKeysTable()
get.fontInfos          = WeakKeysTable()

return get
