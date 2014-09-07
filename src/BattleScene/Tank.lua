require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- 坦克继承C++的Sprite对象
local Tank = class("Tank",function()
    return cc.Sprite:create()
end)

-- 坦克创建
function Tank.create()
    local tank = Tank.new()
    return tank
end

-- 定义坦克属性
-- ##########################################
Tank.TankState = {RUN = 1, STOP =2, DEATH =3}
Tank._pic = "tank.png"

Tank._hp = 0 -- 血量
function Tank:getHp()
    return self._hp
end
function Tank:setHp(hp)
    self._hp = hp
end

Tank._speed = 0.7 -- 移动速度
function Tank:getSpeed()
    return self._speed
end
function Tank:setSpeed(speed)
    self._speed = speed
end

Tank._direction = cc.p(0, 1) -- 移动方向
function Tank:getDirection()
    return self._direction
end
function Tank:setDirection(direction)
    self._direction = direction
end

Tank._shootLength = 50 -- 炮弹射程
function Tank:getShootLength()
    return self._shootLength
end
function Tank:setShootLength(shootLength)
    self._shootLength = shootLength
end

Tank._physicsType = 1 -- 物理类别
function Tank:getPhysicsType()
    return self._physicsType
end
function Tank:setPhysicsType(physicsType)
    Tank._physicsType = physicsType
end
 
Tank._physicsContact = {4,} -- 接收物理类别回调
Tank._physicsCollision = {2,} -- 接收物理类别碰撞

Tank._state = Tank.TankState.STOP -- 状态
-- ##########################################

-- 定义坦克方法
-- ##########################################
-- 坦克构造
function Tank:ctor()
    -- 初始化图片
    self:setTexture(self._pic)
    -- 创建物理body   
    local body = cc.PhysicsBody:createBox(
        cc.size(self:getContentSize().width*self:getScale(), 
        self:getContentSize().height*self:getScale()))
    -- 设置物理类别
    body:setCategoryBitmask(getBitmaskByNum(self._physicsType))
    -- 设置碰撞触发回调bitmask
    --cclog("bitmask %d", getBitmaskByTable(self._physicsContact))
    body:setContactTestBitmask(getBitmaskByTable(self._physicsContact)) 
    -- 设置碰撞bitmask
    body:setCollisionBitmask(getBitmaskByTable(self._physicsCollision))  
    body:setDynamic(true)    
    self:setPhysicsBody(body)
end

-- 坦克停止移动
function Tank:stop()
    self:changeState(Tank.TankState.STOP)
end

-- 改变状态
function Tank:changeState(state)
    -- 精灵已经被击倒（Game Over），就不能再出发其他动作了
    if (self._state == Tank.TankState.DEATH) then
        return false
    end
    
    -- 精灵已经处于要改变的状态，就没必要在改变了
    if (self._state == state) then
        return false
    end
    
    self._state = state
end

-- 移动
function Tank:move()
    self:changeState(Tank.TankState.RUN)
end

function Tank:dead()
    self:changeState(Tank.TankState.DEATH)
end

-- 更新
function Tank:tankUpdate()
    if (self._hp <= 0) then
        self:dead()
    end
    
    if (self._state == Tank.TankState.RUN) then       
        local startPosX, startPosY = self:getPosition()
        local velocity = cc.pMul(cc.pNormalize(self._direction), self._speed)
        local curPos = cc.pAdd(velocity, {x=startPosX, y=startPosY})
        self:setRotation(90 - math.deg(cc.pToAngleSelf(self._direction)))
        self:setPosition(curPos)
    elseif (self._state == Tank.TankState.STOP) then
        --
    elseif (self._state == Tank.TankState.DEATH) then
        --
    end
end


return Tank