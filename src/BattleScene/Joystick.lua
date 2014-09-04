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

function Joystick:ctor(joystickPic, joystickBgPic)
    self._joystick = cc.Sprite:create(joystickPic)
    self._joystickBg = cc.Sprite:create(joystickBgPic)
    self._boundingRect = getBoundingRect(self._joystickBg)
    self._isMoved = false
    self._moveDeg = 0
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

function Joystick:enlarge()
    self._joystickBg:setScale(1.5)
end

-- 重置摇杆位置
function Joystick:reset()
    self._joystick:setScale(1)
    self._joystickBg:setScale(1)
    self._joystick:setPosition(self._boundingRect.xMid, self._boundingRect.yMid)
    self._joystickBg:setPosition(self._boundingRect.xMid, self._boundingRect.yMid)
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
    local joystickStartX = self._boundingRect.xMid
    local joystickStartY = self._boundingRect.yMid
    
    -- 没有移动
    if (x == joystickStartX and y == joystickStartY) then
        self._isMoved = false
        return    
    end
    
    self._isMoved = true
    
    local joystickX = 0
    local joystickY = 0
    local radius = self._boundingRect.width/2
    
    -- y轴正向移动
    if (x == joystickStartX and y > joystickStartY) then
        self._joystick:setPosition(joystickStartX, joystickStartY + radius)
        self._moveDeg = 0
        return
    end
    
     -- y轴负向移动
    if (x == joystickStartX and y < joystickStartY) then
        self._joystick:setPosition(joystickStartX, joystickStartY - radius)
        self._moveDeg = 180
        return
    end
    
    -- 其他情况   
    local slope = (joystickStartY - y) / (joystickStartX - x)

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
    
    -- 设置移动角度
    local deg = math.deg(math.atan(math.abs(joystickY-joystickStartY)/math.abs(joystickX-joystickStartX)))
    if (joystickX > joystickStartX and joystickY > joystickStartY) then
        -- 第一象限
        self._moveDeg = 90 - deg
    elseif (joystickX < joystickStartX and joystickY > joystickStartY) then
        -- 第二象限
        self._moveDeg = 270 + deg
    elseif (joystickX < joystickStartX and joystickY < joystickStartY) then
        -- 第三象限
        self._moveDeg = 270 - deg
    else
        -- 第四象限
        self._moveDeg = 90 + deg
    end
    
    self._joystick:setPosition(joystickX, joystickY)
end

-- 判断摇杆是否移动
function Joystick:IsMoved()
    return self._isMoved
end

-- 获取摇杆角度(以y轴正向为0°)
function Joystick:getDeg()
    return self._moveDeg
end

return Joystick