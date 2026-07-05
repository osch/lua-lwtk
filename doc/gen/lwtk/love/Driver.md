# Class lwtk.love.Driver


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Attributes](#attributes)
      * [drawContext](#.drawContext)
      * [layoutContext](#.layoutContext)
      * [newWindows](#.newWindows)
      * [processFunc](#.processFunc)
      * [nextProcessTime](#.nextProcessTime)
      * [hasViews](#.hasViews)
   * [Methods](#methods)
      * [close()](#.close)
      * [getDrawContext()](#.getDrawContext)
      * [getLayoutContext()](#.getLayoutContext)
      * [getScreenScale()](#.getScreenScale)
      * [getTime()](#.getTime)
      * [grabFocus()](#.grabFocus)
      * [newView()](#.newView)
      * [setErrorFunc()](#.setErrorFunc)
      * [setMinSize()](#.setMinSize)
      * [setNextProcessTime()](#.setNextProcessTime)
      * [setProcessFunc()](#.setProcessFunc)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../../lwtk/Object.md#inheritance)** / _**`love.Driver`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`love.Driver(initParams)`**</span>



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `errorFunc` - [setErrorFunc()](#.setErrorFunc)
   * `minSize` - [setMinSize()](#.setMinSize)
   * `nextProcessTime` - [setNextProcessTime()](#.setNextProcessTime)
   * `processFunc` - [setProcessFunc()](#.setProcessFunc)

## <a id="attributes"></a>Attributes
   * <span id=".drawContext">**`drawContext`**</span>

   * <span id=".layoutContext">**`layoutContext`**</span>

   * <span id=".newWindows">**`newWindows`**</span> : `table`

   * <span id=".processFunc">**`processFunc`**</span>

   * <span id=".nextProcessTime">**`nextProcessTime`**</span>

   * <span id=".hasViews">**`hasViews`**</span>


## <a id="methods"></a>Methods
   * <span id=".close">**`love.Driver:close()`**</span>


   * <span id=".getDrawContext">**`love.Driver:getDrawContext()`**</span>


   * <span id=".getLayoutContext">**`love.Driver:getLayoutContext()`**</span>


   * <span id=".getScreenScale">**`love.Driver:getScreenScale()`**</span>


   * <span id=".getTime">**`love.Driver:getTime()`**</span>


   * <span id=".grabFocus">**`love.Driver:grabFocus(window)`**</span>


   * <span id=".newView">**`love.Driver:newView(window, initParams)`**</span>


   * <span id=".setErrorFunc">**`love.Driver:setErrorFunc(...)`**</span>


   * <span id=".setMinSize">**`love.Driver:setMinSize(window, minW, minH)`**</span>


   * <span id=".setNextProcessTime">**`love.Driver:setNextProcessTime(t)`**</span>


   * <span id=".setProcessFunc">**`love.Driver:setProcessFunc(f)`**</span>



## <a id="inherited-methods"></a>Inherited Methods
   * **[Object](../../lwtk/Object.md)**:
      * [getClass()](../../lwtk/Object.md#.getClass), [getClassPath()](../../lwtk/Object.md#.getClassPath), [getMember()](../../lwtk/Object.md#.getMember), [getReverseClassPath()](../../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../../lwtk/Object.md#.isInstanceOf), [setAttributes()](../../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * **[Object](../../lwtk/Object.md)**:
      * [declare()](../../lwtk/Object.md#.declare), [getMixinBase()](../../lwtk/Object.md#.getMixinBase), [newSubClass()](../../lwtk/Object.md#.newSubClass)
