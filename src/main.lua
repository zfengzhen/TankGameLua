require "Cocos2d"

-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    math.randomseed(os.time())
    
    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")
    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(480, 320, 0)

    dump = require("inspect")
    require "utils"
        
    local size = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    
    visibleRect = cc.rect(origin.x, origin.y, size.width, size.height)
    visibleRect.xMid = cc.rectGetMidX(visibleRect)
    visibleRect.yMid = cc.rectGetMidY(visibleRect)
    visibleRect.xMax = cc.rectGetMaxX(visibleRect)
    visibleRect.yMax = cc.rectGetMaxY(visibleRect)
    
    --create scene 
--    local scene = require("BattleScene/BattleScene")
--    local battleScene = scene.create()
    local scene = require("MainScene/MainScene")
    local mainScene = scene.create()
    
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(mainScene)
    else
        cc.Director:getInstance():runWithScene(mainScene)
    end

end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
