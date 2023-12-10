# Class lwtk.Color

RGBA Color value.

Contains the float values *r (red)*, *g (green)*, *b (blue)* and optional
*a (alpha value)* in the range >= 0 and <= 1.

## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Methods](#methods)
      * [lighten()](#.lighten)
      * [saturate()](#.saturate)
      * [toHex()](#.toHex)
      * [toRGB()](#.toRGB)
      * [toRGBA()](#.toRGBA)
   * [Inherited Methods](#inherited-methods)


## Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / _**`Color`**_

## Constructor
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


## Methods
   * <span id=".lighten">**`Color:lighten(amount)`**</span>


   * <span id=".saturate">**`Color:saturate(amount)`**</span>


   * <span id=".toHex">**`Color:toHex()`**</span>


   * <span id=".toRGB">**`Color:toRGB()`**</span>


   * <span id=".toRGBA">**`Color:toRGBA(a)`**</span>



## Inherited Methods
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)
