require "Cocos2d"
require "Cocos2dConstants"

-- cclog
local cclog = function(...)
    print(string.format(...))
end

local MyTank = class("MyTank", require("BattleScene/Tank"))

-- 我方坦克创建
function MyTank.create()
    local myTank = MyTank.new()
    return myTank
end
-- 定义我方坦克属性
-- ##########################################
MyTank.baseCtor = require("BattleScene/Tank").ctor -- 坦克构造函数
MyTank.baseTankUpdate = require("BattleScene/Tank").tankUpdate -- 坦克更新函数
MyTank._targetPic = "target.png" -- target图片

MyTank._isReadyForShoot = false -- 是否准备发射炮弹
function MyTank:IsReadyForShoot()
    return self._isReadyForShoot 
end
function MyTank:SetReadyForShoot(ready)
    self._isReadyForShoot = ready
end
-- ##########################################

function MyTank:ctor()
    self:baseCtor()
    self._target = cc.Sprite:create(self._targetPic)
    self._target:setVisible(false)
    self:addChild(self._target) 
end

function MyTank:tankUpdate(gameLayer)
    self:baseTankUpdate()
    if (self._isReadyForShoot == true) then
        local x = self:getPositionX()
        local y = self:getPositionY()
        local length = self:getContentSize().height * self:getScale() / 2 + self._shootLength
        local curPos = cc.pAdd({x=x,y=y}, cc.pMul(self:getDirection(), length))
        
        local bulletRangeVertex = getVertex(curPos, 1, self._shootLength, self._direction)
        local isLockTarget = false
        for i, enemyTank in pairs(gameLayer._enemyTanks) do
            local enemyTankPos = {x=enemyTank:getPositionX(), y=enemyTank:getPositionY()}
            local enemyTankWidth = enemyTank:getContentSize().width*enemyTank:getScaleX()
            local enemyTankWidth = enemyTank:getContentSize().height*enemyTank:getScaleY()
            isLockTarget = isObbCollision(curPos, 10, self._shootLength, self._direction,
                enemyTankPos,enemyTankWidth,enemyTankWidth, enemyTank:getDirection())
                
            if (isLockTarget == true) then
                self._target:setPosition(self:convertToNodeSpace(cc.p(enemyTankPos.x, enemyTankPos.y)))
                self._target:setVisible(true)
                break
            end
        end
        
        if (isLockTarget == false) then
            local curPos = cc.pAdd({x=x,y=y}, cc.pMul(self:getDirection(), length))
            if (curPos.x > visibleRect.xMax) then
                curPos.x = visibleRect.xMax
            elseif (curPos.x < visibleRect.x) then
                curPos.x = visibleRect.x
            end
            if (curPos.y > visibleRect.yMax) then
                curPos.y = visibleRect.yMax
            elseif (curPos.y < visibleRect.y) then
                curPos.y = visibleRect.y
            end
            self._target:setPosition(self:convertToNodeSpace(cc.p(curPos.x, curPos.y)))
            self._target:setVisible(true)
        end
        self._target:setVisible(true)
    else
        self._target:setVisible(false)
    end
end

return MyTank