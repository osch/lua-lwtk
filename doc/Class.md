# lwtk.Class Usage

Like [lwtk.Meta] objects, [lwtk.Class] objects are factories for creating derived objects 
of a certain type. The thereby derived objects are belonging to a type hierarchy of super 
classes providing inheritance mechanismen.


[lwtk.Meta]:  ./gen/lwtk/Meta.md
[lwtk.Class]: ./gen/lwtk/Class.md
[lwtk.Mixin]: ./gen/lwtk/Mixin.md

<!-- ---------------------------------------------------------------------------------------- -->
##   Contents
<!-- ---------------------------------------------------------------------------------------- -->

   * [Creating Classes](#creating-classes)
   * [Instantiating Derived Objects](#instantiating-derived-objects)
   * [Declaring Members](#declaring-members)
   * [Defining Methods](#defining-methods)
   * [Creating Subclasses](#creating-subclasses)
   * [Instantiating Derived Objects from Subclass](#instantiating-derived-objects-from-subclass)
   * [Overriding Members](#overriding-members)
   * [Implementing Members](#implementing-members)
   * [Constructors](#constructors)
   * [Static Members](#static-members)
   * [Extra Members](#extra-members)

<!-- ---------------------------------------------------------------------------------------- -->
##   Creating Classes
<!-- ---------------------------------------------------------------------------------------- -->

Let's start by creating a new class object named `"Foo"`:

```lua
local lwtk = require("lwtk")
local Foo = lwtk.newClass("Foo")
```

The new class object `Foo` is actually a Lua table that has [lwtk.Class] as metatable.
Its `tostring` value is `"lwtk.Class<Foo>"` and *[lwtk.type()]* evaluates to `"lwtk.Class"`:

[lwtk.type()]: ./gen/lwtk/type.md

```lua
assert(type(Foo) == "table")
assert(getmetatable(Foo) == lwtk.Class)
assert(tostring(Foo) == "lwtk.Class<Foo>")
assert(lwtk.type(Foo) == "lwtk.Class")
```
<!--lua
assert(getmetatable(Foo).__name == "lwtk.Class")
-->

The class name is only used for debugging purposes: it is allowed to create two 
different class objects with the same name (although this is not recommended):

```lua
local Foo2 = lwtk.newClass("Foo")
assert(Foo ~= Foo2)
assert(tostring(Foo) == tostring(Foo2))
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Instantiating Derived Objects
<!-- ---------------------------------------------------------------------------------------- -->

The class object is used to instantiate new derived objects by simply calling the class object:

```lua
local o1 = Foo()
local o2 = Foo()
```

The instantiated objects are Lua tables that have the class object `Foo` as metatable.
Their `tostring` value contains the class name `"Foo"` and *[lwtk.type()]* evaluates 
to `"Foo"`:

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

**Technical details**

Strictly speaking, the class object is not the real metatable, but gives access to
the underlying metatable, which can be observed by using the Lua `debug` package:
```lua
local realMt = debug.getmetatable(o1)
assert(realMt == debug.getmetatable(o2))
assert(realMt ~= Foo)
assert(realMt.__index    == Foo.__index)
assert(realMt.__newindex == Foo.__newindex)
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Declaring Members
<!-- ---------------------------------------------------------------------------------------- -->

Members of the class object become available in the derived objects:

```lua
Foo.x = 100
Foo.y = false
assert(o1.x == 100)
assert(o2.x == 100)
assert(o1.y == false)
assert(o2.y == false)
```

Members of the class object may not be changed once they are declared:

```lua
local ok, err = pcall(function() Foo.x = 999 end)
assert(not ok and err:match('member "x" already defined in class'))
```

Througout lwtk, a _defined_ member denotes a member having a value that is
not `false` and not `nil`. A _declared_ member denotes a member having a value
that is not `nil`. So in our example, member `x` is defined (and declared) and
member `y` is only declared:

```lua
local ok, err = pcall(function() Foo.y = 999 end)
assert(not ok and err:match('member "y" already declared in class'))
```

If a member value is changed in a derived object, it does not effect the
member value in the underlying class object or in other derived objects:

```lua
o1.x = 200
assert(o1.x == 200)
assert(o2.x == 100)
assert(Foo.x == 100)
```

It is not allowed to get or set members in a derived object that
are not declared in the underlying class object:

```lua
local ok, err = pcall(function() o1.z = 300 end)
assert(not ok and err:match('member "z" not declared in class'))

local ok, err = pcall(function() print(o1.z) end)
assert(not ok and err:match('member "z" not declared in class'))
```

Therefore all object members have to be declared in the underlying
class object. This can be done by setting them to an initial value (as 
seen above) or by using the `declare` helper method, that sets the
given members to the value `false`:

```lua
Foo:declare("a", "b")
o1.a = "A1"
o2.a = "A2"
assert(Foo.a == false)
assert(Foo.b == false)
assert(o1.a == "A1")
assert(o2.a == "A2")
```

**Technical details**

Members are retrieved by metatable lookup from the underlying class object until
they are overwritten in the derived object:

```lua
Foo.bar = {}
assert(o1.bar == Foo.bar)
assert(rawget(o1, "bar") == nil)
assert(rawget(Foo, "bar") == nil)
assert(rawget(Foo.__index, "bar") == Foo.bar)
o1.bar = {}
assert(o1.bar ~= Foo.bar)
assert(rawget(o1, "bar") == o1.bar)
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Defining Methods
<!-- ---------------------------------------------------------------------------------------- -->

Methods are members of type `function` which are defined using Lua's member syntax: 

```lua
function Foo:setX(x)
    self.x = x
end
function Foo:getX()
    return self.x
end
o1:setX(10)
o2:setX(20)
assert(o1:getX() == 10)
assert(o2:getX() == 20)
assert(o1.x == 10)
assert(o2.x == 20)
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Creating Subclasses
<!-- ---------------------------------------------------------------------------------------- -->

Let's create a new subclass named `"Bar"` that has `Foo` as superclass:

```lua
local Bar = lwtk.newClass("Bar", Foo)

```

Every class declared by `lwtk.newClass()` has a superclass, 
default superclass is `lwtk.Object`:
```lua
assert(Bar:getSuperClass() == Foo)
assert(Foo:getSuperClass() == lwtk.Object)
assert(lwtk.Object:getSuperClass() == nil)
assert(Bar:getClassPath() == "Bar(Foo(lwtk.Object))")
assert(Bar:getReverseClassPath() == "/lwtk.Object/Foo/Bar")
```

The new class `Bar` is a Lua table that has `lwtk.Class` as metatable.
Its `tostring` value is `"lwtk.Class<Bar>"` and `lwtk.type()` evaluates to `"lwtk.Class"`:

```lua
assert(type(Bar) == "table")
assert(getmetatable(Bar) == lwtk.Class)
assert(tostring(Bar) == "lwtk.Class<Bar>")
assert(lwtk.type(Bar) == "lwtk.Class")
```

The subclass contains the members of the superclass at the time when `newClass`
was invoked:

```lua
assert(rawget(Bar.__index, "setX") == Foo.setX)
assert(rawget(Bar.__index, "getX") == Foo.getX)
```

Members declared for `Foo` after the creation of class `Bar` have no effect:

```lua
Foo.newMember = {}
local ok, err = pcall(function() print(Bar.newMember) end)
assert(not ok and err:match('no member "newMember" in class'))
assert(rawget(Foo.__index, "newMember") == Foo.newMember)
assert(rawget(Bar.__index, "newMember") == nil)
assert(rawget(Bar, "newMember") == nil)
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Instantiating Derived Objects from Subclass
<!-- ---------------------------------------------------------------------------------------- -->


Let's instantiate a derived object of the subclass `Bar`:

```lua
local o3 = Bar()
```

The instantiated object is a Lua table, it has the class object `Bar` as metatable.
The `tostring` value contains the class name `"Bar"` and *[lwtk.type()]* evaluates 
to `"Bar"`:

```lua
assert(type(o3) == "table")
assert(getmetatable(o3) == Bar)
assert(tostring(o3):match("^Bar: [xa-fA-F0-9]+$")) -- e.g. "Bar: 0x55d1e35c2430"
assert(lwtk.type(o3) == "Bar")
```

The instantiated object has the members of the superclass:

```lua
assert(o3.setX == Foo.setX)

o3:setX(300)
assert(o3:getX()== 300)
assert(o3.x == 300)
```

Members declared for the subclass are only available for subclass derived objects:


```lua
function Bar:addX(x)
    return self.x + x
end
assert(o3:addX(2) == 302)

local ok, err = pcall(function() print(o2.addX) end)
assert(not ok and err:match('member "addX" not declared in class'))
```


Use `lwtk.isInstanceOf()` to check if an object is an instance of the specified class:

```lua
assert(lwtk.isInstanceOf(o3, Bar))
assert(lwtk.isInstanceOf(o3, Foo))
assert(lwtk.isInstanceOf(o3, lwtk.Object))

assert(not lwtk.isInstanceOf(o2, Bar))
assert(lwtk.isInstanceOf(o2, Foo))
assert(lwtk.isInstanceOf(o2, lwtk.Object))

```


<!-- ---------------------------------------------------------------------------------------- -->
##   Overriding Members
<!-- ---------------------------------------------------------------------------------------- -->

For going on, let's instantiate new class objects:

```lua
local Foo = lwtk.newClass("Foo")
do
    Foo.x = 100
    Foo.y = false
    function Foo:getX()
        return self.x
    end
end
local Bar = lwtk.newClass("Bar", Foo)
```

It's not allowed to simply declare a member in a subclass that is alread declared in the
superclass:

```lua

local ok, err = pcall(function() Bar.x = false end)
assert(not ok and err:match('member "x" .* is already defined in superclass'))

local ok, err = pcall(function() Bar:declare("x") end)
assert(not ok and err:match('member "x" .* is already defined in superclass'))

local ok, err = pcall(function() Bar.y = 999 end)
assert(not ok and err:match('member "y" .* is already declared in superclass'))

local ok, err = pcall(function() Bar:declare("y") end)
assert(not ok and err:match('member "y" .* is already declared in superclass'))
```

To indicate that overriding a member of the superclass is intentional, 
a special `override` syntax has to be used:

```lua
local t = {}

Bar.override.x = false
Bar.override.y = t

local foo = Foo()
local bar = Bar()

assert(foo.x == 100   and foo.y == false)
assert(bar.x == false and bar.y == t)

assert(Foo.x == 100   and Foo.y == false)
assert(Bar.x == false and Bar.y == t)
```

Each class object may have a special `override` table containing the 
overridden members:

```lua
for k, v in pairs(Bar.override) do
    assert(k == "x" and v == false
        or k == "y" and v == t)
end
```

This example demonstrates an overriding method calling the 
overridden super method:

```lua
function Bar.override:getX()
    return 2 * Foo.getX(self) -- double the value from the superclass
end
foo.x = 100
bar.x = 200
assert(foo:getX() == 100) -- invokes Foo.getX
assert(bar:getX() == 400) -- invokes Bar.getX
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Implementing Members
<!-- ---------------------------------------------------------------------------------------- -->

Use the `implement` table to ensure that the overridden member has no
definition in the superclass. This is especially useful for methods where it
could be crucial to know that a superclass implementation needs not to be
considered:

```lua
local Foo = lwtk.newClass("Foo")
do
    function Foo:m1() 
        return 100 
    end
    
    Foo.m2 = false
    
    function Foo:m3() 
        return 300 
    end
    
    Foo.m4 = false
end

local Bar = lwtk.newClass("Bar", Foo)

function Bar.override:m1()
    return 1000 + Foo.m1(self) -- consider superclass method
end

function Bar.implement:m2()
    return 2000 -- no m2 in superclass
end
```

It is an error to implement members that are defined in the superclass:

```lua
local ok, err = pcall(function()
    function Bar.implement:m3()
        return 3000
    end
end)
assert(not ok and err:match('member "m3" .* already defined in superclass'))
```

It is also an error to implement members that are not declared in the superclass:

```lua
local ok, err = pcall(function()
    function Bar.implement:m3a()
        return 3000
    end
end)
assert(not ok and err:match('cannot implement member "m3a"'))
```

It is possible to override superclass members that are only declared and not
defined in the superclass (this is especially useful for implementing objects of 
type [lwtk.Mixin]):

```lua
function Bar.override:m4()
    if Foo.m4 then
        return 4000 + Foo.m4(self) -- consider superclass method
    end
end

```

<!-- ---------------------------------------------------------------------------------------- -->
##   Constructors
<!-- ---------------------------------------------------------------------------------------- -->

The construction of new derived objects can be customized by implementing the method `new` in 
the class object. The `new` method receives the newly created derived object as `self` argument.

```lua
local Foo = lwtk.newClass("Foo")
do
    Foo.x = false
    function Foo:new(x)
        self.x = x
    end
end
local o1 = Foo(100)
local o2 = Foo(200)
assert(o1.x == 100)
assert(o2.x == 200)
```

The `new` method can also be overriden like normal methods:

```lua
local Bar = lwtk.newClass("Bar", Foo)
do
    function Bar.override:new(x)
        Foo.new(self, 2 * x) -- call superclass new
    end
end
local o3 = Bar(300)
assert(o3.x == 600)
```


<!-- ---------------------------------------------------------------------------------------- -->
##   Static Members
<!-- ---------------------------------------------------------------------------------------- -->

A table named `static` can be used to declare members that are only available in the 
class object and not in the derived objects:

```lua
local Foo = lwtk.newClass("Foo")
local t = {}
Foo.static.T = t
assert(Foo.T == t)

local foo = Foo()  -- derived object

local ok, err = pcall(function() print(foo.T) end)
assert(not ok and err:match('member "T" not declared'))

local ok, err = pcall(function() print(foo.static.T) end)
assert(not ok and err:match('member "static" not declared'))
```

Such static members are inherited by subclasses like normal members:
```lua
local Bar = lwtk.newClass("Bar", Foo)
assert(Bar.T == t)
assert(Bar.static.T == t)
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Extra Members
<!-- ---------------------------------------------------------------------------------------- -->

The `extra` table can be used to declare members that are only available
in the class object's extra table and are not inherited by subclasses
and also not in derived objects:

```lua
local Foo = lwtk.newClass("Foo")
local t = {}
Foo.extra.T = t

local ok, err = pcall(function() print(Foo.T) end)
assert(not ok and err:match('no member "T" in class'))

local Bar = lwtk.newClass("Bar", Foo)
assert(Bar.extra.T == nil)
assert(Foo.extra.T == t)

local foo = Foo() -- derived object
local bar = Bar() -- derived object

local ok, err = pcall(function() print(foo.T) end)
assert(not ok and err:match('member "T" not declared in class'))

local ok, err = pcall(function() print(foo.extra.T) end)
assert(not ok and err:match('member "extra" not declared in class'))

local ok, err = pcall(function() print(bar.T) end)
assert(not ok and err:match('member "T" not declared in class'))

local ok, err = pcall(function() print(bar.extra.T) end)
assert(not ok and err:match('member "extra" not declared in class'))

```

<!-- ---------------------------------------------------------------------------------------- -->
<!--lua
    print("Class.md: OK")
-->
