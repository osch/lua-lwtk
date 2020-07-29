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
    "lua >= 5.1, <= 5.4",
    "compat53",
    "luautf8",
    "lpugl_cairo"
}
build = {
    type = "builtin",
    modules = {
        -- MODULES BEGIN
        ["lwtk"]                     = "src/lwtk/init.lua",
        ["lwtk.Actionable"]          = "src/lwtk/Actionable.lua",
        ["lwtk.Animatable"]          = "src/lwtk/Animatable.lua",
        ["lwtk.Application"]         = "src/lwtk/Application.lua",
        ["lwtk.Area"]                = "src/lwtk/Area.lua",
        ["lwtk.Border"]              = "src/lwtk/Border.lua",
        ["lwtk.Bordered"]            = "src/lwtk/Bordered.lua",
        ["lwtk.Button"]              = "src/lwtk/Button.lua",
        ["lwtk.ChildLookup"]         = "src/lwtk/ChildLookup.lua",
        ["lwtk.Color"]               = "src/lwtk/Color.lua",
        ["lwtk.Column"]              = "src/lwtk/Column.lua",
        ["lwtk.Compound"]            = "src/lwtk/Compound.lua",
        ["lwtk.Control"]             = "src/lwtk/Control.lua",
        ["lwtk.DefaultKeyBinding"]   = "src/lwtk/DefaultKeyBinding.lua",
        ["lwtk.DefaultStyleRules"]   = "src/lwtk/DefaultStyleRules.lua",
        ["lwtk.DefaultStyleTypes"]   = "src/lwtk/DefaultStyleTypes.lua",
        ["lwtk.FocusHandler"]        = "src/lwtk/FocusHandler.lua",
        ["lwtk.Focusable"]           = "src/lwtk/Focusable.lua",
        ["lwtk.FontInfo"]            = "src/lwtk/FontInfo.lua",
        ["lwtk.FontInfos"]           = "src/lwtk/FontInfos.lua",
        ["lwtk.Group"]               = "src/lwtk/Group.lua",
        ["lwtk.HotkeyHandler"]       = "src/lwtk/HotkeyHandler.lua",
        ["lwtk.KeyBinding"]          = "src/lwtk/KeyBinding.lua",
        ["lwtk.KeyHandler"]          = "src/lwtk/KeyHandler.lua",
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
        ["lwtk.TextCursor"]          = "src/lwtk/TextCursor.lua",
        ["lwtk.TextFragment"]        = "src/lwtk/TextFragment.lua",
        ["lwtk.TextInput"]           = "src/lwtk/TextInput.lua",
        ["lwtk.Timer"]               = "src/lwtk/Timer.lua",
        ["lwtk.Transition"]          = "src/lwtk/Transition.lua",
        ["lwtk.TypeRule"]            = "src/lwtk/TypeRule.lua",
        ["lwtk.Widget"]              = "src/lwtk/Widget.lua",
        ["lwtk.WidgetWrapper"]       = "src/lwtk/WidgetWrapper.lua",
        ["lwtk.Window"]              = "src/lwtk/Window.lua",
        ["lwtk.call"]                = "src/lwtk/call.lua",
        ["lwtk.class"]               = "src/lwtk/class.lua",
        ["lwtk.draw"]                = "src/lwtk/draw.lua",
        ["lwtk.errorf"]              = "src/lwtk/errorf.lua",
        ["lwtk.get"]                 = "src/lwtk/get.lua",
        ["lwtk.internal"]            = "src/lwtk/internal/init.lua",
        ["lwtk.internal.ColumnImpl"] = "src/lwtk/internal/ColumnImpl.lua",
        ["lwtk.internal.LayoutImpl"] = "src/lwtk/internal/LayoutImpl.lua",
        ["lwtk.layout"]              = "src/lwtk/layout.lua",
        ["lwtk.newClass"]            = "src/lwtk/newClass.lua",
        ["lwtk.type"]                = "src/lwtk/type.lua",
        ["lwtk.utf8"]                = "src/lwtk/utf8.lua",
        ["lwtk.vivid"]               = "src/lwtk/vivid.lua",
        -- MODULES END
    },
    copy_directories = {}
}
