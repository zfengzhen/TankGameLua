require "Cocos2d"
require "Cocos2dConstants"
require "utils"

-- cclog
local cclog = function(...)
    print(string.format(...))
end

local Joystick = class("Joystick")

-- 虚拟摇杆创建
function Joystick.create(joystickPic, joystickBgPic)
    local joystick = Joystick.new(joystickPic, joystickBgPic)
    return joystick
end

function Joystick:ctor(joystickPic, joystickBgPic)
    self._joystick = cc.Sprite:create(joystickPic)
    self._joystickBg = cc.Sprite:create(joystickBgPic)
    self._joystick:setScale(0.5)
    self._boundingRect = getBoundingRect(self._joystickBg)
end

-- 添加到Layer
function Joystick:addToLayer(layer)
    layer:addChild(self._joystick, 0)
    layer:addChild(self._joystickBg, 1)
end

-- 设置左下角
function Joystick:setLeftBottom()
    local x = visibleRect.x + self._boundingRect.width
    local y = visibleRect.y + self._boundingRect.height
    self:showJoystick(x, y)
    self._boundingRect = getBoundingRect(self._joystickBg)
end

-- 设置到右下角
function Joystick:setRightBottom()
    local x = visibleRect.x + visibleRect.width - self._boundingRect.width
    local y = visibleRect.y + self._boundingRect.height
    self:showJoystick(x, y)
    self._boundingRect = getBoundingRect(self._joystickBg)
end

-- 重置摇杆位置
function Joystick:reset()
    self._joystick:setPosition(self._boundingRect.xMid, self._boundingRect.yMid)
    self._joystickBg:setPosition(self._boundingRect.xMid, self._boundingRect.yMid)
end

-- 显示摇杆
function Joystick:showJoystick(x, y)
    self._joystick:setPosition(x, y)
    self._joystickBg:setPosition(x, y)
    self._joystick:setVisible(true)
    self._joystickBg:setVisible(true)
end

-- 隐藏摇杆
function Joystick:hideJoystick()
    self._joystick:setPosition(self._joystickBg:getPositionX(), self._joystickBg:getPositionY());
    self._joystick:setVisible(false)
    self._joystickBg:setVisible(false)
end

-- 更新摇杆位置
function Joystick:updateJoystick(x, y)
    local joystickStartX = self._boundingRect.xMid
    local joystickStartY = self._boundingRect.yMid
    local slope = (joystickStartY - y) / (joystickStartX - x)

    local joystickX = 0
    local joystickY = 0
    local radius = self._boundingRect.width/2
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