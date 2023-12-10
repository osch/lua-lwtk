# Function lwtk.newClass

   * **`newClass(className, superClass, ...)`**

     Creates new class object. A class object has [lwtk.Class](../lwtk/Class.md) as metatable
     and [lwtk.type](../lwtk/type.md)() evaluates to `"lwtk.Class"`.
     
        * *className*  - string value
        * *superClass* - optional class object, if not given, [lwtk.Object](../lwtk/Object.md)
                         is taken as superclass.
        * *...*        - optional further arguments that are reached over
                         to [lwtk.Object.newSubClass()](../lwtk/Object.md#.newSubClass).
     
     See [lwtk.Class Usage](../../Class.md) for detailed documentation
     and usage examples.
