# Mixin lwtk.Styleable


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Attributes](#attributes)
      * [state](#.state)
      * [_hasOwnStyle](#._hasOwnStyle)
   * [Methods](#methods)
      * [clearStyleCache()](#.clearStyleCache)
      * [getStateString()](#.getStateString)
      * [getStyle()](#.getStyle)
      * [getStyleParam()](#.getStyleParam)
      * [setState()](#.setState)
      * [setStyle()](#.setStyle)
      * [_getStyleParam()](#._getStyleParam)
      * [_setStyleFromParent()](#._setStyleFromParent)
   * [Static Members](#static-members)
      * [newSubClass()](#.newSubClass)
   * [Used Style Parameters](#used-style-parameters)
   * [Subclasses](#subclasses)


## <a id="inheritance"></a>Inheritance
   * / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) /
        * **[Component](../lwtk/Component.md#inheritance)** / _`Styleable`_
        * _`Styleable`_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`Styleable:new(initParams)`**</span>



## <a id="attributes"></a>Attributes
   * <span id=".state">**`state`**</span> : `table`

   * <span id="._hasOwnStyle">**`_hasOwnStyle`**</span> : `boolean`


## <a id="methods"></a>Methods
   * <span id=".clearStyleCache">**`Styleable:clearStyleCache()`**</span>


   * <span id=".getStateString">**`Styleable:getStateString()`**</span>


   * <span id=".getStyle">**`Styleable:getStyle(style)`**</span>


   * <span id=".getStyleParam">**`Styleable:getStyleParam(paramName)`**</span>


   * <span id=".setState">**`Styleable:setState(name, flag)`**</span>


   * <span id=".setStyle">**`Styleable:setStyle(style)`**</span>


   * <span id="._getStyleParam">**`Styleable:_getStyleParam(style, paramName)`**</span>


   * <span id="._setStyleFromParent">**`Styleable:_setStyleFromParent(parentStyle)`**</span>



## <a id="static-members"></a>Static Members

Static members are only available in the class object,
not in the derived objects:

   * <span id=".newSubClass">**`Styleable.newSubClass(baseClass, className, ...)`**</span>


## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

Style parameters used in super classes:

   * **[Component](../lwtk/Component.md#used-style-parameters)**: `Opacity`

## <a id="subclasses"></a>Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / [Actionable](../lwtk/Actionable.md#subclasses) / [Node](../lwtk/Node.md#subclasses) / [Drawable](../lwtk/Drawable.md#subclasses) /
        * **[Component](../lwtk/Component.md#subclasses)** / _`Styleable`_ / [Animatable](../lwtk/Animatable.md#subclasses) / **[Widget](../lwtk/Widget.md#subclasses)** / [Compound](../lwtk/Compound.md#subclasses) /
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
        * _`Styleable`_ / [KeyHandler](../lwtk/KeyHandler.md#subclasses) / [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[Window](../lwtk/Window.md#inheritance)**

