local lwtk = require"lwtk"

local Group = lwtk.Group

assert(tostring(lwtk.Button) == "lwtk.Button")
assert(tostring(lwtk.Button()):match("^lwtk.Button: [x0-9A-Fa-f]+$"))
local ok, err = pcall(function() lwtk.Button()() end)
assert(not ok and err:match("attempt to call a lwtk.Button value"))

local MyButton = lwtk.newClass("MyButton", lwtk.Widget)
do
    function MyButton:setText(text)
        self.text = text
        self:triggerRedraw()
    end
end

assert(tostring(MyButton) == "MyButton")
assert(tostring(MyButton()):match("^MyButton: [x0-9A-Fa-f]+$"))

local g1 = Group {
    MyButton {
        id = "b1",
        text = "B1"
    },
    MyButton {
        id = "b2",
        text = "B2"
    }
}

assert(g1.child.b2.text == "B2")
assert(g1.child.b2:getRoot() == g1)
assert(g1.child.b2:getRoot() == g1)
assert(g1.child.b2:getRoot().child.b1.text == "B1")
assert(g1:getRoot() == g1)
assert(g1:getRoot() == g1)

local g2 = Group {
    g1
}

assert(g1.child.b2:getRoot() == g2)
assert(g1.child.b2:getRoot() == g2)
assert(g2.child.b2:getRoot() == g2)

print("OK.")
