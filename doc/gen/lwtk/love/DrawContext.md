# Class lwtk.love.DrawContext


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Attributes](#attributes)
      * [opacityStack](#.opacityStack)
      * [scissorStack](#.scissorStack)
   * [Methods](#methods)
      * [beginOpacity()](#.beginOpacity)
      * [drawBorder()](#.drawBorder)
      * [drawLine()](#.drawLine)
      * [drawText()](#.drawText)
      * [endOpacity()](#.endOpacity)
      * [fillRect()](#.fillRect)
      * [intersectClip()](#.intersectClip)
      * [restore()](#.restore)
      * [save()](#.save)
      * [setColor()](#.setColor)
      * [setLineWidth()](#.setLineWidth)
      * [translate()](#.translate)
      * [_reset()](#._reset)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../../lwtk/Object.md#inheritance)** / **[love.LayoutContext](../../lwtk/love/LayoutContext.md#inheritance)** / _**`love.DrawContext`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`love.DrawContext(...)`**</span>

        * Overrides: **[love.LayoutContext()](../../lwtk/love/LayoutContext.md#constructor)**



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `color` - [setColor()](#.setColor)
   * `lineWidth` - [setLineWidth()](#.setLineWidth)

## <a id="attributes"></a>Attributes
   * <span id=".opacityStack">**`opacityStack`**</span> : `table`

   * <span id=".scissorStack">**`scissorStack`**</span> : `table`


## <a id="methods"></a>Methods
   * <span id=".beginOpacity">**`love.DrawContext:beginOpacity(opacity)`**</span>


   * <span id=".drawBorder">**`love.DrawContext:drawBorder(color, borderThickness, x, y, w, h)`**</span>


   * <span id=".drawLine">**`love.DrawContext:drawLine(x1, y1, x2, y2, ...)`**</span>


   * <span id=".drawText">**`love.DrawContext:drawText(x, y, text)`**</span>


   * <span id=".endOpacity">**`love.DrawContext:endOpacity()`**</span>


   * <span id=".fillRect">**`love.DrawContext:fillRect(color, x, y, w, h)`**</span>


   * <span id=".intersectClip">**`love.DrawContext:intersectClip(x, y, w, h)`**</span>


   * <span id=".restore">**`love.DrawContext:restore()`**</span>


   * <span id=".save">**`love.DrawContext:save()`**</span>


   * <span id=".setColor">**`love.DrawContext:setColor(r, g, b, a)`**</span>


   * <span id=".setLineWidth">**`love.DrawContext:setLineWidth(w)`**</span>


   * <span id=".translate">**`love.DrawContext:translate(x, y)`**</span>


   * <span id="._reset">**`love.DrawContext:_reset()`**</span>

        * Overrides: [love.LayoutContext:_reset()](../../lwtk/love/LayoutContext.md#._reset)



## <a id="inherited-methods"></a>Inherited Methods
   * **[love.LayoutContext](../../lwtk/love/LayoutContext.md)**:
      * [getFontHeightMeasures()](../../lwtk/love/LayoutContext.md#.getFontHeightMeasures), [getTextMeasures()](../../lwtk/love/LayoutContext.md#.getTextMeasures), [getTextWidth()](../../lwtk/love/LayoutContext.md#.getTextWidth), [selectFont()](../../lwtk/love/LayoutContext.md#.selectFont)
   * **[Object](../../lwtk/Object.md)**:
      * [getClass()](../../lwtk/Object.md#.getClass), [getClassPath()](../../lwtk/Object.md#.getClassPath), [getMember()](../../lwtk/Object.md#.getMember), [getReverseClassPath()](../../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../../lwtk/Object.md#.isInstanceOf), [setAttributes()](../../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * **[Object](../../lwtk/Object.md)**:
      * [declare()](../../lwtk/Object.md#.declare), [getMixinBase()](../../lwtk/Object.md#.getMixinBase), [newSubClass()](../../lwtk/Object.md#.newSubClass)
