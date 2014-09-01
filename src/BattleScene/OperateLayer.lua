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
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local joystick = require("BattleScene/Joystick")
    self._joystickMove = joystick:create()
    self._joystickMove:addToLayer(self)
    
    self._joystickShoot = joystick:create()
    self._joystickShoot:addToLayer(self)
    
    -- 关闭按钮回调
    local function menuCloseCallback(sender)
        cclog("menuCloseCallback...")
        cc.Director:getInstance():endToLua()
    end

    -- 关闭按钮
    local closeItem = cc.MenuItemImage:create("closeNormal.png", "closeSelected.png")
    closeItem:registerScriptTapHandler(menuCloseCallback)
    closeItem:setPosition(self.origin.x + self.visibleSize.width - closeItem:getContentSize().width/2,
        self.origin.y + closeItem:getContentSize().height/2)
    
    -- 菜单   
    local  menu = cc.Menu:create()
    menu:addChild(closeItem)
    menu:setPosition(cc.p(0,0))
    self:addChild(menu)

    -- 触摸事件
    local function onTouchesBegan(touches, event)
        for i=1, #touches do
            local location = touches[i]:getLocation()
            local winSize = cc.Director:getInstance():getWinSize()
            if (location.x < winSize.width/2) then
                self._joystickMove:showJoystick(location.x,location.y)
            else
                self._joystickShoot:showJoystick(location.x,location.y)
            end
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
            if (start.x < winSize.width/2 and location.x < winSize.width/2) then
                isMoveTouch = true
                self._joystickMove:updateJoystick(location.x,location.y)
                self._tank:setMoveDirection(location.x-start.x, location.y-start.y)
            elseif (start.x > winSize.width/2 and location.x > winSize.width/2) then
                isShootTouch = true
                self._joystickShoot:updateJoystick(location.x,location.y)
                self._tank:setShootDirection(location.x-start.x, location.y-start.y)
            end
        end
        
        if (isMoveTouch == false) then
            self._joystickMove:hideJoystick()
            self._tank:setMoveDirection(0, 0)
        end
        if (isShootTouch == false) then
            self._joystickShoot:hideJoystick()
        end
    end

    local function onTouchesEnded(touches, event)
        for i=1, #touches do
            local start = touches[i]:getStartLocation()
            local location = touches[i]:getLocation()
            local winSize = cc.Director:getInstance():getWinSize()
            if (start.x < winSize.width/2 and location.x < winSize.width/2) then
                self._joystickMove:hideJoystick()
                self._tank:setMoveDirection(0, 0)
            elseif (start.x > winSize.width/2 and location.x > winSize.width/2) then
                self._joystickShoot:hideJoystick()
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
