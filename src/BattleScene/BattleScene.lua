require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local BattleScene = class("BattleScene",function()
    return cc.Scene:create()
end)

function BattleScene.create()
    local scene = BattleScene.new()
 
    local layer = require("BattleScene/BulletLayer")
    local bulletLayer = layer:create()
    scene:addChild(bulletLayer)

    local layer = require("BattleScene/GameLayer")
    local gameLayer = layer:create()
    gameLayer._bulletLayer = bulletLayer
    scene:addChild(gameLayer)

    local layer = require("BattleScene/OperateLayer")
    local operateLayer = layer:create()
    operateLayer._tank = gameLayer._tank
    operateLayer._bulletLayer = bulletLayer
    scene:addChild(operateLayer) 

    return scene
end

function BattleScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
end

return BattleScene
