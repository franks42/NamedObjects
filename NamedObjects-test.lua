local NamedObjects = require("NamedObjects")
json = require("cadkjson")
local pp = json.pp
local ppdb = json.ppdb

print("NamedObjects-test")

-- we have NamedObjects.registerNameObjectand(aName,AnObject), NamedObjects.getObject(aName),
-- and NamedObjects.removeNameObject(aNameOrObject)
-- seems easy enough!

local t1
t1 = {["say"]="hello"}
NamedObjects.registerNameObject("t1",t1,"WeakContext")
NamedObjects.registerNameObject("t2",{"jaja"},NamedObjects)

local r
r = NamedObjects.getObject("t1")
print(r and r.say)
pp("NamedObjects.getAllNamesAllObjects",NamedObjects.getAllNamesAllObjects())
pp("NamedObjects.getAllNamesAllObjects2",(NamedObjects.getAllNamesAllObjects(NamedObjects)))
NamedObjects.removeNameObject("t1")
r = NamedObjects.getObject("t1")
print(r and r.say)

-- that was easy, no surprises, however... let's expand the example

t1 = {["say"]="hello"}
NamedObjects.registerNameObject("t1",t1,"WeakContext")
r = NamedObjects.getObject("t1")
print(r and r.say)
t1 = nil
r = nil
r = NamedObjects.getObject("t1")
print(r and r.say)
r = nil
collectgarbage()
r = NamedObjects.getObject("t1")
print(r and r.say)

-- so we lost our mapping object after the garbage collection ("gc")!
-- that is becaue the name-object mapping is stored in weak-table by default,
-- which implies that if there is no more explicit reference to the object,
-- and the garbage collector cleans up, the mapping entry will vanish automagically.
-- which is great and exactly what you want as this name-object system shouldn't
-- interfere with the gc.
--
-- however, note that when we ask for the object just before we explicitly kick the 
-- garbage collector into action, we have no explicit references left, which means that
-- although we obtained the object, we shouldn't have... the reason is that the time for 
-- the actual gc-cycle is not predictable.
-- In other words the system could give mapped objects back that were waiting for gc.
-- 
pp(NamedObjects.getAllNamesAllObjects())


