# Style Parameter Index

All style parameters with their default rules from [lwtk.DefaultStyle](lwtk/DefaultStyle.md) and the classes whose implementation uses them. See [lwtk.Style](lwtk/Style.md) and [lwtk.BuiltinStyleTypes](lwtk/BuiltinStyleTypes.md) for more information about style parameters.

   * <span id=".*Margin">**`*Margin`**</span>
      * default `@Control`: `get"Margin"`
   * <span id=".*TransitionSeconds">**`*TransitionSeconds`**</span>
      * default: `0.05`
   * <span id=".AccentColor">**`AccentColor`**</span>
      * default: `Color"006fc7"`
   * <span id=".BackgroundColor">**`BackgroundColor`**</span>
      * default: `Color"f9f9fa"`
      * default `@PushButton`: `Color"e1e1e1"`
      * default `@PushButton:hover`: `Color"c9c9ca"`
      * default `@PushButton:pressed`: `Color"c9c9ca"`
      * default `@PushButton:pressed+hover`: `Color"b1b1b2"`
      * default `@PushButton:default`: `Color"e5f1fb"`
      * default `@PushButton:default+hover`: `Color"d5e1eb"`
      * default `@PushButton:default+pressed`: `Color"c5d1db"`
      * default `@PushButton:focused`: `Color"e5f1fb"`
      * default `@PushButton:focused+hover`: `Color"d5e1eb"`
      * default `@PushButton:focused+pressed`: `Color"c5d1db"`
      * used by: [Colored](lwtk/Colored.md#used-style-parameters), [LayoutFrame](lwtk/LayoutFrame.md#used-style-parameters), **[Window](lwtk/Window.md#used-style-parameters)**
   * <span id=".BorderColor">**`BorderColor`**</span>
      * default `@Box`: `Color"adadad"`
      * default `@TextLabel`: `nil`
      * default `@PushButton`: `Color"adadad"`
      * default `@PushButton:focused`: `get"AccentColor"`
      * default `@PushButton:default`: `get"AccentColor"`
      * default `@TextInput`: `Color"adadad"`
      * default `@TextInput:focused`: `get"AccentColor"`
      * default `@FocusGroup`: `Color"adadad"`
      * default `@FocusGroup:focused`: `get"AccentColor"`
      * used by: [LayoutFrame](lwtk/LayoutFrame.md#used-style-parameters)
   * <span id=".BorderPadding">**`BorderPadding`**</span>
      * default `@Control`: `3`
      * default `@Box`: `3`
      * default `@TextLabel`: `0`
      * used by: [LayoutFrame](lwtk/LayoutFrame.md#used-style-parameters), **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".BorderSize">**`BorderSize`**</span>
      * default `@Box`: `1`
      * default `@TextLabel`: `0`
      * default `@PushButton`: `1`
      * default `@PushButton:focused`: `2`
      * default `@TextInput`: `1`
      * default `@TextInput:focused`: `2`
      * default `@FocusGroup`: `1`
      * default `@FocusGroup:focused`: `2`
      * default `@FocusGroup:focused+entered`: `1`
      * used by: [LayoutFrame](lwtk/LayoutFrame.md#used-style-parameters)
   * <span id=".Columns">**`Columns`**</span>
      * default `@TextInput`: `20`
      * used by: **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".CursorColor">**`CursorColor`**</span>
      * default: `Color"00000000"`
      * default `:focused`: `Color"000000"`
      * used by: **[TextCursor](lwtk/TextCursor.md#used-style-parameters)**
   * <span id=".CursorWidth">**`CursorWidth`**</span>
      * default: `2`
      * used by: **[TextInput](lwtk/TextInput.md#used-style-parameters)**
   * <span id=".FontFamily">**`FontFamily`**</span>
      * default: `"sans-serif"`
      * default `@TextInput`: `"monospace"`
      * used by: **[TextFragment](lwtk/TextFragment.md#used-style-parameters)**
   * <span id=".FrameTransitionSeconds">**`FrameTransitionSeconds`**</span>
      * default: `0.05`
      * used by: [Animatable](lwtk/Animatable.md#used-style-parameters)
   * <span id=".Height">**`Height`**</span>
      * default `@Control`: `24`
      * used by: **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".HoverTransitionSeconds">**`HoverTransitionSeconds`**</span>
      * default: `0.20`
   * <span id=".LeftPadding">**`LeftPadding`**</span>
      * default `@PushButton`: `10`
      * used by: **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".Margin">**`Margin`**</span>
      * default `@Control`: `8`
   * <span id=".MaxColumns">**`MaxColumns`**</span>
      * default `@TextInput`: `-1`
      * used by: **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".MaxSize">**`MaxSize`**</span>
      * used by: **[Square](lwtk/Square.md#used-style-parameters)**
   * <span id=".MinColumns">**`MinColumns`**</span>
      * default `@TextInput`: `10`
      * used by: **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".MinSize">**`MinSize`**</span>
      * used by: **[Square](lwtk/Square.md#used-style-parameters)**
   * <span id=".MinWidth">**`MinWidth`**</span>
      * used by: **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".Opacity">**`Opacity`**</span>
      * used by: **[Component](lwtk/Component.md#used-style-parameters)**, [Compound](lwtk/Compound.md#used-style-parameters), **[love.Application](lwtk/love/Application.md#used-style-parameters)**
   * <span id=".PressedTransitionSeconds">**`PressedTransitionSeconds`**</span>
      * default: `0.05`
   * <span id=".RightPadding">**`RightPadding`**</span>
      * default `@PushButton`: `10`
      * used by: **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".ScrollBarSize">**`ScrollBarSize`**</span>
      * default: `12`
   * <span id=".SimulateButtonClickSeconds">**`SimulateButtonClickSeconds`**</span>
      * default: `0.10`
      * used by: **[PushButton](lwtk/PushButton.md#used-style-parameters)**
   * <span id=".Size">**`Size`**</span>
      * used by: **[Square](lwtk/Square.md#used-style-parameters)**
   * <span id=".TextAlign">**`TextAlign`**</span>
      * used by: **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".TextColor">**`TextColor`**</span>
      * default: `Color"000000"`
      * default `@PushButton:disabled`: `Color"adadad"`
      * used by: **[TextFragment](lwtk/TextFragment.md#used-style-parameters)**
   * <span id=".TextFullVisible">**`TextFullVisible`**</span>
      * default `@Control`: `true`
      * default `@TextInput`: `false`
      * used by: **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".TextOffset">**`TextOffset`**</span>
      * default: `0`
      * default `@PushButton:pressed+hover`: `0.3`
      * used by: **[TextFragment](lwtk/TextFragment.md#used-style-parameters)**
   * <span id=".TextSize">**`TextSize`**</span>
      * default: `12`
      * default `@TitleText`: `scale(2, get"TextSize")`
      * used by: **[TextFragment](lwtk/TextFragment.md#used-style-parameters)**
   * <span id=".VisibilityTransitionSeconds">**`VisibilityTransitionSeconds`**</span>
      * default: `0.05`
      * default `:invisible`: `0.10`
   * <span id=".Width">**`Width`**</span>
      * default `@PushButton`: `80`
      * used by: **[TextLabel](lwtk/TextLabel.md#used-style-parameters)**
   * <span id=".bottomMargin">**`bottomMargin`**</span>
      * used by: **[Square](lwtk/Square.md#used-style-parameters)**, [layout](lwtk/layout.md#used-style-parameters)
   * <span id=".leftMargin">**`leftMargin`**</span>
      * used by: **[Square](lwtk/Square.md#used-style-parameters)**, [layout](lwtk/layout.md#used-style-parameters)
   * <span id=".maxSizeFixed">**`maxSizeFixed`**</span>
      * used by: **[Window](lwtk/Window.md#used-style-parameters)**
   * <span id=".rightMargin">**`rightMargin`**</span>
      * used by: **[Square](lwtk/Square.md#used-style-parameters)**, [layout](lwtk/layout.md#used-style-parameters)
   * <span id=".topMargin">**`topMargin`**</span>
      * used by: **[Square](lwtk/Square.md#used-style-parameters)**, [layout](lwtk/layout.md#used-style-parameters)
