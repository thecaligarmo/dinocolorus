--[[
    An overlay which just displays some text.

    No background, no nothing. Just text.
]]
TextOverlay = Class{__includes = AbstractOverlay}

function TextOverlay:enter(params)
    self.text = params.text
    self.callback = params.callback or function () end
end

function TextOverlay:update(dt)
    if pressedEnter() then
        SceneManager:closeOverlay()
    end
end

function TextOverlay:exit()
    self.callback()
end


function TextOverlay:render()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(
        self.text,
        0,  gGameHeight/2 - gFonts['large']:getHeight(),
        gGameWidth,
        'center'
    )

    ResetColor()
end