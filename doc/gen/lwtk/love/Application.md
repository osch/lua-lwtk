# Class lwtk.love.Application

Application implementation for the [LÖVE](https://love2d.org/) 2D game engine.

Use [lwtk.Application](../../lwtk/Application.md) for runing standalone desktop applications.

## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Attributes](#attributes)
      * [modKeyToBit](#.modKeyToBit)
      * [mouseEntered](#.mouseEntered)
      * [focusWindow](#.focusWindow)
      * [_implicitWindowFocus](#._implicitWindowFocus)
      * [_keyModState](#._keyModState)
      * [_handledKey](#._handledKey)
   * [Methods](#methods)
      * [draw()](#.draw)
      * [focus()](#.focus)
      * [keypressed()](#.keypressed)
      * [keyreleased()](#.keyreleased)
      * [mousefocus()](#.mousefocus)
      * [mousemoved()](#.mousemoved)
      * [mousepressed()](#.mousepressed)
      * [mousereleased()](#.mousereleased)
      * [setFocusWindow()](#.setFocusWindow)
      * [textinput()](#.textinput)
      * [update()](#.update)
   * [Used Style Parameters](#used-style-parameters)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../../lwtk/Object.md#inheritance)** / **[Application](../../lwtk/Application.md#inheritance)** / [Node](../../lwtk/Node.md#inheritance) / [MouseDispatcher](../../lwtk/MouseDispatcher.md#inheritance) / _**`love.Application`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`love.Application(initParams)`**</span>

        * Overrides: [MouseDispatcher()](../../lwtk/MouseDispatcher.md#constructor)
             * Overrides: **[Application()](../../lwtk/Application.md#constructor)**



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `errorFunc` - **[Application:setErrorFunc()](../../lwtk/Application.md#.setErrorFunc)**
   * `extensions` - **[Application:setExtensions()](../../lwtk/Application.md#.setExtensions)**
   * `focusWindow` - [setFocusWindow()](#.setFocusWindow)
   * `style` - **[Application:setStyle()](../../lwtk/Application.md#.setStyle)**
   * `timer` - **[Application:setTimer()](../../lwtk/Application.md#.setTimer)**

## <a id="attributes"></a>Attributes
   * <span id=".modKeyToBit">**`modKeyToBit`**</span> : `table`

   * <span id=".mouseEntered">**`mouseEntered`**</span> : `boolean`

   * <span id=".focusWindow">**`focusWindow`**</span>

   * <span id="._implicitWindowFocus">**`_implicitWindowFocus`**</span> : `boolean`

   * <span id="._keyModState">**`_keyModState`**</span> : `number`

   * <span id="._handledKey">**`_handledKey`**</span>


## <a id="methods"></a>Methods
   * <span id=".draw">**`love.Application:draw()`**</span>


   * <span id=".focus">**`love.Application:focus(focus)`**</span>


   * <span id=".keypressed">**`love.Application:keypressed(key)`**</span>


   * <span id=".keyreleased">**`love.Application:keyreleased(key)`**</span>


   * <span id=".mousefocus">**`love.Application:mousefocus(focus)`**</span>


   * <span id=".mousemoved">**`love.Application:mousemoved(x, y)`**</span>


   * <span id=".mousepressed">**`love.Application:mousepressed(x, y, button)`**</span>


   * <span id=".mousereleased">**`love.Application:mousereleased(x, y, button)`**</span>


   * <span id=".setFocusWindow">**`love.Application:setFocusWindow(window)`**</span>


   * <span id=".textinput">**`love.Application:textinput(text)`**</span>


   * <span id=".update">**`love.Application:update()`**</span>

        * Overrides: [Application:update()](../../lwtk/Application.md#.update)



## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../../lwtk/Style.md), [lwtk.DefaultStyle](../../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../../styleparams.md) lists all style parameters.

The implementation uses the following style parameters:

   * `Opacity`

## <a id="inherited-methods"></a>Inherited Methods
   * [MouseDispatcher](../../lwtk/MouseDispatcher.md):
      * [removeChild()](../../lwtk/MouseDispatcher.md#.removeChild), [_processMouseDown()](../../lwtk/MouseDispatcher.md#._processMouseDown), [_processMouseEnter()](../../lwtk/MouseDispatcher.md#._processMouseEnter), [_processMouseLeave()](../../lwtk/MouseDispatcher.md#._processMouseLeave), [_processMouseMove()](../../lwtk/MouseDispatcher.md#._processMouseMove), [_processMouseScroll()](../../lwtk/MouseDispatcher.md#._processMouseScroll), [_processMouseUp()](../../lwtk/MouseDispatcher.md#._processMouseUp)
   * [Node](../../lwtk/Node.md):
      * [discard()](../../lwtk/Node.md#.discard)
   * **[Application](../../lwtk/Application.md)**:
      * [addStyle()](../../lwtk/Application.md#.addStyle), [close()](../../lwtk/Application.md#.close), [deferChanges()](../../lwtk/Application.md#.deferChanges), [getCurrentTime()](../../lwtk/Application.md#.getCurrentTime), [getFontInfo()](../../lwtk/Application.md#.getFontInfo), [getLayoutContext()](../../lwtk/Application.md#.getLayoutContext), [getScreenScale()](../../lwtk/Application.md#.getScreenScale), [hasWindows()](../../lwtk/Application.md#.hasWindows), [newWindow()](../../lwtk/Application.md#.newWindow), [runEventLoop()](../../lwtk/Application.md#.runEventLoop), [setErrorFunc()](../../lwtk/Application.md#.setErrorFunc), [setExtensions()](../../lwtk/Application.md#.setExtensions), [setStyle()](../../lwtk/Application.md#.setStyle), [setTimer()](../../lwtk/Application.md#.setTimer), [_addWindow()](../../lwtk/Application.md#._addWindow), [_processAllChanges()](../../lwtk/Application.md#._processAllChanges), [_removeWindow()](../../lwtk/Application.md#._removeWindow)
   * **[Object](../../lwtk/Object.md)**:
      * [getClass()](../../lwtk/Object.md#.getClass), [getClassPath()](../../lwtk/Object.md#.getClassPath), [getMember()](../../lwtk/Object.md#.getMember), [getReverseClassPath()](../../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../../lwtk/Object.md#.isInstanceOf), [setAttributes()](../../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * **[Object](../../lwtk/Object.md)**:
      * [declare()](../../lwtk/Object.md#.declare), [getMixinBase()](../../lwtk/Object.md#.getMixinBase), [newSubClass()](../../lwtk/Object.md#.newSubClass)
