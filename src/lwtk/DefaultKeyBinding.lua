local lwtk = require"lwtk"

return function()
    return lwtk.KeyBinding 
    {
        { "Ctrl+F,Right",      "FocusRight"   }, -- TODO: WIP just for playing around
        { "Ctrl+F,Left",       "FocusLeft"    }, -- TODO: WIP just for playing around
        
        
        { "Tab",      "FocusNext"          },
        { "Shift+Tab","FocusPrev"          },
        
        { "Right",
          "Alt+Right",
          "KP_Right", "FocusRight"         },

        { "Left", 
          "Alt+Left",
          "KP_Left",  "FocusLeft"          },

        { "Up", 
          "Alt+Up",
          "KP_Up",    "FocusUp"            },

        { "Down",
          "Alt+Down",
          "KP_Down",  "FocusDown"          },

        { "Return",
          "KP_Enter",
          "Space",    "FocusedButtonClick" },

        { "Right",
          "KP_Right", "CursorRight"         },

        { "Left", 
          "KP_Left",  "CursorLeft"          },
        
        { "Backspace",
                      "DeleteCharLeft"      },

        { "Delete",
                      "DeleteCharRight"     },

        { "Home",
                      "CursorToBeginOfLine" },

        { "End",
                      "CursorToEndOfLine"   },

        { "Return",
          "KP_Enter",
                      "InputNext"           },
        { "Shift+Return",
          "Shift+KP_Enter",
                      "InputPrev"           },

        { "Return",
          "KP_Enter",
                      "DefaultButton"       },
        
        { "Escape",
          "Alt+Escape",
          "Shift+Escape",
          "Ctrl+Escape",
                      "CloseWindow"         },
                      
        { "Return",
          "Space",
          "KP_Enter",
                      "EnterFocusGroup"     },

        { "Escape",
                      "ExitFocusGroup"     },
    }
end

