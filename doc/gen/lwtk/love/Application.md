# Class lwtk.love.Application

Application implementation for the [LÖVE](https://love2d.org/) 2D game engine.

Use [lwtk.Application](../../lwtk/Application.md) for runing standalone desktop applications.

## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
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
   * [Inherited Methods](#inherited-methods)


## Inheritance
   *  / **[Object](../../lwtk/Object.md#inheritance)** / **[Application](../../lwtk/Application.md#inheritance)** / [Node](../../lwtk/Node.md#inheritance) / [MouseDispatcher](../../lwtk/MouseDispatcher.md#inheritance) / _**`love.Application`**_

## Constructor
   * <span id=".new">**`love.Application(initParams)`**</span>

        * Overrides: [MouseDispatcher()](../../lwtk/MouseDispatcher.md#constructor)
             * Overrides: **[Application()](../../lwtk/Application.md#constructor)**



## Methods
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



## Inherited Methods
   * [MouseDispatcher](../../lwtk/MouseDispatcher.md):
      * [removeChild()](../../lwtk/MouseDispatcher.md#.removeChild), [_processMouseDown()](../../lwtk/MouseDispatcher.md#._processMouseDown), [_processMouseEnter()](../../lwtk/MouseDispatcher.md#._processMouseEnter), [_processMouseLeave()](../../lwtk/MouseDispatcher.md#._processMouseLeave), [_processMouseMove()](../../lwtk/MouseDispatcher.md#._processMouseMove), [_processMouseScroll()](../../lwtk/MouseDispatcher.md#._processMouseScroll), [_processMouseUp()](../../lwtk/MouseDispatcher.md#._processMouseUp)
   * [Node](../../lwtk/Node.md):
      * [discard()](../../lwtk/Node.md#.discard)
   * **[Application](../../lwtk/Application.md)**:
      * [addStyle()](../../lwtk/Application.md#.addStyle), [close()](../../lwtk/Application.md#.close), [deferChanges()](../../lwtk/Application.md#.deferChanges), [getCurrentTime()](../../lwtk/Application.md#.getCurrentTime), [getFontInfo()](../../lwtk/Application.md#.getFontInfo), [getLayoutContext()](../../lwtk/Application.md#.getLayoutContext), [getScreenScale()](../../lwtk/Application.md#.getScreenScale), [hasWindows()](../../lwtk/Application.md#.hasWindows), [newWindow()](../../lwtk/Application.md#.newWindow), [runEventLoop()](../../lwtk/Application.md#.runEventLoop), [setErrorFunc()](../../lwtk/Application.md#.setErrorFunc), [setExtensions()](../../lwtk/Application.md#.setExtensions), [setStyle()](../../lwtk/Application.md#.setStyle), [setTimer()](../../lwtk/Application.md#.setTimer), [_addWindow()](../../lwtk/Application.md#._addWindow), [_processAllChanges()](../../lwtk/Application.md#._processAllChanges), [_removeWindow()](../../lwtk/Application.md#._removeWindow)
   * **[Object](../../lwtk/Object.md)**:
      * [getClass()](../../lwtk/Object.md#.getClass), [getClassPath()](../../lwtk/Object.md#.getClassPath), [getMember()](../../lwtk/Object.md#.getMember), [getReverseClassPath()](../../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../../lwtk/Object.md#.isInstanceOf), [setAttributes()](../../lwtk/Object.md#.setAttributes)
