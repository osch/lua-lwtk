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
    modules = 
    {
        -- MODULES BEGIN
        --
        ["lwtk"]                           = "src/lwtk/init.lua",
        ["lwtk.Actionable"]                = "src/lwtk/Actionable.lua",
        ["lwtk.Animatable"]                = "src/lwtk/Animatable.lua",
        ["lwtk.Animations"]                = "src/lwtk/Animations.lua",
        ["lwtk.Application"]               = "src/lwtk/Application.lua",
        ["lwtk.Area"]                      = "src/lwtk/Area.lua",
        ["lwtk.Box"]                       = "src/lwtk/Box.lua",
        ["lwtk.BuiltinStyleTypes"]         = "src/lwtk/BuiltinStyleTypes.lua",
        ["lwtk.Button"]                    = "src/lwtk/Button.lua",
        ["lwtk.Callback"]                  = "src/lwtk/Callback.lua",
        ["lwtk.ChildLookup"]               = "src/lwtk/ChildLookup.lua",
        ["lwtk.Class"]                     = "src/lwtk/Class.lua",
        ["lwtk.Color"]                     = "src/lwtk/Color.lua",
        ["lwtk.Colored"]                   = "src/lwtk/Colored.lua",
        ["lwtk.Column"]                    = "src/lwtk/Column.lua",
        ["lwtk.Component"]                 = "src/lwtk/Component.lua",
        ["lwtk.Compound"]                  = "src/lwtk/Compound.lua",
        ["lwtk.Control"]                   = "src/lwtk/Control.lua",
        ["lwtk.DefaultKeyBinding"]         = "src/lwtk/DefaultKeyBinding.lua",
        ["lwtk.DefaultStyle"]              = "src/lwtk/DefaultStyle.lua",
        ["lwtk.Drawable"]                  = "src/lwtk/Drawable.lua",
        ["lwtk.FocusGroup"]                = "src/lwtk/FocusGroup.lua",
        ["lwtk.FocusHandler"]              = "src/lwtk/FocusHandler.lua",
        ["lwtk.Focusable"]                 = "src/lwtk/Focusable.lua",
        ["lwtk.FontInfo"]                  = "src/lwtk/FontInfo.lua",
        ["lwtk.FontInfos"]                 = "src/lwtk/FontInfos.lua",
        ["lwtk.Group"]                     = "src/lwtk/Group.lua",
        ["lwtk.HotkeyListener"]            = "src/lwtk/HotkeyListener.lua",
        ["lwtk.InnerCompound"]             = "src/lwtk/InnerCompound.lua",
        ["lwtk.KeyBinding"]                = "src/lwtk/KeyBinding.lua",
        ["lwtk.KeyHandler"]                = "src/lwtk/KeyHandler.lua",
        ["lwtk.LayoutFrame"]               = "src/lwtk/LayoutFrame.lua",
        ["lwtk.Matrix"]                    = "src/lwtk/Matrix.lua",
        ["lwtk.Meta"]                      = "src/lwtk/Meta.lua",
        ["lwtk.Mixin"]                     = "src/lwtk/Mixin.lua",
        ["lwtk.MouseDispatcher"]           = "src/lwtk/MouseDispatcher.lua",
        ["lwtk.Node"]                      = "src/lwtk/Node.lua",
        ["lwtk.Object"]                    = "src/lwtk/Object.lua",
        ["lwtk.PushButton"]                = "src/lwtk/PushButton.lua",
        ["lwtk.Rect"]                      = "src/lwtk/Rect.lua",
        ["lwtk.Row"]                       = "src/lwtk/Row.lua",
        ["lwtk.Space"]                     = "src/lwtk/Space.lua",
        ["lwtk.Square"]                    = "src/lwtk/Square.lua",
        ["lwtk.Style"]                     = "src/lwtk/Style.lua",
        ["lwtk.StyleRef"]                  = "src/lwtk/StyleRef.lua",
        ["lwtk.StyleTypeAttributes"]       = "src/lwtk/StyleTypeAttributes.lua",
        ["lwtk.Styleable"]                 = "src/lwtk/Styleable.lua",
        ["lwtk.TextCursor"]                = "src/lwtk/TextCursor.lua",
        ["lwtk.TextFragment"]              = "src/lwtk/TextFragment.lua",
        ["lwtk.TextInput"]                 = "src/lwtk/TextInput.lua",
        ["lwtk.TextLabel"]                 = "src/lwtk/TextLabel.lua",
        ["lwtk.Timer"]                     = "src/lwtk/Timer.lua",
        ["lwtk.TitleText"]                 = "src/lwtk/TitleText.lua",
        ["lwtk.ViewSwitcher"]              = "src/lwtk/ViewSwitcher.lua",
        ["lwtk.WeakKeysTable"]             = "src/lwtk/WeakKeysTable.lua",
        ["lwtk.Widget"]                    = "src/lwtk/Widget.lua",
        ["lwtk.Window"]                    = "src/lwtk/Window.lua",
        ["lwtk._VERSION"]                  = "src/lwtk/_VERSION.lua",
        ["lwtk.btest"]                     = "src/lwtk/btest.lua",
        ["lwtk.call"]                      = "src/lwtk/call.lua",
        ["lwtk.discard"]                   = "src/lwtk/discard.lua",
        ["lwtk.errorf"]                    = "src/lwtk/errorf.lua",
        ["lwtk.extract"]                   = "src/lwtk/extract.lua",
        ["lwtk.get"]                       = "src/lwtk/get.lua",
        ["lwtk.getSuperClass"]             = "src/lwtk/getSuperClass.lua",
        ["lwtk.isInstanceOf"]              = "src/lwtk/isInstanceOf.lua",
        ["lwtk.layout"]                    = "src/lwtk/layout.lua",
        ["lwtk.lpugl"]                     = "src/lwtk/lpugl/init.lua",
        ["lwtk.lpugl.CairoDrawContext"]    = "src/lwtk/lpugl/CairoDrawContext.lua",
        ["lwtk.lpugl.CairoLayoutContext"]  = "src/lwtk/lpugl/CairoLayoutContext.lua",
        ["lwtk.lpugl.Driver"]              = "src/lwtk/lpugl/Driver.lua",
        ["lwtk.newClass"]                  = "src/lwtk/newClass.lua",
        ["lwtk.newMeta"]                   = "src/lwtk/newMeta.lua",
        ["lwtk.newMixin"]                  = "src/lwtk/newMixin.lua",
        ["lwtk.tryrequire"]                = "src/lwtk/tryrequire.lua",
        ["lwtk.type"]                      = "src/lwtk/type.lua",
        ["lwtk.utf8"]                      = "src/lwtk/utf8.lua",
        ["lwtk.util"]                      = "src/lwtk/util.lua",
        --
        ["lwtk.internal"]                  = "src/lwtk/internal/init.lua",
        ["lwtk.internal.ColumnImpl"]       = "src/lwtk/internal/ColumnImpl.lua",
        ["lwtk.internal.LayoutImpl"]       = "src/lwtk/internal/LayoutImpl.lua",
        ["lwtk.internal.StyleRule"]        = "src/lwtk/internal/StyleRule.lua",
        ["lwtk.internal.StyleRuleContext"] = "src/lwtk/internal/StyleRuleContext.lua",
        ["lwtk.internal.TypeRule"]         = "src/lwtk/internal/TypeRule.lua",
        ["lwtk.internal.utf8string"]       = "src/lwtk/internal/utf8string.lua",
        ["lwtk.internal.vivid"]            = "src/lwtk/internal/vivid.lua",
        --
        -- MODULES END
    },
    copy_directories = {}
}
