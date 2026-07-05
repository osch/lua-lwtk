# Mixin lwtk.LayoutFrame


## Contents

   * [Inheritance](#inheritance)
   * [Methods](#methods)
      * [addChild()](#.addChild)
      * [onDraw()](#.onDraw)
      * [onLayout()](#.onLayout)
   * [Extra Members](#extra-members)
      * [getMeasures()](#.getMeasures)
   * [Used Style Parameters](#used-style-parameters)
   * [Subclasses](#subclasses)


## <a id="inheritance"></a>Inheritance
   * / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** / [Styleable](../lwtk/Styleable.md#inheritance) / [Animatable](../lwtk/Animatable.md#inheritance) / **[Widget](../lwtk/Widget.md#inheritance)** / [Compound](../lwtk/Compound.md#inheritance) /
        * _`LayoutFrame`_
        * [MouseDispatcher](../lwtk/MouseDispatcher.md#inheritance) / **[Group](../lwtk/Group.md#inheritance)** / _`LayoutFrame`_

## <a id="methods"></a>Methods
   * <span id=".addChild">**`LayoutFrame:addChild(child, index)`**</span>


   * <span id=".onDraw">**`LayoutFrame:onDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)`**</span>


   * <span id=".onLayout">**`LayoutFrame:onLayout(w, h)`**</span>



## <a id="extra-members"></a>Extra Members

Members of the `extra` subtable are not inherited by subclasses and
are not available in derived objects: subclasses adopt them explicitly.

   * <span id=".getMeasures">**`LayoutFrame.extra:getMeasures()`**</span>


## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

The implementation uses the following style parameters:

   * `BackgroundColor`
   * `BorderColor`
   * `BorderPadding`
   * `BorderSize`

Style parameters used in super classes:

   * [Compound](../lwtk/Compound.md#used-style-parameters): `Opacity`
   * [Animatable](../lwtk/Animatable.md#used-style-parameters): `FrameTransitionSeconds`

## <a id="subclasses"></a>Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / [Actionable](../lwtk/Actionable.md#subclasses) / [Node](../lwtk/Node.md#subclasses) / [Drawable](../lwtk/Drawable.md#subclasses) / **[Component](../lwtk/Component.md#subclasses)** / [Styleable](../lwtk/Styleable.md#subclasses) / [Animatable](../lwtk/Animatable.md#subclasses) / **[Widget](../lwtk/Widget.md#subclasses)** / [Compound](../lwtk/Compound.md#subclasses) /
        * _`LayoutFrame`_ / [Control](../lwtk/Control.md#subclasses) /
             * [Focusable](../lwtk/Focusable.md#subclasses) / **[TextInput](../lwtk/TextInput.md#inheritance)**
             * [HotkeyListener](../lwtk/HotkeyListener.md#subclasses) / **[Button](../lwtk/Button.md#subclasses)** /
                  * [Focusable](../lwtk/Focusable.md#subclasses) / **[PushButton](../lwtk/PushButton.md#inheritance)**
                  * **[TextLabel](../lwtk/TextLabel.md#subclasses)** / **[TitleText](../lwtk/TitleText.md#inheritance)**
        * [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[Group](../lwtk/Group.md#subclasses)** / _`LayoutFrame`_ / [Control](../lwtk/Control.md#subclasses) / **[Box](../lwtk/Box.md#subclasses)** / [Focusable](../lwtk/Focusable.md#subclasses) / **[FocusGroup](../lwtk/FocusGroup.md#inheritance)**

