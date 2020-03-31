local lwtk = require"lwtk"

return function()
    return lwtk.KeyBinding 
    {
        -- TODO: WIP just for playing around
        { "Ctrl+Right,Space,Space",    "FocusRight"         },
        { "F,Right", "FocusRight"         },
        { "Alt_L", "FocusRight"         },
        { "KP_Right", "FocusRight"         },

        { "Shift+Left",     "FocusLeft"          },
        { "KP_Left",  "FocusLeft"          },

        { "Up",       "FocusUp"            },
        { "KP_Up",    "FocusUp"            },

        { "Down",     "FocusDown"          },
        { "KP_Down",  "FocusDown"          },

        { "Space",    "FocusedButtonClick" },
    }
end

