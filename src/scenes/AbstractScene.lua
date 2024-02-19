--[[
    Base scene all other scenes will abstract from to ensure we have all
    appropriate functions
]]

AbstractScene = Class{}

function AbstractScene:init()
end

function AbstractScene:update(dt)
end

function AbstractScene:pausedUpdate(dt)
end

function AbstractScene:render()
end

function AbstractScene:enter(params)
end

function AbstractScene:exit()
end