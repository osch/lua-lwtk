# Class lwtk.Application

Default application implementation.

Use this for standalone desktop applications. Use [lwtk.love.Application](../lwtk/love/Application.md) for
running within the [LÖVE](https://love2d.org/) 2D game engine.

## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Attributes](#attributes)
      * [animationTimer](#.animationTimer)
      * [appName](#.appName)
      * [driver](#.driver)
      * [postprocessNeeded](#.postprocessNeeded)
      * [scale()](#.scale) - Multiplies the arguments with the *screenScale* factor.
      * [timers](#.timers) - list of timers
      * [_animations](#._animations)
      * [_eventFunc()](#._eventFunc)
      * [_hasChanges](#._hasChanges)
      * [_processingDeferredChanges](#._processingDeferredChanges)
   * [Methods](#methods)
      * [addStyle()](#.addStyle)
      * [close()](#.close)
      * [deferChanges()](#.deferChanges)
      * [getCurrentTime()](#.getCurrentTime)
      * [getFontInfo()](#.getFontInfo)
      * [getLayoutContext()](#.getLayoutContext)
      * [getScreenScale()](#.getScreenScale) - Returns the *screenScale* factor.
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
   * [Inherited Static Members](#inherited-static-members)
   * [Subclasses](#subclasses)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / _**`Application`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`Application(arg1, arg2)`**</span>



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `errorFunc` - [setErrorFunc()](#.setErrorFunc)
   * `extensions` - [setExtensions()](#.setExtensions)
   * `style` - [setStyle()](#.setStyle)
   * `timer` - [setTimer()](#.setTimer)

## <a id="attributes"></a>Attributes
   * <span id=".animationTimer">**`animationTimer`**</span>

   * <span id=".appName">**`appName`**</span>

   * <span id=".driver">**`driver`**</span>

   * <span id=".postprocessNeeded">**`postprocessNeeded`**</span> : `table`

   * <span id=".scale">**`scale(a, a2, a3, a4)`**</span>

     Multiplies the arguments with the *screenScale* factor.
     
     Possible invocations:
     
     * *scale(x, y)*         - returns the multiplied values
     * *scale(x, y, w, h)*   - returns the multiplied values
     * *scale({x, y})*       - multiplies the values in the given table and returns table
     * *scale({x, y, w, y})* - multiplies the values in the given table and returns table
   * <span id=".timers">**`timers`**</span>

      list of timers
   * <span id="._animations">**`_animations`**</span> : [lwtk.Animations](../lwtk/Animations.md)

   * <span id="._eventFunc">**`_eventFunc(window, view, event, ...)`**</span>

   * <span id="._hasChanges">**`_hasChanges`**</span> : `boolean`

   * <span id="._processingDeferredChanges">**`_processingDeferredChanges`**</span> : `boolean`


## <a id="methods"></a>Methods
   * <span id=".addStyle">**`Application:addStyle(additionalStyle)`**</span>


   * <span id=".close">**`Application:close()`**</span>


   * <span id=".deferChanges">**`Application:deferChanges(callback)`**</span>


   * <span id=".getCurrentTime">**`Application:getCurrentTime()`**</span>


   * <span id=".getFontInfo">**`Application:getFontInfo(family, slant, weight, size)`**</span>


   * <span id=".getLayoutContext">**`Application:getLayoutContext()`**</span>


   * <span id=".getScreenScale">**`Application:getScreenScale()`**</span>

     Returns the *screenScale* factor.

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



## <a id="inherited-methods"></a>Inherited Methods
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * **[Object](../lwtk/Object.md)**:
      * [declare()](../lwtk/Object.md#.declare), [getMixinBase()](../lwtk/Object.md#.getMixinBase), [newSubClass()](../lwtk/Object.md#.newSubClass)

## <a id="subclasses"></a>Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / _**`Application`**_ / [Node](../lwtk/Node.md#subclasses) / [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[love.Application](../lwtk/love/Application.md#inheritance)**

