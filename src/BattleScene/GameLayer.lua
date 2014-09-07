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
    local MyTankClass = require("BattleScene/MyTank")
    -- 我方坦克初始化
    MyTankClass._pic = "tank.png"
    MyTankClass._hp = 100 -- 血量
    MyTankClass._speed = 1 -- 移动速度
    MyTankClass._shootLength = 100 -- 炮弹射程
    MyTankClass._physicsType = 1 -- 物理类别
    MyTankClass._physicsContact = {4,} -- 接收物理类别回调
    MyTankClass._physicsCollision = {2,} -- 接收物理类别碰撞
    --MyTankClass._isReadyForShoot = true
    -- #############################################  
    
    local EnemyTankClass = require("BattleScene/Tank")
    -- 敌方坦克初始化
    EnemyTankClass._pic = "tankEnemy.png"
    EnemyTankClass._hp = 1 -- 血量
    EnemyTankClass._speed = 0.5 -- 移动速度
    EnemyTankClass._shootLength = 50 -- 炮弹射程
    EnemyTankClass._physicsType = 2 -- 物理类别
    EnemyTankClass._physicsContact = {3,} -- 接收物理类别回调
    EnemyTankClass._physicsCollision = {1,} -- 接收物理类别碰撞
    -- #############################################  

    self._explodeBatchNode = cc.SpriteBatchNode:create("explode.png")
    self._explodeBatchNode:setPosition(0,0)
    self:addChild(self._explodeBatchNode, 3)
        
    self._tank = MyTankClass.create()
    self._tank:setPosition(visibleRect.xMid, visibleRect.yMid)
    self._tankDistory = 0
    self._tank:setScale(0.5)
    self:addChild(self._tank, 2)
    
    self._enemyTanks = {}
    self._enemyTanksNum = 0
    setmetatable(self._enemyTanks, {__mode = "v"})  
    
    self._label = cc.LabelTTF:create("", "Arial", 30)
    self._label:setPosition(visibleRect.xMid, visibleRect.yMax - 50)
    self:addChild(self._label, 3)
      

    local time = 0
    local function update(dt)
        time = time + dt 
        self._tank:tankUpdate(self)
        local str = "hp[" .. self._tank._hp .. "] distory[" .. self._tankDistory .. "]"
        self._label:setString(str)

        if (time > 3 and self._enemyTanksNum < 5) then
            time = 0
            local function enemyRandomPos()
                if (math.random(1,4) == 1) then
                    -- y轴上方
                    return math.random(visibleRect.x, visibleRect.xMax), visibleRect.yMax - 20
                elseif (math.random(1,4) == 2) then
                    -- y轴下方
                    return math.random(visibleRect.x, visibleRect.xMax), visibleRect.y + 20
                elseif (math.random(1,4) == 3) then
                    -- x轴左方
                    return visibleRect.x + 20, math.random(visibleRect.y, visibleRect.yMax)
                else
                    -- x轴右方
                    return visibleRect.xMax - 20, math.random(visibleRect.y, visibleRect.yMax)
                end
            end
            local enemyTank = EnemyTankClass.create()
            enemyTank:setPosition(enemyRandomPos())
            local myTankPos = {x=self._tank:getPositionX(), y=self._tank:getPositionY()}
            local enemyTankPos = {x=enemyTank:getPositionX(), y=enemyTank:getPositionY()}
            enemyTank:setDirection(cc.pSub(myTankPos, enemyTankPos))
            enemyTank:setScale(0.5)
            self:addChild(enemyTank)
            table.insert(self._enemyTanks, enemyTank)
            self._enemyTanksNum = self._enemyTanksNum + 1             
        end
        
        for i, enemyTank in pairs(self._enemyTanks) do
            enemyTank:tankUpdate()
            if (enemyTank._state == 3) then
                enemyTank:removeFromParent()
                self._enemyTanksNum = self._enemyTanksNum - 1
                self._enemyTanks[i] = nil
                self._tankDistory = self._tankDistory + 1
            else
                local myTankPos = {x=self._tank:getPositionX(), y=self._tank:getPositionY()}
                local enemyTankPos = {x=enemyTank:getPositionX(), y=enemyTank:getPositionY()}
                enemyTank:setDirection(cc.pSub(myTankPos, enemyTankPos))
                
                if (math.random(0, 5) == 1) then
                    enemyTank:move()
                else
                    enemyTank:stop()
                end
            
                if (math.random(0, 200) == 1) then
                    -- cclog("dump: %s", self._bulletLayer)
                    self._bulletLayer:addEnemyBullet(enemyTank:getPositionX(), 
                        enemyTank:getPositionY(), enemyTank:getDirection(), 80)
                end
           end
        end
    end
    self:scheduleUpdateWithPriorityLua(update, 0) 
    
    local function onContactBegin(contact)
        local a = contact:getShapeA():getBody()                                                                                 
        local b = contact:getShapeB():getBody()
        
        local function contactDo(a, b)
            if (a:getCategoryBitmask() == 0x04 and b:getCategoryBitmask() == 0x02) then
                -- 我方子弹击中敌方坦克
                a:getNode():setVisible(false)
                b:getNode()._hp = b:getNode()._hp - 1
                self:addExplode(b:getNode():getPosition())
            end
            
            if (a:getCategoryBitmask() == 0x08 and b:getCategoryBitmask() == 0x01) then
                -- 敌方子弹击中我方坦克
                a:getNode():setVisible(false)
                b:getNode()._hp = b:getNode()._hp - 1
                self:addExplode(b:getNode():getPosition())
            end
        end
        
        contactDo(a, b)
        contactDo(b, a)

        return true                                                                                                             
    end 
       
    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, self)
  
end

function GameLayer:addExplode(x, y)
    local explode = cc.Sprite:createWithTexture(self._explodeBatchNode:getTexture())
    explode:setPosition(x, y)
    self._explodeBatchNode:addChild(explode)

    local actionFadeOut= cc.FadeOut:create(2)

    local function removeBullet()
        self._explodeBatchNode:removeChild(explode, true)
    end

    local actionDone = cc.CallFunc:create(removeBullet)
    local sequence = cc.Sequence:create(actionFadeOut, actionDone)
    explode:runAction(sequence)

end

return GameLayer
