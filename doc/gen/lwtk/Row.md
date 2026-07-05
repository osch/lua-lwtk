# Class lwtk.Row


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Methods](#methods)
      * [getMeasures()](#.getMeasures)
      * [onLayout()](#.onLayout)
   * [Used Style Parameters](#used-style-parameters)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** / [Styleable](../lwtk/Styleable.md#inheritance) / [Animatable](../lwtk/Animatable.md#inheritance) / **[Widget](../lwtk/Widget.md#inheritance)** / [Compound](../lwtk/Compound.md#inheritance) / [MouseDispatcher](../lwtk/MouseDispatcher.md#inheritance) / **[Group](../lwtk/Group.md#inheritance)** / _**`Row`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`Row(initParams)`**</span>

        * Inherited from: **[Group()](../lwtk/Group.md#constructor)**


## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `frame` - **[Component:setFrame()](../lwtk/Component.md#.setFrame)**
   * `onInputChanged` - **[Widget:setOnInputChanged()](../lwtk/Widget.md#.setOnInputChanged)**
   * `onRealize` - **[Widget:setOnRealize()](../lwtk/Widget.md#.setOnRealize)**
   * `state` - [Animatable:setState()](../lwtk/Animatable.md#.setState)
   * `states` - [Animatable:setStates()](../lwtk/Animatable.md#.setStates)
   * `style` - [Animatable:setStyle()](../lwtk/Animatable.md#.setStyle)
   * `timer` - **[Component:setTimer()](../lwtk/Component.md#.setTimer)**
   * `visible` - [Animatable:setVisible()](../lwtk/Animatable.md#.setVisible)

Additionally parameters matching `onAction<ActionName>` register action methods, see [lwtk.Actionable](../lwtk/Actionable.md) for details.

## <a id="methods"></a>Methods
   * <span id=".getMeasures">**`Row:getMeasures()`**</span>

        * Implements: [Component:getMeasures()](../lwtk/Component.md#.getMeasures)


   * <span id=".onLayout">**`Row:onLayout(width, height, isLayoutTransition)`**</span>

        * Implements: [Component:onLayout()](../lwtk/Component.md#.onLayout)



## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

Style parameters used in super classes:

   * [Compound](../lwtk/Compound.md#used-style-parameters): `Opacity`
   * [Animatable](../lwtk/Animatable.md#used-style-parameters): `FrameTransitionSeconds`

## <a id="inherited-methods"></a>Inherited Methods
   * **[Group](../lwtk/Group.md)**:
      * [addChild()](../lwtk/Group.md#.addChild), [childById()](../lwtk/Group.md#.childById), [removeChild()](../lwtk/Group.md#.removeChild), [_clearChildLookup()](../lwtk/Group.md#._clearChildLookup)
   * [MouseDispatcher](../lwtk/MouseDispatcher.md):
      * [_processMouseDown()](../lwtk/MouseDispatcher.md#._processMouseDown), [_processMouseEnter()](../lwtk/MouseDispatcher.md#._processMouseEnter), [_processMouseLeave()](../lwtk/MouseDispatcher.md#._processMouseLeave), [_processMouseMove()](../lwtk/MouseDispatcher.md#._processMouseMove), [_processMouseScroll()](../lwtk/MouseDispatcher.md#._processMouseScroll), [_processMouseUp()](../lwtk/MouseDispatcher.md#._processMouseUp)
   * [Compound](../lwtk/Compound.md):
      * [discardChild()](../lwtk/Compound.md#.discardChild), [_processChanges()](../lwtk/Compound.md#._processChanges), [_processDraw()](../lwtk/Compound.md#._processDraw)
   * **[Widget](../lwtk/Widget.md)**:
      * [notifyInputChanged()](../lwtk/Widget.md#.notifyInputChanged), [setOnInputChanged()](../lwtk/Widget.md#.setOnInputChanged), [setOnRealize()](../lwtk/Widget.md#.setOnRealize), [_setApp()](../lwtk/Widget.md#._setApp), [_setParent()](../lwtk/Widget.md#._setParent)
   * [Animatable](../lwtk/Animatable.md):
      * [animateFrame()](../lwtk/Animatable.md#.animateFrame), [getStyle()](../lwtk/Animatable.md#.getStyle), [getStyleParam()](../lwtk/Animatable.md#.getStyleParam), [isVisible()](../lwtk/Animatable.md#.isVisible), [setState()](../lwtk/Animatable.md#.setState), [setStates()](../lwtk/Animatable.md#.setStates), [setStyle()](../lwtk/Animatable.md#.setStyle), [setVisible()](../lwtk/Animatable.md#.setVisible), [updateAnimation()](../lwtk/Animatable.md#.updateAnimation), [_setStyleFromParent()](../lwtk/Animatable.md#._setStyleFromParent)
   * [Styleable](../lwtk/Styleable.md):
      * [clearStyleCache()](../lwtk/Styleable.md#.clearStyleCache), [getStateString()](../lwtk/Styleable.md#.getStateString), [_getStyleParam()](../lwtk/Styleable.md#._getStyleParam)
   * **[Component](../lwtk/Component.md)**:
      * [byId()](../lwtk/Component.md#.byId), [getCurrentTime()](../lwtk/Component.md#.getCurrentTime), [getFocusHandler()](../lwtk/Component.md#.getFocusHandler), [getFontInfo()](../lwtk/Component.md#.getFontInfo), [getFrame()](../lwtk/Component.md#.getFrame), [getLayoutContext()](../lwtk/Component.md#.getLayoutContext), [getParent()](../lwtk/Component.md#.getParent), [getRoot()](../lwtk/Component.md#.getRoot), [getSize()](../lwtk/Component.md#.getSize), [handleRemainingInitParams()](../lwtk/Component.md#.handleRemainingInitParams), [parentById()](../lwtk/Component.md#.parentById), [setFrame()](../lwtk/Component.md#.setFrame), [setInitParams()](../lwtk/Component.md#.setInitParams), [setTimer()](../lwtk/Component.md#.setTimer), [transformXY()](../lwtk/Component.md#.transformXY), [triggerLayout()](../lwtk/Component.md#.triggerLayout), [triggerRedraw()](../lwtk/Component.md#.triggerRedraw), [updateFrameTransition()](../lwtk/Component.md#.updateFrameTransition), [_setFrame()](../lwtk/Component.md#._setFrame)
   * [Drawable](../lwtk/Drawable.md):
      * [getMandatoryStyleParam()](../lwtk/Drawable.md#.getMandatoryStyleParam)
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
