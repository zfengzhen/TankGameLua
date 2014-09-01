require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local OperateLayer = class("OperateLayer",function()
    return cc.Layer:create()
end)

function OperateLayer.create()
    local layer = OperateLayer.new()
    return layer
end

function OperateLayer:ctor()
    self._visibleSize = cc.Director:getInstance():getVisibleSize()
    self._origin = cc.Director:getInstance():getVisibleOrigin()
    
    local joystick = require("BattleScene/Joystick")
    self._joystickMove = joystick.create("joystick.png", "joystickBg.png")
    self._joystickMove:setLeftBottom()
    self._joystickMove:addToLayer(self)
    
    self._joystickShoot = joystick.create("joystick.png", "joystickBg.png")
    self._joystickShoot:setRightBottom()
    self._joystickShoot:addToLayer(self)
    
    -- 关闭按钮回调
    local function menuCloseCallback(sender)
        cclog("menuCloseCallback...")
        cc.Director:getInstance():endToLua()
    end

    -- 关闭按钮
    local closeItem = cc.MenuItemImage:create("closeNormal.png", "closeSelected.png")
    closeItem:registerScriptTapHandler(menuCloseCallback)
    closeItem:setPosition(self._origin.x + self._visibleSize.width - closeItem:getContentSize().width/2,
        self._origin.y + self._visibleSize.height - closeItem:getContentSize().height/2)
    
    -- 菜单   
    local  menu = cc.Menu:create()
    menu:addChild(closeItem)
    menu:setPosition(cc.p(0,0))
    self:addChild(menu)

    -- 触摸事件
    local function onTouchesBegan(touches, event)
        for i=1, #touches do
            local location = touches[i]:getLocation()
        end
        -- CCTOUCHBEGAN event must return true
        return true
    end

    local function onTouchesMoved(touches, event)
        local isMoveTouch = false
        local isShootTouch = false
        
        for i=1, #touches do
            local start = touches[i]:getStartLocation()
            local location = touches[i]:getLocation()
            local winSize = cc.Director:getInstance():getWinSize()
            if (cc.rectContainsPoint(self._joystickMove._boundingRect, start) and cc.rectContainsPoint(self._joystickMove._boundingRect, location)) then
                isMoveTouch = true
                self._joystickMove:updateJoystick(location.x,location.y)
                self._tank:setMoveDirection(location.x-start.x, location.y-start.y)
            elseif (cc.rectContainsPoint(self._joystickShoot._boundingRect, start) and cc.rectContainsPoint(self._joystickShoot._boundingRect, location)) then
                isShootTouch = true
                self._joystickShoot:updateJoystick(location.x,location.y)
                self._tank:setShootDirection(location.x-start.x, location.y-start.y)
            end
        end
        
        if (isMoveTouch == false) then
            self._tank:setMoveDirection(0, 0)
            self._joystickMove:reset()
        end
        if (isShootTouch == false) then
            self._joystickShoot:reset()
        end
    end

    local function onTouchesEnded(touches, event)
        for i=1, #touches do
            local start = touches[i]:getStartLocation()
            local location = touches[i]:getLocation()
            if (cc.rectContainsPoint(self._joystickMove._boundingRect, start) and cc.rectContainsPoint(self._joystickMove._boundingRect, location)) then
                self._joystickMove:reset()
                self._tank:setMoveDirection(0, 0)
            elseif (cc.rectContainsPoint(self._joystickShoot._boundingRect, start) and cc.rectContainsPoint(self._joystickShoot._boundingRect, location)) then
                self._joystickShoot:reset()
            end
        end
    end

    local function onTouchesCanelled(touches, event)
    end
    
    local listener = cc.EventListenerTouchAllAtOnce:create()
    listener:registerScriptHandler(onTouchesBegan,cc.Handler.EVENT_TOUCHES_BEGAN)
    listener:registerScriptHandler(onTouchesMoved,cc.Handler.EVENT_TOUCHES_MOVED)
    listener:registerScriptHandler(onTouchesEnded,cc.Handler.EVENT_TOUCHES_ENDED)
    listener:registerScriptHandler(onTouchesCanelled,cc.Handler.EVENT_TOUCHES_CANCELLED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end

return OperateLayer
