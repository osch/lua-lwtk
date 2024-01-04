# Class lwtk.TextLabel


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Methods](#methods)
      * [getMeasures()](#.getMeasures)
      * [onHotkeyDisabled()](#.onHotkeyDisabled)
      * [onHotkeyDown()](#.onHotkeyDown)
      * [onHotkeyEnabled()](#.onHotkeyEnabled)
      * [onLayout()](#.onLayout)
      * [onMouseDown()](#.onMouseDown)
      * [setInput()](#.setInput)
      * [setText()](#.setText)
   * [Inherited Methods](#inherited-methods)
   * [Subclasses](#subclasses)


## Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** / [Styleable](../lwtk/Styleable.md#inheritance) / [Animatable](../lwtk/Animatable.md#inheritance) / **[Widget](../lwtk/Widget.md#inheritance)** / [Compound](../lwtk/Compound.md#inheritance) / [LayoutFrame](../lwtk/LayoutFrame.md#inheritance) / [Control](../lwtk/Control.md#inheritance) / [HotkeyListener](../lwtk/HotkeyListener.md#inheritance) / **[Button](../lwtk/Button.md#inheritance)** / _**`TextLabel`**_

## Constructor
   * <span id=".new">**`TextLabel(initParams)`**</span>

        * Overrides: **[Widget()](../lwtk/Widget.md#constructor)**
             * Overrides: [Animatable()](../lwtk/Animatable.md#constructor)
                  * Overrides: [Styleable()](../lwtk/Styleable.md#constructor)
                       * Overrides: **[Component()](../lwtk/Component.md#constructor)**
                            * Overrides: [Actionable()](../lwtk/Actionable.md#constructor)



## Methods
   * <span id=".getMeasures">**`TextLabel:getMeasures()`**</span>

        * Implements: [Component:getMeasures()](../lwtk/Component.md#.getMeasures)


   * <span id=".onHotkeyDisabled">**`TextLabel:onHotkeyDisabled(hotkey)`**</span>

        * Overrides: [HotkeyListener:onHotkeyDisabled()](../lwtk/HotkeyListener.md#.onHotkeyDisabled)


   * <span id=".onHotkeyDown">**`TextLabel:onHotkeyDown()`**</span>


   * <span id=".onHotkeyEnabled">**`TextLabel:onHotkeyEnabled(hotkey)`**</span>

        * Overrides: [HotkeyListener:onHotkeyEnabled()](../lwtk/HotkeyListener.md#.onHotkeyEnabled)
             * Implements: [Component:onHotkeyEnabled()](../lwtk/Component.md#.onHotkeyEnabled)


   * <span id=".onLayout">**`TextLabel:onLayout(width, height)`**</span>

        * Overrides: [LayoutFrame:onLayout()](../lwtk/LayoutFrame.md#.onLayout)
             * Implements: [Component:onLayout()](../lwtk/Component.md#.onLayout)


   * <span id=".onMouseDown">**`TextLabel:onMouseDown(x, y, button, modState)`**</span>

        * Implements: [Node:onMouseDown()](../lwtk/Node.md#.onMouseDown)


   * <span id=".setInput">**`TextLabel:setInput(inputId)`**</span>


   * <span id=".setText">**`TextLabel:setText(text)`**</span>



## Inherited Methods
   * [HotkeyListener](../lwtk/HotkeyListener.md):
      * [isHotkeyEnabled()](../lwtk/HotkeyListener.md#.isHotkeyEnabled), [onDisabled()](../lwtk/HotkeyListener.md#.onDisabled), [onEffectiveVisibilityChanged()](../lwtk/HotkeyListener.md#.onEffectiveVisibilityChanged), [setHotkey()](../lwtk/HotkeyListener.md#.setHotkey), [_handleHasFocusHandler()](../lwtk/HotkeyListener.md#._handleHasFocusHandler), [_handleRemovedFocusHandler()](../lwtk/HotkeyListener.md#._handleRemovedFocusHandler)
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

## Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / [Actionable](../lwtk/Actionable.md#subclasses) / [Node](../lwtk/Node.md#subclasses) / [Drawable](../lwtk/Drawable.md#subclasses) / **[Component](../lwtk/Component.md#subclasses)** / [Styleable](../lwtk/Styleable.md#subclasses) / [Animatable](../lwtk/Animatable.md#subclasses) / **[Widget](../lwtk/Widget.md#subclasses)** / [Compound](../lwtk/Compound.md#subclasses) / [LayoutFrame](../lwtk/LayoutFrame.md#subclasses) / [Control](../lwtk/Control.md#subclasses) / [HotkeyListener](../lwtk/HotkeyListener.md#subclasses) / **[Button](../lwtk/Button.md#subclasses)** / _**`TextLabel`**_ / **[TitleText](../lwtk/TitleText.md#inheritance)**

