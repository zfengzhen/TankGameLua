require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- 创建子弹层
local BulletLayer = class("BulletLayer",function()
    return cc.Layer:create()
end)

function BulletLayer.create()
    local layer = BulletLayer.new()
    return layer
end

function BulletLayer:ctor()
    self._bulletArray = {}
    setmetatable(self._bulletArray, {__mode = "v"})
    self._bulletBatchNode = cc.SpriteBatchNode:create("bullet.png")
    self._bulletBatchNode:setPosition(0,0)
    self._bulletBatchNode:setScale(1) 
    self:addChild(self._bulletBatchNode)
end

-- 添加新的子弹
function BulletLayer:addNewBullet(x, y, deg)
    local newBullet = cc.Sprite:createWithTexture(self._bulletBatchNode:getTexture())
    newBullet:setPosition(x, y)
    local body = cc.PhysicsBody:createBox(
        cc.size(newBullet:getContentSize().width*newBullet:getScale(), 
            newBullet:getContentSize().height*newBullet:getScale()))
    body:setCategoryBitmask(0x01)
    body:setContactTestBitmask(0x02)
    body:setCollisionBitmask(0)   
    newBullet:setPhysicsBody(body)
    self._bulletBatchNode:addChild(newBullet)
    
    local length = 2*visibleRect.width
    local velocity = 500 --飞行速度
    local moveTime = length/velocity

    local curX, curY = moveByDeg(x, y, length, deg)
    newBullet:setRotation(deg) 
    local actionMove = cc.MoveTo:create(moveTime, cc.p(curX, curY))
    
    local function removeBullet()
        self._bulletBatchNode:removeChild(newBullet, true)
    end
    
    local actionDone = cc.CallFunc:create(removeBullet)
    local sequence = cc.Sequence:create(actionMove, actionDone)
    newBullet:runAction(sequence)
    
    table.insert(self._bulletArray, newBullet)
end

return BulletLayer