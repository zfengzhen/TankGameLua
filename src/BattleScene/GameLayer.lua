require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local GameLayer = class("GameLayer",function()
    return cc.Layer:create()
end)

function GameLayer.create()
    local layer = GameLayer.new()
    return layer
end

function GameLayer:ctor()
    local tank = require("BattleScene/Tank")
    self._tank = tank.create()
    self._tank:setPosition(visibleRect.xMid, visibleRect.yMid)
    self:addChild(self._tank, 2)
    
    self._enemyTanks = {}
    setmetatable(self._enemyTanks, {__mode = "v"})   
      

    local dt = 1
    local function update()
        dt = dt + 1 
        self._tank:moveUpdate()
        if (dt % 120 == 0) then
            dt = 1
            local enemyTank = tank.create()
            enemyTank:getPhysicsBody():setCollisionBitmask(3)
            enemyTank:setPosition(math.random(visibleRect.x, visibleRect.xMax),
                 math.random(visibleRect.y, visibleRect.yMax))
            enemyTank:setRotation(math.random(0, 360))
            enemyTank:setScale(0.5)
            self:addChild(enemyTank)
            table.insert(self._enemyTanks, enemyTank)             
        end
    end
    self:scheduleUpdateWithPriorityLua(update, 0) 
    
    local function onContactBegin(contact)
        local a = contact:getShapeA():getBody():getNode()                                                                                 
        local b = contact:getShapeB():getBody():getNode()
        if (a == self._tank or b == self._tank) then
            return false
        end

        a:removeFromParent()
        b:removeFromParent()

        return true                                                                                                             
    end 
       
    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, self)
  
end

return GameLayer
