# Function lwtk.type

   * **`type(arg)`**

     Returns the type name.
     
      * If *arg* is of type *"table"* or *"userdata"* and has a metatable of 
        type *"table"* with a field *"__name"*, than the value of this field 
        is returned.
     
      * If *arg* is of type *"table"* or *"userdata"* and has a metatable of 
        type *"string"*, than this string value is returned.
        
      * In all other cases this functions returns the same value, as the
        builtin Lua function *type()* would return.
