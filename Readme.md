NamedObjects - name-object and object-name mapping facility
===========================================================

This NamedObjects facility manages the name-object and object-name mapping in weak-tables or
in tables depending on a context-object's existence. As a result, the management should therefor
be more "garbage-collection friendly" at the cost of having to understand in what context
your objects live.

When you try to link sprites to event-handlers, and state-changes to changeState-handlers, 
and buttons to button-handlers, etc., and you want to keep as much of your code outside of the 
hard-coded imperative Lua, and in declarative config files and GUI-properties, then you soon 
will try to work with string-name abstractions that have to map to your objects and handlers
during runtime. The danger with those mappings is that they will normally hold-on to object
references and therefor make the garbage collection less effective (...understatement...).

One issue that remains is that the mapping entries of deleted objects will remain in the tables 
until the garbage collector kicks in - when the latter happens is unpredictable.

Therefor, when the program logic relies on it, one has to explicitly remove mapping entries,
even though those entries would be removed automagically by the garbage collector at some 
unknown time in the future. In other words, this facility only solves the issue of preventing
the garbage collector to do its work, but coders still have to worry about deleted references
for application logic - call removeNameObject() explicitly if you know an object is removed, 
or use the same call to delete all name-object mappings associated with a context.

The module is also "Corona-aware" and will recognize display objects as they are registered. 
Those display objects will transparently be auto-registered as "display objects", and this will 
be used to check whether the caller asks for a resolution of an already removeSelf()'ed object,
as display objects can be deleted by the Corona runtime, but a table-instance orphan will remain
as long as it's not garbage collected. Asking for such an orphaned object by name will return nil
instead of the orphan to avoid any subsequent erroneous processing. 

Best practices: always NamedObjects.registerDisplayObject(aDisplayObject)
(doesn't cost much - a few bytes only - registration is cleaned up with GC - allows DO-orphan detection)




globalEventHandlerFactory(eventTarget, eventName, anObject, aSelfEventHandler)
globalEventHandlerFactory(Runtime, "enterFrame", do1, maxSpeed)

localEventHandlerFactory(anObject, eventName, aSelfEventHandler)
localEventHandlerFactory(do1, "enterFrame", maxSpeed)

localTableEventHandlerFactory(eventTarget, eventName, anObject)
localTableEventHandlerFactory(Runtime, "enterFrame", do1)
do1["enterFrame"] = localTableEventHandler
-- forward global events to local object


event.name - string identifying the event, like "enterFrame", "collision"


event.object1 & event.object2 - two objects involved in a "collision" event

crate1.preCollision = onLocalPreCollision
crate1:addEventListener( "preCollision", crate1 )
self & event.other for table listener

event.target & event.other for local collision handler

event.source - the registration info timer.cancel(event.source)

event.target - the object to whom the event was sent

event.other

Collision sequence:
First table handler
Second list of object handlers
third list of global handlers

An object's state has a name and a list of event-handlers associated with that state-name
A state-change will remove any event-handlers that are not part of the new state and add those that are from the new state only.

Also associated with an object's state is a sprite-sequence name. A state change will turn on the new sprite-sequence.

tableHandler - target, eventName, object.eventName=tableHandler(self,event), target:addEventListener(eventName,object)
crate2:addEventListener( "collision", crate2 )

runtimeTableToLocalHandler

localHandlers - eventName, localHandler(event)
object:addEventListener(eventName,localHandler)
crate2:addEventListener( "collision", onCollision )

globalHandlers - target, eventName, globalHandler(event)
target:addEventListener(eventName,globalHandler)
Runtime:addEventListener( "enterFrame", onEnterFrame )



timerHandlers - timer, handlerFunction(event), delay, 