local NamedObjects = require("NamedObjects")
local NamedEventHandlers = require("NamedEventHandlers")
json = require("cadkjson")
local pp = json.pp
local ppdb = json.ppdb

print("NamedObjects-test")


local c1,c2,c3
c1 = display.newCircle( 200,200 , 50 )
c1:setFillColor(math.random(255),math.random(255),math.random(255))
NamedObjects.registerNameObject("c1",c1,NamedObjects)
c2 = display.newCircle( 300,300 , 25 )
c2:setFillColor(math.random(255),math.random(255),math.random(255))
NamedObjects.registerNameObject("c2",c2,NamedObjects)
c3 = display.newCircle( 240,300 , 15 )
c3:setFillColor(math.random(255),math.random(255),math.random(255))
NamedObjects.registerNameObject("c3",c3,NamedObjects)

function mytimerCrashing(self, event)
	print( "self-timer-handler called for:"..(NamedObjects.getName(self) or "nil"), NamedObjects.isDisplayObject(self) )
	self:setFillColor(math.random(255),math.random(255),math.random(255),math.random(255))
	self.x = math.random(300); c1.y = math.random(500)
end

function mytimer(self, event)
--	if(NamedObjects.isDisplayObjectOrphan(self))then timer.cancel(event.source); return end
	print( "self-timer-handler called for:"..(NamedObjects.getName(self) or "nil"), NamedObjects.isDisplayObject(self) )
	if(NamedObjects.isDisplayObjectOrphan(self)) then
		print("metatable display,timer,e.source  ",getmetatable(display),getmetatable(timer),getmetatable(event.source))
		ppdb("timer",timer)
		ppdb("event.source",event.source)
		timer.cancel(event.source)
		print("timer cancelled for "..(select(2,NamedObjects.getName(self)) or "nil"))
		return
	end
	self:setFillColor(math.random(255),math.random(255),math.random(255),math.random(255))
	self.x = math.random(300); c1.y = math.random(500)
end

function mytimer2(self, event)
	print("mytimer2:",type(self))
	print( "self-timer-handler called for:"..(NamedObjects.getName(self) or "nil"), NamedObjects.isDisplayObject(self) )
	self:setFillColor(math.random(255),math.random(255),math.random(255),math.random(255))
	self.x = math.random(300); c1.y = math.random(500)
end

--c1.timer = mytimerCrashing
c1.timer = mytimer
c2.timer = mytimer
 
timer.performWithDelay(1000, c1, 0)
timer.performWithDelay(1000, c2, 0)
timer.performWithDelay(750, NamedEventHandlers.timerHandlerFactory(c3,mytimer2), 0)

local function timerCanceller(self, event )
print( "timerCanceller called" )
	self:removeSelf()
end

function selfListenerF(self, afun)
	return function(e) return afun(self,e) end
end
 
--timer.performWithDelay(5000, listener )
timer.performWithDelay(5000, selfListenerF(c1, timerCanceller) )
timer.performWithDelay(7000, selfListenerF(c3, timerCanceller) )

nEnterFrameH = 0
local enterFrameH
enterFrameH = function(event)
	print( "enterFrameH called" ,enterFrameH, Runtime, Runtime["_functionListeners"]["enterFrame"][1])
	ppdb(event, Runtime)
	nEnterFrameH = nEnterFrameH + 1
	if(nEnterFrameH >= 1)then
		Runtime:removeEventListener( event.name, enterFrameH )
	end
end
Runtime:addEventListener("enterFrame", enterFrameH)

