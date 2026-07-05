# Class lwtk.TextFragment


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Attributes](#attributes)
      * [tx](#.tx)
      * [ty](#.ty)
      * [label](#.label)
      * [labelLeft](#.labelLeft)
      * [labelKey](#.labelKey)
      * [labelRight](#.labelRight)
      * [text](#.text)
      * [textWidth](#.textWidth)
      * [considerHotkey](#.considerHotkey)
      * [hotkey](#.hotkey)
      * [fontInfo](#.fontInfo)
      * [textSize](#.textSize)
      * [fontFamily](#.fontFamily)
      * [showHotKey](#.showHotKey)
   * [Methods](#methods)
      * [getFontInfo()](#.getFontInfo)
      * [getTextMeasures()](#.getTextMeasures)
      * [onDraw()](#.onDraw)
      * [setConsiderHotkey()](#.setConsiderHotkey)
      * [setShowHotkey()](#.setShowHotkey)
      * [setText()](#.setText)
      * [setTextPos()](#.setTextPos)
   * [Used Style Parameters](#used-style-parameters)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / **[Component](../lwtk/Component.md#inheritance)** / _**`TextFragment`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`TextFragment(initParams)`**</span>

        * Overrides: **[Component()](../lwtk/Component.md#constructor)**
             * Overrides: [Actionable()](../lwtk/Actionable.md#constructor)



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `considerHotkey` - [setConsiderHotkey()](#.setConsiderHotkey)
   * `frame` - **[Component:setFrame()](../lwtk/Component.md#.setFrame)**
   * `showHotkey` - [setShowHotkey()](#.setShowHotkey)
   * `text` - [setText()](#.setText)
   * `textPos` - [setTextPos()](#.setTextPos)
   * `timer` - **[Component:setTimer()](../lwtk/Component.md#.setTimer)**

Additionally parameters matching `onAction<ActionName>` register action methods, see [lwtk.Actionable](../lwtk/Actionable.md) for details.

## <a id="attributes"></a>Attributes
   * <span id=".tx">**`tx`**</span>

   * <span id=".ty">**`ty`**</span>

   * <span id=".label">**`label`**</span> : `string`

   * <span id=".labelLeft">**`labelLeft`**</span>

   * <span id=".labelKey">**`labelKey`**</span>

   * <span id=".labelRight">**`labelRight`**</span>

   * <span id=".text">**`text`**</span>

   * <span id=".textWidth">**`textWidth`**</span>

   * <span id=".considerHotkey">**`considerHotkey`**</span>

   * <span id=".hotkey">**`hotkey`**</span>

   * <span id=".fontInfo">**`fontInfo`**</span>

   * <span id=".textSize">**`textSize`**</span>

   * <span id=".fontFamily">**`fontFamily`**</span>

   * <span id=".showHotKey">**`showHotKey`**</span>


## <a id="methods"></a>Methods
   * <span id=".getFontInfo">**`TextFragment:getFontInfo(family, slant, weight, size)`**</span>

        * Overrides: [Component:getFontInfo()](../lwtk/Component.md#.getFontInfo)


   * <span id=".getTextMeasures">**`TextFragment:getTextMeasures()`**</span>


   * <span id=".onDraw">**`TextFragment:onDraw(ctx, ...)`**</span>

        * Implements: [Component:onDraw()](../lwtk/Component.md#.onDraw)


   * <span id=".setConsiderHotkey">**`TextFragment:setConsiderHotkey(flag)`**</span>


   * <span id=".setShowHotkey">**`TextFragment:setShowHotkey(flag)`**</span>


   * <span id=".setText">**`TextFragment:setText(text)`**</span>


   * <span id=".setTextPos">**`TextFragment:setTextPos(tx, ty)`**</span>



## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

The implementation uses the following style parameters:

   * `FontFamily`
   * `TextColor`
   * `TextOffset`
   * `TextSize`

Style parameters used in super classes:

   * **[Component](../lwtk/Component.md#used-style-parameters)**: `Opacity`

## <a id="inherited-methods"></a>Inherited Methods
   * **[Component](../lwtk/Component.md)**:
      * [animateFrame()](../lwtk/Component.md#.animateFrame), [byId()](../lwtk/Component.md#.byId), [getCurrentTime()](../lwtk/Component.md#.getCurrentTime), [getFocusHandler()](../lwtk/Component.md#.getFocusHandler), [getFrame()](../lwtk/Component.md#.getFrame), [getLayoutContext()](../lwtk/Component.md#.getLayoutContext), [getParent()](../lwtk/Component.md#.getParent), [getRoot()](../lwtk/Component.md#.getRoot), [getSize()](../lwtk/Component.md#.getSize), [handleRemainingInitParams()](../lwtk/Component.md#.handleRemainingInitParams), [parentById()](../lwtk/Component.md#.parentById), [setFrame()](../lwtk/Component.md#.setFrame), [setInitParams()](../lwtk/Component.md#.setInitParams), [setTimer()](../lwtk/Component.md#.setTimer), [transformXY()](../lwtk/Component.md#.transformXY), [triggerLayout()](../lwtk/Component.md#.triggerLayout), [triggerRedraw()](../lwtk/Component.md#.triggerRedraw), [updateAnimation()](../lwtk/Component.md#.updateAnimation), [updateFrameTransition()](../lwtk/Component.md#.updateFrameTransition), [_processChanges()](../lwtk/Component.md#._processChanges), [_processDraw()](../lwtk/Component.md#._processDraw), [_setApp()](../lwtk/Component.md#._setApp), [_setFrame()](../lwtk/Component.md#._setFrame), [_setParent()](../lwtk/Component.md#._setParent)
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
