# Class lwtk.PushButton


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Attributes](#attributes)
      * [textFragment](#.textFragment)
      * [text](#.text)
      * [mousePressed](#.mousePressed)
      * [mouseEntered](#.mouseEntered)
      * [_mouseDownTime](#._mouseDownTime)
   * [Event Callbacks](#event-callbacks)
      * [onClicked()](#.onClicked)
   * [Methods](#methods)
      * [getMeasures()](#.getMeasures)
      * [onActionFocusedButtonClick()](#.onActionFocusedButtonClick)
      * [onDefaultChanged()](#.onDefaultChanged)
      * [onHotkeyDisabled()](#.onHotkeyDisabled)
      * [onHotkeyDown()](#.onHotkeyDown)
      * [onHotkeyEnabled()](#.onHotkeyEnabled)
      * [onLayout()](#.onLayout)
      * [onMouseDown()](#.onMouseDown)
      * [onMouseEnter()](#.onMouseEnter)
      * [onMouseLeave()](#.onMouseLeave)
      * [onMouseUp()](#.onMouseUp)
      * [setDefault()](#.setDefault)
      * [setDisabled()](#.setDisabled)
      * [setOnClicked()](#.setOnClicked)
      * [setText()](#.setText)
   * [Used Style Parameters](#used-style-parameters)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** / [Styleable](../lwtk/Styleable.md#inheritance) / [Animatable](../lwtk/Animatable.md#inheritance) / **[Widget](../lwtk/Widget.md#inheritance)** / [Compound](../lwtk/Compound.md#inheritance) / [LayoutFrame](../lwtk/LayoutFrame.md#inheritance) / [Control](../lwtk/Control.md#inheritance) / [HotkeyListener](../lwtk/HotkeyListener.md#inheritance) / **[Button](../lwtk/Button.md#inheritance)** / [Focusable](../lwtk/Focusable.md#inheritance) / _**`PushButton`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`PushButton(initParams)`**</span>

        * Overrides: **[Widget()](../lwtk/Widget.md#constructor)**
             * Overrides: [Animatable()](../lwtk/Animatable.md#constructor)
                  * Overrides: [Styleable()](../lwtk/Styleable.md#constructor)
                       * Overrides: **[Component()](../lwtk/Component.md#constructor)**
                            * Overrides: [Actionable()](../lwtk/Actionable.md#constructor)



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `default` - [setDefault()](#.setDefault)
   * `disabled` - [setDisabled()](#.setDisabled)
   * `focus` - [Focusable:setFocus()](../lwtk/Focusable.md#.setFocus)
   * `frame` - **[Component:setFrame()](../lwtk/Component.md#.setFrame)**
   * `hotkey` - [HotkeyListener:setHotkey()](../lwtk/HotkeyListener.md#.setHotkey)
   * `onClicked` - [setOnClicked()](#.setOnClicked)
   * `onInputChanged` - **[Widget:setOnInputChanged()](../lwtk/Widget.md#.setOnInputChanged)**
   * `onRealize` - **[Widget:setOnRealize()](../lwtk/Widget.md#.setOnRealize)**
   * `state` - [Animatable:setState()](../lwtk/Animatable.md#.setState)
   * `states` - [Animatable:setStates()](../lwtk/Animatable.md#.setStates)
   * `style` - [Animatable:setStyle()](../lwtk/Animatable.md#.setStyle)
   * `text` - [setText()](#.setText)
   * `timer` - **[Component:setTimer()](../lwtk/Component.md#.setTimer)**
   * `visible` - [Animatable:setVisible()](../lwtk/Animatable.md#.setVisible)

Additionally parameters matching `onAction<ActionName>` register action methods, see [lwtk.Actionable](../lwtk/Actionable.md) for details.

## <a id="attributes"></a>Attributes
   * <span id=".textFragment">**`textFragment`**</span> : [lwtk.TextFragment](../lwtk/TextFragment.md)

   * <span id=".text">**`text`**</span>

   * <span id=".mousePressed">**`mousePressed`**</span> : `boolean`

   * <span id=".mouseEntered">**`mouseEntered`**</span> : `boolean`

   * <span id="._mouseDownTime">**`_mouseDownTime`**</span>


## <a id="event-callbacks"></a>Event Callbacks
   * <span id=".onClicked">**`onClicked`**</span>


## <a id="methods"></a>Methods
   * <span id=".getMeasures">**`PushButton:getMeasures()`**</span>

        * Implementation: [TextLabel:getMeasures()](../lwtk/TextLabel.md#.getMeasures)
        * Implements: [Component:getMeasures()](../lwtk/Component.md#.getMeasures)


   * <span id=".onActionFocusedButtonClick">**`PushButton:onActionFocusedButtonClick()`**</span>


   * <span id=".onDefaultChanged">**`PushButton:onDefaultChanged(isCurrentDefault, isPrincipalDefault)`**</span>


   * <span id=".onHotkeyDisabled">**`PushButton:onHotkeyDisabled(hotkey)`**</span>

        * Overrides: [HotkeyListener:onHotkeyDisabled()](../lwtk/HotkeyListener.md#.onHotkeyDisabled)


   * <span id=".onHotkeyDown">**`PushButton:onHotkeyDown()`**</span>

        * Implements: [Focusable:onHotkeyDown()](../lwtk/Focusable.md#.onHotkeyDown)


   * <span id=".onHotkeyEnabled">**`PushButton:onHotkeyEnabled(hotkey)`**</span>

        * Overrides: [HotkeyListener:onHotkeyEnabled()](../lwtk/HotkeyListener.md#.onHotkeyEnabled)
             * Implements: [Component:onHotkeyEnabled()](../lwtk/Component.md#.onHotkeyEnabled)


   * <span id=".onLayout">**`PushButton:onLayout(width, height)`**</span>

        * Overrides: [LayoutFrame:onLayout()](../lwtk/LayoutFrame.md#.onLayout)
             * Implements: [Component:onLayout()](../lwtk/Component.md#.onLayout)


   * <span id=".onMouseDown">**`PushButton:onMouseDown(x, y, button, modState)`**</span>

        * Implements: [Node:onMouseDown()](../lwtk/Node.md#.onMouseDown)


   * <span id=".onMouseEnter">**`PushButton:onMouseEnter(x, y)`**</span>

        * Implements: [Node:onMouseEnter()](../lwtk/Node.md#.onMouseEnter)


   * <span id=".onMouseLeave">**`PushButton:onMouseLeave(x, y)`**</span>

        * Implements: [Node:onMouseLeave()](../lwtk/Node.md#.onMouseLeave)


   * <span id=".onMouseUp">**`PushButton:onMouseUp(x, y, button, modState)`**</span>

        * Implements: [Node:onMouseUp()](../lwtk/Node.md#.onMouseUp)


   * <span id=".setDefault">**`PushButton:setDefault(defaultFlag)`**</span>

        * Implementation: [Focusable.extra:setDefault()](../lwtk/Focusable.md#.setDefault)

   * <span id=".setDisabled">**`PushButton:setDisabled(flag)`**</span>


   * <span id=".setOnClicked">**`PushButton:setOnClicked(onClicked)`**</span>


   * <span id=".setText">**`PushButton:setText(text)`**</span>



## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

The implementation uses the following style parameters:

   * `SimulateButtonClickSeconds`

Style parameters used in super classes:

   * [LayoutFrame](../lwtk/LayoutFrame.md#used-style-parameters): `BackgroundColor`, `BorderColor`, `BorderPadding`, `BorderSize`
   * [Compound](../lwtk/Compound.md#used-style-parameters): `Opacity`
   * [Animatable](../lwtk/Animatable.md#used-style-parameters): `FrameTransitionSeconds`

## <a id="inherited-methods"></a>Inherited Methods
   * [Focusable](../lwtk/Focusable.md):
      * [onDisabled()](../lwtk/Focusable.md#.onDisabled), [onEffectiveVisibilityChanged()](../lwtk/Focusable.md#.onEffectiveVisibilityChanged), [setFocus()](../lwtk/Focusable.md#.setFocus), [_handleFocusIn()](../lwtk/Focusable.md#._handleFocusIn), [_handleFocusOut()](../lwtk/Focusable.md#._handleFocusOut), [_handleHasFocusHandler()](../lwtk/Focusable.md#._handleHasFocusHandler)
   * [HotkeyListener](../lwtk/HotkeyListener.md):
      * [isHotkeyEnabled()](../lwtk/HotkeyListener.md#.isHotkeyEnabled), [setHotkey()](../lwtk/HotkeyListener.md#.setHotkey), [_handleRemovedFocusHandler()](../lwtk/HotkeyListener.md#._handleRemovedFocusHandler)
   * [LayoutFrame](../lwtk/LayoutFrame.md):
      * [addChild()](../lwtk/LayoutFrame.md#.addChild), [onDraw()](../lwtk/LayoutFrame.md#.onDraw)
   * [Compound](../lwtk/Compound.md):
      * [discardChild()](../lwtk/Compound.md#.discardChild), [removeChild()](../lwtk/Compound.md#.removeChild), [_processChanges()](../lwtk/Compound.md#._processChanges), [_processDraw()](../lwtk/Compound.md#._processDraw)
   * **[Widget](../lwtk/Widget.md)**:
      * [notifyInputChanged()](../lwtk/Widget.md#.notifyInputChanged), [setOnInputChanged()](../lwtk/Widget.md#.setOnInputChanged), [setOnRealize()](../lwtk/Widget.md#.setOnRealize), [_setApp()](../lwtk/Widget.md#._setApp), [_setParent()](../lwtk/Widget.md#._setParent)
   * [Animatable](../lwtk/Animatable.md):
      * [animateFrame()](../lwtk/Animatable.md#.animateFrame), [getStyle()](../lwtk/Animatable.md#.getStyle), [getStyleParam()](../lwtk/Animatable.md#.getStyleParam), [isVisible()](../lwtk/Animatable.md#.isVisible), [setState()](../lwtk/Animatable.md#.setState), [setStates()](../lwtk/Animatable.md#.setStates), [setStyle()](../lwtk/Animatable.md#.setStyle), [setVisible()](../lwtk/Animatable.md#.setVisible), [updateAnimation()](../lwtk/Animatable.md#.updateAnimation), [_setStyleFromParent()](../lwtk/Animatable.md#._setStyleFromParent)
   * [Styleable](../lwtk/Styleable.md):
      * [clearStyleCache()](../lwtk/Styleable.md#.clearStyleCache), [getStateString()](../lwtk/Styleable.md#.getStateString), [_getStyleParam()](../lwtk/Styleable.md#._getStyleParam)
   * **[Component](../lwtk/Component.md)**:
      * [byId()](../lwtk/Component.md#.byId), [getCurrentTime()](../lwtk/Component.md#.getCurrentTime), [getFocusHandler()](../lwtk/Component.md#.getFocusHandler), [getFontInfo()](../lwtk/Component.md#.getFontInfo), [getFrame()](../lwtk/Component.md#.getFrame), [getLayoutContext()](../lwtk/Component.md#.getLayoutContext), [getParent()](../lwtk/Component.md#.getParent), [getRoot()](../lwtk/Component.md#.getRoot), [getSize()](../lwtk/Component.md#.getSize), [handleRemainingInitParams()](../lwtk/Component.md#.handleRemainingInitParams), [parentById()](../lwtk/Component.md#.parentById), [setFrame()](../lwtk/Component.md#.setFrame), [setInitParams()](../lwtk/Component.md#.setInitParams), [setTimer()](../lwtk/Component.md#.setTimer), [transformXY()](../lwtk/Component.md#.transformXY), [triggerLayout()](../lwtk/Component.md#.triggerLayout), [triggerRedraw()](../lwtk/Component.md#.triggerRedraw), [updateFrameTransition()](../lwtk/Component.md#.updateFrameTransition), [_setFrame()](../lwtk/Component.md#._setFrame)
   * [Drawable](../lwtk/Drawable.md):
      * [getMandatoryStyleParam()](../lwtk/Drawable.md#.getMandatoryStyleParam), [_processMouseDown()](../lwtk/Drawable.md#._processMouseDown), [_processMouseEnter()](../lwtk/Drawable.md#._processMouseEnter), [_processMouseLeave()](../lwtk/Drawable.md#._processMouseLeave), [_processMouseMove()](../lwtk/Drawable.md#._processMouseMove), [_processMouseScroll()](../lwtk/Drawable.md#._processMouseScroll), [_processMouseUp()](../lwtk/Drawable.md#._processMouseUp)
   * [Node](../lwtk/Node.md):
      * [discard()](../lwtk/Node.md#.discard)
   * [Actionable](../lwtk/Actionable.md):
      * [hasActionMethod()](../lwtk/Actionable.md#.hasActionMethod), [invokeActionMethod()](../lwtk/Actionable.md#.invokeActionMethod)
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * [Styleable](../lwtk/Styleable.md):
      * [newSubClass()](../lwtk/Styleable.md#.newSubClass)
   * **[Object](../lwtk/Object.md)**:
      * [declare()](../lwtk/Object.md#.declare), [getMixinBase()](../lwtk/Object.md#.getMixinBase)
