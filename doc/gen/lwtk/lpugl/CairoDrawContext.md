# Class lwtk.lpugl.CairoDrawContext


## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Attributes](#attributes)
      * [opacityStack](#.opacityStack)
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
      * [_setCairoContext()](#._setCairoContext)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../../lwtk/Object.md#inheritance)** / **[lpugl.CairoLayoutContext](../../lwtk/lpugl/CairoLayoutContext.md#inheritance)** / _**`lpugl.CairoDrawContext`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`lpugl.CairoDrawContext(...)`**</span>

        * Overrides: **[lpugl.CairoLayoutContext()](../../lwtk/lpugl/CairoLayoutContext.md#constructor)**



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `color` - [setColor()](#.setColor)
   * `lineWidth` - [setLineWidth()](#.setLineWidth)

## <a id="attributes"></a>Attributes
   * <span id=".opacityStack">**`opacityStack`**</span> : `table`


## <a id="methods"></a>Methods
   * <span id=".beginOpacity">**`lpugl.CairoDrawContext:beginOpacity(opacity)`**</span>


   * <span id=".drawBorder">**`lpugl.CairoDrawContext:drawBorder(color, borderThickness, x, y, w, h)`**</span>


   * <span id=".drawLine">**`lpugl.CairoDrawContext:drawLine(x1, y1, x2, y2, ...)`**</span>


   * <span id=".drawText">**`lpugl.CairoDrawContext:drawText(x, y, text)`**</span>


   * <span id=".endOpacity">**`lpugl.CairoDrawContext:endOpacity()`**</span>


   * <span id=".fillRect">**`lpugl.CairoDrawContext:fillRect(color, x, y, w, h)`**</span>


   * <span id=".intersectClip">**`lpugl.CairoDrawContext:intersectClip(x, y, w, h)`**</span>


   * <span id=".restore">**`lpugl.CairoDrawContext:restore()`**</span>


   * <span id=".save">**`lpugl.CairoDrawContext:save()`**</span>


   * <span id=".setColor">**`lpugl.CairoDrawContext:setColor(r, g, b, a)`**</span>


   * <span id=".setLineWidth">**`lpugl.CairoDrawContext:setLineWidth(w)`**</span>


   * <span id=".translate">**`lpugl.CairoDrawContext:translate(x, y)`**</span>


   * <span id="._setCairoContext">**`lpugl.CairoDrawContext:_setCairoContext(cairoCtx)`**</span>



## <a id="inherited-methods"></a>Inherited Methods
   * **[lpugl.CairoLayoutContext](../../lwtk/lpugl/CairoLayoutContext.md)**:
      * [getFontHeightMeasures()](../../lwtk/lpugl/CairoLayoutContext.md#.getFontHeightMeasures), [getTextMeasures()](../../lwtk/lpugl/CairoLayoutContext.md#.getTextMeasures), [getTextWidth()](../../lwtk/lpugl/CairoLayoutContext.md#.getTextWidth), [selectFont()](../../lwtk/lpugl/CairoLayoutContext.md#.selectFont)
   * **[Object](../../lwtk/Object.md)**:
      * [getClass()](../../lwtk/Object.md#.getClass), [getClassPath()](../../lwtk/Object.md#.getClassPath), [getMember()](../../lwtk/Object.md#.getMember), [getReverseClassPath()](../../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../../lwtk/Object.md#.isInstanceOf), [setAttributes()](../../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * **[Object](../../lwtk/Object.md)**:
      * [declare()](../../lwtk/Object.md#.declare), [getMixinBase()](../../lwtk/Object.md#.getMixinBase), [newSubClass()](../../lwtk/Object.md#.newSubClass)
