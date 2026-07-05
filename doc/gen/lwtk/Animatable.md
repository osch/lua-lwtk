# Mixin lwtk.Animatable


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Attributes](#attributes)
      * [_animationUpdated](#._animationUpdated)
   * [Methods](#methods)
      * [animateFrame()](#.animateFrame)
      * [getStyle()](#.getStyle)
      * [getStyleParam()](#.getStyleParam)
      * [isVisible()](#.isVisible)
      * [setState()](#.setState)
      * [setStates()](#.setStates)
      * [setStyle()](#.setStyle)
      * [setVisible()](#.setVisible)
      * [updateAnimation()](#.updateAnimation)
      * [_setApp()](#._setApp)
      * [_setStyleFromParent()](#._setStyleFromParent)
   * [Used Style Parameters](#used-style-parameters)
   * [Subclasses](#subclasses)


## <a id="inheritance"></a>Inheritance
   * / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** / [Styleable](../lwtk/Styleable.md#inheritance) / _`Animatable`_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`Animatable:new(initParams)`**</span>



## <a id="attributes"></a>Attributes
   * <span id="._animationUpdated">**`_animationUpdated`**</span> : `boolean`


## <a id="methods"></a>Methods
   * <span id=".animateFrame">**`Animatable:animateFrame(newX, newY, newW, newH, isLayoutTransition)`**</span>


   * <span id=".getStyle">**`Animatable:getStyle()`**</span>


   * <span id=".getStyleParam">**`Animatable:getStyleParam(paramName)`**</span>


   * <span id=".isVisible">**`Animatable:isVisible()`**</span>


   * <span id=".setState">**`Animatable:setState(name, flag)`**</span>


   * <span id=".setStates">**`Animatable:setStates(stateNames)`**</span>


   * <span id=".setStyle">**`Animatable:setStyle(style)`**</span>


   * <span id=".setVisible">**`Animatable:setVisible(shouldBeVisible)`**</span>


   * <span id=".updateAnimation">**`Animatable:updateAnimation()`**</span>


   * <span id="._setApp">**`Animatable:_setApp(app)`**</span>


   * <span id="._setStyleFromParent">**`Animatable:_setStyleFromParent(parentStyle)`**</span>



## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

The implementation uses the following style parameters:

   * `FrameTransitionSeconds`

Style parameters used in super classes:

   * **[Component](../lwtk/Component.md#used-style-parameters)**: `Opacity`

## <a id="subclasses"></a>Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / [Actionable](../lwtk/Actionable.md#subclasses) / [Node](../lwtk/Node.md#subclasses) / [Drawable](../lwtk/Drawable.md#subclasses) / **[Component](../lwtk/Component.md#subclasses)** / [Styleable](../lwtk/Styleable.md#subclasses) / _`Animatable`_ / **[Widget](../lwtk/Widget.md#subclasses)** / [Compound](../lwtk/Compound.md#subclasses) /
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

