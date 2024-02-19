--[[
    Dialogue overlay which shows speaker and the dialogue text
]]
DialogueOverlay = Class{__includes = AbstractOverlay}

function DialogueOverlay:enter(params)
    self.text = params.text
    self.speaker = params.speaker
    self.callback = params.callback or function () end

    self.speakerWidth = gFonts['medium']:getWidth(self.text)
end

function DialogueOverlay:update(dt)
    if pressedEnter() then
        SceneManager:closeOverlay()
    end
end

function DialogueOverlay:exit()
    self.callback()
end


function DialogueOverlay:render()
    padding = 30
    width = gGameWidth - padding * 2
    height = 480
    
    -- background
    local bgWScale = width / gImages['background']['dialogue']:getWidth()
    local bgHScale = height / gImages['background']['dialogue']:getHeight()
    love.graphics.draw(
        gImages['background']['dialogue'],
        padding, padding, 0,
        bgWScale, bgHScale
    )

    -- Lines around object
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle('line', padding+30,  padding+30, width - 60, height-60, 15, 15)
    love.graphics.rectangle('line', padding+24,  padding+24, width - 48, height-48, 15, 15)

    -- Speaker text
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(
        self.speaker,
        padding * 2,  padding * 2 + 30,
        width - padding * 4,
        'center'
    )

    -- Dialogue Text
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf(
        self.text,
        padding * 2 + 30,  padding * 2 + 130,
        width - padding * 4 - 60,
        'left'
    )

    -- Enter Text
    enterText = "Press enter"
    enterWidth = gFonts['small']:getWidth(enterText)
    love.graphics.printf(
        enterText,
        gGameWidth - padding * 2 - 30 - enterWidth,  padding + height - 30 - 64,
        enterWidth,
        'left'
    )
    ResetColor()
end