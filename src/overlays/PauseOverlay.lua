--[[
    Pause overlay.

    Todo: Add settings button
]]
PauseOverlay = Class{__includes = AbstractOverlay}


function PauseOverlay:render()
    DrawBackground('main')

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle('line', 30,  30, gGameWidth-60, gGameHeight-60, 15, 15)
    love.graphics.rectangle('line', 24,  24, gGameWidth-48, gGameHeight-48, 15, 15)
    ResetColor()

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf(
        'Pause',
        0,  gGameHeight / 2 - 256,
        gGameWidth,
        'center'
    )
end


