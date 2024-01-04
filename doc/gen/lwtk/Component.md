# Class lwtk.Component


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Methods](#methods)
      * [animateFrame()](#.animateFrame)
      * [byId()](#.byId)
      * [getCurrentTime()](#.getCurrentTime)
      * [getFocusHandler()](#.getFocusHandler)
      * [getFontInfo()](#.getFontInfo)
      * [getFrame()](#.getFrame)
      * [getLayoutContext()](#.getLayoutContext)
      * [getParent()](#.getParent)
      * [getRoot()](#.getRoot)
      * [getSize()](#.getSize)
      * [handleRemainingInitParams()](#.handleRemainingInitParams)
      * [parentById()](#.parentById)
      * [setFrame()](#.setFrame)
      * [setInitParams()](#.setInitParams)
      * [setTimer()](#.setTimer)
      * [transformXY()](#.transformXY)
      * [triggerLayout()](#.triggerLayout)
      * [triggerRedraw()](#.triggerRedraw)
      * [updateAnimation()](#.updateAnimation)
      * [updateFrameTransition()](#.updateFrameTransition)
      * [_processChanges()](#._processChanges)
      * [_processDraw()](#._processDraw)
      * [_setApp()](#._setApp)
      * [_setFrame()](#._setFrame)
      * [_setParent()](#._setParent)
   * [Inherited Methods](#inherited-methods)
   * [Subclasses](#subclasses)


## Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / _**`Component`**_

## Constructor
   * <span id=".new">**`Component(initParams)`**</span>

        * Overrides: [Actionable()](../lwtk/Actionable.md#constructor)



## Methods
   * <span id=".animateFrame">**`Component:animateFrame(...)`**</span>


   * <span id=".byId">**`Component:byId(id)`**</span>


   * <span id=".getCurrentTime">**`Component:getCurrentTime()`**</span>


   * <span id=".getFocusHandler">**`Component:getFocusHandler()`**</span>


   * <span id=".getFontInfo">**`Component:getFontInfo(family, slant, weight, size)`**</span>


   * <span id=".getFrame">**`Component:getFrame()`**</span>


   * <span id=".getLayoutContext">**`Component:getLayoutContext()`**</span>


   * <span id=".getParent">**`Component:getParent()`**</span>


   * <span id=".getRoot">**`Component:getRoot()`**</span>


   * <span id=".getSize">**`Component:getSize()`**</span>


   * <span id=".handleRemainingInitParams">**`Component:handleRemainingInitParams(initParams)`**</span>

        * Overrides: [Actionable:handleRemainingInitParams()](../lwtk/Actionable.md#.handleRemainingInitParams)


   * <span id=".parentById">**`Component:parentById(id)`**</span>


   * <span id=".setFrame">**`Component:setFrame(...)`**</span>


   * <span id=".setInitParams">**`Component:setInitParams(initParams)`**</span>

        * Overrides: [Actionable:setInitParams()](../lwtk/Actionable.md#.setInitParams)


   * <span id=".setTimer">**`Component:setTimer(seconds, func, ...)`**</span>


   * <span id=".transformXY">**`Component:transformXY(x, y, parent)`**</span>


   * <span id=".triggerLayout">**`Component:triggerLayout()`**</span>


   * <span id=".triggerRedraw">**`Component:triggerRedraw()`**</span>


   * <span id=".updateAnimation">**`Component:updateAnimation()`**</span>


   * <span id=".updateFrameTransition">**`Component:updateFrameTransition()`**</span>


   * <span id="._processChanges">**`Component:_processChanges(x0, y0, cx, cy, cw, ch, damagedArea)`**</span>


   * <span id="._processDraw">**`Component:_processDraw(ctx, x0, y0, cx, cy, cw, ch, exposedArea)`**</span>


   * <span id="._setApp">**`Component:_setApp(app)`**</span>


   * <span id="._setFrame">**`Component:_setFrame(newX, newY, newW, newH, fromFrameAnimation)`**</span>


   * <span id="._setParent">**`Component:_setParent(parent)`**</span>



## Inherited Methods
   * [Drawable](../lwtk/Drawable.md):
      * [getMandatoryStyleParam()](../lwtk/Drawable.md#.getMandatoryStyleParam), [getStyleParam()](../lwtk/Drawable.md#.getStyleParam), [_processMouseDown()](../lwtk/Drawable.md#._processMouseDown), [_processMouseEnter()](../lwtk/Drawable.md#._processMouseEnter), [_processMouseLeave()](../lwtk/Drawable.md#._processMouseLeave), [_processMouseMove()](../lwtk/Drawable.md#._processMouseMove), [_processMouseScroll()](../lwtk/Drawable.md#._processMouseScroll), [_processMouseUp()](../lwtk/Drawable.md#._processMouseUp)
   * [Node](../lwtk/Node.md):
      * [discard()](../lwtk/Node.md#.discard)
   * [Actionable](../lwtk/Actionable.md):
      * [hasActionMethod()](../lwtk/Actionable.md#.hasActionMethod), [invokeActionMethod()](../lwtk/Actionable.md#.invokeActionMethod)
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)

## Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / [Actionable](../lwtk/Actionable.md#subclasses) / [Node](../lwtk/Node.md#subclasses) / [Drawable](../lwtk/Drawable.md#subclasses) / _**`Component`**_ /
        * [Compound](../lwtk/Compound.md#subclasses) / **[InnerCompound](../lwtk/InnerCompound.md#inheritance)**
        * [Styleable](../lwtk/Styleable.md#subclasses) / [Animatable](../lwtk/Animatable.md#subclasses) / **[Widget](../lwtk/Widget.md#subclasses)** / [Compound](../lwtk/Compound.md#subclasses) /
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
        * **[TextCursor](../lwtk/TextCursor.md#inheritance)**
        * **[TextFragment](../lwtk/TextFragment.md#inheritance)**

