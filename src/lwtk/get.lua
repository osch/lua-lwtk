local lwtk = require("lwtk")

local WeakKeysTable = lwtk.WeakKeysTable

local get = {}

get.app                = WeakKeysTable()
get.root               = WeakKeysTable()
get.parent             = WeakKeysTable()
get.style              = WeakKeysTable()
get.focusHandler       = WeakKeysTable()
get.parentFocusHandler = WeakKeysTable()
get.focusedChild       = WeakKeysTable()

get.wrapper            = WeakKeysTable()
get.wrappedChild       = WeakKeysTable()
get.wrappingParent     = WeakKeysTable()
get.focusableChildren  = WeakKeysTable()
get.actions            = WeakKeysTable()
get.keyBinding         = WeakKeysTable()
get.hotKeys            = WeakKeysTable()
get.stylePath          = WeakKeysTable()
get.fontInfos          = WeakKeysTable()
get.childLookup        = WeakKeysTable()
get.visibilityChanges  = WeakKeysTable()
get.deferredChanges    = WeakKeysTable()

return get
