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
    self._myBulletArray = {}
    setmetatable(self._myBulletArray, {__mode = "v"})
    self._enemyBulletArray = {}
    setmetatable(self._enemyBulletArray, {__mode = "v"})
    self._bulletBatchNode = cc.SpriteBatchNode:create("bullet.png")
    self._bulletBatchNode:setPosition(0,0)
    self._bulletBatchNode:setScale(1) 
    self:addChild(self._bulletBatchNode)
end

-- 添加我方子弹
function BulletLayer:addMyBullet(x, y, direction, length)
    local myBullet = cc.Sprite:createWithTexture(self._bulletBatchNode:getTexture())
    myBullet:setPosition(x, y)
    myBullet:setScale(0.5)
    local body = cc.PhysicsBody:createBox(
        cc.size(myBullet:getContentSize().width*myBullet:getScale(), 
            myBullet:getContentSize().height*myBullet:getScale()))
    body:setCategoryBitmask(0x04)
    body:setContactTestBitmask(0x02)
    body:setCollisionBitmask(0)   
    myBullet:setPhysicsBody(body)
    self._bulletBatchNode:addChild(myBullet)
    
    -- local length = 2*visibleRect.width
    local speed = 200 --飞行速度
    local moveTime = length/speed
    
    local velocity = cc.pMul(cc.pNormalize(direction), length)
    local curPos = cc.pAdd(velocity, {x=x, y=y})
    myBullet:setRotation(90 - math.deg(cc.pToAngleSelf(direction)))
    local actionMove = cc.MoveTo:create(moveTime, cc.p(curPos.x, curPos.y))
    
    local function removeBullet()
        self._bulletBatchNode:removeChild(myBullet, true)
    end
    
    local actionDone = cc.CallFunc:create(removeBullet)
    local sequence = cc.Sequence:create(actionMove, actionDone)
    myBullet:runAction(sequence)
    
    table.insert(self._myBulletArray, myBullet)
end

-- 添加敌方子弹
function BulletLayer:addEnemyBullet(x, y, direction, length)
    local enemyBullet = cc.Sprite:createWithTexture(self._bulletBatchNode:getTexture())
    enemyBullet:setScale(0.5)
    enemyBullet:setPosition(x, y)
    local body = cc.PhysicsBody:createBox(
        cc.size(enemyBullet:getContentSize().width*enemyBullet:getScale(), 
            enemyBullet:getContentSize().height*enemyBullet:getScale()))
    body:setCategoryBitmask(0x08)
    body:setContactTestBitmask(0x01)
    body:setCollisionBitmask(0)   
    enemyBullet:setPhysicsBody(body)
    self._bulletBatchNode:addChild(enemyBullet)

    -- local length = 2*visibleRect.width
    local speed = 50 --飞行速度
    local moveTime = length/speed

    local velocity = cc.pMul(cc.pNormalize(direction), length)
    local curPos = cc.pAdd(velocity, {x=x, y=y})
    enemyBullet:setRotation(90 - math.deg(cc.pToAngleSelf(direction))) 
    local actionMove = cc.MoveTo:create(moveTime, cc.p(curPos.x, curPos.y))

    local function removeBullet()
        self._bulletBatchNode:removeChild(enemyBullet, true)
    end

    local actionDone = cc.CallFunc:create(removeBullet)
    local sequence = cc.Sequence:create(actionMove, actionDone)
    enemyBullet:runAction(sequence)

    table.insert(self._enemyBulletArray, enemyBullet)
end

return BulletLayer