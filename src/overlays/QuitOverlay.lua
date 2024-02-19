--[[
    Overlay for handling quitting the game

    Todo: Allow for people to click with mouse
]]
QuitOverlay = Class{__includes = AbstractOverlay}

function QuitOverlay:init()
    self.allowOptions = false
end

function QuitOverlay:enter(params)
    Timer.after(0.1, function() self.allowOptions = true end)
end

function QuitOverlay:update(dt)
    Timer.update(dt)
    if self.allowOptions then
        if pressedEscape() then
            love.event.quit()
        end

        if pressedEnter() then
            SceneManager:closeOverlay()
        end
    end
end


function QuitOverlay:render()
    paddingX = 240
    paddingY = 200
    internalPadding = 30
    width = gGameWidth - paddingX * 2
    height = 700
    
    -- background
    local bgWScale = width / gImages['background']['dialogue']:getWidth()
    local bgHScale = height / gImages['background']['dialogue']:getHeight()
    love.graphics.draw(
        gImages['background']['dialogue'],
        paddingX, paddingY, 0,
        bgWScale, bgHScale
    )

    -- Lines around object
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle('line', paddingX+30,  paddingY+30, width - 60, height-60, 15, 15)
    love.graphics.rectangle('line', paddingX+24,  paddingY+24, width - 48, height-48, 15, 15)

    -- Speaker text
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(
        "Quit?",
        paddingX + internalPadding,  paddingY  + internalPadding + 30,
        width - internalPadding * 2,
        'center'
    )

    -- Dialogue Text
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf(
        "Press escape again to quit or press enter to go back.",
        paddingX  + internalPadding + 30,  paddingY  + internalPadding + 130,
        width - internalPadding * 2 - 60,
        'left'
    )

    -- Enter Text
    enterText = "Enter to return"
    enterWidth = gFonts['small']:getWidth(enterText)
    love.graphics.printf(
        enterText,
        gGameWidth - paddingX  - internalPadding - enterWidth - 15,  paddingY + height - internalPadding - 64,
        enterWidth,
        'left'
    )

    enterText = "Esc to quit"
    enterWidth = gFonts['small']:getWidth(enterText)
    love.graphics.printf(
        enterText,
        paddingX  + internalPadding + 15,  paddingY + height - internalPadding - 64,
        enterWidth,
        'left'
    )
    ResetColor()
end