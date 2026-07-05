# Mixin lwtk.Drawable


## Contents

   * [Inheritance](#inheritance)
   * [Attributes](#attributes)
      * [visible](#.visible)
      * [x](#.x)
      * [y](#.y)
      * [w](#.w)
      * [h](#.h)
      * [id](#.id)
      * [_setStyleFromParent](#._setStyleFromParent)
   * [Methods](#methods)
      * [getMandatoryStyleParam()](#.getMandatoryStyleParam)
      * [getStyleParam()](#.getStyleParam)
      * [_processMouseDown()](#._processMouseDown)
      * [_processMouseEnter()](#._processMouseEnter)
      * [_processMouseLeave()](#._processMouseLeave)
      * [_processMouseMove()](#._processMouseMove)
      * [_processMouseScroll()](#._processMouseScroll)
      * [_processMouseUp()](#._processMouseUp)
   * [Subclasses](#subclasses)


## <a id="inheritance"></a>Inheritance
   * / **[Object](../lwtk/Object.md#inheritance)** / [Actionable](../lwtk/Actionable.md#inheritance) / [Node](../lwtk/Node.md#inheritance) / _`Drawable`_

## <a id="attributes"></a>Attributes
   * <span id=".visible">**`visible`**</span>

   * <span id=".x">**`x`**</span>

   * <span id=".y">**`y`**</span>

   * <span id=".w">**`w`**</span>

   * <span id=".h">**`h`**</span>

   * <span id=".id">**`id`**</span>

   * <span id="._setStyleFromParent">**`_setStyleFromParent`**</span>


## <a id="methods"></a>Methods
   * <span id=".getMandatoryStyleParam">**`Drawable:getMandatoryStyleParam(paramName)`**</span>


   * <span id=".getStyleParam">**`Drawable:getStyleParam(paramName)`**</span>


   * <span id="._processMouseDown">**`Drawable:_processMouseDown(mx, my, button, modState)`**</span>


   * <span id="._processMouseEnter">**`Drawable:_processMouseEnter(x, y)`**</span>


   * <span id="._processMouseLeave">**`Drawable:_processMouseLeave(x, y)`**</span>


   * <span id="._processMouseMove">**`Drawable:_processMouseMove(mouseEntered, x, y)`**</span>


   * <span id="._processMouseScroll">**`Drawable:_processMouseScroll(dx, dy)`**</span>


   * <span id="._processMouseUp">**`Drawable:_processMouseUp(mouseEntered, mx, my, button, modState)`**</span>



## <a id="subclasses"></a>Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** / [Actionable](../lwtk/Actionable.md#subclasses) / [Node](../lwtk/Node.md#subclasses) / _`Drawable`_ /
        * **[Component](../lwtk/Component.md#subclasses)** /
             * [Compound](../lwtk/Compound.md#subclasses) / **[InnerCompound](../lwtk/InnerCompound.md#inheritance)**
             * [Styleable](../lwtk/Styleable.md#subclasses) / [Animatable](../lwtk/Animatable.md#subclasses) / **[Widget](../lwtk/Widget.md#subclasses)** / [Compound](../lwtk/Compound.md#subclasses) /
                  * [LayoutFrame](../lwtk/LayoutFrame.md#subclasses) / [Control](../lwtk/Control.md#subclasses) /
                       * [Focusable](../lwtk/Focusable.md#subclasses) / **[TextInput](../lwtk/TextInput.md#inheritance)**
                       * [HotkeyListener](../lwtk/HotkeyListener.md#subclasses) / **[Button](../lwtk/Button.md#subclasses)** /
                            * [Focusable](../lwtk/Focusable.md#subclasses) / **[PushButton](../lwtk/PushButton.md#inheritance)**
                            * **[TextLabel](../lwtk/TextLabel.md#subclasses)** / **[TitleText](../lwtk/TitleText.md#inheritance)**
                  * [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[Group](../lwtk/Group.md#subclasses)** /
                       * [Colored](../lwtk/Colored.md#subclasses) / **[ViewSwitcher](../lwtk/ViewSwitcher.md#inheritance)**
                       * **[Column](../lwtk/Column.md#inheritance)**
                       * [LayoutFrame](../lwtk/LayoutFrame.md#subclasses) / [Control](../lwtk/Control.md#subclasses) / **[Box](../lwtk/Box.md#subclasses)** / [Focusable](../lwtk/Focusable.md#subclasses) / **[FocusGroup](../lwtk/FocusGroup.md#inheritance)**
                       * **[Matrix](../lwtk/Matrix.md#inheritance)**
                       * **[Row](../lwtk/Row.md#inheritance)**
                       * **[Space](../lwtk/Space.md#inheritance)**
                       * **[Square](../lwtk/Square.md#inheritance)**
             * **[TextCursor](../lwtk/TextCursor.md#inheritance)**
             * **[TextFragment](../lwtk/TextFragment.md#inheritance)**
        * [Styleable](../lwtk/Styleable.md#subclasses) / [KeyHandler](../lwtk/KeyHandler.md#subclasses) / [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[Window](../lwtk/Window.md#inheritance)**

