function getBoundingRect(sprite)
    local boundingBox = sprite:getBoundingBox()
    boundingBox.xMid = cc.rectGetMidX(boundingBox)
    boundingBox.yMid = cc.rectGetMidY(boundingBox)
    boundingBox.xMax = cc.rectGetMaxX(boundingBox)
    boundingBox.yMax = cc.rectGetMaxY(boundingBox)
    return boundingBox
end

function moveByDeg(x, y, length, deg)
    local curX = 0
    local curY = 0
    if (deg >= 0 and deg < 90) then
        -- 第一象限
        curX = x + length * math.sin(math.rad(deg)) 
        curY = y + length * math.cos(math.rad(deg))
    elseif (deg >= 90 and deg < 180) then
        -- 第四象限
        curX = x + length * math.sin(math.rad(180-deg))
        curY = y - length * math.cos(math.rad(180-deg))
    elseif (deg >= 180 and deg < 270) then
        -- 第三象限 
        curX = x - length * math.sin(math.rad(deg-180))
        curY = y - length * math.cos(math.rad(deg-180))  
    else
        -- 第二象限 
        curX = x - length * math.sin(math.rad(360-deg))
        curY = y + length * math.cos(math.rad(360-deg))  
    end
    
    return curX, curY
end

function initWithLayer(layer, callback)
    local function onNodeEvent(event)
        if "enter" == event then
            callback()
        end
    end
    layer:registerScriptHandler(onNodeEvent)
end