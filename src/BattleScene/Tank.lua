require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local Tank = class("Tank",function()
    return cc.Sprite:create()
end)

-- 坦克状态
local TankState = {RUN = 1, STOP =2, DEATH =3}

-- 坦克创建
function Tank.create()
    local tank = Tank.new()
    return tank
end

function Tank:ctor()
    -- 初始化图片
    self:setTexture("tank.png")
    -- 设置旋转角度
    self._rotateDeg = 0
    self:setRotation(self._rotateDeg)
    -- 设置坦克状态
    self._state = TankState.STOP
    -- 设置坦克速度
    self:setSpeed(0.7)
    -- 创建物理body   
    self._body = cc.PhysicsBody:createBox(
        cc.size(self:getContentSize().width*self:getScale(), 
        self:getContentSize().height*self:getScale()))
    -- 设置物理类别
    self._body:setCategoryBitmask(0x02)
    -- 设置碰撞触发回调bitmask
    self._body:setContactTestBitmask(0x01) 
    -- 设置碰撞bitmask
    self._body:setCollisionBitmask(0x02)  
    self._body:setDynamic(true)    
    self:setPhysicsBody(self._body)
end

-- 设置坦克移动速度
function Tank:setSpeed(speed)
    self._speed = speed
end

-- 设置旋转角度
function Tank:setRotateDeg(deg)
    self._rotateDeg = deg
end

-- 坦克停止移动
function Tank:stop()
    self._state = TankState.STOP
end

-- 改变状态
function Tank:changeState(state)
    -- 精灵已经被击倒（Game Over），就不能再出发其他动作了
    if (self._state == TankState.DEATH) then
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
    self:changeState(TankState.RUN)
end

-- 移动更新
function Tank:moveUpdate()
    if (self._state ~= TankState.RUN) then
        return
    end
    
    local startX = self:getPositionX()
    local startY = self:getPositionY()
    local deg = self._rotateDeg % 360
    local curX, curY = moveByDeg(startX, startY, self._speed, deg)

    self:setRotation(deg)   
    self:setPosition(curX, curY)
end


return Tank