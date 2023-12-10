local lwtk = require"lwtk"


local Node = lwtk.newMixin("lwtk.Node")

Node:declare(
    "_processMouseEnter",
    "onMouseEnter",
    "_processMouseLeave",
    "onMouseLeave",
    "_processMouseMove",
    "onMouseMove",
    "_processMouseScroll",
    "onMouseScroll",
    "_processMouseDown",
    "onMouseDown",
    "_processMouseUp",
    "onMouseUp",
    "onInputChanged"
)


return Node
