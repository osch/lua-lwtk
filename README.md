# lwtk - Lua Widget Toolkit
[![Licence](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)
[![build status](https://github.com/osch/lua-lwtk/workflows/test/badge.svg)](https://github.com/osch/lua-lwtk/actions/workflows/test.yml)
[![Install](https://img.shields.io/badge/Install-LuaRocks-brightgreen.svg)](https://luarocks.org/modules/osch/lwtk)

This toolkit provides a foundation for building cross platform GUI widgets in pure [Lua] 
on top of [LPugl] or within the [LÖVE] 2D game engine. For [LPugl] only the cairo drawing backend 
is supported. Further Backend abstraction and support for other backends could be possible in 
the future.

This project is work in progress. First aim is to provide a basic infrastructure
for creating and customizing widgets. Second aim is to implement a reasonable set 
of standard widgets. So far only very simple standard widgets are provided, e.g. 
`lwtk.TextInput` and `lwtk.PushButton`.

<!-- ---------------------------------------------------------------------------------------- -->

#### Supported platforms: 
   * Linux (X11)
   * Windows
   * Mac OS X
   * [LÖVE] 2D game engine


<!-- ---------------------------------------------------------------------------------------- -->

#### Further reading:
   * [Documentation](doc/README.md)
   * [Examples](./example/README.md#lwtk-examples)

<!-- ---------------------------------------------------------------------------------------- -->

## First Example

* The first example demonstrates a simple "Hello World" dialog.
  The appearance of the widgets is configured in [lwtk.DefaultStyle](src/lwtk/DefaultStyle.lua).
  The key bindings are configured in [lwtk.DefaultKeyBinding](src/lwtk/DefaultKeyBinding.lua).

     ![Screenshot example01](./example/screenshot00.png)

    ```lua
    local lwtk = require("lwtk")
    
    local Application    = lwtk.Application
    local Column         = lwtk.Column
    local Row            = lwtk.Row
    local PushButton     = lwtk.PushButton
    local TitleText      = lwtk.TitleText
    local Space          = lwtk.Space
    
    local app = Application("example")
    
    local function quit()
        app:close()
    end
    
    local win = app:newWindow {
        title = "example",
        Column {
            TitleText  { text = "Hello World!", style = { textSize = 35 } },
            Row {
                Space {},
                PushButton { text = "&OK", onClicked = quit },
                Space {}
            }
        },
    }
    win:show()
    app:runEventLoop()
    ```

<!-- ---------------------------------------------------------------------------------------- -->

[lua]:                      https://www.lua.org/
[LÖVE]:                     https://love2d.org/
[lpugl]:                    https://github.com/osch/lua-lpugl#lpugl

<!-- ---------------------------------------------------------------------------------------- -->
