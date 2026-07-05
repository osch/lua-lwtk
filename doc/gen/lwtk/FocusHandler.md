# Class lwtk.FocusHandler


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Attributes](#attributes)
      * [baseWidget](#.baseWidget)
      * [defaultPostponed](#.defaultPostponed)
      * [_hasFocus](#._hasFocus)
   * [Methods](#methods)
      * [childById()](#.childById)
      * [deregisterHotkeys()](#.deregisterHotkeys)
      * [findNextInput()](#.findNextInput)
      * [findPrevInput()](#.findPrevInput)
      * [handleHotkey()](#.handleHotkey)
      * [hasActionMethod()](#.hasActionMethod)
      * [invokeActionMethod()](#.invokeActionMethod)
      * [isDefault()](#.isDefault)
      * [onActionCloseWindow()](#.onActionCloseWindow)
      * [onActionDefaultButton()](#.onActionDefaultButton)
      * [onActionFocusDown()](#.onActionFocusDown)
      * [onActionFocusLeft()](#.onActionFocusLeft)
      * [onActionFocusNext()](#.onActionFocusNext)
      * [onActionFocusPrev()](#.onActionFocusPrev)
      * [onActionFocusRight()](#.onActionFocusRight)
      * [onActionFocusUp()](#.onActionFocusUp)
      * [onKeyDown()](#.onKeyDown)
      * [registerHotkeys()](#.registerHotkeys)
      * [releaseFocus()](#.releaseFocus)
      * [setDefault()](#.setDefault)
      * [setFocusDisabled()](#.setFocusDisabled)
      * [setFocusTo()](#.setFocusTo)
      * [setFocusToNextInput()](#.setFocusToNextInput)
      * [setFocusToPrevInput()](#.setFocusToPrevInput)
      * [_addFocusableChild()](#._addFocusableChild)
      * [_handleFocusIn()](#._handleFocusIn)
      * [_handleFocusOut()](#._handleFocusOut)
      * [_removeFocusableChildren()](#._removeFocusableChildren)
      * [_setParentFocusHandler()](#._setParentFocusHandler)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / _**`FocusHandler`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`FocusHandler(baseWidget)`**</span>

        * Overrides: [Actionable()](../lwtk/Actionable.md#constructor)



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `default` - [setDefault()](#.setDefault)
   * `focusDisabled` - [setFocusDisabled()](#.setFocusDisabled)
   * `focusTo` - [setFocusTo()](#.setFocusTo)
   * `focusToNextInput` - [setFocusToNextInput()](#.setFocusToNextInput)
   * `focusToPrevInput` - [setFocusToPrevInput()](#.setFocusToPrevInput)

Additionally parameters matching `onAction<ActionName>` register action methods, see [lwtk.Actionable](../lwtk/Actionable.md) for details.

## <a id="attributes"></a>Attributes
   * <span id=".baseWidget">**`baseWidget`**</span>

   * <span id=".defaultPostponed">**`defaultPostponed`**</span> : `boolean`

   * <span id="._hasFocus">**`_hasFocus`**</span> : `boolean`


## <a id="methods"></a>Methods
   * <span id=".childById">**`FocusHandler:childById(id)`**</span>


   * <span id=".deregisterHotkeys">**`FocusHandler:deregisterHotkeys(widget, hotkeys)`**</span>


   * <span id=".findNextInput">**`FocusHandler:findNextInput(child)`**</span>


   * <span id=".findPrevInput">**`FocusHandler:findPrevInput(child)`**</span>


   * <span id=".handleHotkey">**`FocusHandler:handleHotkey(key, modifier, ...)`**</span>


   * <span id=".hasActionMethod">**`FocusHandler:hasActionMethod(actionMethodName)`**</span>

        * Overrides: [Actionable:hasActionMethod()](../lwtk/Actionable.md#.hasActionMethod)


   * <span id=".invokeActionMethod">**`FocusHandler:invokeActionMethod(actionMethodName)`**</span>

        * Overrides: [Actionable:invokeActionMethod()](../lwtk/Actionable.md#.invokeActionMethod)


   * <span id=".isDefault">**`FocusHandler:isDefault(childOrId)`**</span>


   * <span id=".onActionCloseWindow">**`FocusHandler:onActionCloseWindow()`**</span>


   * <span id=".onActionDefaultButton">**`FocusHandler:onActionDefaultButton()`**</span>


   * <span id=".onActionFocusDown">**`FocusHandler:onActionFocusDown()`**</span>


   * <span id=".onActionFocusLeft">**`FocusHandler:onActionFocusLeft()`**</span>


   * <span id=".onActionFocusNext">**`FocusHandler:onActionFocusNext()`**</span>


   * <span id=".onActionFocusPrev">**`FocusHandler:onActionFocusPrev()`**</span>


   * <span id=".onActionFocusRight">**`FocusHandler:onActionFocusRight()`**</span>


   * <span id=".onActionFocusUp">**`FocusHandler:onActionFocusUp()`**</span>


   * <span id=".onKeyDown">**`FocusHandler:onKeyDown(key, modifier, keyText, hotKeyName)`**</span>


   * <span id=".registerHotkeys">**`FocusHandler:registerHotkeys(widget, hotkeys)`**</span>


   * <span id=".releaseFocus">**`FocusHandler:releaseFocus(child)`**</span>


   * <span id=".setDefault">**`FocusHandler:setDefault(childOrId, defaultFlag)`**</span>


   * <span id=".setFocusDisabled">**`FocusHandler:setFocusDisabled(child, disableFlag)`**</span>


   * <span id=".setFocusTo">**`FocusHandler:setFocusTo(newFocusChild)`**</span>


   * <span id=".setFocusToNextInput">**`FocusHandler:setFocusToNextInput(child)`**</span>


   * <span id=".setFocusToPrevInput">**`FocusHandler:setFocusToPrevInput(child)`**</span>


   * <span id="._addFocusableChild">**`FocusHandler:_addFocusableChild(child)`**</span>


   * <span id="._handleFocusIn">**`FocusHandler:_handleFocusIn()`**</span>


   * <span id="._handleFocusOut">**`FocusHandler:_handleFocusOut()`**</span>


   * <span id="._removeFocusableChildren">**`FocusHandler:_removeFocusableChildren(child)`**</span>


   * <span id="._setParentFocusHandler">**`FocusHandler:_setParentFocusHandler(parentFocusHandler)`**</span>



## <a id="inherited-methods"></a>Inherited Methods
   * [Actionable](../lwtk/Actionable.md):
      * [handleRemainingInitParams()](../lwtk/Actionable.md#.handleRemainingInitParams), [setInitParams()](../lwtk/Actionable.md#.setInitParams)
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * **[Object](../lwtk/Object.md)**:
      * [declare()](../lwtk/Object.md#.declare), [getMixinBase()](../lwtk/Object.md#.getMixinBase), [newSubClass()](../lwtk/Object.md#.newSubClass)
