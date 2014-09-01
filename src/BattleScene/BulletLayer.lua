require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local BulletLayer = class("BulletLayer",function()
    return cc.Layer:create()
end)

function BulletLayer.create()
    local layer = BulletLayer.new()
    return layer
end

function BulletLayer:ctor()
    self._visibleSize = cc.Director:getInstance():getVisibleSize()
    self._origin = cc.Director:getInstance():getVisibleOrigin()

    self._bulletArray = {}
    setmetatable(self._bulletArray, {__mode = "v"})
    self._bulletBatchNode = cc.SpriteBatchNode:create("bullet.png")
    self._bulletBatchNode:setPosition(0,0)
    self._bulletBatchNode:setScale(1) 
    self:addChild(self._bulletBatchNode)
end

function BulletLayer:addNewBullet(x, y, direction)
    local newBullet = cc.Sprite:createWithTexture(self._bulletBatchNode:getTexture())
    newBullet:setPosition(x, y)
    self._bulletBatchNode:addChild(newBullet)
    
    local length = 2*self._visibleSize.width
    local velocity = 500 --飞行速度
    local moveTime = length/velocity
    local actionMove = nil
    
    if (direction.x == 0 and direction.y == 0) then
        actionMove = cc.MoveTo:create(moveTime, cc.p(x, 2*self._visibleSize.width))
        newBullet:setRotation(0)
    elseif (direction.y > 0 and direction.x == 0) then
        actionMove = cc.MoveTo:create(moveTime, cc.p(x, 2*self._visibleSize.width))
        newBullet:setRotation(0)
    elseif (direction.y < 0 and direction.x == 0) then
        actionMove = cc.MoveTo:create(moveTime, cc.p(x, 0))
        newBullet:setRotation(180)
    else
        local deg = math.deg(math.atan(direction.x/direction.y))       
        local slope = (direction.y) / (direction.x) 
        local curX = 0
        local curY = 0
        local radius = self._visibleSize.width
        if (direction.x > 0) then
            curX = radius/(math.sqrt(slope*slope +1)) + x
        else
            curX = -radius/(math.sqrt(slope*slope +1)) + x
        end
    
        if (direction.y > 0) then
            curY = radius*math.abs(slope)/(math.sqrt(slope*slope +1)) + y
            newBullet:setRotation(deg)
        else
            curY = -radius*math.abs(slope)/(math.sqrt(slope*slope +1)) + y
            newBullet:setRotation(180+deg)
        end
        cclog("direction.x[%f] y[%f]", direction.x, direction.y)
        cclog("curX[%f] curY[%f]", curX, curY)
        actionMove = cc.MoveTo:create(moveTime, cc.p(curX, curY))
    end
    
    local function removeBullet()
        cclog("removeBullet")
        self._bulletBatchNode:removeChild(newBullet, true)
    end
    
    local actionDone = cc.CallFunc:create(removeBullet)
    local sequence = cc.Sequence:create(actionMove, actionDone)
    newBullet:runAction(sequence)
    
    table.insert(self._bulletArray, newBullet)
end

return BulletLayer