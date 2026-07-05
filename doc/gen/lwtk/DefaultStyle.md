# Class lwtk.DefaultStyle


See also the [Style Parameter Index](../styleparams.md) for all style
parameters with their default rules and using classes.

## Contents

   * [Inheritance](#inheritance)
   * [Constructor](#constructor)
   * [Init Parameters](#init-parameters)
   * [Default Style Rules](#default-style-rules)
   * [Inherited Methods](#inherited-methods)
   * [Inherited Static Members](#inherited-static-members)


## <a id="inheritance"></a>Inheritance
   *  / **[Object](../lwtk/Object.md#inheritance)** / **[Style](../lwtk/Style.md#inheritance)** / _**`DefaultStyle`**_

## <a id="constructor"></a>Constructor
   * <span id=".new">**`DefaultStyle(initParams)`**</span>

        * Overrides: **[Style()](../lwtk/Style.md#constructor)**



## <a id="init-parameters"></a>Init Parameters

The following parameters can be given to the constructor; each parameter
is handled by the corresponding setter method:

   * `rules` - **[Style:setRules()](../lwtk/Style.md#.setRules)**
   * `scaleFactor` - **[Style:setScaleFactor()](../lwtk/Style.md#.setScaleFactor)**

## <a id="default-style-rules"></a>Default Style Rules

A rule name consists of the style parameter name with optional class and
state selectors, see [lwtk.Style](../lwtk/Style.md). All default values can be
overridden by constructor init parameters of the same name.

| Rule | Default Value |
|------|---------------|
| `*TransitionSeconds` | `0.05` |
| `VisibilityTransitionSeconds` | `0.05` |
| `VisibilityTransitionSeconds:invisible` | `0.10` |
| `FrameTransitionSeconds` | `0.05` |
| `HoverTransitionSeconds` | `0.20` |
| `PressedTransitionSeconds` | `0.05` |
| `SimulateButtonClickSeconds` | `0.10` |
| `TextSize` | `12` |
| `FontFamily` | `"sans-serif"` |
| `ScrollBarSize` | `12` |
| `BackgroundColor` | `Color"f9f9fa"` |
| `TextColor` | `Color"000000"` |
| `AccentColor` | `Color"006fc7"` |
| `TextOffset` | `0` |
| `CursorColor` | `Color"00000000"` |
| `CursorColor:focused` | `Color"000000"` |
| `CursorWidth` | `2` |
| `Margin@Control` | `8` |
| `*Margin@Control` | `get"Margin"` |
| `Height@Control` | `24` |
| `BorderPadding@Control` | `3` |
| `TextFullVisible@Control` | `true` |
| `BorderSize@Box` | `1` |
| `BorderPadding@Box` | `3` |
| `BorderColor@Box` | `Color"adadad"` |
| `BorderPadding@TextLabel` | `0` |
| `BorderSize@TextLabel` | `0` |
| `BorderColor@TextLabel` | `nil` |
| `Width@PushButton` | `80` |
| `BorderSize@PushButton` | `1` |
| `BorderSize@PushButton:focused` | `2` |
| `LeftPadding@PushButton` | `10` |
| `RightPadding@PushButton` | `10` |
| `TextOffset@PushButton:pressed+hover` | `0.3` |
| `BackgroundColor@PushButton` | `Color"e1e1e1"` |
| `BackgroundColor@PushButton:hover` | `Color"c9c9ca"` |
| `BackgroundColor@PushButton:pressed` | `Color"c9c9ca"` |
| `BackgroundColor@PushButton:pressed+hover` | `Color"b1b1b2"` |
| `BackgroundColor@PushButton:default` | `Color"e5f1fb"` |
| `BackgroundColor@PushButton:default+hover` | `Color"d5e1eb"` |
| `BackgroundColor@PushButton:default+pressed` | `Color"c5d1db"` |
| `BackgroundColor@PushButton:focused` | `Color"e5f1fb"` |
| `BackgroundColor@PushButton:focused+hover` | `Color"d5e1eb"` |
| `BackgroundColor@PushButton:focused+pressed` | `Color"c5d1db"` |
| `TextColor@PushButton:disabled` | `Color"adadad"` |
| `BorderColor@PushButton` | `Color"adadad"` |
| `BorderColor@PushButton:focused` | `get"AccentColor"` |
| `BorderColor@PushButton:default` | `get"AccentColor"` |
| `MinColumns@TextInput` | `10` |
| `Columns@TextInput` | `20` |
| `MaxColumns@TextInput` | `-1` |
| `BorderColor@TextInput` | `Color"adadad"` |
| `BorderColor@TextInput:focused` | `get"AccentColor"` |
| `BorderSize@TextInput` | `1` |
| `BorderSize@TextInput:focused` | `2` |
| `FontFamily@TextInput` | `"monospace"` |
| `TextFullVisible@TextInput` | `false` |
| `TextSize@TitleText` | `scale(2, get"TextSize")` |
| `BorderColor@FocusGroup` | `Color"adadad"` |
| `BorderColor@FocusGroup:focused` | `get"AccentColor"` |
| `BorderSize@FocusGroup` | `1` |
| `BorderSize@FocusGroup:focused` | `2` |
| `BorderSize@FocusGroup:focused+entered` | `1` |


## <a id="inherited-methods"></a>Inherited Methods
   * **[Style](../lwtk/Style.md)**:
      * [addRules()](../lwtk/Style.md#.addRules), [clearCache()](../lwtk/Style.md#.clearCache), [getScaleFactor()](../lwtk/Style.md#.getScaleFactor), [getStyleParam()](../lwtk/Style.md#.getStyleParam), [isAnimatable()](../lwtk/Style.md#.isAnimatable), [isScalable()](../lwtk/Style.md#.isScalable), [setRules()](../lwtk/Style.md#.setRules), [setScaleFactor()](../lwtk/Style.md#.setScaleFactor), [_getStyleParam()](../lwtk/Style.md#._getStyleParam), [_getStyleParam2()](../lwtk/Style.md#._getStyleParam2), [_replaceParentStyle()](../lwtk/Style.md#._replaceParentStyle), [_setParentStyle()](../lwtk/Style.md#._setParentStyle)
   * **[Object](../lwtk/Object.md)**:
      * [getClass()](../lwtk/Object.md#.getClass), [getClassPath()](../lwtk/Object.md#.getClassPath), [getMember()](../lwtk/Object.md#.getMember), [getReverseClassPath()](../lwtk/Object.md#.getReverseClassPath), [getSuperClass()](../lwtk/Object.md#.getSuperClass), [isInstanceOf()](../lwtk/Object.md#.isInstanceOf), [setAttributes()](../lwtk/Object.md#.setAttributes)

## <a id="inherited-static-members"></a>Inherited Static Members
   * **[Object](../lwtk/Object.md)**:
      * [declare()](../lwtk/Object.md#.declare), [getMixinBase()](../lwtk/Object.md#.getMixinBase), [newSubClass()](../lwtk/Object.md#.newSubClass)
