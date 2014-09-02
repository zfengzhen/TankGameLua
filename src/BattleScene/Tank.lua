require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local Tank = class("Tank")
-- 坦克状态
local TankState = {RUN = 1, STOP =2, DEATH =3}

-- 坦克创建
function Tank.create()
    local tank = Tank.new()
    return tank
end

function Tank:ctor()
    self._tankHead = cc.Sprite:create("tankHead.png")
    self._tankBody = cc.Sprite:create("tankBody.png")
    self._tankHead:setScale(0.3)
    self._tankBody:setScale(0.3)
    self._tankHead:setAnchorPoint(cc.p(0.5, 0.35))
    self._moveDeg = 0
    self._shootDeg = 0
    self._state = TankState.STOP
    self._tankHead:setRotation(self._shootDeg)
    self._tankBody:setRotation(self._moveDeg)
    self:setSpeed(0.7)
    self._boundingRect = getBoundingRect(self._tankBody)
end

-- 设置坦克位置
function Tank:setPosition(x, y)
    self._tankHead:setPosition(x, y)
    self._tankBody:setPosition(x, y)
    self._boundingRect = getBoundingRect(self._tankBody)
end

-- 添加到Layer
function Tank:addToLayer(layer)
    layer:addChild(self._tankHead, 1)
    layer:addChild(self._tankBody, 0)
end

-- 设置坦克移动速度
function Tank:setSpeed(speed)
    self._speed = speed
end

-- 设置移动角度
function Tank:setMoveDeg(deg)
    self._moveDeg = deg
end

-- 设置射击角度
function Tank:setShootDeg(deg)
    self._shootDeg = deg
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
    
    local startX = self._tankBody:getPositionX()
    local startY = self._tankBody:getPositionY()
    local deg = self._moveDeg % 360
    local curX, curY = moveByDeg(startX, startY, self._speed, deg)

    self._tankBody:setRotation(deg)   
    self:setPosition(curX, curY)
end

-- 射击更新(暂时是射击方向)
function Tank:shootUpdate()
    self._tankHead:setRotation(self._shootDeg)   
end

return Tank