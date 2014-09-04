require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local MainScene = class("MainScene",function()
    return cc.Scene:create()
end)

function MainScene.create()
    local scene = MainScene.new()
    return scene
end

function MainScene:ctor()
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
        visibleRect.yMid + startGameItem:getContentSize().height/2 + 5)
 
    -- 关闭游戏按钮回调
    local function menuEndGameCallback(sender)
        cc.Director:getInstance():endToLua()
    end

    -- 关闭游戏按钮
    local endGameItem = cc.MenuItemImage:create("endGameMenu.png", "endGameMenu.png")
    endGameItem:registerScriptTapHandler(menuEndGameCallback)
    endGameItem:setPosition(visibleRect.xMid,
        visibleRect.yMid - endGameItem:getContentSize().height/2 - 5)
               
    -- 菜单   
    local  menu = cc.Menu:create()
    menu:addChild(startGameItem)
    menu:addChild(endGameItem)
    menu:setPosition(cc.p(0,0))
    self:addChild(menu)

end

return MainScene
