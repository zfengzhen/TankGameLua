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
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local tank = require("BattleScene/Tank")
    self._tank = tank:create()
    self._tank:addToLayer(self)
    self._tank:setPosition(100, 100)
    local dt = 1
    local function update()
        dt = dt + 1 
        self._tank:move()
        self._tank:shoot()
        if (dt % 60 == 0) then
            self._bulletLayer:addNewBullet(self._tank._tankHead:getPositionX(), self._tank._tankHead:getPositionY(), {x=self._tank._shootDirectionX, y =self._tank._shootDirectionY})
        end
    end
    
    self:scheduleUpdateWithPriorityLua(update, 0)   
end

return GameLayer
