# Mixin lwtk.Focusable


## Contents

   * [Inheritance](#inheritance)
   * [Attributes](#attributes)
      * [disabled](#.disabled)
      * [hasFocus](#.hasFocus)
      * [handleHotkey](#.handleHotkey)
      * [_focusDisabled](#._focusDisabled)
      * [_wantsDefault](#._wantsDefault)
      * [_wantsFocus](#._wantsFocus)
      * [_wantsFocusDisabled](#._wantsFocusDisabled)
   * [Event Callbacks](#event-callbacks)
      * [onHotkeyDown()](#.onHotkeyDown)
      * [onKeyDown()](#.onKeyDown)
      * [onFocusIn()](#.onFocusIn)
      * [onFocusOut()](#.onFocusOut)
   * [Methods](#methods)
      * [onDisabled()](#.onDisabled)
      * [onEffectiveVisibilityChanged()](#.onEffectiveVisibilityChanged)
      * [setFocus()](#.setFocus)
      * [_handleFocusIn()](#._handleFocusIn)
      * [_handleFocusOut()](#._handleFocusOut)
      * [_handleHasFocusHandler()](#._handleHasFocusHandler)
   * [Extra Members](#extra-members)
      * [setDefault()](#.setDefault)
   * [Used Style Parameters](#used-style-parameters)
   * [Subclasses](#subclasses)


## <a id="inheritance"></a>Inheritance
   * / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** / [Styleable](../lwtk/Styleable.md#inheritance) / [Animatable](../lwtk/Animatable.md#inheritance) / **[Widget](../lwtk/Widget.md#inheritance)** / [Compound](../lwtk/Compound.md#inheritance) /
        * [LayoutFrame](../lwtk/LayoutFrame.md#inheritance) / [Control](../lwtk/Control.md#inheritance) /
             * _`Focusable`_
             * [HotkeyListener](../lwtk/HotkeyListener.md#inheritance) / **[Button](../lwtk/Button.md#inheritance)** / _`Focusable`_
        * [MouseDispatcher](../lwtk/MouseDispatcher.md#inheritance) / **[Group](../lwtk/Group.md#inheritance)** / [LayoutFrame](../lwtk/LayoutFrame.md#inheritance) / [Control](../lwtk/Control.md#inheritance) / **[Box](../lwtk/Box.md#inheritance)** / _`Focusable`_

## <a id="attributes"></a>Attributes
   * <span id=".disabled">**`disabled`**</span>

   * <span id=".hasFocus">**`hasFocus`**</span> : `boolean`

   * <span id=".handleHotkey">**`handleHotkey`**</span>

   * <span id="._focusDisabled">**`_focusDisabled`**</span>

   * <span id="._wantsDefault">**`_wantsDefault`**</span>

   * <span id="._wantsFocus">**`_wantsFocus`**</span> : `boolean`

   * <span id="._wantsFocusDisabled">**`_wantsFocusDisabled`**</span> : `boolean`


## <a id="event-callbacks"></a>Event Callbacks
   * <span id=".onHotkeyDown">**`onHotkeyDown`**</span>

   * <span id=".onKeyDown">**`onKeyDown`**</span>

   * <span id=".onFocusIn">**`onFocusIn`**</span>

   * <span id=".onFocusOut">**`onFocusOut`**</span>


## <a id="methods"></a>Methods
   * <span id=".onDisabled">**`Focusable:onDisabled(disableFlag)`**</span>


   * <span id=".onEffectiveVisibilityChanged">**`Focusable:onEffectiveVisibilityChanged(hidden)`**</span>


   * <span id=".setFocus">**`Focusable:setFocus(flag)`**</span>


   * <span id="._handleFocusIn">**`Focusable:_handleFocusIn()`**</span>


   * <span id="._handleFocusOut">**`Focusable:_handleFocusOut()`**</span>


   * <span id="._handleHasFocusHandler">**`Focusable:_handleHasFocusHandler(focusHandler)`**</span>



## <a id="extra-members"></a>Extra Members

Members of the `extra` subtable are not inherited by subclasses and
are not available in derived objects: subclasses adopt them explicitly.

   * <span id=".setDefault">**`Focusable.extra:setDefault(defaultFlag)`**</span>


## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

Style parameters used in super classes:

   * [LayoutFrame](../lwtk/LayoutFrame.md#used-style-parameters): `BackgroundColor`, `BorderColor`, `BorderPadding`, `BorderSize`
   * [Compound](../lwtk/Compound.md#used-style-parameters): `Opacity`
   * [Animatable](../lwtk/Animatable.md#used-style-parameters): `FrameTransitionSeconds`

## <a id="subclasses"></a>Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / [Actionable](../lwtk/Actionable.md#subclasses) / [Node](../lwtk/Node.md#subclasses) / [Drawable](../lwtk/Drawable.md#subclasses) / **[Component](../lwtk/Component.md#subclasses)** / [Styleable](../lwtk/Styleable.md#subclasses) / [Animatable](../lwtk/Animatable.md#subclasses) / **[Widget](../lwtk/Widget.md#subclasses)** / [Compound](../lwtk/Compound.md#subclasses) /
        * [LayoutFrame](../lwtk/LayoutFrame.md#subclasses) / [Control](../lwtk/Control.md#subclasses) /
             * _`Focusable`_ / **[TextInput](../lwtk/TextInput.md#inheritance)**
             * [HotkeyListener](../lwtk/HotkeyListener.md#subclasses) / **[Button](../lwtk/Button.md#subclasses)** / _`Focusable`_ / **[PushButton](../lwtk/PushButton.md#inheritance)**
        * [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[Group](../lwtk/Group.md#subclasses)** / [LayoutFrame](../lwtk/LayoutFrame.md#subclasses) / [Control](../lwtk/Control.md#subclasses) / **[Box](../lwtk/Box.md#subclasses)** / _`Focusable`_ / **[FocusGroup](../lwtk/FocusGroup.md#inheritance)**

