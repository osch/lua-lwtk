# lwtk.Style

<!-- ---------------------------------------------------------------------------------------- -->

The appearance of gui widgets can be configured for the whole application using
objects of type *lwtk.Style*. 

Let's start by constructing three widget classes:

```lua
local lwtk = require("lwtk")

local MyWidget1 = lwtk.newClass("MyWidget1", lwtk.Widget)
local MyWidget2 = lwtk.newClass("MyWidget2", lwtk.Widget)
local MyWidget3 = lwtk.newClass("MyWidget3", MyWidget2)   -- MyWidget3 is derived from MyWidget2
```

<!-- ---------------------------------------------------------------------------------------- -->

And then create three widget objects of theses classes:
```lua
local w1 = MyWidget1()
local w2 = MyWidget2()
local w3 = MyWidget3()
```

<!-- ---------------------------------------------------------------------------------------- -->

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

<!-- ---------------------------------------------------------------------------------------- -->

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

<!-- ---------------------------------------------------------------------------------------- -->

The style rule list it evaluated from bottom to top:
```lua
local style = lwtk.Style {
    { "FooWidth@MyWidget2", 20 },
    { "FooWidth",           10 }
}
assert(style:getStyleParam(w1, "FooWidth") == 10)
assert(style:getStyleParam(w2, "FooWidth") == 10)
```

<!-- ---------------------------------------------------------------------------------------- -->

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

<!-- ---------------------------------------------------------------------------------------- -->

Simple wildcards * can be used for matching parameter and class names:
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

<!-- ---------------------------------------------------------------------------------------- -->

Multiple patterns can be given to map different parameter names to the same value:
```lua
local style = lwtk.Style {
    { "F*Width",
      "F*Height",          10 },
    { "F*Width@My*2",      20 },
}
assert(style:getStyleParam(w1, "FooWidth")  == 10)
assert(style:getStyleParam(w1, "FooHeight") == 10)
assert(style:getStyleParam(w2, "FooWidth")  == 20)
```

<!-- ---------------------------------------------------------------------------------------- -->

Widgets can have user defined state flags that can be used to match style parameters:
```lua
w1:setState("s1", true)
w1:setState("s2", false)

assert(w1.state["s1"] == true)
assert(w1.state["s2"] == false)                        assert(w1:getStateString() == "<s1>")

local style = lwtk.Style {
    { "FooWidth",          10 },
    { "FooWidth:s1",       20 },
    { "FooWidth:s2",       30 },
}

assert(style:getStyleParam(w1, "FooWidth")  == 20)     assert(w1:getStateString() == "<s1>")
w1:setState("s1", false)
assert(style:getStyleParam(w1, "FooWidth")  == 10)     assert(w1:getStateString() == "")
w1:setState("s2", true)
assert(style:getStyleParam(w1, "FooWidth")  == 30)     assert(w1:getStateString() == "<s2>")
```

<!-- ---------------------------------------------------------------------------------------- -->

As already mentioned: style rules are evaluated from last to first:
```lua
w1:setState("s1", true)
assert(style:getStyleParam(w1, "FooWidth")  == 30)     assert(w1:getStateString() == "<s1><s2>")
w1:setState("s2", false)
assert(style:getStyleParam(w1, "FooWidth")  == 20)     assert(w1:getStateString() == "<s1>")
w1:setState("s1", false)
assert(style:getStyleParam(w1, "FooWidth")  == 10)     assert(w1:getStateString() == "")

```

<!-- ---------------------------------------------------------------------------------------- -->

In a style matching rule multiple state flags can be combined using a + character:
```lua
w1:setState("s1", true)
w1:setState("s2", false)

assert(w1.state["s1"] == true)
assert(w1.state["s2"] == false)
assert(w1.state["s3"] == nil)

local style = lwtk.Style {
    { "*Width",            10 },
    { "FooWidth:s1",       20 },
    { "FooWidth:s1+s2",    30 }
}

w1:setState("s1", true)
assert(style:getStyleParam(w1, "FooWidth")  == 20)    assert(w1:getStateString() == "<s1>")
w1:setState("s2", true)                
assert(style:getStyleParam(w1, "FooWidth")  == 30)    assert(w1:getStateString() == "<s1><s2>")
w1:setState("s1", false)                
assert(style:getStyleParam(w1, "FooWidth")  == 10)    assert(w1:getStateString() == "<s2>")
```

<!-- ---------------------------------------------------------------------------------------- -->
The order does not matter:
```lua
local style = lwtk.Style {
    { "*Width",            10 },
    { "FooWidth:s1+s2",    20 },
    { "BarWidth:s2+s1",    30 }
}

assert(style:getStyleParam(w1, "FooWidth")  == 10)    assert(w1:getStateString() == "<s2>")
assert(style:getStyleParam(w1, "BarWidth")  == 10)    assert(w1:getStateString() == "<s2>")
w1:setState("s1", true)
assert(style:getStyleParam(w1, "FooWidth")  == 20)    assert(w1:getStateString() == "<s1><s2>")
assert(style:getStyleParam(w1, "BarWidth")  == 30)    assert(w1:getStateString() == "<s1><s2>")
```

<!-- ---------------------------------------------------------------------------------------- -->

States not mentioned in the pattern are ignored:
```lua
local style = lwtk.Style {
    { "FooWidth",          10 },
    { "FooWidth:s1",       20 }
}

assert(style:getStyleParam(w1, "FooWidth")  == 20)    assert(w1:getStateString() == "<s1><s2>")
```

<!-- ---------------------------------------------------------------------------------------- -->

You can close the pattern's state list using a : character at the end:
```lua
local style = lwtk.Style {
    { "FooWidth",          10 },
    { "FooWidth:s1:",      20 },   -- state list closed
}

assert(style:getStyleParam(w1, "FooWidth")  == 10)    assert(w1:getStateString() == "<s1><s2>")

local style = lwtk.Style {
    { "FooWidth:",         10 },   -- empty state list, not closed
    { "FooWidth:s1:",      20 },
}

assert(style:getStyleParam(w1, "FooWidth")  == 10)    assert(w1:getStateString() == "<s1><s2>")

local style = lwtk.Style {
    { "FooWidth::",        10 },    -- empty state list, closed
    { "FooWidth:s1:",      20 },
}

assert(style:getStyleParam(w1, "FooWidth")  == nil)    assert(w1:getStateString() == "<s1><s2>")
```

<!-- ---------------------------------------------------------------------------------------- -->
TODO

<!-- ---------------------------------------------------------------------------------------- -->
<!--lua
    print("Style.md: OK")
-->
