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
    local joystick = require("BattleScene/Joystick")
    self._joystickMove = joystick.create("joystick.png", "joystickBg.png")
    self._joystickMove:setLeftBottom()
    self._joystickMove:addToLayer(self)
    
    -- 关闭按钮回调
    local function menuCloseCallback(sender)
        local scene = require("MainScene/MainScene")
        local mainScene = scene.create()
        cc.Director:getInstance():replaceScene(cc.TransitionZoomFlipX:create(1.2, mainScene))
    end

    -- 关闭按钮
    local closeItem = cc.MenuItemImage:create("closeNormal.png", "closeSelected.png")
    closeItem:registerScriptTapHandler(menuCloseCallback)
    closeItem:setPosition(visibleRect.x + visibleRect.width - closeItem:getContentSize().width/2,
        visibleRect.y + visibleRect.height - closeItem:getContentSize().height/2)
 
    -- 炮弹按钮回调
    local function menuBulletCallback(sender)
        self._bulletLayer:addNewBullet(self._tank:getPositionX(),
            self._tank:getPositionY(), self._tank._rotateDeg)
    end
            
    -- 炮弹按钮
    local bulletItem = cc.MenuItemImage:create("bulletNormal.png", "bulletSelected.png")
    bulletItem:registerScriptTapHandler(menuBulletCallback)
    bulletItem:setPosition(visibleRect.x + visibleRect.width - bulletItem:getContentSize().width,
        visibleRect.y + bulletItem:getContentSize().height)
    
    -- 菜单   
    local  menu = cc.Menu:create()
    menu:addChild(closeItem)
    menu:addChild(bulletItem)
    menu:setPosition(cc.p(0,0))
    self:addChild(menu)

    -- 触摸事件
    local function onTouchesBegan(touches, event)
        for i=1, #touches do
            local start = touches[i]:getLocation()
            if (cc.rectContainsPoint(self._joystickMove._boundingRect, start)
                and cc.rectContainsPoint(self._joystickMove._boundingRect, start)) then
                -- CCTOUCHBEGAN event must return true
                self._joystickMove:enlarge()
                return true
            end
        end
        return false
    end

    local function onTouchesMoved(touches, event)
        local isMoveTouch = false
        
        for i=1, #touches do
            local start = touches[i]:getStartLocation()
            local location = touches[i]:getLocation()
            local winSize = cc.Director:getInstance():getWinSize()
            -- if (start.x < visibleRect.xMid and location.x < visibleRect.xMid) then
            if (cc.rectContainsPoint(self._joystickMove._boundingRect, start)
                and cc.rectContainsPoint(self._joystickMove._boundingRect, start)) then
                isMoveTouch = true
                self._joystickMove:updateJoystick(location.x,location.y)
                self._tank:setRotateDeg(self._joystickMove:getDeg())
                self._tank:move()
            end
        end
        
        if (isMoveTouch == false) then
            self._joystickMove:reset()
            self._tank:stop()
        end
    end

    local function onTouchesEnded(touches, event)
        for i=1, #touches do
            local start = touches[i]:getStartLocation()
            local location = touches[i]:getLocation()
            if (start.x < visibleRect.xMid and location.x < visibleRect.xMid) then
                self._joystickMove:reset()
                self._tank:stop()
            end
        end
    end

    local function onTouchesCanelled(touches, event)
        -- 无
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
