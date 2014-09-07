require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local GameEndLayer = class("GameEndLayer",function()
    return cc.Layer:create()
end)

function GameEndLayer.create()
    local layer = GameEndLayer.new()
    return layer
end

GameEndLayer._label = nil

function GameEndLayer:ctor()
    -- 开始游戏按钮回调
    local function menuStartGameCallback(sender)
        local scene = require("BattleScene/BattleScene")
        local battleScene = scene.create()
        cc.Director:getInstance():replaceScene(cc.TransitionZoomFlipX:create(1.2, battleScene))
    end

    -- 开始游戏按钮
    local startGameItem = cc.MenuItemImage:create("startGameMenu.png", "startGameMenu.png")
    startGameItem:registerScriptTapHandler(menuStartGameCallback)
    startGameItem:setPosition(visibleRect.xMid,
        visibleRect.yMid - startGameItem:getContentSize().height + 5)
    
    -- 菜单   
    local  menu = cc.Menu:create()
    menu:addChild(startGameItem)
    menu:setPosition(cc.p(0,0))
    self:addChild(menu)

    -- 标题
    self._label = cc.LabelTTF:create("", "Arial", 30)
    self._label:setPosition(visibleRect.xMid, visibleRect.yMax - 50)
    self:addChild(self._label, 3) 
    
    self:setVisible(false)
end

function GameEndLayer:showDistroyNum(num)
    local str = "你消灭了 " .. num .. "架坦克!"
    self._label:setString(str)
    self:setVisible(true)
end


return GameEndLayer
