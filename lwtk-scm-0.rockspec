package = "lwtk"
version = "scm-0"
source = {
  url = "https://github.com/osch/lua-lwtk/archive/master.zip",
  dir = "lua-lwtk-master",
}
description = {
    summary = "Lua Widget Toolkit: implement cross platform GUI widgets in Lua",
    detailed = [[
    ]],
    homepage = "http://github.com/osch/lua-lwtk",
    license = "MIT/X11"
}
dependencies = {
    "lua >= 5.1, < 5.4",
    "lpugl.cairo"
}
build = {
    type = "builtin",
    modules = {
        -- MODULES BEGIN
        ["lwtk"]                     = "src/lwtk/init.lua",
        ["lwtk.Animatable"]          = "src/lwtk/Animatable.lua",
        ["lwtk.Application"]         = "src/lwtk/Application.lua",
        ["lwtk.Area"]                = "src/lwtk/Area.lua",
        ["lwtk.Border"]              = "src/lwtk/Border.lua",
        ["lwtk.Bordered"]            = "src/lwtk/Bordered.lua",
        ["lwtk.Button"]              = "src/lwtk/Button.lua",
        ["lwtk.ChildLookup"]         = "src/lwtk/ChildLookup.lua",
        ["lwtk.Class"]               = "src/lwtk/Class.lua",
        ["lwtk.Color"]               = "src/lwtk/Color.lua",
        ["lwtk.Column"]              = "src/lwtk/Column.lua",
        ["lwtk.Control"]             = "src/lwtk/Control.lua",
        ["lwtk.DefaultStyleRules"]   = "src/lwtk/DefaultStyleRules.lua",
        ["lwtk.DefaultStyleTypes"]   = "src/lwtk/DefaultStyleTypes.lua",
        ["lwtk.Group"]               = "src/lwtk/Group.lua",
        ["lwtk.Matrix"]              = "src/lwtk/Matrix.lua",
        ["lwtk.Object"]              = "src/lwtk/Object.lua",
        ["lwtk.PushButton"]          = "src/lwtk/PushButton.lua",
        ["lwtk.Rect"]                = "src/lwtk/Rect.lua",
        ["lwtk.Row"]                 = "src/lwtk/Row.lua",
        ["lwtk.Space"]               = "src/lwtk/Space.lua",
        ["lwtk.StyleParamRef"]       = "src/lwtk/StyleParamRef.lua",
        ["lwtk.StyleParams"]         = "src/lwtk/StyleParams.lua",
        ["lwtk.StyleRule"]           = "src/lwtk/StyleRule.lua",
        ["lwtk.StyleRuleContext"]    = "src/lwtk/StyleRuleContext.lua",
        ["lwtk.Styleable"]           = "src/lwtk/Styleable.lua",
        ["lwtk.Timer"]               = "src/lwtk/Timer.lua",
        ["lwtk.Transition"]          = "src/lwtk/Transition.lua",
        ["lwtk.TypeRule"]            = "src/lwtk/TypeRule.lua",
        ["lwtk.Widget"]              = "src/lwtk/Widget.lua",
        ["lwtk.WidgetWrapper"]       = "src/lwtk/WidgetWrapper.lua",
        ["lwtk.Window"]              = "src/lwtk/Window.lua",
        ["lwtk.call"]                = "src/lwtk/call.lua",
        ["lwtk.draw"]                = "src/lwtk/draw.lua",
        ["lwtk.errorf"]              = "src/lwtk/errorf.lua",
        ["lwtk.get"]                 = "src/lwtk/get.lua",
        ["lwtk.internal"]            = "src/lwtk/internal/init.lua",
        ["lwtk.internal.ColumnImpl"] = "src/lwtk/internal/ColumnImpl.lua",
        ["lwtk.internal.LayoutImpl"] = "src/lwtk/internal/LayoutImpl.lua",
        ["lwtk.layout"]              = "src/lwtk/layout.lua",
        ["lwtk.newClass"]            = "src/lwtk/newClass.lua",
        ["lwtk.type"]                = "src/lwtk/type.lua",
        ["lwtk.vivid"]               = "src/lwtk/vivid.lua",
        -- MODULES END
    },
    copy_directories = {}
}
