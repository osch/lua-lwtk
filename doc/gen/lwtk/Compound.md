# Mixin lwtk.Compound

Base for components that can have children.

## Contents

   * [Inheritance](#inheritance)
   * [Methods](#methods)
      * [addChild()](#.addChild) - Adds child.
      * [discardChild()](#.discardChild) - Discard child that should no longer be used.
      * [removeChild()](#.removeChild) - Removes child.
      * [_processChanges()](#._processChanges)
      * [_processDraw()](#._processDraw)
   * [Used Style Parameters](#used-style-parameters)
   * [Subclasses](#subclasses)


## <a id="inheritance"></a>Inheritance
   * / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** /
        * _`Compound`_
        * [Styleable](../lwtk/Styleable.md#inheritance) / [Animatable](../lwtk/Animatable.md#inheritance) / **[Widget](../lwtk/Widget.md#inheritance)** / _`Compound`_

## <a id="methods"></a>Methods
   * <span id=".addChild">**`Compound:addChild(child, index)`**</span>

     Adds child.
     
     * *child*  - child object
     * *index*  - optional integer
     
     The *index* denotes the position where the child is inserted in the list.
     Negative values are possible, -1 means the last position of the current list.
     
     If *index* is not given or 0, the child is inserted at the end of the list.
     
     Returns the added child object.

   * <span id=".discardChild">**`Compound:discardChild(child)`**</span>

     Discard child that should no longer be used.
     
     This function could be useful under Lua 5.1 which does not have ephemeron tables.

   * <span id=".removeChild">**`Compound:removeChild(child)`**</span>

     Removes child.
     
     * *child*  - child object or child index.
     
     Returns the removed child object.

   * <span id="._processChanges">**`Compound:_processChanges(x0, y0, cx, cy, cw, ch, damagedArea)`**</span>


   * <span id="._processDraw">**`Compound:_processDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)`**</span>



## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

The implementation uses the following style parameters:

   * `Opacity`

Style parameters used in super classes:

   * [Animatable](../lwtk/Animatable.md#used-style-parameters): `FrameTransitionSeconds`

## <a id="subclasses"></a>Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / [Actionable](../lwtk/Actionable.md#subclasses) / [Node](../lwtk/Node.md#subclasses) / [Drawable](../lwtk/Drawable.md#subclasses) / **[Component](../lwtk/Component.md#subclasses)** /
        * _`Compound`_ / **[InnerCompound](../lwtk/InnerCompound.md#inheritance)**
        * [Styleable](../lwtk/Styleable.md#subclasses) / [Animatable](../lwtk/Animatable.md#subclasses) / **[Widget](../lwtk/Widget.md#subclasses)** / _`Compound`_ /
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

