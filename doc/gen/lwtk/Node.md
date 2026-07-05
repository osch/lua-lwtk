# Mixin lwtk.Node


## Contents

   * [Inheritance](#inheritance)
   * [Attributes](#attributes)
      * [addChild](#.addChild)
      * [removeChild](#.removeChild)
      * [discardChild](#.discardChild)
      * [_processMouseEnter](#._processMouseEnter)
      * [_processMouseLeave](#._processMouseLeave)
      * [_processMouseMove](#._processMouseMove)
      * [_processMouseScroll](#._processMouseScroll)
      * [_processMouseDown](#._processMouseDown)
      * [_processMouseUp](#._processMouseUp)
   * [Event Callbacks](#event-callbacks)
      * [onMouseEnter()](#.onMouseEnter)
      * [onMouseLeave()](#.onMouseLeave)
      * [onMouseMove()](#.onMouseMove)
      * [onMouseScroll()](#.onMouseScroll)
      * [onMouseDown()](#.onMouseDown)
      * [onMouseUp()](#.onMouseUp)
      * [onInputChanged()](#.onInputChanged)
   * [Methods](#methods)
      * [discard()](#.discard) - Discard Node that should no longer be used.
   * [Subclasses](#subclasses)


## <a id="inheritance"></a>Inheritance
   * / **[Object](../lwtk/Object.md#inheritance)** /
        * [Actionable](../lwtk/Actionable.md#inheritance) / _`Node`_
        * **[Application](../lwtk/Application.md#inheritance)** / _`Node`_

## <a id="attributes"></a>Attributes
   * <span id=".addChild">**`addChild`**</span>

   * <span id=".removeChild">**`removeChild`**</span>

   * <span id=".discardChild">**`discardChild`**</span>

   * <span id="._processMouseEnter">**`_processMouseEnter`**</span>

   * <span id="._processMouseLeave">**`_processMouseLeave`**</span>

   * <span id="._processMouseMove">**`_processMouseMove`**</span>

   * <span id="._processMouseScroll">**`_processMouseScroll`**</span>

   * <span id="._processMouseDown">**`_processMouseDown`**</span>

   * <span id="._processMouseUp">**`_processMouseUp`**</span>


## <a id="event-callbacks"></a>Event Callbacks
   * <span id=".onMouseEnter">**`onMouseEnter`**</span>

   * <span id=".onMouseLeave">**`onMouseLeave`**</span>

   * <span id=".onMouseMove">**`onMouseMove`**</span>

   * <span id=".onMouseScroll">**`onMouseScroll`**</span>

   * <span id=".onMouseDown">**`onMouseDown`**</span>

   * <span id=".onMouseUp">**`onMouseUp`**</span>

   * <span id=".onInputChanged">**`onInputChanged`**</span>


## <a id="methods"></a>Methods
   * <span id=".discard">**`Node:discard()`**</span>

     Discard Node that should no longer be used.
     
     This function could be useful under Lua 5.1 which does not have ephemeron tables.


## <a id="subclasses"></a>Subclasses
   * / **[Object](../lwtk/Object.md#subclasses)** /
        * [Actionable](../lwtk/Actionable.md#subclasses) / _`Node`_ / [Drawable](../lwtk/Drawable.md#subclasses) /
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
        * **[Application](../lwtk/Application.md#subclasses)** / _`Node`_ / [MouseDispatcher](../lwtk/MouseDispatcher.md#subclasses) / **[love.Application](../lwtk/love/Application.md#inheritance)**

