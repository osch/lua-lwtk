# Function lwtk.isInstanceOf

   * **`isInstanceOf(self, C)`**

     Determines if object is instance of the given class.
     
     Returns *true*, if *self* is an object that was created by invoking class *C*
     or by invoking a subclass of *C*.
     
     Returns also *true* if *C* is a metatable of *self* or somewhere in the 
     metatable chain of *self*.
