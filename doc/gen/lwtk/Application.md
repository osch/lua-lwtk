# Class lwtk.Application

Default application implementation.

Use this for standalone desktop applications. Use [lwtk.love.Application](../lwtk/love/Application.md) for
running within the [LÖVE](https://love2d.org/) 2D game engine.

## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Methods](#methods)
      * [addStyle()](#.addStyle)
      * [close()](#.close)
      * [deferChanges()](#.deferChanges)
      * [getCurrentTime()](#.getCurrentTime)
      * [getFontInfo()](#.getFontInfo)
      * [getLayoutContext()](#.getLayoutContext)
      * [getScreenScale()](#.getScreenScale)
      * [hasWindows()](#.hasWindows)
      * [newWindow()](#.newWindow)
      * [runEventLoop()](#.runEventLoop) - Update by processing events from the window system.
      * [setErrorFunc()](#.setErrorFunc)
      * [setExtensions()](#.setExtensions)
      * [setStyle()](#.setStyle)
      * [setTimer()](#.setTimer)
      * [update()](#.update) - Update by processing events from the window system.
      * [_addWindow()](#._addWindow)
      * [_processAllChanges()](#._processAllChanges)
      * [_removeWindow()](#._removeWindow)
   * [Inherited Methods](#inherited-methods)
   * [Subclasses](#subclasses)


## Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / _**`Application`**_

## Constructor
   * <span id=".new">**`Application(arg1, arg2)`**</span>



## Methods
   * <span id=".addStyle">**`Application:addStyle(additionalStyle)`**</span>


   * <span id=".close">**`Application:close()`**</span>


   * <span id=".deferChanges">**`Application:deferChanges(callback)`**</span>


   * <span id=".getCurrentTime">**`Application:getCurrentTime()`**</span>


   * <span id=".getFontInfo">**`Application:getFontInfo(family, slant, weight, size)`**</span>


   * <span id=".getLayoutContext">**`Application:getLayoutContext()`**</span>


   * <span id=".getScreenScale">**`Application:getScreenScale()`**</span>


   * <span id=".hasWindows">**`Application:hasWindows()`**</span>


   * <span id=".newWindow">**`Application:newWindow(attributes)`**</span>


   * <span id=".runEventLoop">**`Application:runEventLoop(timeout)`**</span>

     Update by processing events from the window system.
     
     * *timeout*  - optional float, timeout in seconds  
       
     If *timeout* is given, this function will process events from the window system until
     the time period in seconds has elapsed or until all window objects have been closed.
       
     If *timeout* is `nil` or not given, this function will process events from the window system
     until all window objects have been closed.

   * <span id=".setErrorFunc">**`Application:setErrorFunc(...)`**</span>


   * <span id=".setExtensions">**`Application:setExtensions(extensions)`**</span>


   * <span id=".setStyle">**`Application:setStyle(style)`**</span>


   * <span id=".setTimer">**`Application:setTimer(seconds, func, ...)`**</span>


   * <span id=".update">**`Application:update(timeout)`**</span>

     Update by processing events from the window system.
       
     * *timeout*  - optional float, timeout in seconds  
       
     If *timeout* is given, this function will wait for *timeout* seconds until
     events from the window system become available. If *timeout* is `nil` or not
     given, this function will block indefinitely until an event occurs.
       
     As soon as events are available, all events in the queue are processed and this function 
     returns `true`.
     
     If *timeout* is given and there are no events available after *timeout*
     seconds, this function will return `false`.

   * <span id="._addWindow">**`Application:_addWindow(win)`**</span>


   * <span id="._processAllChanges">**`Application:_processAllChanges()`**</span>


   * <span id="._removeWindow">**`Application:_removeWindow(win)`**</span>



## Inherited Methods
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)

## Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / _**`Application`**_ / [Node](../lwtk/Node.md#subclasses) / [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[love.Application](../lwtk/love/Application.md#inheritance)**

