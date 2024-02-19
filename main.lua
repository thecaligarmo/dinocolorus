--[[
    Final project for GD50

    When code is supplied from external sources, this is noted.

    Structure based off code from the GD50 class.

    Description: The idea of the game is a platformer/explorer in which you need
    to collect some things in order to "win". The catch of this game is that
    there are two hues which dictate the world: light and dark.
    When in light mode (the start), you can only interact with light things.
    When in dark mode, you can only interact with dark things.
    You need to switch between light and dark in order to progress.    
]]
love.graphics.setDefaultFilter('nearest', 'nearest')
require 'src/Dependencies'

function love.load()
    love.window.setTitle('Dinocolorus')
    love.window.setMode(gGameWidth, gGameHeight, {
        fullscreen = false,
        resizable = true,
    })

    -- iniitialize (true)
    resetKeysMouse(true) 

    -- initialize music
    gSounds['background']:setLooping(true)
    gSounds['background']:setVolume(0.5)
    gSounds['background']:play()

    -- Start our scene manager
    SceneManager:init({
        ['start'] = {name = 'StartScene'; default = true},
        ['mainmenu'] = {name = 'MainMenuScene'},
        ['char'] = {name = 'CharSelectScene'},
        ['play'] = {name = 'PlayScene'},
    },{
        ['pause'] = {name = 'PauseOverlay'},
        ['dialogue'] = {name = 'DialogueOverlay'},
        ['text'] = {name = 'TextOverlay'},
        ['quit'] = {name = 'QuitOverlay'}
    })
end

function love.resize(w, h)
    gGameWidth = w
    gGameHeight = h
end

function love.update(dt)
    love.mouse.curCoords.x, love.mouse.curCoords.y = love.mouse.getPosition()
    SceneManager:update(dt)

    -- reset keys and mouse (don't initialize)
    resetKeysMouse(false)
end

function love.draw()
    -- push:start()
    SceneManager:render()
    displayFPS()
    -- push:finish()
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    if DEBUG then 
        -- simple FPS display across all states
        love.graphics.setFont(gFonts['default'])
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
        ResetColor()
    end
end