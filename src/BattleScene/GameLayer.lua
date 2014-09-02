require "Cocos2d"
require "Cocos2dConstants"
-- cclog
local cclog = function(...)
    print(string.format(...))
end

local GameLayer = class("GameLayer",function()
    return cc.Layer:create()
end)

function GameLayer.create()
    local layer = GameLayer.new()
    return layer
end

function GameLayer:ctor()
    
    local tank = require("BattleScene/Tank")
    self._tank = tank:create()
    self._tank:addToLayer(self)
    self._tank:setPosition(visibleRect.xMid, visibleRect.yMid)
    local dt = 1
    local function update()
        dt = dt + 1 
        self._tank:moveUpdate()
        self._tank:shootUpdate()
        if (dt % 60 == 0) then
            self._bulletLayer:addNewBullet(self._tank._tankHead:getPositionX(), self._tank._tankHead:getPositionY(), self._tank._shootDeg)
        end
    end
    
    self:scheduleUpdateWithPriorityLua(update, 0)   
end

return GameLayer
