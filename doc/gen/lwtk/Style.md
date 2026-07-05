# Class lwtk.Style


See also the [Style Parameter Index](../styleparams.md) for all style
parameters with their default rules and using classes.

## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Attributes](#attributes)
      * [typeList](#.typeList)
      * [myScaleFactor](#.myScaleFactor)
      * [ruleList](#.ruleList)
      * [cache](#.cache)
      * [animatable](#.animatable)
      * [scalable](#.scalable)
      * [scaleFactor](#.scaleFactor)
      * [localParams](#.localParams)
      * [parent](#.parent)
   * [Methods](#methods)
      * [addRules()](#.addRules)
      * [clearCache()](#.clearCache)
      * [getScaleFactor()](#.getScaleFactor)
      * [getStyleParam()](#.getStyleParam)
      * [isAnimatable()](#.isAnimatable)
      * [isScalable()](#.isScalable)
      * [setRules()](#.setRules)
      * [setScaleFactor()](#.setScaleFactor)
      * [_getStyleParam()](#._getStyleParam)
      * [_getStyleParam2()](#._getStyleParam2)
      * [_replaceParentStyle()](#._replaceParentStyle)
      * [_setParentStyle()](#._setParentStyle)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)
   * [Subclasses](#subclasses)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / _**`Style`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`Style(ruleList)`**</span>



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `rules` - [setRules()](#.setRules)
   * `scaleFactor` - [setScaleFactor()](#.setScaleFactor)

## <a id="attributes"></a>Attributes
   * <span id=".typeList">**`typeList`**</span>

   * <span id=".myScaleFactor">**`myScaleFactor`**</span>

   * <span id=".ruleList">**`ruleList`**</span>

   * <span id=".cache">**`cache`**</span> : `table`

   * <span id=".animatable">**`animatable`**</span> : `table`

   * <span id=".scalable">**`scalable`**</span> : `table`

   * <span id=".scaleFactor">**`scaleFactor`**</span>

   * <span id=".localParams">**`localParams`**</span>

   * <span id=".parent">**`parent`**</span>


## <a id="methods"></a>Methods
   * <span id=".addRules">**`Style:addRules(rules)`**</span>


   * <span id=".clearCache">**`Style:clearCache()`**</span>


   * <span id=".getScaleFactor">**`Style:getScaleFactor()`**</span>


   * <span id=".getStyleParam">**`Style:getStyleParam(widget, parName)`**</span>


   * <span id=".isAnimatable">**`Style:isAnimatable(parName)`**</span>


   * <span id=".isScalable">**`Style:isScalable(parName)`**</span>


   * <span id=".setRules">**`Style:setRules(rules)`**</span>


   * <span id=".setScaleFactor">**`Style:setScaleFactor(scaleFactor)`**</span>


   * <span id="._getStyleParam">**`Style:_getStyleParam(parName, classSelectorPath, stateSelectorPath, considerLocal, extraParentStyle)`**</span>


   * <span id="._getStyleParam2">**`Style:_getStyleParam2(parName, classSelectorPath, stateSelectorPath, ctxRules)`**</span>


   * <span id="._replaceParentStyle">**`Style:_replaceParentStyle(parentStyle)`**</span>


   * <span id="._setParentStyle">**`Style:_setParentStyle(parentStyle)`**</span>



## <a id="inherited-methods"></a>Inherited Methods
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * **[Object](../lwtk/Object.md)**:
      * [declare()](../lwtk/Object.md#.declare), [getMixinBase()](../lwtk/Object.md#.getMixinBase), [newSubClass()](../lwtk/Object.md#.newSubClass)

## <a id="subclasses"></a>Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / _**`Style`**_ / **[DefaultStyle](../lwtk/DefaultStyle.md#inheritance)**

