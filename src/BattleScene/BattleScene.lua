require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local BattleScene = class("BattleScene",function()
    return cc.Scene:createWithPhysics()
end)

function BattleScene.create()
    local scene = BattleScene.new()
    return scene
end

function BattleScene:ctor()
    --self:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    self.schedulerID = nil
    self:getPhysicsWorld():setGravity(cc.p(0, 0))
    
    local body = cc.PhysicsBody:createEdgeBox(cc.size(visibleRect.width, visibleRect.height))
    local edgeNode = cc.Node:create()
    edgeNode:setPosition(visibleRect.xMid, visibleRect.yMid)
    edgeNode:setPhysicsBody(body)
    self:addChild(edgeNode)
        
    
    local layer = require("BattleScene/BulletLayer")
    local bulletLayer = layer.create()
    self:addChild(bulletLayer)

    local layer = require("BattleScene/GameLayer")
    local gameLayer = layer.create()
    gameLayer._bulletLayer = bulletLayer
    self:addChild(gameLayer)

    local layer = require("BattleScene/OperateLayer")
    local operateLayer = layer.create()
    operateLayer._tank = gameLayer._tank
    operateLayer._bulletLayer = bulletLayer
    self:addChild(operateLayer)

end

return BattleScene
