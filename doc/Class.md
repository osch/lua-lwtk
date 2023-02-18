# lwtk.Class

Each lwtk *object* is actually a Lua table that has a lwtk *class* as metatable. The class
is also called the object's *type*.

<!-- ---------------------------------------------------------------------------------------- -->
##   Contents
<!-- ---------------------------------------------------------------------------------------- -->

   * [Declaring Classes](#declaring-classes)
   * [Instantiating Objects](#instantiating-objects)
   * [Declaring Methods](#declaring-methods)
   * [Declaring Derived Classes](#declaring-derived-classes)
   * [Instantiating Derived Objects](#instantiating-derived-objects)
   * [Overriding Methods](#overriding-methods)

<!-- ---------------------------------------------------------------------------------------- -->
##   Declaring Classes
<!-- ---------------------------------------------------------------------------------------- -->

Let's start by declaring a new class named `"Foo"`:

```lua
local lwtk = require("lwtk")
local Foo = lwtk.newClass("Foo")
```

The new class `Foo` is actually a Lua table that has `lwtk.Class` as metatable.
Its `tostring` value is the class name `"Foo"` and `lwtk.type()` evaluates to `"lwtk.Class"`:

```lua
assert(type(Foo) == "table")
assert(getmetatable(Foo) == lwtk.Class)
assert(tostring(Foo) == "Foo")
assert(lwtk.type(Foo) == "lwtk.Class")
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Instantiating Objects
<!-- ---------------------------------------------------------------------------------------- -->

Objects of a certain class are instantiated by calling the class:

```lua
local o1 = Foo()
local o2 = Foo()
```

The created objects are Lua tables that  have `Foo` as metatable. Their `tostring` value 
contains the class name `"Foo"` and `lwtk.type()` evaluates to `"Foo"`:

```lua
for _, o in ipairs{o1, o2} do
    assert(type(o) == "table")
    assert(getmetatable(o)  == Foo)
    assert(tostring(o):match("^Foo: [xa-fA-F0-9]+$")) -- e.g. "Foo: 0x55d1e35c2430"
    assert(lwtk.type(o) == "Foo")
end
assert(o1 ~= o2)
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Declaring Methods
<!-- ---------------------------------------------------------------------------------------- -->

Methods declared for the class table become methods for all objects of this type:

```lua
function Foo:setX(x)
    self._x = x
end
function Foo:getX(x)
    return self._x
end
o1:setX(100)
o2:setX(200)
assert(o1:getX() == 100)
assert(o2:getX() == 200)
assert(o1._x == 100)
assert(o2._x == 200)
```

The methods are retrieved by metatable lookup from the class:

```lua
assert(rawget(o1, "setX") == nil)
assert(rawget(Foo, "setX") == Foo.setX)
assert(o1.setX == Foo.setX)
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Declaring Derived Classes
<!-- ---------------------------------------------------------------------------------------- -->

Let's create a derived class named `"Bar"` that has `Foo` as super class:

```lua
local Bar = lwtk.newClass("Bar", Foo)

```

Every class declared by `lwtk.newClass()` has a super class, 
default super class is `lwtk.Object`:
```lua
assert(lwtk.getSuperClass(Bar) == Foo)
assert(lwtk.getSuperClass(Foo) == lwtk.Object)
assert(lwtk.getSuperClass(lwtk.Object) == nil)
```

The new class object is a Lua table, its `tostring` value is the class name `"Bar"`, 
`lwtk.type()` evaluates to `"lwtk.Class"` and has `lwtk.Class` as metatable:

```lua
assert(type(Bar) == "table")
assert(tostring(Bar) == "Bar")
assert(lwtk.type(Bar) == "lwtk.Class")
assert(getmetatable(Bar) == lwtk.Class)
```

The derived class contains the methods of the super class at the time when `newClass`
was invoked:

```lua
assert(rawget(Bar, "setX") == Foo.setX)
assert(rawget(Bar, "getX") == Foo.getX)
```

Methods declared for `Foo` after the creation of class `Bar` have no effect:

```lua
function Foo:setY(y)
    self._y = y
end
assert(Bar.setY == nil)
assert(Foo.setY ~= nil)
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Instantiating Derived Objects
<!-- ---------------------------------------------------------------------------------------- -->


Let's instantiate an object of the derived class `Bar`:

```lua
local o3 = Bar()
```

The created object is a Lua table, the `tostring` value contains the class name `"Bar"`, 
`lwtk.type()` evaluates to `"Bar"` and its metatable is `Bar`:


```lua
assert(type(o3) == "table")
assert(tostring(o3):match("^Bar: [xa-fA-F0-9]+$")) -- e.g. "Bar: 0x55d1e35c2430"
assert(lwtk.type(o3) == "Bar")
assert(getmetatable(o3) == Bar)
```

The created object has the methods of the super class:

```lua
assert(o3.setX == Foo.setX)
assert(o3.setY == nil)

o3:setX(300)
assert(o3:getX()== 300)
assert(o3._x == 300)
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
##   Overriding Methods
<!-- ---------------------------------------------------------------------------------------- -->

Methods declared for the derived class are only available for derived objects:


```lua
function Bar:addX(x)
    return self._x + x
end
assert(o2.addX == nil)
assert(o3.addX ~= nil)
assert(o3:addX(2) == 302)

```

Let's override the method `getX` for the derived class:

```lua
function Bar:getX()
    return 2 * Foo.getX(self) -- double the value from the super class
end
assert(o1:getX() == 100) -- invokes Foo.getX
assert(o3:getX() == 600) -- invokes Bar.getX
```


<!-- ---------------------------------------------------------------------------------------- -->
<!--lua
    print("Class.md: OK")
-->
