# lwtk.Meta Usage

[lwtk.Meta] objects are factories for creating derived objects that are sharing the 
same Lua metatable. They are lightweight wrappers around the standard Lua 
metatable mechanism.

[lwtk.Meta]: ./gen/lwtk/Meta.md

<!-- ---------------------------------------------------------------------------------------- -->
##   Contents
<!-- ---------------------------------------------------------------------------------------- -->

   * [Creating Meta Objects](#creating-meta-objects)
   * [Instantiating Derived Objects](#instantiating-derived-objects)
   * [Constructors](#constructors)
   * [Example](#example)

<!-- ---------------------------------------------------------------------------------------- -->
##   Creating Meta Objects
<!-- ---------------------------------------------------------------------------------------- -->

Let's start by creating a new meta object named `"Foo"`:

```lua
local lwtk = require("lwtk")
local Foo = lwtk.newMeta("Foo")
```

The new meta object `Foo` is actually a Lua table that has [lwtk.Meta] as metatable.
Its `tostring` value is `"lwtk.Meta<Foo>"` and *[lwtk.type()]* evaluates to `"lwtk.Meta"`:

[lwtk.type()]: ./gen/lwtk/type.md

```lua
assert(type(Foo) == "table")
assert(getmetatable(Foo) == lwtk.Meta)
assert(tostring(Foo) == "lwtk.Meta<Foo>")
assert(lwtk.type(Foo) == "lwtk.Meta")
```

<!--lua
assert(getmetatable(Foo).__name == "lwtk.Meta")
-->

The meta object's name is only used for debugging purposes: it is allowed to create two 
different meta objects with the same name (although this is not recommended):

```lua
local Foo2 = lwtk.newMeta("Foo")
assert(Foo ~= Foo2)
assert(tostring(Foo) == tostring(Foo2))
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Instantiating Derived Objects
<!-- ---------------------------------------------------------------------------------------- -->

The meta object is used to create new derived objects by simply calling the meta object:

```lua
local o1 = Foo()
local o2 = Foo()
```

The thereby created objects are Lua tables that  have `Foo` as metatable. Their `tostring` value 
contains the meta name `"Foo"` and *[lwtk.type()]* evaluates to `"Foo"`:

```lua
for _, o in ipairs{o1, o2} do
    assert(type(o) == "table")
    assert(getmetatable(o)  == Foo)
    assert(tostring(o):match("^Foo: [xa-fA-F0-9]+$")) -- e.g. "Foo: 0x55d1e35c2430"
    assert(lwtk.type(o) == "Foo")
end
assert(o1 ~= o2)
```
<!--lua
assert(getmetatable(o1).__name == "Foo")
-->

<!-- ---------------------------------------------------------------------------------------- -->
##   Constructors
<!-- ---------------------------------------------------------------------------------------- -->

The construction of new derived objects can be customized by implementing the method `new` in 
the meta object. The `new` method receives the newly created derived object as `self` argument.

```lua
function Foo:new(arg)
    assert(getmetatable(self) == Foo)
    self.arg = arg
end
local o3 = Foo(300)
local o4 = Foo(400)
assert(o3.arg == 300)
assert(o4.arg == 400)
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Example
<!-- ---------------------------------------------------------------------------------------- -->

Meta objects can be used to create enriched objects by implementing standard Lua metamethods:

```lua
local Vector = lwtk.newMeta("Vector")

function Vector:new(x, y)
    self.x = x
    self.y = y
end

function Vector:__add(other)
    return Vector(self.x + other.x,
                  self.y + other.y)
end

function Vector:__tostring()
    return string.format("Vector(%d,%d)", self.x, self.y)
end

local v1 = Vector(100,10)
local v2 = Vector(200,20)

assert(tostring(v1 + v2) == "Vector(300,30)")
```

<!-- ---------------------------------------------------------------------------------------- -->
<!--lua
    print("Meta.md: OK")
-->
