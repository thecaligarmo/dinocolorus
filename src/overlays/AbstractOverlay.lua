--[[
    An overlay is like a scene except that it lives on a stack (the current scene is at the bottom of the stack)

    Base overlay all other overlays will abstract from to ensure we have all
    appropriate functions.
]]

AbstractOverlay = Class{}

function AbstractOverlay:init()
end

function AbstractOverlay:update(dt)
end

function AbstractOverlay:render()
end

function AbstractOverlay:enter(params)
end

function AbstractOverlay:exit()
end