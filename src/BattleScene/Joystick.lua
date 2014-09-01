require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local Joystick = class("Joystick")


function Joystick.create()
    local joystick = Joystick.new()
    return joystick
end

function Joystick:ctor()
    self._joystick = cc.Sprite:create("joystick.png")
    self._joystickBg = cc.Sprite:create("joystickBg.png")
    self._joystick:setScale(0.5)
    self._joystickBg:setScale(0.5)
    self:hideJoystick()
end

function Joystick:addToLayer(layer)
    layer:addChild(self._joystick, 0)
    layer:addChild(self._joystickBg, 1)
end

function Joystick:showJoystick(x, y)
    self._joystick:setPosition(x, y)
    self._joystickBg:setPosition(x, y)
    self._joystick:setVisible(true)
    self._joystickBg:setVisible(true)
end

function Joystick:hideJoystick()
    self._joystick:setPosition(self._joystickBg:getPositionX(), self._joystickBg:getPositionY());
    self._joystick:setVisible(false)
    self._joystickBg:setVisible(false)
end

function Joystick:updateJoystick(x, y)
    local joystickStartX = self._joystickBg:getPositionX()
    local joystickStartY = self._joystickBg:getPositionY()
    local slope = (joystickStartY - y) / (joystickStartX - x)

    local joystickX = 0
    local joystickY = 0
    local radius = 30
    if (x >= joystickStartX) then
        joystickX = radius/(math.sqrt(slope*slope +1)) + joystickStartX
    else
        joystickX = -radius/(math.sqrt(slope*slope +1)) + joystickStartX
    end

    if (y >= joystickStartY) then
        joystickY = radius*math.abs(slope)/(math.sqrt(slope*slope +1)) + joystickStartY
    else
        joystickY = -radius*math.abs(slope)/(math.sqrt(slope*slope +1)) + joystickStartY
    end


    self._joystick:setPosition(joystickX, joystickY)
end


return Joystick