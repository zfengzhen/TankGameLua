
-- cclog
local cclog = function(...)
    print(string.format(...))
end

function getBoundingRect(sprite)
    -- boundingBox不会旋转，它会因为图形的旋转变得更大
    -- 因为这个box始终会生成一个足够大大矩形包裹住图像显示范围
    local boundingBox = sprite:getBoundingBox()
    boundingBox.xMid = cc.rectGetMidX(boundingBox)
    boundingBox.yMid = cc.rectGetMidY(boundingBox)
    boundingBox.xMax = cc.rectGetMaxX(boundingBox)
    boundingBox.yMax = cc.rectGetMaxY(boundingBox)
    return boundingBox
end

function getPositionByXYLenghthDeg(x, y, length, deg)
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

function getBitmaskByNum(num)
    if (num > 0) then
        return 2 ^ (num - 1)
    else
        return 0
    end
end

function getBitmaskByTable(t)
    if (type(t) ~= "table") then
        return 0
    end
    local bitmask = 0
    for i, v in pairs(t) do
        bitmask = bitmask + 2 ^ (v - 1)
    end
    return bitmask
end

-- 设平面上一点（x1,y1），绕另一点（x0,y0）逆时针旋转A角度后的点为（x2,y2）,则：
-- x2 = (x1-x0)*cosA - (y1-y0)*sinA + x0
-- y2 = (x1-x0)*sinA + (y1-y0)*cosA + y0
-- 顺时针的话，就把A改成-A就好了
function getVertex(centerPos, width, height, direction)
    local p1 = {x=centerPos.x+width/2, y=centerPos.y+height/2}
    local p2 = {x=centerPos.x-width/2, y=centerPos.y+height/2}
    local p3 = {x=centerPos.x-width/2, y=centerPos.y-height/2}
    local p4 = {x=centerPos.x+width/2, y=centerPos.y-height/2}
    local A = cc.pToAngleSelf(direction)
    
    local new_p1 = {}
    new_p1.x = (p1.x - centerPos.x)*math.cos(A) - (p1.y - centerPos.y)*math.sin(A) + centerPos.x
    new_p1.y = (p1.x - centerPos.x)*math.sin(A) - (p1.y - centerPos.y)*math.cos(A) + centerPos.y
    
    local new_p2 = {}
    new_p2.x = (p2.x - centerPos.x)*math.cos(A) - (p2.y - centerPos.y)*math.sin(A) + centerPos.x
    new_p2.y = (p2.x - centerPos.x)*math.sin(A) - (p2.y - centerPos.y)*math.cos(A) + centerPos.y
    
    local new_p3 = {}
    new_p3.x = (p3.x - centerPos.x)*math.cos(A) - (p3.y - centerPos.y)*math.sin(A) + centerPos.x
    new_p3.y = (p3.x - centerPos.x)*math.sin(A) - (p3.y - centerPos.y)*math.cos(A) + centerPos.y
    
    local new_p4 = {}
    new_p4.x = (p4.x - centerPos.x)*math.cos(A) - (p4.y - centerPos.y)*math.sin(A) + centerPos.x
    new_p4.y = (p4.x - centerPos.x)*math.sin(A) - (p4.y - centerPos.y)*math.cos(A) + centerPos.y
    
    local vertex = {p1=new_p1, p2=new_p2, p3=new_p3, p4=new_p4}
    vertex.xMin = math.min(new_p1.x, new_p2.x, new_p3.x, new_p4.x)
    vertex.xMax = math.max(new_p1.x, new_p2.x, new_p3.x, new_p4.x)
    vertex.yMin = math.min(new_p1.y, new_p2.y, new_p3.y, new_p4.y)
    vertex.yMax = math.max(new_p1.y, new_p2.y, new_p3.y, new_p4.y)
    
    return vertex
end

function isObbCollision(centerPos1, width1, height1, direction1, centerPos2, width2, height2, direction2)
    local vertex1 = getVertex(centerPos1, width1, height1, direction1)
    local vertex2 = getVertex(centerPos2, width2, height2, direction2)
    
    local xOverlap = true
    if (vertex1.xMin > vertex2.xMax or vertex2.xMin > vertex1.xMax) then
        xOverlap = false
    end
    
    local yOverlap = true
    if (vertex1.yMin > vertex2.yMax or vertex2.yMin > vertex1.yMax) then
        yOverlap = false
    end
    
    if (xOverlap == true and yOverlap == true) then
        return true
    else
        return false
    end

end