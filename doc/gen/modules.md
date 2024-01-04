# Module Index

   * [lwtk](#lwtk) - Root module for all other *lwtk* modules.
   * [lwtk.love](#lwtklove) - Modules for using *lwtk* with the [LÖVE](https://love2d.org/) 2D game engine.
   * [lwtk.lpugl](#lwtklpugl) - Modules for using *lwtk* on top of [LPugl](https://github.com/osch/lua-lpugl#lpugl), a minimal Lua-API for building GUIs for Linux, Windows or macOS.

## lwtk

### Classes
   * **[lwtk.Animations](lwtk/Animations.md)**
   * **[lwtk.Application](lwtk/Application.md)** - Default application implementation.
   * **[lwtk.Area](lwtk/Area.md)** - A list of rectangle coordinates forming an area.
   * **[lwtk.Box](lwtk/Box.md)**
   * **[lwtk.Button](lwtk/Button.md)**
   * **[lwtk.Color](lwtk/Color.md)** - RGBA Color value.
   * **[lwtk.Column](lwtk/Column.md)**
   * **[lwtk.Component](lwtk/Component.md)**
   * **[lwtk.DefaultStyle](lwtk/DefaultStyle.md)**
   * **[lwtk.FocusGroup](lwtk/FocusGroup.md)**
   * **[lwtk.FocusHandler](lwtk/FocusHandler.md)**
   * **[lwtk.FontInfo](lwtk/FontInfo.md)**
   * **[lwtk.FontInfos](lwtk/FontInfos.md)**
   * **[lwtk.Group](lwtk/Group.md)**
   * **[lwtk.InnerCompound](lwtk/InnerCompound.md)**
   * **[lwtk.Matrix](lwtk/Matrix.md)**
   * **[lwtk.Object](lwtk/Object.md)** - Superclass for all classes created by [lwtk.newClass](lwtk/newClass.md)().
   * **[lwtk.PushButton](lwtk/PushButton.md)**
   * **[lwtk.Rect](lwtk/Rect.md)**
   * **[lwtk.Row](lwtk/Row.md)**
   * **[lwtk.Space](lwtk/Space.md)**
   * **[lwtk.Square](lwtk/Square.md)**
   * **[lwtk.Style](lwtk/Style.md)**
   * **[lwtk.TextCursor](lwtk/TextCursor.md)**
   * **[lwtk.TextFragment](lwtk/TextFragment.md)**
   * **[lwtk.TextInput](lwtk/TextInput.md)**
   * **[lwtk.TextLabel](lwtk/TextLabel.md)**
   * **[lwtk.Timer](lwtk/Timer.md)**
   * **[lwtk.TitleText](lwtk/TitleText.md)**
   * **[lwtk.ViewSwitcher](lwtk/ViewSwitcher.md)**
   * **[lwtk.Widget](lwtk/Widget.md)**
   * **[lwtk.Window](lwtk/Window.md)**
### Mixins
   * [lwtk.Actionable](lwtk/Actionable.md)
   * [lwtk.Animatable](lwtk/Animatable.md)
   * [lwtk.Colored](lwtk/Colored.md)
   * [lwtk.Compound](lwtk/Compound.md) - Base for components that can have children.
   * [lwtk.Control](lwtk/Control.md)
   * [lwtk.Drawable](lwtk/Drawable.md)
   * [lwtk.Focusable](lwtk/Focusable.md)
   * [lwtk.HotkeyListener](lwtk/HotkeyListener.md)
   * [lwtk.KeyHandler](lwtk/KeyHandler.md)
   * [lwtk.LayoutFrame](lwtk/LayoutFrame.md)
   * [lwtk.MouseDispatcher](lwtk/MouseDispatcher.md)
   * [lwtk.Node](lwtk/Node.md)
   * [lwtk.Styleable](lwtk/Styleable.md)
### Metas
   * [lwtk.Callback](lwtk/Callback.md) - Holds a function with arguments that can be called.
   * [lwtk.ChildLookup](lwtk/ChildLookup.md)
   * [lwtk.KeyBinding](lwtk/KeyBinding.md)
   * [lwtk.WeakKeysTable](lwtk/WeakKeysTable.md)
### Functions
   * [lwtk.BuiltinStyleTypes](lwtk/BuiltinStyleTypes.md)
   * [lwtk.DefaultKeyBinding](lwtk/DefaultKeyBinding.md) - Returns new [lwtk.KeyBinding](lwtk/KeyBinding.md) object with default settings.
   * [lwtk.btest](lwtk/btest.md) - Returns *true* if bitwise AND of its operands is different from zero.
   * [lwtk.call](lwtk/call.md)
   * [lwtk.discard](lwtk/discard.md) - Discard object that should no longer be used.
   * [lwtk.errorf](lwtk/errorf.md)
   * [lwtk.extract](lwtk/extract.md)
   * [lwtk.getSuperClass](lwtk/getSuperClass.md)
   * [lwtk.isInstanceOf](lwtk/isInstanceOf.md) - Determines if object is instance of the given class.
   * [lwtk.newClass](lwtk/newClass.md) - Creates new class object.
   * [lwtk.newMeta](lwtk/newMeta.md) - Creates new meta object.
   * [lwtk.newMixin](lwtk/newMixin.md) - Creates new mixin object.
   * [lwtk.tryrequire](lwtk/tryrequire.md)
   * [lwtk.type](lwtk/type.md) - Returns the type name.
### Other
   * [lwtk.Class](lwtk/Class.md) - Metatable for objects created by [lwtk.newClass](lwtk/newClass.md)().
   * [lwtk.Meta](lwtk/Meta.md) - Metatable for objects created by [lwtk.newMeta](lwtk/newMeta.md)().
   * [lwtk.Mixin](lwtk/Mixin.md) - Metatable for objects created by [lwtk.newMixin](lwtk/newMixin.md)().
   * [lwtk.StyleRef](lwtk/StyleRef.md)
   * [lwtk.StyleTypeAttributes](lwtk/StyleTypeAttributes.md)
   * [lwtk._VERSION](lwtk/_VERSION.md)
   * [lwtk.get](lwtk/get.md)
   * [lwtk.layout](lwtk/layout.md)
   * [lwtk.utf8](lwtk/utf8.md)
   * [lwtk.util](lwtk/util.md)

## lwtk.love

### Classes
   * **[lwtk.love.Application](lwtk/love/Application.md)** - Application implementation for the [LÖVE](https://love2d.org/) 2D game engine.
   * **[lwtk.love.DrawContext](lwtk/love/DrawContext.md)**
   * **[lwtk.love.Driver](lwtk/love/Driver.md)**
   * **[lwtk.love.LayoutContext](lwtk/love/LayoutContext.md)**
   * **[lwtk.love.View](lwtk/love/View.md)**
### Other
   * [lwtk.love.keyNameMap](lwtk/love/keyNameMap.md)

## lwtk.lpugl

### Classes
   * **[lwtk.lpugl.CairoDrawContext](lwtk/lpugl/CairoDrawContext.md)**
   * **[lwtk.lpugl.CairoLayoutContext](lwtk/lpugl/CairoLayoutContext.md)**
   * **[lwtk.lpugl.Driver](lwtk/lpugl/Driver.md)**
