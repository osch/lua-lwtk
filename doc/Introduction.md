# lwtk Introduction

The lwtk root module has the name `lwtk`. All other lwtk modules are submodules
of this root module.
   
Submodules are loaded automatically on demand by simply accessing 
the submodule name  in the parent module, e.g.:
```lua
    local lwtk = require("lwtk")
    assert(lwtk.Color == require("lwtk.Color"))
    assert(lwtk.lpugl == require("lwtk.lpugl"))
    assert(lwtk.love.Application == require("lwtk.love.Application"))
```

See also [Module Index](./gen/modules.md) for a list of all lwtk modules.

Most lwtk modules are objects (more precisely: Lua tables with metatables) derived 
from one of the three type objects [lwtk.Meta], [lwtk.Class] and [lwtk.Mixin]. 
The therefore derived module objects are having the corresponding type object 
as metatable.

Further details:
   * [lwtk.Meta Usage](Meta.md)
   * [lwtk.Class Usage](Class.md)
   * [lwtk.Mixin Usage](Mixin.md)
   

[lwtk.Meta]:  ./gen/lwtk/Meta.md
[lwtk.Class]: ./gen/lwtk/Class.md
[lwtk.Mixin]: ./gen/lwtk/Mixin.md



<!-- ---------------------------------------------------------------------------------------- -->
<!--lua
    print("Modules.md: OK")
-->
