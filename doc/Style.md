# lwtk.Style

The appearance of gui widgets can be configured for the whole application using
objects of type *lwtk.Style*. 

<!-- ---------------------------------------------------------------------------------------- -->
##   Contents
<!-- ---------------------------------------------------------------------------------------- -->

   * [Basic Usage](#basic-usage)
   * [Matching Class Names](#matching-class-names)
   * [Matching Package Names](#matching-package-names)
   * [Matching Widget States](#matching-widget-states)

<!-- ---------------------------------------------------------------------------------------- -->
##   Basic Usage
<!-- ---------------------------------------------------------------------------------------- -->

*Style* objects contain rule sets for determining the values of named parameters
for a widget according to the widget's class name and the widget's state.

Let's start by constructing our first widget class and create a widget object of this class:

```lua
local lwtk = require("lwtk")
local MyWidget1 = lwtk.newClass("MyWidget1", lwtk.Widget)
local w1 = MyWidget1()
```

<!-- ---------------------------------------------------------------------------------------- -->

Now let's create a style object and obtain style parameter values for the
widget:
```lua
local style = lwtk.Style {
    { "FooWidth", 10 },
    { "BarWidth", 20 }
}
assert(style:getStyleParam(w1, "FooWidth") == 10)
assert(style:getStyleParam(w1, "BarWidth") == 20)
```

<!-- ---------------------------------------------------------------------------------------- -->
Simple wildcards * can be used for matching parameter names. The style rule list it evaluated 
from last to to first, i.e. place the most general rules at the beginning of the rule list before
more specialized rules can follow:
```lua
local style = lwtk.Style {
    { "*Width",             10 },
    { "BarWidth",           20 },
}
assert(style:getStyleParam(w1, "FooWidth") == 10)
assert(style:getStyleParam(w1, "BarWidth") == 20)
assert(style:getStyleParam(w1, "xxxWidth") == 10)
assert(style:getStyleParam(w1, "Width")    == 10)
```

<!-- ---------------------------------------------------------------------------------------- -->

Multiple patterns can be given to map different parameter names to the same value:
```lua
local style = lwtk.Style {
    { "FooWidth",
      "FooHeight",     10 },
    { "BarWidth",      20 }
}
assert(style:getStyleParam(w1, "FooWidth")  == 10)
assert(style:getStyleParam(w1, "FooHeight") == 10)
assert(style:getStyleParam(w1, "BarWidth")  == 20)
```

<!-- ---------------------------------------------------------------------------------------- -->

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
##   Matching Class Names
<!-- ---------------------------------------------------------------------------------------- -->

Let's define more widget classes:

```lua
local MyWidget1 = lwtk.newClass("MyWidget1",     lwtk.Widget)
local MyWidget2 = lwtk.newClass("MyWidget2",     lwtk.Widget)
local MyWidget3 = lwtk.newClass("MyWidget3",     MyWidget2)   -- MyWidget3 is derived from MyWidget2
```

<!-- ---------------------------------------------------------------------------------------- -->

And then create widget objects of theses classes:
```lua
local w1 = MyWidget1()
local w2 = MyWidget2()
local w3 = MyWidget3()
```
<!-- ---------------------------------------------------------------------------------------- -->

So let's create a valid style object and obtain style parameter values for the
widgets:
```lua
local style = lwtk.Style {
    { "FooWidth",           10 },   -- missing class name -> matches any class name
    { "FooWidth@MyWidget2", 20 }    -- matches only for widget with specified class name
}
assert(style:getStyleParam(w1, "FooWidth") == 10)
assert(style:getStyleParam(w2, "FooWidth") == 20)
```

<!-- ---------------------------------------------------------------------------------------- -->

The style rule list it evaluated from last to to first:
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
##   Matching Package Names
<!-- ---------------------------------------------------------------------------------------- -->

A full class name may contain package name and simple class name. A dot character separates 
the package name and simple class name, e.g. `lwtk.Widget` has package name `lwtk`
and simpe class name `Widget`. Package names can also contain dot characters for separating
sub-packages, e.g. `foo.bar.Widget` has package name `foo.bar` and simple class name `Widget`.

So lets create some more classes containing package names: 
```lua
local MyWidget3p = lwtk.newClass("aaa.MyWidget3",     lwtk.Widget) -- package aaa
local MyWidget4p = lwtk.newClass("aaa.bbb.MyWidget4", lwtk.Widget) -- package aaa.bbb

local w3p = MyWidget3p()
local w4p = MyWidget4p()
```

Altogether we now have the following full class names:
```lua
assert(lwtk.type(w1)  == "MyWidget1")
assert(lwtk.type(w2)  == "MyWidget2")
assert(lwtk.type(w3)  == "MyWidget3")
assert(lwtk.type(w3p) == "aaa.MyWidget3")     
assert(lwtk.type(w4p) == "aaa.bbb.MyWidget4")  
```

<!-- ---------------------------------------------------------------------------------------- -->

Package names are not relevant for matching if the full class name pattern in the style rule
does not contain a dot character:
```lua
local style = lwtk.Style {
    { "*Width",             10 },
    { "FooWidth@MyWidget1", 20 },
    { "FooWidth@MyWidget3", 30 },
    { "BarWidth@My*4",      40 }
}

assert(style:getStyleParam(w1,  "FooWidth") == 20)
assert(style:getStyleParam(w3,  "FooWidth") == 30)
assert(style:getStyleParam(w3p, "FooWidth") == 30)
assert(style:getStyleParam(w4p, "FooWidth") == 10)
assert(style:getStyleParam(w4p, "BarWidth") == 40)
```

<!-- ---------------------------------------------------------------------------------------- -->

Package names are relevant for matching if the full class name pattern in the style rule
contains a dot character:
```lua
local style = lwtk.Style {
    { "*Width",                 10 },
    { "*Width@MyWidget1",       20 },
    { "*Width@MyWidget3",       30 },
    { "*Width@aaa.MyWidget*",   40 },
    { "BarWidth@aa*.MyWidget*", 50 }
}

assert(style:getStyleParam(w1,  "FooWidth") == 20)
assert(style:getStyleParam(w3,  "FooWidth") == 30)
assert(style:getStyleParam(w3p, "FooWidth") == 40)
assert(style:getStyleParam(w3p, "BarWidth") == 50)
assert(style:getStyleParam(w4p, "BarWidth") == 50)
```

<!-- ---------------------------------------------------------------------------------------- -->

An empty package name in the style rule matches only full class names without package
names:
```lua
local style = lwtk.Style {
    { "*Width",                 10 },
    { "*Width@.MyWidget3",      20 },   -- empty package name
}

assert(style:getStyleParam(w3,   "FooWidth") == 20)
assert(style:getStyleParam(w3p,  "FooWidth") == 10)
```


<!-- ---------------------------------------------------------------------------------------- -->


<!-- ---------------------------------------------------------------------------------------- -->
##   Matching Widget States
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
    { "FooWidth:s2",       30 }
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
The order of the state flags does not matter:
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

States not mentioned in the pattern are ignored. i.e. the rule matches independently of
these states:
```lua
local style = lwtk.Style {
    { "FooWidth",          10 },
    { "FooWidth:s1",       20 }    -- must have state s1, other states are ignored
}

assert(style:getStyleParam(w1, "FooWidth")  == 20)    assert(w1:getStateString() == "<s1><s2>")
```

<!-- ---------------------------------------------------------------------------------------- -->

You can close the pattern's state list using a : character at the end:
```lua
local style = lwtk.Style {
    { "FooWidth",          10 },   -- no state list, matches any state
    { "FooWidth:s1:",      20 }    -- state list closed
}
assert(style:getStyleParam(w1, "FooWidth")  == 10)    assert(w1:getStateString() == "<s1><s2>")

local style = lwtk.Style {
    { "FooWidth:",         10 },   -- empty state list, not closed, matches any state
    { "FooWidth:s1:",      20 }
}
assert(style:getStyleParam(w1, "FooWidth")  == 10)    assert(w1:getStateString() == "<s1><s2>")

local style = lwtk.Style {
    { "FooWidth::",        10 },    -- empty state list, closed
    { "FooWidth:s1:",      20 }
}
assert(style:getStyleParam(w1, "FooWidth")  == nil)   assert(w1:getStateString() == "<s1><s2>")

local style = lwtk.Style {
    { "FooWidth::",        10 },
    { "FooWidth:s1+s2:",   20 }
}
assert(style:getStyleParam(w1, "FooWidth")  == 20)    assert(w1:getStateString() == "<s1><s2>")
```

<!-- ---------------------------------------------------------------------------------------- -->

Wildcards are not allowed for matching state names in style rules:
```lua
local ok, err = pcall(  function() 
                            lwtk.Style { 
                                { "Foo:s*", 10 } 
                            }
                        end)
assert(not ok and err:match("state name must not contain wildcard"))
```

<!-- ---------------------------------------------------------------------------------------- -->
TODO

<!-- ---------------------------------------------------------------------------------------- -->
<!--lua
    print("Style.md: OK")
-->
