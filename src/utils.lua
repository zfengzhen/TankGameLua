function getBoundingRect(sprite)
    local boundingBox = sprite:getBoundingBox()
    boundingBox.xMid = cc.rectGetMidX(boundingBox)
    boundingBox.yMid = cc.rectGetMidY(boundingBox)
    boundingBox.xMax = cc.rectGetMaxX(boundingBox)
    boundingBox.yMax = cc.rectGetMaxY(boundingBox)
    return boundingBox
end
