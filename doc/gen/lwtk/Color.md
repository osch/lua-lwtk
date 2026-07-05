# Class lwtk.Color

RGBA Color value.

Contains the float values *r (red)*, *g (green)*, *b (blue)* and optional
*a (alpha value)* in the range >= 0 and <= 1.

## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Attributes](#attributes)
      * [r](#.r) - red color float value (0 <= r <= 1)
      * [g](#.g) - green color float value (0 <= g <= 1)
      * [b](#.b) - blue color float value (0 <= b <= 1)
      * [a](#.a) - alpha float value (0 <= a <= 1) or nil
   * [Methods](#methods)
      * [lighten()](#.lighten)
      * [saturate()](#.saturate)
      * [toHex()](#.toHex)
      * [toRGB()](#.toRGB)
      * [toRGBA()](#.toRGBA)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / _**`Color`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`Color(...)`**</span>

     Creates a new RGBA color value.
     
     Possible invocations:
     
     * **`Color()`**
     
       If called without arguments, the color black is created, i.e. 
       *r = g = b = 0*.
     
     * **`Color(r,g,b,a)`**
     
       If more than one arg is given, arguments are the float color
       values *r*, *g*, *b*, *a* with the alpha value *a* being optional.
       
     * **`Color(table)`**
     
       * *table* - a table with the entries for the keys *r*, *g*, *b*
                   with optional alpha value *a*.
                   Missing entries for *r*, *g*, *b* are treated as 0.
     
     * **`Color(string)`**
     
       * *string* - a string in hex encoding with length 6 or 8
                    (format *"rrggbb"* or *"rrggbbaa"*). Each color value
                    consists of two hexadecimal digits and is in the range 
                    *00 <= value <= ff*, alpha value is optional.


## <a id="attributes"></a>Attributes
   * <span id=".r">**`r`**</span> : `number`

      red color float value (0 <= r <= 1)
   * <span id=".g">**`g`**</span> : `number`

      green color float value (0 <= g <= 1)
   * <span id=".b">**`b`**</span> : `number`

      blue color float value (0 <= b <= 1)
   * <span id=".a">**`a`**</span>

      alpha float value (0 <= a <= 1) or nil

## <a id="methods"></a>Methods
   * <span id=".lighten">**`Color:lighten(amount)`**</span>


   * <span id=".saturate">**`Color:saturate(amount)`**</span>


   * <span id=".toHex">**`Color:toHex()`**</span>


   * <span id=".toRGB">**`Color:toRGB()`**</span>


   * <span id=".toRGBA">**`Color:toRGBA(a)`**</span>



## <a id="inherited-methods"></a>Inherited Methods
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * **[Object](../lwtk/Object.md)**:
      * [declare()](../lwtk/Object.md#.declare), [getMixinBase()](../lwtk/Object.md#.getMixinBase), [newSubClass()](../lwtk/Object.md#.newSubClass)
