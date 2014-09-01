require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local Tank = class("Tank")


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
    self._moveDirectionX = 0
    self._moveDirectionY = 0
    self._shootDirectionX = 0
    self._shootDirectionY = 0
    self._tankBody:setRotation(0)
    self:setSpeed(0.7)
end

function Tank:setPosition(x, y)
    self._tankHead:setPosition(x, y)
    self._tankBody:setPosition(x, y)
end

function Tank:addToLayer(layer)
    layer:addChild(self._tankHead, 1)
    layer:addChild(self._tankBody, 0)
end

function Tank:setSpeed(speed)
    self._speed = speed
end

function Tank:setMoveDirection(x, y)
    self._moveDirectionX = x
    self._moveDirectionY = y
end

function Tank:setShootDirection(x, y)
    self._shootDirectionX = x
    self._shootDirectionY = y
end

function Tank:move()
    local startX = self._tankBody:getPositionX()
    local startY = self._tankBody:getPositionY()
    
    
    if (self._moveDirectionX == 0 and self._moveDirectionY == 0) then
        return
    elseif (self._moveDirectionY ~= 0 and self._moveDirectionX == 0) then
        self:setPosition(startX, startY+self._speed)
        if (self._moveDirectionY > 0) then
            self._tankBody:setRotation(0)
        else
            self._tankBody:setRotation(180)
        end
        return
    end
    local deg = math.deg(math.atan(self._moveDirectionX/self._moveDirectionY))
    local slope = (self._moveDirectionY) / (self._moveDirectionX)

    local curX = 0
    local curY = 0
    local radius = self._speed
    if (self._moveDirectionX > 0) then
        curX = radius/(math.sqrt(slope*slope +1)) + startX
    else
        curX = -radius/(math.sqrt(slope*slope +1)) + startX
    end

    if (self._moveDirectionY > 0) then
        curY = radius*math.abs(slope)/(math.sqrt(slope*slope +1)) + startY
        self._tankBody:setRotation(deg)
    else
        curY = -radius*math.abs(slope)/(math.sqrt(slope*slope +1)) + startY
        self._tankBody:setRotation(180+deg)
    end

    
    self:setPosition(curX, curY)
end

function Tank:shoot()
    if (self._shootDirectionX == 0 and self._shootDirectionY == 0) then
        return
    elseif (self._shootDirectionY ~= 0 and self._shootDirectionX == 0) then
        if (self._shootDirectionY > 0) then
            self._tankHead:setRotation(0)
        else
            self._tankHead:setRotation(180)
        end
        return
    end
    
    local deg = math.deg(math.atan(self._shootDirectionX/self._shootDirectionY))
    
    if (self._shootDirectionY > 0) then
        self._tankHead:setRotation(deg)
    else
        self._tankHead:setRotation(180+deg)
    end   
end

return Tank