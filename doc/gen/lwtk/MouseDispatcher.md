# Mixin lwtk.MouseDispatcher


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Attributes](#attributes)
      * [mouseButtonChild](#.mouseButtonChild)
      * [mouseChildButtons](#.mouseChildButtons)
      * [mouseHoverChild](#.mouseHoverChild)
      * [mouseX](#.mouseX)
      * [mouseY](#.mouseY)
   * [Methods](#methods)
      * [removeChild()](#.removeChild)
      * [_processMouseDown()](#._processMouseDown)
      * [_processMouseEnter()](#._processMouseEnter)
      * [_processMouseLeave()](#._processMouseLeave)
      * [_processMouseMove()](#._processMouseMove)
      * [_processMouseScroll()](#._processMouseScroll)
      * [_processMouseUp()](#._processMouseUp)
   * [Used Style Parameters](#used-style-parameters)
   * [Subclasses](#subclasses)


## <a id="inheritance"></a>Inheritance
   * / **[Object](../lwtk/Object.md#inheritance)** /
        * [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) /
             * **[Component](../lwtk/Component.md#inheritance)** / [Styleable](../lwtk/Styleable.md#inheritance) / [Animatable](../lwtk/Animatable.md#inheritance) / **[Widget](../lwtk/Widget.md#inheritance)** / [Compound](../lwtk/Compound.md#inheritance) / _`MouseDispatcher`_
             * [Styleable](../lwtk/Styleable.md#inheritance) / [KeyHandler](../lwtk/KeyHandler.md#inheritance) / _`MouseDispatcher`_
        * **[Application](../lwtk/Application.md#inheritance)** / [Node](../lwtk/Node.md#inheritance) / _`MouseDispatcher`_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`MouseDispatcher:new(initParams)`**</span>



## <a id="attributes"></a>Attributes
   * <span id=".mouseButtonChild">**`mouseButtonChild`**</span>

   * <span id=".mouseChildButtons">**`mouseChildButtons`**</span> : `table`

   * <span id=".mouseHoverChild">**`mouseHoverChild`**</span>

   * <span id=".mouseX">**`mouseX`**</span>

   * <span id=".mouseY">**`mouseY`**</span>


## <a id="methods"></a>Methods
   * <span id=".removeChild">**`MouseDispatcher:removeChild(child)`**</span>


   * <span id="._processMouseDown">**`MouseDispatcher:_processMouseDown(mx, my, button, modState)`**</span>


   * <span id="._processMouseEnter">**`MouseDispatcher:_processMouseEnter(mx, my)`**</span>


   * <span id="._processMouseLeave">**`MouseDispatcher:_processMouseLeave(mx, my)`**</span>


   * <span id="._processMouseMove">**`MouseDispatcher:_processMouseMove(mouseEntered, mx, my)`**</span>


   * <span id="._processMouseScroll">**`MouseDispatcher:_processMouseScroll(dx, dy)`**</span>


   * <span id="._processMouseUp">**`MouseDispatcher:_processMouseUp(mouseEntered, mx, my, button, modState)`**</span>



## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

Style parameters used in super classes:

   * [Compound](../lwtk/Compound.md#used-style-parameters): `Opacity`
   * [Animatable](../lwtk/Animatable.md#used-style-parameters): `FrameTransitionSeconds`

## <a id="subclasses"></a>Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** /
        * [Actionable](../lwtk/Actionable.md#subclasses) / [Node](../lwtk/Node.md#subclasses) / [Drawable](../lwtk/Drawable.md#subclasses) /
             * **[Component](../lwtk/Component.md#subclasses)** / [Styleable](../lwtk/Styleable.md#subclasses) / [Animatable](../lwtk/Animatable.md#subclasses) / **[Widget](../lwtk/Widget.md#subclasses)** / [Compound](../lwtk/Compound.md#subclasses) / _`MouseDispatcher`_ / **[Group](../lwtk/Group.md#subclasses)** /
                  * [Colored](../lwtk/Colored.md#subclasses) / **[ViewSwitcher](../lwtk/ViewSwitcher.md#inheritance)**
                  * **[Column](../lwtk/Column.md#inheritance)**
                  * [LayoutFrame](../lwtk/LayoutFrame.md#subclasses) / [Control](../lwtk/Control.md#subclasses) / **[Box](../lwtk/Box.md#subclasses)** / [Focusable](../lwtk/Focusable.md#subclasses) / **[FocusGroup](../lwtk/FocusGroup.md#inheritance)**
                  * **[Matrix](../lwtk/Matrix.md#inheritance)**
                  * **[Row](../lwtk/Row.md#inheritance)**
                  * **[Space](../lwtk/Space.md#inheritance)**
                  * **[Square](../lwtk/Square.md#inheritance)**
             * [Styleable](../lwtk/Styleable.md#subclasses) / [KeyHandler](../lwtk/KeyHandler.md#subclasses) / _`MouseDispatcher`_ / **[Window](../lwtk/Window.md#inheritance)**
        * **[Application](../lwtk/Application.md#subclasses)** / [Node](../lwtk/Node.md#subclasses) / _`MouseDispatcher`_ / **[love.Application](../lwtk/love/Application.md#inheritance)**

