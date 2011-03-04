--
-- Project: Objects By Name
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2011 Frank Siebenlist. All Rights Reserved.
-- 

require("NamedObjects")

require("NamedObjects-test")
require("NamedObjectsEvents-test")


--[[
print("start main")

function try()
	local a = {}
	NamedObjects.registerNameObject("a",a, "WeakContext")
end
try()

local b = {}
NamedObjects.registerNameObject("b",b, "WeakContext")
local c = {}
NamedObjects.registerNameObject("c",c, "WeakContext")
local d = {}
NamedObjects.registerNameObject("d",d, "WeakContext")
local e = {}
NamedObjects.registerNameObject("e",e, "WeakContext")

local function fF()
	local f = function() return end
	return f
end
NamedObjects.registerNameObject("fF",fF, "WeakContext")
NamedObjects.registerNameObject("fF()",fF(), "WeakContext")

NamedObjects.dump()

b = nil

print("b = nil - collectgarbage")
collectgarbage()
NamedObjects.dump()

c = nil

print("c = nil - collectgarbage")
collectgarbage()
NamedObjects.dump()

print("remove d by name")
NamedObjects.removeNameObject("name-d")
NamedObjects.dump()

print("remove e by object")
NamedObjects.removeNameObject(e)
NamedObjects.dump()

local myContext = {}
print("myContext",myContext)
NamedObjects.registerNameObject("context-1", {},myContext)
NamedObjects.registerNameObject("context-2", {},myContext)
NamedObjects.dump()

print("remove context-1 by name")
NamedObjects.removeNameObject("context-1")
NamedObjects.dump()

print("remove myContext by object")
--NamedObjects.removeNameObject(myContext)
myContext = nil
collectgarbage()
NamedObjects.dump()

print("display objects")

local do1 = display.newCircle( 100,100 , 30 )
do1.name = "do1"
NamedObjects.registerNameObject("do1",do1, "WeakContext")
NamedObjects.registerNameObject("do2",display.newCircle( 200,200 , 30 ), "WeakContext")
NamedObjects.getObject("do2").name = "do2"
print(NamedObjects.getObject("do2").name, NamedObjects.isDisplayObject(NamedObjects.getObject("do2")))
print("before remove",do1.name, NamedObjects.isDisplayObject(do1), do1.x, do1)
NamedObjects.dump()
do1:removeSelf()
do1 = nil
collectgarbage()
NamedObjects.getObject("do2"):setFillColor(100,200,150)
NamedObjects.getObject("do2"):removeSelf()
local o,oo = NamedObjects.getObject("do2")
if(o)then
	print(NamedObjects.getObject("do2").name, NamedObjects.isDisplayObject(NamedObjects.getObject("do2")))
else
	print("do2 is orphaned if you see a table ref:",o,oo)
end
--NamedObjects.getObject("do2"):setFillColor(200,200,250)
--print("after remove",do1.name, NamedObjects.isDisplayObject(do1), do1.x, do1)
NamedObjects.dump()

NamedObjects.registerNameObject("p1",display.newCircle( 400,400 , 50 ),NamedObjects)
NamedObjects.registerNameObject("p2",display.newCircle( 400,400 , 50 ),NamedObjects)
NamedObjects.registerNameObject("p3",display.newCircle( 400,400 , 50 ),NamedObjects)
NamedObjects.registerNameObject("p4",display.newCircle( 400,400 , 50 ),NamedObjects)
NamedObjects.dump()
local dos = NamedObjects.removeNameObjectContext(NamedObjects)
NamedObjects.dump()
for i,o in ipairs(dos)do o:removeSelf() end
dos = nil
collectgarbage()
NamedObjects.dump()

print("end main")
--]]