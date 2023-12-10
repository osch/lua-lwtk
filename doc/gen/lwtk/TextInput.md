# Class lwtk.TextInput


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Methods](#methods)
      * [getMeasures()](#.getMeasures)
      * [onActionCursorLeft()](#.onActionCursorLeft)
      * [onActionCursorRight()](#.onActionCursorRight)
      * [onActionCursorToBeginOfLine()](#.onActionCursorToBeginOfLine)
      * [onActionCursorToEndOfLine()](#.onActionCursorToEndOfLine)
      * [onActionDeleteCharLeft()](#.onActionDeleteCharLeft)
      * [onActionDeleteCharRight()](#.onActionDeleteCharRight)
      * [onActionInputNext()](#.onActionInputNext)
      * [onActionInputPrev()](#.onActionInputPrev)
      * [onFocusIn()](#.onFocusIn)
      * [onFocusOut()](#.onFocusOut)
      * [onKeyDown()](#.onKeyDown)
      * [onLayout()](#.onLayout)
      * [onMouseDown()](#.onMouseDown)
      * [onRealize()](#.onRealize)
      * [setDefault()](#.setDefault)
      * [setFilterInput()](#.setFilterInput)
      * [setText()](#.setText)
   * [Inherited Methods](#inherited-methods)


## Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** / [Styleable](../lwtk/Styleable.md#inheritance) / [Animatable](../lwtk/Animatable.md#inheritance) / **[Widget](../lwtk/Widget.md#inheritance)** / [Compound](../lwtk/Compound.md#inheritance) / [LayoutFrame](../lwtk/LayoutFrame.md#inheritance) / [Control](../lwtk/Control.md#inheritance) / [Focusable](../lwtk/Focusable.md#inheritance) / _**`TextInput`**_

## Constructor
   * <span id=".new">**`TextInput(initParams)`**</span>

        * Overrides: **[Widget()](../lwtk/Widget.md#constructor)**
             * Overrides: [Animatable()](../lwtk/Animatable.md#constructor)
                  * Overrides: [Styleable()](../lwtk/Styleable.md#constructor)
                       * Overrides: **[Component()](../lwtk/Component.md#constructor)**
                            * Overrides: [Actionable()](../lwtk/Actionable.md#constructor)



## Methods
   * <span id=".getMeasures">**`TextInput:getMeasures()`**</span>

        * Implementation: [TextLabel:getMeasures()](../lwtk/TextLabel.md#getMeasures)
        * Implements: [Component:getMeasures()](../lwtk/Component.md#.getMeasures)


   * <span id=".onActionCursorLeft">**`TextInput:onActionCursorLeft()`**</span>


   * <span id=".onActionCursorRight">**`TextInput:onActionCursorRight()`**</span>


   * <span id=".onActionCursorToBeginOfLine">**`TextInput:onActionCursorToBeginOfLine()`**</span>


   * <span id=".onActionCursorToEndOfLine">**`TextInput:onActionCursorToEndOfLine()`**</span>


   * <span id=".onActionDeleteCharLeft">**`TextInput:onActionDeleteCharLeft()`**</span>


   * <span id=".onActionDeleteCharRight">**`TextInput:onActionDeleteCharRight()`**</span>


   * <span id=".onActionInputNext">**`TextInput:onActionInputNext()`**</span>


   * <span id=".onActionInputPrev">**`TextInput:onActionInputPrev()`**</span>


   * <span id=".onFocusIn">**`TextInput:onFocusIn()`**</span>

        * Implements: [Focusable:onFocusIn()](../lwtk/Focusable.md#.onFocusIn)


   * <span id=".onFocusOut">**`TextInput:onFocusOut()`**</span>

        * Implements: [Focusable:onFocusOut()](../lwtk/Focusable.md#.onFocusOut)


   * <span id=".onKeyDown">**`TextInput:onKeyDown(keyName, keyState, keyText)`**</span>

        * Implements: [Focusable:onKeyDown()](../lwtk/Focusable.md#.onKeyDown)


   * <span id=".onLayout">**`TextInput:onLayout(width, height)`**</span>

        * Overrides: [LayoutFrame:onLayout()](../lwtk/LayoutFrame.md#.onLayout)
             * Implements: [Component:onLayout()](../lwtk/Component.md#.onLayout)


   * <span id=".onMouseDown">**`TextInput:onMouseDown(mx, my, button, modState)`**</span>

        * Implements: [Node:onMouseDown()](../lwtk/Node.md#.onMouseDown)


   * <span id=".onRealize">**`TextInput:onRealize()`**</span>

        * Implements: [Component:onRealize()](../lwtk/Component.md#.onRealize)


   * <span id=".setDefault">**`TextInput:setDefault(buttonId)`**</span>


   * <span id=".setFilterInput">**`TextInput:setFilterInput(filterInput)`**</span>


   * <span id=".setText">**`TextInput:setText(text)`**</span>



## Inherited Methods
   * [Focusable](../lwtk/Focusable.md):
      * [onDisabled()](../lwtk/Focusable.md#.onDisabled), [onEffectiveVisibilityChanged()](../lwtk/Focusable.md#.onEffectiveVisibilityChanged), [setFocus()](../lwtk/Focusable.md#.setFocus), [_handleFocusIn()](../lwtk/Focusable.md#._handleFocusIn), [_handleFocusOut()](../lwtk/Focusable.md#._handleFocusOut), [_handleHasFocusHandler()](../lwtk/Focusable.md#._handleHasFocusHandler)
   * [LayoutFrame](../lwtk/LayoutFrame.md):
      * [addChild()](../lwtk/LayoutFrame.md#.addChild), [onDraw()](../lwtk/LayoutFrame.md#.onDraw)
   * [Compound](../lwtk/Compound.md):
      * [_processChanges()](../lwtk/Compound.md#._processChanges), [_processDraw()](../lwtk/Compound.md#._processDraw)
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
   * [Actionable](../lwtk/Actionable.md):
      * [hasActionMethod()](../lwtk/Actionable.md#.hasActionMethod), [invokeActionMethod()](../lwtk/Actionable.md#.invokeActionMethod)
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)
