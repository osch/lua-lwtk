local lwtk = require"lwtk"

return function()
    return lwtk.KeyBinding 
    {
        { "F,Right",           "FocusRight"   }, -- TODO: WIP just for playing around
        { "Ctrl+F,Left,Space", "FocusLeft"    }, -- TODO: WIP just for playing around
        
        
        { "Tab",      "FocusNext"          },
        { "Shift+Tab","FocusPrev"          },
        
        { "Right",
          "KP_Right", "FocusRight"         },

        { "Left", 
          "KP_Left",  "FocusLeft"          },

        { "Up", 
          "KP_Up",    "FocusUp"            },

        { "Down",
          "KP_Down",  "FocusDown"          },

        { "Return",
          "KP_Enter",
          "Space",    "FocusedButtonClick" },

        { "Right",
          "KP_Right", "CursorRight"         },

        { "Left", 
          "KP_Left",  "CursorLeft"          },

    }
end

