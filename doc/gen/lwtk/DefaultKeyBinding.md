# Function lwtk.DefaultKeyBinding

   * **`DefaultKeyBinding()`**

     Returns new [lwtk.KeyBinding](../lwtk/KeyBinding.md) object with default settings.
## Contents

   * [Key Bindings](#key-bindings)


## <a id="key-bindings"></a>Key Bindings

| Keys | Action |
|------|--------|
| `Ctrl+F,Right` | `FocusRight` |
| `Ctrl+F,Left` | `FocusLeft` |
| `Tab` | `FocusNext` |
| `Shift+Tab` | `FocusPrev` |
| `Right`, `Alt+Right`, `KP_Right` | `FocusRight` |
| `Left`, `Alt+Left`, `KP_Left` | `FocusLeft` |
| `Up`, `Alt+Up`, `KP_Up` | `FocusUp` |
| `Down`, `Alt+Down`, `KP_Down` | `FocusDown` |
| `Return`, `KP_Enter`, `Space` | `FocusedButtonClick` |
| `Right`, `KP_Right` | `CursorRight` |
| `Left`, `KP_Left` | `CursorLeft` |
| `Backspace` | `DeleteCharLeft` |
| `Delete` | `DeleteCharRight` |
| `Home` | `CursorToBeginOfLine` |
| `End` | `CursorToEndOfLine` |
| `Return`, `KP_Enter` | `InputNext` |
| `Shift+Return`, `Shift+KP_Enter` | `InputPrev` |
| `Return`, `KP_Enter` | `DefaultButton` |
| `Escape`, `Alt+Escape`, `Shift+Escape`, `Ctrl+Escape` | `CloseWindow` |
| `Return`, `Space`, `KP_Enter` | `EnterFocusGroup` |
| `Escape` | `ExitFocusGroup` |

