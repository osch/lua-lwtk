# Class lwtk.FocusGroup


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Methods](#methods)
      * [handleHotkey()](#.handleHotkey)
      * [invokeActionMethod()](#.invokeActionMethod)
      * [onActionEnterFocusGroup()](#.onActionEnterFocusGroup)
      * [onActionExitFocusGroup()](#.onActionExitFocusGroup)
      * [onKeyDown()](#.onKeyDown)
      * [setFocus()](#.setFocus)
      * [_handleChildRequestsFocus()](#._handleChildRequestsFocus)
      * [_handleFocusIn()](#._handleFocusIn)
      * [_handleFocusOut()](#._handleFocusOut)
      * [_processMouseDown()](#._processMouseDown)
      * [_setApp()](#._setApp)
   * [Inherited Methods](#inherited-methods)


## Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** / [Styleable](../lwtk/Styleable.md#inheritance) / [Animatable](../lwtk/Animatable.md#inheritance) / **[Widget](../lwtk/Widget.md#inheritance)** / [Compound](../lwtk/Compound.md#inheritance) / [MouseDispatcher](../lwtk/MouseDispatcher.md#inheritance) / **[Group](../lwtk/Group.md#inheritance)** / [LayoutFrame](../lwtk/LayoutFrame.md#inheritance) / [Control](../lwtk/Control.md#inheritance) / **[Box](../lwtk/Box.md#inheritance)** / [Focusable](../lwtk/Focusable.md#inheritance) / _**`FocusGroup`**_

## Constructor
   * <span id=".new">**`FocusGroup(...)`**</span>

        * Overrides: **[Group()](../lwtk/Group.md#constructor)**
             * Overrides: [MouseDispatcher()](../lwtk/MouseDispatcher.md#constructor)
                  * Overrides: **[Widget()](../lwtk/Widget.md#constructor)**
                       * Overrides: [Animatable()](../lwtk/Animatable.md#constructor)
                            * Overrides: [Styleable()](../lwtk/Styleable.md#constructor)
                                 * Overrides: **[Component()](../lwtk/Component.md#constructor)**
                                      * Overrides: [Actionable()](../lwtk/Actionable.md#constructor)



## Methods
   * <span id=".handleHotkey">**`FocusGroup:handleHotkey(key, modifier, ...)`**</span>

        * Implements: [Focusable:handleHotkey()](../lwtk/Focusable.md#.handleHotkey)


   * <span id=".invokeActionMethod">**`FocusGroup:invokeActionMethod(actionMethodName)`**</span>

        * Overrides: [Actionable:invokeActionMethod()](../lwtk/Actionable.md#.invokeActionMethod)


   * <span id=".onActionEnterFocusGroup">**`FocusGroup:onActionEnterFocusGroup()`**</span>


   * <span id=".onActionExitFocusGroup">**`FocusGroup:onActionExitFocusGroup()`**</span>


   * <span id=".onKeyDown">**`FocusGroup:onKeyDown(key, modifier, ...)`**</span>

        * Implements: [Focusable:onKeyDown()](../lwtk/Focusable.md#.onKeyDown)


   * <span id=".setFocus">**`FocusGroup:setFocus(flag)`**</span>

        * Overrides: [Focusable:setFocus()](../lwtk/Focusable.md#.setFocus)


   * <span id="._handleChildRequestsFocus">**`FocusGroup:_handleChildRequestsFocus()`**</span>

        * Implements: [Group:_handleChildRequestsFocus()](../lwtk/Group.md#._handleChildRequestsFocus)


   * <span id="._handleFocusIn">**`FocusGroup:_handleFocusIn()`**</span>

        * Overrides: [Focusable:_handleFocusIn()](../lwtk/Focusable.md#._handleFocusIn)
             * Implements: [Component:_handleFocusIn()](../lwtk/Component.md#._handleFocusIn)


   * <span id="._handleFocusOut">**`FocusGroup:_handleFocusOut(reallyLostFocus)`**</span>

        * Overrides: [Focusable:_handleFocusOut()](../lwtk/Focusable.md#._handleFocusOut)


   * <span id="._processMouseDown">**`FocusGroup:_processMouseDown(mx, my, button, modState)`**</span>

        * Overrides: [MouseDispatcher:_processMouseDown()](../lwtk/MouseDispatcher.md#._processMouseDown)
             * Overrides: [Drawable:_processMouseDown()](../lwtk/Drawable.md#._processMouseDown)
                  * Implements: [Node:_processMouseDown()](../lwtk/Node.md#._processMouseDown)


   * <span id="._setApp">**`FocusGroup:_setApp(app)`**</span>

        * Overrides: [Widget:_setApp()](../lwtk/Widget.md#._setApp)
             * Overrides: [Component:_setApp()](../lwtk/Component.md#._setApp)



## Inherited Methods
   * [Focusable](../lwtk/Focusable.md):
      * [onDisabled()](../lwtk/Focusable.md#.onDisabled), [onEffectiveVisibilityChanged()](../lwtk/Focusable.md#.onEffectiveVisibilityChanged), [_handleHasFocusHandler()](../lwtk/Focusable.md#._handleHasFocusHandler)
   * **[Box](../lwtk/Box.md)**:
      * [getMeasures()](../lwtk/Box.md#.getMeasures)
   * [LayoutFrame](../lwtk/LayoutFrame.md):
      * [addChild()](../lwtk/LayoutFrame.md#.addChild), [onDraw()](../lwtk/LayoutFrame.md#.onDraw), [onLayout()](../lwtk/LayoutFrame.md#.onLayout)
   * **[Group](../lwtk/Group.md)**:
      * [childById()](../lwtk/Group.md#.childById), [_clearChildLookup()](../lwtk/Group.md#._clearChildLookup)
   * [MouseDispatcher](../lwtk/MouseDispatcher.md):
      * [_processMouseEnter()](../lwtk/MouseDispatcher.md#._processMouseEnter), [_processMouseLeave()](../lwtk/MouseDispatcher.md#._processMouseLeave), [_processMouseMove()](../lwtk/MouseDispatcher.md#._processMouseMove), [_processMouseScroll()](../lwtk/MouseDispatcher.md#._processMouseScroll), [_processMouseUp()](../lwtk/MouseDispatcher.md#._processMouseUp)
   * [Compound](../lwtk/Compound.md):
      * [_processChanges()](../lwtk/Compound.md#._processChanges), [_processDraw()](../lwtk/Compound.md#._processDraw)
   * **[Widget](../lwtk/Widget.md)**:
      * [notifyInputChanged()](../lwtk/Widget.md#.notifyInputChanged), [setOnInputChanged()](../lwtk/Widget.md#.setOnInputChanged), [setOnRealize()](../lwtk/Widget.md#.setOnRealize), [_setParent()](../lwtk/Widget.md#._setParent)
   * [Animatable](../lwtk/Animatable.md):
      * [animateFrame()](../lwtk/Animatable.md#.animateFrame), [getStyle()](../lwtk/Animatable.md#.getStyle), [getStyleParam()](../lwtk/Animatable.md#.getStyleParam), [isVisible()](../lwtk/Animatable.md#.isVisible), [setState()](../lwtk/Animatable.md#.setState), [setStates()](../lwtk/Animatable.md#.setStates), [setStyle()](../lwtk/Animatable.md#.setStyle), [setVisible()](../lwtk/Animatable.md#.setVisible), [updateAnimation()](../lwtk/Animatable.md#.updateAnimation), [_setStyleFromParent()](../lwtk/Animatable.md#._setStyleFromParent)
   * [Styleable](../lwtk/Styleable.md):
      * [clearStyleCache()](../lwtk/Styleable.md#.clearStyleCache), [getStateString()](../lwtk/Styleable.md#.getStateString), [_getStyleParam()](../lwtk/Styleable.md#._getStyleParam)
   * **[Component](../lwtk/Component.md)**:
      * [byId()](../lwtk/Component.md#.byId), [getCurrentTime()](../lwtk/Component.md#.getCurrentTime), [getFocusHandler()](../lwtk/Component.md#.getFocusHandler), [getFontInfo()](../lwtk/Component.md#.getFontInfo), [getFrame()](../lwtk/Component.md#.getFrame), [getLayoutContext()](../lwtk/Component.md#.getLayoutContext), [getParent()](../lwtk/Component.md#.getParent), [getRoot()](../lwtk/Component.md#.getRoot), [getSize()](../lwtk/Component.md#.getSize), [handleRemainingInitParams()](../lwtk/Component.md#.handleRemainingInitParams), [parentById()](../lwtk/Component.md#.parentById), [setFrame()](../lwtk/Component.md#.setFrame), [setInitParams()](../lwtk/Component.md#.setInitParams), [setTimer()](../lwtk/Component.md#.setTimer), [transformXY()](../lwtk/Component.md#.transformXY), [triggerLayout()](../lwtk/Component.md#.triggerLayout), [triggerRedraw()](../lwtk/Component.md#.triggerRedraw), [updateFrameTransition()](../lwtk/Component.md#.updateFrameTransition), [_setFrame()](../lwtk/Component.md#._setFrame)
   * [Drawable](../lwtk/Drawable.md):
      * [getMandatoryStyleParam()](../lwtk/Drawable.md#.getMandatoryStyleParam)
   * [Actionable](../lwtk/Actionable.md):
      * [hasActionMethod()](../lwtk/Actionable.md#.hasActionMethod)
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)
