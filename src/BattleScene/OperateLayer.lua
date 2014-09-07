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
    self._joystick = joystick.create("joystick.png", "joystickBg.png")
    self._joystick:setLeftBottom()
    self._joystick:addToLayer(self)
    
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
 
    -- 菜单   
    local  menu = cc.Menu:create()
    menu:addChild(closeItem)
    menu:setPosition(cc.p(0,0))
    self:addChild(menu)
               
    -- 炮弹按钮
    self._bulletButton = cc.Sprite:create("bulletNormal.png")
    self._bulletButton:setPosition(visibleRect.x + visibleRect.width - self._bulletButton:getContentSize().width,
        visibleRect.y + self._bulletButton:getContentSize().height)
    self:addChild(self._bulletButton)
    
    -- 触摸事件
    local isBulletButtonPressed = false
    local function onTouchesBegan(touches, event)
        for i=1, #touches do
            local start = touches[i]:getLocation()
            if (cc.rectContainsPoint(self._joystick:getBoundingBox(), start)) then
                self._joystick:enlarge()
                return true
            elseif (cc.rectContainsPoint(self._bulletButton:getBoundingBox(), start)) then
                self._bulletButton:setScale(2)
                isBulletButtonPressed = true
                self._tank._isReadyForShoot = true
            end
        end
        return true
    end

    local function onTouchesMoved(touches, event)
        local isMoveTouch = false
        
        for i=1, #touches do
            local start = touches[i]:getStartLocation()
            local location = touches[i]:getLocation()
            local winSize = cc.Director:getInstance():getWinSize()
            -- if (start.x < visibleRect.xMid and location.x < visibleRect.xMid) then
            if (cc.rectContainsPoint(self._joystick:getBoundingBox(), start)) then
                isMoveTouch = true
                self._joystick:updateJoystick(location.x,location.y)
                self._tank._direction = self._joystick:getDirection()                
                self._tank:move()
            elseif (cc.rectContainsPoint(self._bulletButton:getBoundingBox(), start) and
                cc.rectContainsPoint(self._bulletButton:getBoundingBox(), location) == false
                and isBulletButtonPressed == true) then
                --
            end
        end
        
        if (isMoveTouch == false) then
            self._joystick:reset()
            self._tank:stop()
        end
    end

    local function onTouchesEnded(touches, event)
        for i=1, #touches do
            local start = touches[i]:getStartLocation()
            local location = touches[i]:getLocation()
            if (start.x < visibleRect.xMid and location.x < visibleRect.xMid) then
                self._joystick:reset()
                self._tank:stop()
            elseif (cc.rectContainsPoint(self._bulletButton:getBoundingBox(), start)) then
                local x = self._tank:getPositionX()
                local y = self._tank:getPositionY()
                local length = self._tank:getContentSize().height * self._tank:getScale() / 2
                local curPos = cc.pAdd({x=x,y=y}, cc.pMul(self._tank:getDirection(), length))
                self._bulletLayer:addMyBullet(curPos.x, curPos.y, self._tank:getDirection(), self._tank._shootLength)
                self._bulletButton:setScale(1)
                isBulletButtonPressed = false
                self._tank._isReadyForShoot = false
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
