local lwtk = require("lwtk")

local WeakKeysTable = lwtk.WeakKeysTable

local get = {}

get.objectMeta         = WeakKeysTable("lwtk.get.objectMeta")
get.class              = WeakKeysTable("lwtk.get.class")
get.superClass         = WeakKeysTable("lwtk.get.superClass")
get.app                = WeakKeysTable("lwtk.get.app")
get.root               = WeakKeysTable("lwtk.get.root")
get.parent             = WeakKeysTable("lwtk.get.parent")
get.style              = WeakKeysTable("lwtk.get.style")
get.focusHandler       = WeakKeysTable("lwtk.get.focusHandler")
get.parentFocusHandler = WeakKeysTable("lwtk.get.parentFocusHandler")
get.focusedChild       = WeakKeysTable("lwtk.get.focusedChild")

get.focusableChildren  = WeakKeysTable("lwtk.get.focusableChildren")
get.actions            = WeakKeysTable("lwtk.get.actions")
get.keyBinding         = WeakKeysTable("lwtk.get.keyBinding")
get.stylePath          = WeakKeysTable("lwtk.get.stylePath")
get.fontInfos          = WeakKeysTable("lwtk.get.fontInfos")
get.childLookup        = WeakKeysTable("lwtk.get.childLookup")
get.visibilityChanges  = WeakKeysTable("lwtk.get.visibilityChanges")
get.deferredChanges    = WeakKeysTable("lwtk.get.deferredChanges")
get.mixinBase          = WeakKeysTable("lwtk.get.mixinBase")

return get
