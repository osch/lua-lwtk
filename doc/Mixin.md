# lwtk.Mixin Usage

[lwtk.Mixin] objects can be used to inject reusable functionality into new [lwtk.Class] 
objects.

[lwtk.Meta]:  ./gen/lwtk/Meta.md
[lwtk.Class]: ./gen/lwtk/Class.md
[lwtk.Mixin]: ./gen/lwtk/Mixin.md

<!-- ---------------------------------------------------------------------------------------- -->
##   Contents
<!-- ---------------------------------------------------------------------------------------- -->

   * [Creating Mixins](#creating-mixins)
   * [Deriving Classes from Mixins](#deriving-classes-from-mixins)
   * [First Example](#first-example)
   * [Referring to Superclasses](#referring.to-superclasses)

<!-- ---------------------------------------------------------------------------------------- -->
##   Creating Mixins
<!-- ---------------------------------------------------------------------------------------- -->

Let's start by creating a new mixin object named `"Foo"`:

```lua
local lwtk = require("lwtk")
local Foo = lwtk.newMixin("Foo")
```

The new mixin object `Foo` is actually a Lua table that has [lwtk.Mixin] as metatable.
Its `tostring` value is `"lwtk.Mixin<Foo>"` and *[lwtk.type()]* evaluates to `"lwtk.Mixin"`:

[lwtk.type()]: ./gen/lwtk/type.md

```lua
assert(type(Foo) == "table")
assert(getmetatable(Foo) == lwtk.Mixin)
assert(tostring(Foo) == "lwtk.Mixin<Foo>")
assert(lwtk.type(Foo) == "lwtk.Mixin")
```
<!--lua
assert(getmetatable(Foo).__name == "lwtk.Mixin")
-->

The mixin object's name is only used for debugging purposes: it is allowed to create two 
different mixin objects with the same name (although this is not recommended):

```lua
local Foo2 = lwtk.newMixin("Foo")
assert(Foo ~= Foo2)
assert(tostring(Foo) == tostring(Foo2))
```

<!-- ---------------------------------------------------------------------------------------- -->
##   Deriving Classes from Mixins
<!-- ---------------------------------------------------------------------------------------- -->

A new class is created by calling the mixin object:

```lua
local C1 = Foo()
assert(lwtk.type(C1) == "lwtk.Class")
assert(tostring(C1) == "lwtk.Class<Foo()>")
```
This call is cached, i.e. calling the mixin object again leads to the same class object:

```lua
assert(C1 == Foo())
```

Objects derived by calling the class have as type name the name `Foo()`:

```lua
local o1 = C1()
assert(lwtk.type(o1) == "Foo()")
assert(tostring(o1):match("^Foo%(%): [xa-fA-F0-9]+$")) -- e.g. "Foo(): 0x55d1e35c2430"
assert(o1:getClass() == C1)
assert(o1:getSuperClass() == lwtk.Object)
```

A base class may be given to the mixin object's call to derive a new class with the 
base class as superclass:

```lua
local Base = lwtk.newClass("Base")
local C2 = Foo(Base)
assert(lwtk.type(C2) == "lwtk.Class")
assert(tostring(C2) == "lwtk.Class<Foo(Base)>")
assert(C2 == Foo(Base))
assert(C2:getSuperClass() == Base)
```

```lua
local o2 = C2()
assert(lwtk.type(o2) == "Foo(Base)")
assert(tostring(o2):match("^Foo%(Base%): [xa-fA-F0-9]+$")) -- e.g. "Foo(Base): 0x55d1e35c2430"
assert(o2:getClass() == C2)
assert(o2:getSuperClass() == Base)
```

The mixin class name is marked with a `#` character in the class path:

```lua
assert(C1:getClassPath() == "#Foo(lwtk.Object)")
assert(C2:getClassPath() == "#Foo(Base(lwtk.Object))")
```

<!-- ---------------------------------------------------------------------------------------- -->
##   First Example
<!-- ---------------------------------------------------------------------------------------- -->

```lua
local Base1 = lwtk.newClass("Base1")
local Base2 = lwtk.newClass("Base2")

local Colored = lwtk.newMixin("Colored")
do
    Colored.color = false
    function Colored:setColor(c)
        self.color = c
    end
    function Colored:getColor(c)
        return self.color
    end
end

local Sub1 = lwtk.newClass("Sub1", Colored(Base1))
local Sub2 = lwtk.newClass("Sub2", Colored(Base2))

assert(Sub1:getClassPath() == "Sub1(#Colored(Base1(lwtk.Object)))")
assert(Sub2:getClassPath() == "Sub2(#Colored(Base2(lwtk.Object)))")

local s1 = Sub1()
local s2 = Sub2()

s1:setColor("red")
assert(s1:getColor() == "red")

s2:setColor("blue")
assert(s2:getColor() == "blue")

assert(Sub1:getSuperClass() == Colored(Base1))

```
<!--lua
assert(Sub1:getReverseClassPath() == "/lwtk.Object/Base1/#Colored/Sub1")
assert(Sub2:getReverseClassPath() == "/lwtk.Object/Base2/#Colored/Sub2")
-->

<!-- ---------------------------------------------------------------------------------------- -->
##   Referring to Superclasses
<!-- ---------------------------------------------------------------------------------------- -->

The effective superclass is unknown at the time when a new mixin object is created. A function
may be given to `lwtk.newMixin()` that is called when the mixin object is called to create
a new class object. This function is called with the concrete derived class object and 
the superclass:

```lua
local MyMixin = lwtk.newMixin("MyMixin", 
    function(MyMixin, Super)
    	assert(lwtk.type(MyMixin) == "lwtk.Class")
    	assert(tostring(MyMixin):match("^lwtk.Class<MyMixin%(.*%)>$"))
        function MyMixin.override:getX()
            return 1000 + Super.getX(self)
        end
    end
)
function MyMixin:getY()
    return 2000
end
function Base1:getX()
    return 10
end
function Base2:getX()
    return 20
end
local Class1 = lwtk.newClass("Class1", MyMixin(Base1))
local Class2 = lwtk.newClass("Class2", MyMixin(Base2))
local c1 = Class1()
local c2 = Class2()
assert(c1:getX() == 1010)
assert(c2:getX() == 1020)
assert(c1:getY() == 2000)
assert(c2:getY() == 2000)
```


<!-- ---------------------------------------------------------------------------------------- -->
<!--lua
    print("Mixin.md: OK")
-->

