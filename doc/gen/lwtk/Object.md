# Class lwtk.Object

Superclass for all classes created by [lwtk.newClass](../lwtk/newClass.md)().

## Contents

   * [Methods](#methods)
      * [getClass()](#.getClass)
      * [getClassPath()](#.getClassPath)
      * [getMember()](#.getMember)
      * [getReverseClassPath()](#.getReverseClassPath)
      * [getSuperClass()](#.getSuperClass) - Returns the superclass of this object.
      * [isInstanceOf()](#.isInstanceOf) - Determines if object is instance of the given class.
      * [setAttributes()](#.setAttributes)
   * [Subclasses](#subclasses)


## Methods
   * <span id=".getClass">**`Object:getClass()`**</span>


   * <span id=".getClassPath">**`Object:getClassPath()`**</span>


   * <span id=".getMember">**`Object:getMember(name)`**</span>


   * <span id=".getReverseClassPath">**`Object:getReverseClassPath()`**</span>


   * <span id=".getSuperClass">**`Object:getSuperClass()`**</span>

     Returns the superclass of this object.
     
     This method can also be called on a class. In this
     case the superclass of the given class is returned.

   * <span id=".isInstanceOf">**`Object:isInstanceOf(C)`**</span>

     Determines if object is instance of the given class.
     
     Returns *true*, if *self* is an object that was created by invoking class *C*
     or by invoking a subclass of *C*.
     
     Returns also *true* if *C* is a metatable of *self* or somewhere in the 
     metatable chain of *self*.
        * Implementation: [lwtk.isInstanceOf()](../lwtk/isInstanceOf.md)

   * <span id=".setAttributes">**`Object:setAttributes(attr)`**</span>



## Subclasses
   * / _**`Object`**_ /
        * [Actionable](../lwtk/Actionable.md#subclasses) /
             * **[FocusHandler](../lwtk/FocusHandler.md#inheritance)**
             * [Node](../lwtk/Node.md#subclasses) / [Drawable](../lwtk/Drawable.md#subclasses) /
                  * **[Component](../lwtk/Component.md#subclasses)** /
                       * [Compound](../lwtk/Compound.md#subclasses) / **[InnerCompound](../lwtk/InnerCompound.md#inheritance)**
                       * [Styleable](../lwtk/Styleable.md#subclasses) / [Animatable](../lwtk/Animatable.md#subclasses) / **[Widget](../lwtk/Widget.md#subclasses)** / [Compound](../lwtk/Compound.md#subclasses) /
                            * [LayoutFrame](../lwtk/LayoutFrame.md#subclasses) / [Control](../lwtk/Control.md#subclasses) /
                                 * [Focusable](../lwtk/Focusable.md#subclasses) / **[TextInput](../lwtk/TextInput.md#inheritance)**
                                 * [HotkeyListener](../lwtk/HotkeyListener.md#subclasses) / **[Button](../lwtk/Button.md#subclasses)** /
                                      * [Focusable](../lwtk/Focusable.md#subclasses) / **[PushButton](../lwtk/PushButton.md#inheritance)**
                                      * **[TextLabel](../lwtk/TextLabel.md#subclasses)** / **[TitleText](../lwtk/TitleText.md#inheritance)**
                            * [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[Group](../lwtk/Group.md#subclasses)** /
                                 * [Colored](../lwtk/Colored.md#subclasses) / **[ViewSwitcher](../lwtk/ViewSwitcher.md#inheritance)**
                                 * **[Column](../lwtk/Column.md#inheritance)**
                                 * [LayoutFrame](../lwtk/LayoutFrame.md#subclasses) / [Control](../lwtk/Control.md#subclasses) / **[Box](../lwtk/Box.md#subclasses)** / [Focusable](../lwtk/Focusable.md#subclasses) / **[FocusGroup](../lwtk/FocusGroup.md#inheritance)**
                                 * **[Matrix](../lwtk/Matrix.md#inheritance)**
                                 * **[Row](../lwtk/Row.md#inheritance)**
                                 * **[Space](../lwtk/Space.md#inheritance)**
                                 * **[Square](../lwtk/Square.md#inheritance)**
                       * **[TextCursor](../lwtk/TextCursor.md#inheritance)**
                       * **[TextFragment](../lwtk/TextFragment.md#inheritance)**
                  * [Styleable](../lwtk/Styleable.md#subclasses) / [KeyHandler](../lwtk/KeyHandler.md#subclasses) / [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[Window](../lwtk/Window.md#inheritance)**
        * **[Animations](../lwtk/Animations.md#inheritance)**
        * **[Application](../lwtk/Application.md#subclasses)** / [Node](../lwtk/Node.md#subclasses) / [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[love.Application](../lwtk/love/Application.md#inheritance)**
        * **[Area](../lwtk/Area.md#inheritance)**
        * **[Color](../lwtk/Color.md#inheritance)**
        * **[FontInfo](../lwtk/FontInfo.md#inheritance)**
        * **[FontInfos](../lwtk/FontInfos.md#inheritance)**
        * **[Rect](../lwtk/Rect.md#inheritance)**
        * **[Style](../lwtk/Style.md#subclasses)** / **[DefaultStyle](../lwtk/DefaultStyle.md#inheritance)**
        * **[Timer](../lwtk/Timer.md#inheritance)**
        * **[love.Driver](../lwtk/love/Driver.md#inheritance)**
        * **[love.LayoutContext](../lwtk/love/LayoutContext.md#subclasses)** / **[love.DrawContext](../lwtk/love/DrawContext.md#inheritance)**
        * **[love.View](../lwtk/love/View.md#inheritance)**
        * **[lpugl.CairoLayoutContext](../lwtk/lpugl/CairoLayoutContext.md#subclasses)** / **[lpugl.CairoDrawContext](../lwtk/lpugl/CairoDrawContext.md#inheritance)**
        * **[lpugl.Driver](../lwtk/lpugl/Driver.md#inheritance)**

