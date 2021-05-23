# lwtk.Application

TODO

<!-- ---------------------------------------------------------------------------------------- -->
##   Contents
<!-- ---------------------------------------------------------------------------------------- -->

   * [Application Methods](#application-methods)
        * [Application:runEventLoop()](#Application_runEventLoop)
        * [Application:update()](#Application_update)

<!-- ---------------------------------------------------------------------------------------- -->


<!-- ---------------------------------------------------------------------------------------- -->
##   Application Methods
<!-- ---------------------------------------------------------------------------------------- -->

* <a id="Application_runEventLoop">**`         Application:runEventLoop(timeout)
  `**</a>

  Update by processing events from the window system.

  * *timeout*  - optional float, timeout in seconds  

  If *timeout* is given, this function will process events from the window system until
  the time period in seconds has elapsed or until all window objects have been closed.

  If *timeout* is `nil` or not given, this function will process events from the window system
  until all window objects have been closed.
  
<!-- ---------------------------------------------------------------------------------------- -->

* <a id="Application_update">**`               Application:update(timeout)
  `**</a>

  Update by processing events from the window system.

  * *timeout*  - optional float, timeout in seconds  

  If *timeout* is given, this function will wait for *timeout* seconds until
  events from the window system become available. If *timeout* is `nil` or not
  given, this function will block indefinitely until an event occurs.

  As soon as events are available, all events in the queue are processed and this function 
  returns `true`.
  
  If *timeout* is given and there are no events available after *timeout*
  seconds, this function will return `false`.
  
<!-- ---------------------------------------------------------------------------------------- -->

<!--lua
    print("Application.md: OK")
-->
