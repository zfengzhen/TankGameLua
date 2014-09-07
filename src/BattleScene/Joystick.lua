require "Cocos2d"
require "Cocos2dConstants"

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

-- 定义属性
-- ##########################################
Joystick._joystick = nil
Joystick._joystickBg = nil
Joystick._isMoved = nil
Joystick._direction = cc.p(0, 0)
-- ##########################################

function Joystick:ctor(joystickPic, joystickBgPic)
    self._joystick = cc.Sprite:create(joystickPic)
    self._joystickBg = cc.Sprite:create(joystickBgPic)
end

-- 添加到Layer
function Joystick:addToLayer(layer)
    layer:addChild(self._joystick, 0)
    layer:addChild(self._joystickBg, 1)
end

-- 设置左下角
function Joystick:setLeftBottom()
    local x = visibleRect.x + self._joystickBg:getBoundingBox().width
    local y = visibleRect.y + self._joystickBg:getBoundingBox().height
    self:showJoystick(x, y)
end

-- 设置到右下角
function Joystick:setRightBottom()
    local x = visibleRect.x + visibleRect.width - self._joystickBg:getBoundingBox().width
    local y = visibleRect.y + self._joystickBg:getBoundingBox().height
    self:showJoystick(x, y)
end

function Joystick:enlarge()
    self._joystickBg:setScale(1.5)
end

-- 重置摇杆位置
function Joystick:reset()
    self._joystick:setScale(1)
    self._joystickBg:setScale(1)
    self._joystick:setPosition(self._joystickBg:getPosition())
    self._isMoved = false
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
    self._joystick:reset()
    self._joystick:setVisible(false)
    self._joystickBg:setVisible(false)
end

-- 更新摇杆位置
function Joystick:updateJoystick(x, y)
    local startX, startY= self._joystickBg:getPosition()
    
    -- 没有移动
    if (x == startX and y == startY) then
        self._isMoved = false
        return    
    end
    
    self._isMoved = true
    
    self._direction = cc.pNormalize(cc.pSub({x=x, y=y}, {x=startX, y=startY}))
    local radius = self._joystickBg:getBoundingBox().width/2
    local curPos = cc.pAdd({x=startX, y=startY}, cc.pMul(self._direction, self._joystickBg:getBoundingBox().width/2))
    
    self._joystick:setPosition(curPos.x, curPos.y)
end

-- 判断摇杆是否移动
function Joystick:IsMoved()
    return self._isMoved
end

-- 获取摇杆方向
function Joystick:getDirection()
    return self._direction
end

function Joystick:getBoundingBox()
    local boundingBox =  self._joystickBg:getBoundingBox()
    return boundingBox
end

return Joystick