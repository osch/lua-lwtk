# Class lwtk.Window


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Attributes](#attributes)
      * [color](#.color)
      * [damagedArea](#.damagedArea)
      * [driver](#.driver)
      * [exposedArea](#.exposedArea)
      * [fullRedisplayOutstanding](#.fullRedisplayOutstanding)
      * [hasFocus](#.hasFocus)
      * [initParams](#.initParams)
      * [mapped](#.mapped)
      * [maxH](#.maxH)
      * [maxSizeFixed](#.maxSizeFixed)
      * [maxW](#.maxW)
      * [mouseEntered](#.mouseEntered)
      * [view](#.view)
      * [interceptMouseDown](#.interceptMouseDown)
      * [_hasChanges](#._hasChanges)
      * [_needsRelayout](#._needsRelayout)
      * [_positionsChanged](#._positionsChanged)
      * [_handleChildRequestsFocus](#._handleChildRequestsFocus)
      * [_grabFocus](#._grabFocus)
   * [Event Callbacks](#event-callbacks)
      * [onClose()](#.onClose)
      * [onSizeRequest()](#.onSizeRequest)
      * [onMinSizeChanged()](#.onMinSizeChanged)
   * [Methods](#methods)
      * [addChild()](#.addChild)
      * [byId()](#.byId)
      * [childById()](#.childById)
      * [close()](#.close)
      * [getCurrentTime()](#.getCurrentTime)
      * [getFontInfo()](#.getFontInfo)
      * [getLayoutContext()](#.getLayoutContext)
      * [getNativeHandle()](#.getNativeHandle)
      * [getRoot()](#.getRoot)
      * [getSize()](#.getSize)
      * [hide()](#.hide)
      * [isClosed()](#.isClosed)
      * [requestClose()](#.requestClose)
      * [requestFocus()](#.requestFocus)
      * [setColor()](#.setColor)
      * [setFrame()](#.setFrame)
      * [setInterceptKeyDown()](#.setInterceptKeyDown)
      * [setInterceptMouseDown()](#.setInterceptMouseDown)
      * [setMaxSize()](#.setMaxSize)
      * [setMaxSizeFixed()](#.setMaxSizeFixed)
      * [setMinSize()](#.setMinSize)
      * [setOnClose()](#.setOnClose)
      * [setOnSizeRequest()](#.setOnSizeRequest)
      * [setSize()](#.setSize)
      * [setTimer()](#.setTimer)
      * [setTitle()](#.setTitle)
      * [show()](#.show)
      * [triggerLayout()](#.triggerLayout)
      * [triggerRedraw()](#.triggerRedraw)
      * [_clearChildLookup()](#._clearChildLookup)
      * [_handleConfigure()](#._handleConfigure)
      * [_handleExpose()](#._handleExpose)
      * [_handleFocusIn()](#._handleFocusIn)
      * [_handleFocusOut()](#._handleFocusOut)
      * [_handleMap()](#._handleMap)
      * [_handleMouseDown()](#._handleMouseDown)
      * [_handleMouseEnter()](#._handleMouseEnter)
      * [_handleMouseLeave()](#._handleMouseLeave)
      * [_handleMouseMove()](#._handleMouseMove)
      * [_handleMouseScroll()](#._handleMouseScroll)
      * [_handleMouseUp()](#._handleMouseUp)
      * [_postProcessChanges()](#._postProcessChanges)
      * [_processChanges()](#._processChanges)
   * [Used Style Parameters](#used-style-parameters)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / [Drawable](../lwtk/Drawable.md#inheritance) / [Styleable](../lwtk/Styleable.md#inheritance) / [KeyHandler](../lwtk/KeyHandler.md#inheritance) / [MouseDispatcher](../lwtk/MouseDispatcher.md#inheritance) / _**`Window`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`Window(app, initParams)`**</span>

        * Overrides: [MouseDispatcher()](../lwtk/MouseDispatcher.md#constructor)
             * Overrides: [KeyHandler()](../lwtk/KeyHandler.md#constructor)
                  * Overrides: [Styleable()](../lwtk/Styleable.md#constructor)
                       * Overrides: [Actionable()](../lwtk/Actionable.md#constructor)



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `color` - [setColor()](#.setColor)
   * `frame` - [setFrame()](#.setFrame)
   * `interceptKeyDown` - [setInterceptKeyDown()](#.setInterceptKeyDown)
   * `interceptMouseDown` - [setInterceptMouseDown()](#.setInterceptMouseDown)
   * `maxSize` - [setMaxSize()](#.setMaxSize)
   * `maxSizeFixed` - [setMaxSizeFixed()](#.setMaxSizeFixed)
   * `minSize` - [setMinSize()](#.setMinSize)
   * `onClose` - [setOnClose()](#.setOnClose)
   * `onSizeRequest` - [setOnSizeRequest()](#.setOnSizeRequest)
   * `size` - [setSize()](#.setSize)
   * `state` - [Styleable:setState()](../lwtk/Styleable.md#.setState)
   * `style` - [Styleable:setStyle()](../lwtk/Styleable.md#.setStyle)
   * `timer` - [setTimer()](#.setTimer)
   * `title` - [setTitle()](#.setTitle)

Additionally parameters matching `onAction<ActionName>` register action methods, see [lwtk.Actionable](../lwtk/Actionable.md) for details.

## <a id="attributes"></a>Attributes
   * <span id=".color">**`color`**</span> : `boolean`

   * <span id=".damagedArea">**`damagedArea`**</span> : [lwtk.Area](../lwtk/Area.md)

   * <span id=".driver">**`driver`**</span>

   * <span id=".exposedArea">**`exposedArea`**</span> : [lwtk.Area](../lwtk/Area.md)

   * <span id=".fullRedisplayOutstanding">**`fullRedisplayOutstanding`**</span> : `boolean`

   * <span id=".hasFocus">**`hasFocus`**</span> : `boolean`

   * <span id=".initParams">**`initParams`**</span> : `table`

   * <span id=".mapped">**`mapped`**</span> : `boolean`

   * <span id=".maxH">**`maxH`**</span>

   * <span id=".maxSizeFixed">**`maxSizeFixed`**</span> : `boolean`

   * <span id=".maxW">**`maxW`**</span>

   * <span id=".mouseEntered">**`mouseEntered`**</span> : `boolean`

   * <span id=".view">**`view`**</span>

   * <span id=".interceptMouseDown">**`interceptMouseDown`**</span>

   * <span id="._hasChanges">**`_hasChanges`**</span> : `boolean`

   * <span id="._needsRelayout">**`_needsRelayout`**</span>

   * <span id="._positionsChanged">**`_positionsChanged`**</span>

   * <span id="._handleChildRequestsFocus">**`_handleChildRequestsFocus`**</span>

   * <span id="._grabFocus">**`_grabFocus`**</span> : `boolean`


## <a id="event-callbacks"></a>Event Callbacks
   * <span id=".onClose">**`onClose`**</span>

   * <span id=".onSizeRequest">**`onSizeRequest`**</span>

   * <span id=".onMinSizeChanged">**`onMinSizeChanged`**</span>


## <a id="methods"></a>Methods
   * <span id=".addChild">**`Window:addChild(child)`**</span>

        * Implements: [Node:addChild()](../lwtk/Node.md#.addChild)


   * <span id=".byId">**`Window:byId(id)`**</span>


   * <span id=".childById">**`Window:childById(id)`**</span>

        * Implementation: [Group:childById()](../lwtk/Group.md#.childById)

   * <span id=".close">**`Window:close()`**</span>


   * <span id=".getCurrentTime">**`Window:getCurrentTime()`**</span>


   * <span id=".getFontInfo">**`Window:getFontInfo(family, slant, weight, size)`**</span>


   * <span id=".getLayoutContext">**`Window:getLayoutContext()`**</span>


   * <span id=".getNativeHandle">**`Window:getNativeHandle()`**</span>


   * <span id=".getRoot">**`Window:getRoot()`**</span>

        * Implementation: [Component:getRoot()](../lwtk/Component.md#.getRoot)

   * <span id=".getSize">**`Window:getSize()`**</span>


   * <span id=".hide">**`Window:hide()`**</span>


   * <span id=".isClosed">**`Window:isClosed()`**</span>


   * <span id=".requestClose">**`Window:requestClose()`**</span>


   * <span id=".requestFocus">**`Window:requestFocus()`**</span>


   * <span id=".setColor">**`Window:setColor(color)`**</span>


   * <span id=".setFrame">**`Window:setFrame(x, y, w, h)`**</span>


   * <span id=".setInterceptKeyDown">**`Window:setInterceptKeyDown(interceptKeyDown)`**</span>


   * <span id=".setInterceptMouseDown">**`Window:setInterceptMouseDown(interceptMouseDown)`**</span>


   * <span id=".setMaxSize">**`Window:setMaxSize(w, h)`**</span>


   * <span id=".setMaxSizeFixed">**`Window:setMaxSizeFixed(flag)`**</span>


   * <span id=".setMinSize">**`Window:setMinSize(w, h)`**</span>


   * <span id=".setOnClose">**`Window:setOnClose(onClose)`**</span>


   * <span id=".setOnSizeRequest">**`Window:setOnSizeRequest(onSizeRequest)`**</span>


   * <span id=".setSize">**`Window:setSize(w, h)`**</span>


   * <span id=".setTimer">**`Window:setTimer(seconds, func, ...)`**</span>


   * <span id=".setTitle">**`Window:setTitle(title)`**</span>


   * <span id=".show">**`Window:show()`**</span>


   * <span id=".triggerLayout">**`Window:triggerLayout()`**</span>

        * Implementation: [Component:triggerLayout()](../lwtk/Component.md#.triggerLayout)

   * <span id=".triggerRedraw">**`Window:triggerRedraw()`**</span>

        * Implementation: [Component:triggerRedraw()](../lwtk/Component.md#.triggerRedraw)

   * <span id="._clearChildLookup">**`Window:_clearChildLookup()`**</span>


   * <span id="._handleConfigure">**`Window:_handleConfigure(x, y, w, h)`**</span>


   * <span id="._handleExpose">**`Window:_handleExpose(x, y, w, h, count)`**</span>


   * <span id="._handleFocusIn">**`Window:_handleFocusIn()`**</span>


   * <span id="._handleFocusOut">**`Window:_handleFocusOut()`**</span>


   * <span id="._handleMap">**`Window:_handleMap()`**</span>


   * <span id="._handleMouseDown">**`Window:_handleMouseDown(mx, my, button, modState)`**</span>


   * <span id="._handleMouseEnter">**`Window:_handleMouseEnter(mx, my)`**</span>


   * <span id="._handleMouseLeave">**`Window:_handleMouseLeave(mx, my)`**</span>


   * <span id="._handleMouseMove">**`Window:_handleMouseMove(mx, my)`**</span>


   * <span id="._handleMouseScroll">**`Window:_handleMouseScroll(dx, dy)`**</span>


   * <span id="._handleMouseUp">**`Window:_handleMouseUp(mx, my, button, modState)`**</span>


   * <span id="._postProcessChanges">**`Window:_postProcessChanges()`**</span>


   * <span id="._processChanges">**`Window:_processChanges()`**</span>



## <a id="used-style-parameters"></a>Used Style Parameters

See also [lwtk.Style](../lwtk/Style.md), [lwtk.DefaultStyle](../lwtk/DefaultStyle.md) and [lwtk.BuiltinStyleTypes](../lwtk/BuiltinStyleTypes.md) for more information about style parameters.
The [Style Parameter Index](../styleparams.md) lists all style parameters.

The implementation uses the following style parameters:

   * `BackgroundColor`
   * `maxSizeFixed`

## <a id="inherited-methods"></a>Inherited Methods
   * [MouseDispatcher](../lwtk/MouseDispatcher.md):
      * [removeChild()](../lwtk/MouseDispatcher.md#.removeChild), [_processMouseDown()](../lwtk/MouseDispatcher.md#._processMouseDown), [_processMouseEnter()](../lwtk/MouseDispatcher.md#._processMouseEnter), [_processMouseLeave()](../lwtk/MouseDispatcher.md#._processMouseLeave), [_processMouseMove()](../lwtk/MouseDispatcher.md#._processMouseMove), [_processMouseScroll()](../lwtk/MouseDispatcher.md#._processMouseScroll), [_processMouseUp()](../lwtk/MouseDispatcher.md#._processMouseUp)
   * [KeyHandler](../lwtk/KeyHandler.md):
      * [resetKeyHandling()](../lwtk/KeyHandler.md#.resetKeyHandling), [_handleKeyDown()](../lwtk/KeyHandler.md#._handleKeyDown), [_handleKeyUp()](../lwtk/KeyHandler.md#._handleKeyUp)
   * [Styleable](../lwtk/Styleable.md):
      * [clearStyleCache()](../lwtk/Styleable.md#.clearStyleCache), [getStateString()](../lwtk/Styleable.md#.getStateString), [getStyle()](../lwtk/Styleable.md#.getStyle), [getStyleParam()](../lwtk/Styleable.md#.getStyleParam), [setState()](../lwtk/Styleable.md#.setState), [setStyle()](../lwtk/Styleable.md#.setStyle), [_getStyleParam()](../lwtk/Styleable.md#._getStyleParam), [_setStyleFromParent()](../lwtk/Styleable.md#._setStyleFromParent)
   * [Drawable](../lwtk/Drawable.md):
      * [getMandatoryStyleParam()](../lwtk/Drawable.md#.getMandatoryStyleParam)
   * [Node](../lwtk/Node.md):
      * [discard()](../lwtk/Node.md#.discard)
   * [Actionable](../lwtk/Actionable.md):
      * [handleRemainingInitParams()](../lwtk/Actionable.md#.handleRemainingInitParams), [hasActionMethod()](../lwtk/Actionable.md#.hasActionMethod), [invokeActionMethod()](../lwtk/Actionable.md#.invokeActionMethod), [setInitParams()](../lwtk/Actionable.md#.setInitParams)
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * [Styleable](../lwtk/Styleable.md):
      * [newSubClass()](../lwtk/Styleable.md#.newSubClass)
   * **[Object](../lwtk/Object.md)**:
      * [declare()](../lwtk/Object.md#.declare), [getMixinBase()](../lwtk/Object.md#.getMixinBase)
