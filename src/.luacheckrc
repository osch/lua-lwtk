--
--[[
     luacheck `find lwtk -name "*.lua"|sort` --no-color --codes | less
--]]
--
-- option --codes to display codes
ignore = { 
	"611", "612", -- whitespace
        "613", -- whitespace in strings
        "614", -- trailing whitespace in a comment
        "631", -- line is too long
        "213", -- unused loop variable
        "212", -- unused argument
}


