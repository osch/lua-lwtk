# Class lwtk.Area

A list of rectangle coordinates forming an area.

## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Methods](#methods)
      * [addRect()](#.addRect) - Adds the rectangle coordinates to the area.
      * [clear()](#.clear) - Clears all rectangle coordinates.
      * [getRect()](#.getRect) - Obtain coordinates of the i-th rectangle from the area.
      * [intersects()](#.intersects) - Returns *true* if the given rectangle coordinates intersect the area.
      * [intersectsBorder()](#.intersectsBorder)
      * [isWithin()](#.isWithin) - Returns *true* if the given rectangle coordinates are within the area.
      * [iteration()](#.iteration) - Iterate through all rectangle coordinates.
   * [Inherited Methods](#inherited-methods)


## Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / _**`Area`**_

## Constructor
   * <span id=".new">**`Area()`**</span>

     Creates an empty area object.


## Methods
   * <span id=".addRect">**`Area:addRect(x, y, w, h)`**</span>

     Adds the rectangle coordinates to the area.

   * <span id=".clear">**`Area:clear()`**</span>

     Clears all rectangle coordinates. After this the
     area does not contain any rectangle, i.e. *area.count == 0*.

   * <span id=".getRect">**`Area:getRect(i)`**</span>

     Obtain coordinates of the i-th rectangle from the area.
        
        * *i* - index of the rectangle, *1 <= i <= area.count*
        
     Returns *x, y, w, h* rectangle coordinates

   * <span id=".intersects">**`Area:intersects(x, y, w, h)`**</span>

     Returns *true* if the given rectangle coordinates intersect
     the area.

   * <span id=".intersectsBorder">**`Area:intersectsBorder(x, y, w, h, borderWidth)`**</span>


   * <span id=".isWithin">**`Area:isWithin(x, y, w, h)`**</span>

     Returns *true* if the given rectangle coordinates are 
     within the area.

   * <span id=".iteration">**`Area:iteration()`**</span>

     Iterate through all rectangle coordinates. 
     
     Returns an *iterator function*, *self* and *0*, so that the construction
     ```lua
         for i, x, y, w, h in area:iteration() do ... end
     ```
     will iterate over all rectangle indices and coordinates.


## Inherited Methods
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)
