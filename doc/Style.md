# lwtk.Style

The appearance of gui widgets can be configured for the whole application using
objects of type *lwtk.Style*. 

Let's start by constructing three widget classes:

```lua
local lwtk = require("lwtk")

local MyWidget1 = lwtk.newClass("MyWidget1", lwtk.Widget)
local MyWidget2 = lwtk.newClass("MyWidget2", lwtk.Widget)
local MyWidget3 = lwtk.newClass("MyWidget3", MyWidget2)   -- MyWidget3 is derived from MyWidget2
```

And then create three widget objects of theses classes:
```lua
local w1 = MyWidget1()
local w2 = MyWidget2()
local w3 = MyWidget3()
```

*Style* objects contain rule sets for determining the values of named parameters
for a widget according to the widget's class name and the widget's state.

The type of the style parameter value is determined
by the parameter name ending. Therefore only certain parameter names are valid, 
e.g. names ending with *...Width*, *...Height* or *...Color*. The known parameter
types are defined in [lwtk.DefaultStyleTypes](../src/lwtk/DefaultStyleTypes.lua).
An error is raised if a parameter name with unknown suffix is used:
```lua
local ok, err = pcall(  function() 
                            lwtk.Style { 
                                { "Foo", 10 } 
                            }
                        end)
assert(not ok and err:match("Cannot deduce parameter type"))
```

So let's create a valid style object and obtain style parameter values for the
widgets:
```lua
local style = lwtk.Style {
    { "FooWidth",           10 },
    { "FooWidth@MyWidget2", 20 }
}
assert(style:getStyleParam(w1, "FooWidth") == 10)
assert(style:getStyleParam(w2, "FooWidth") == 20)
```

The style rule list it evaluated from bottom to top:
```lua
local style = lwtk.Style {
    { "FooWidth@MyWidget2", 20 },
    { "FooWidth",           10 }
}
assert(style:getStyleParam(w1, "FooWidth") == 10)
assert(style:getStyleParam(w2, "FooWidth") == 10)
```

Also the super classes are considered:
```lua
local style = lwtk.Style {
    { "FooWidth",           10 },
    { "FooWidth@Widget",    20 },
    { "FooWidth@MyWidget2", 30 }
}
assert(style:getStyleParam(w1, "FooWidth") == 20) -- w1 has super class lwtk.Widget
assert(style:getStyleParam(w2, "FooWidth") == 30) 
assert(style:getStyleParam(w3, "FooWidth") == 30) -- w3 has super class MyWidget2
```

Style rules can contain simple wildcards * for matching parameter and class names:
```lua
local style = lwtk.Style {
    { "*Width",             10 },
    { "F*Width",            20 },
    { "FooWidth@My*1",      30 },
    { "F*Width@My*3",       40 }
}
assert(style:getStyleParam(w1, "FooWidth") == 30)
assert(style:getStyleParam(w2, "FooWidth") == 20)
assert(style:getStyleParam(w3, "FooWidth") == 40)
assert(style:getStyleParam(w3, "BarWidth") == 10)
```

****************************************************************************************
TODO
<!--lua
    print("Style.md: OK")
-->
