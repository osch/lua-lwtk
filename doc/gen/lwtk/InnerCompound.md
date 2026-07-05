# Class lwtk.InnerCompound


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Used Style Parameters](#used-style-parameters)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** / [Compound](../lwtk/Compound.md#inheritance) / _**`InnerCompound`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`InnerCompound(initParams)`**</span>

        * Inherited from: **[Component()](../lwtk/Component.md#constructor)**


## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `frame` - **[Component:setFrame()](../lwtk/Component.md#.setFrame)**
   * `timer` - **[Component:setTimer()](../lwtk/Component.md#.setTimer)**

Additionally parameters matching `onAction<ActionName>` register action methods, see [lwtk.Actionable](../lwtk/Actionable.md) for details.

## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

Style parameters used in super classes:

   * [Compound](../lwtk/Compound.md#used-style-parameters): `Opacity`

## <a id="inherited-methods"></a>Inherited Methods
   * [Compound](../lwtk/Compound.md):
      * [addChild()](../lwtk/Compound.md#.addChild), [discardChild()](../lwtk/Compound.md#.discardChild), [removeChild()](../lwtk/Compound.md#.removeChild), [_processChanges()](../lwtk/Compound.md#._processChanges), [_processDraw()](../lwtk/Compound.md#._processDraw)
   * **[Component](../lwtk/Component.md)**:
      * [animateFrame()](../lwtk/Component.md#.animateFrame), [byId()](../lwtk/Component.md#.byId), [getCurrentTime()](../lwtk/Component.md#.getCurrentTime), [getFocusHandler()](../lwtk/Component.md#.getFocusHandler), [getFontInfo()](../lwtk/Component.md#.getFontInfo), [getFrame()](../lwtk/Component.md#.getFrame), [getLayoutContext()](../lwtk/Component.md#.getLayoutContext), [getParent()](../lwtk/Component.md#.getParent), [getRoot()](../lwtk/Component.md#.getRoot), [getSize()](../lwtk/Component.md#.getSize), [handleRemainingInitParams()](../lwtk/Component.md#.handleRemainingInitParams), [parentById()](../lwtk/Component.md#.parentById), [setFrame()](../lwtk/Component.md#.setFrame), [setInitParams()](../lwtk/Component.md#.setInitParams), [setTimer()](../lwtk/Component.md#.setTimer), [transformXY()](../lwtk/Component.md#.transformXY), [triggerLayout()](../lwtk/Component.md#.triggerLayout), [triggerRedraw()](../lwtk/Component.md#.triggerRedraw), [updateAnimation()](../lwtk/Component.md#.updateAnimation), [updateFrameTransition()](../lwtk/Component.md#.updateFrameTransition), [_setApp()](../lwtk/Component.md#._setApp), [_setFrame()](../lwtk/Component.md#._setFrame), [_setParent()](../lwtk/Component.md#._setParent)
   * [Drawable](../lwtk/Drawable.md):
      * [getMandatoryStyleParam()](../lwtk/Drawable.md#.getMandatoryStyleParam), [getStyleParam()](../lwtk/Drawable.md#.getStyleParam), [_processMouseDown()](../lwtk/Drawable.md#._processMouseDown), [_processMouseEnter()](../lwtk/Drawable.md#._processMouseEnter), [_processMouseLeave()](../lwtk/Drawable.md#._processMouseLeave), [_processMouseMove()](../lwtk/Drawable.md#._processMouseMove), [_processMouseScroll()](../lwtk/Drawable.md#._processMouseScroll), [_processMouseUp()](../lwtk/Drawable.md#._processMouseUp)
   * [Node](../lwtk/Node.md):
      * [discard()](../lwtk/Node.md#.discard)
   * [Actionable](../lwtk/Actionable.md):
      * [hasActionMethod()](../lwtk/Actionable.md#.hasActionMethod), [invokeActionMethod()](../lwtk/Actionable.md#.invokeActionMethod)
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * **[Object](../lwtk/Object.md)**:
      * [declare()](../lwtk/Object.md#.declare), [getMixinBase()](../lwtk/Object.md#.getMixinBase), [newSubClass()](../lwtk/Object.md#.newSubClass)
