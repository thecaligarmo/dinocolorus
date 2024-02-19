--[[
    functions and global data for graphics related stuff.

    Functions first
    Settings later

    Credits for graphics:
        - Kenney.nl - Abstract Platformer - https://opengameart.org/content/abstract-platformer
        - @ScissorMarks - Dino Characters - https://arks.itch.io/dino-characters
        - @DemChing - Dino Family - https://demching.itch.io/dino-family
        - Des Gomez - Font - https://www.dafont.com/es/dinosaursarealive.font
]]

-- Generate a set of tiles
function GenerateTiles(image, tileWidth, tileHeight, startCoords, endCoords)
    local sheetCols = image:getWidth() / tileWidth
    local sheetRows = image:getHeight() / tileHeight

    local row = (startCoords and startCoords.row) or 1
    local col = (startCoords and startCoords.col) or 1
    local endRow = (endCoords and endCoords.row) or sheetRows
    local endCol = (endCoords and endCoords.col) or sheetCols

    local tileCount = 1
    local tileSheet = {}

    for r = row, endRow do
        for c = col, endCol do
            
            tileSheet[tileCount] = love.graphics.newQuad( 
                (c - 1) * tileWidth, (r - 1) * tileHeight,
                tileWidth, tileHeight,
                image
            )
            tileCount = tileCount + 1
        end
    end
    return tileSheet
end

-- Handles drawing of background
function DrawBackground(name, x, y)
    offsetX = x or 0
    offsetX = -offsetX
    offsetY = y or 0
    offsetY = -offsetY
    local bgScale = GAME_WIDTH / gImages['background'][name]:getWidth() * 2
    love.graphics.draw(gImages['background'][name], 0, 0, 0, bgScale, bgScale)
    
    local bgHillsScale = gGameHeight / gImages['background_hills'][name]:getHeight()
    local bgHillWidth = gImages['background_hills'][name]:getWidth() * bgHillsScale
    offsetX = (offsetX * BACKGROUND_SCROLL_SPEED) % bgHillWidth
    
    
    love.graphics.draw(
        gImages['background_diamonds'][name],
        offsetX, 0, -- x, y
        0, -- orientation
        bgHillsScale, bgHillsScale -- scaleing factor
    )
    love.graphics.draw(
        gImages['background_diamonds'][name],
        offsetX + bgHillWidth, 0, -- x, y
        0, -- orientation
        bgHillsScale, bgHillsScale -- scaleing factor
    )
    love.graphics.draw(
        gImages['background_diamonds'][name],
        offsetX - bgHillWidth, 0, -- x, y
        0, -- orientation
        bgHillsScale, bgHillsScale -- scaleing factor
    )
end

-- reset all color options so everything shows up properly
function ResetColor()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth( 3 )
end


-- Setup Window height
gWindowWidth, gWindowHeight = love.window.getDesktopDimensions()
gWindowWidth, gWindowHeight = gWindowWidth * WINDOW_SCALE, gWindowHeight * WINDOW_SCALE

-- graphics vars
local kenney = 'media/graphics/KenneyAbstractPlatformer/'
local dinoFam = 'media/graphics/DinoFamily/'
dinoNames = {'doux', 'mort', 'tard', 'vita', 'cole', 'kira', 'kuro', 'loki', 'mono', 'nico', 'olaf', 'sena'}
dinoAnimations = {'idle', 'move', 'hurt', 'dead', 'jump'}

-- global image variable
gImages = {
    ['tiles'] = love.graphics.newImage(kenney .. 'Tilesheet/tilesheet_complete.png'),
    ['enemies'] = love.graphics.newImage(kenney .. 'Tilesheet/tilesheet_enemies.png'),
    ['background'] = {
        ['main'] = love.graphics.newImage(kenney .. 'PNG/Backgrounds/set3_background.png'),
        ['red'] = love.graphics.newImage(kenney .. 'PNG/Backgrounds/set1_background.png'),
        ['green'] = love.graphics.newImage(kenney .. 'PNG/Backgrounds/set2_background.png'),
        ['dialogue'] = love.graphics.newImage(kenney .. 'PNG/Backgrounds/set4_background.png'),
    },
    ['background_hills'] = {
        ['main'] = love.graphics.newImage(kenney .. 'PNG/Backgrounds/set3_hills.png'),
        ['red'] = love.graphics.newImage(kenney .. 'PNG/Backgrounds/set1_hills.png'),
        ['green'] = love.graphics.newImage(kenney .. 'PNG/Backgrounds/set2_hills.png'),
    },
    ['background_diamonds'] = {
        ['main'] = love.graphics.newImage(kenney .. 'PNG/Backgrounds/set3_tiles.png'),
        ['red'] = love.graphics.newImage(kenney .. 'PNG/Backgrounds/set1_tiles.png'),
        ['green'] = love.graphics.newImage(kenney .. 'PNG/Backgrounds/set2_tiles.png'),
    },
    ['dinos'] = {},
}

-- global tile variable
gTiles = {
    ['tiles'] = GenerateTiles(gImages['tiles'], 64, 64),
    ['enemies'] = GenerateTiles(gImages['enemies'], 64, 64),
    ['dinos'] = {},
}
-- Add all the dinosaurs
for _, dinoName in pairs(dinoNames) do
    if gImages['dinos'][dinoName] == nil then
        gImages['dinos'][dinoName] = {['male'] = {}, ['female'] = {}}
        gTiles['dinos'][dinoName] = {['male'] = {}, ['female'] = {}}
    end
    for _, dinoAnim in pairs(dinoAnimations) do
        gImages['dinos'][dinoName]['male'][dinoAnim] = love.graphics.newImage(dinoFam .. 'male/' .. dinoName .. '/base/' .. dinoAnim .. '.png')
        gImages['dinos'][dinoName]['female'][dinoAnim] = love.graphics.newImage(dinoFam .. 'female/' .. dinoName .. '/base/' .. dinoAnim .. '.png')
        gTiles['dinos'][dinoName]['male'][dinoAnim] = GenerateTiles(gImages['dinos'][dinoName]['male'][dinoAnim], 24, 24)
        gTiles['dinos'][dinoName]['female'][dinoAnim] = GenerateTiles(gImages['dinos'][dinoName]['female'][dinoAnim], 24, 24)
    end
end

-- fonts - Octav Codrea
-- https://www.1001freefonts.com/dinomouse.font
gFonts = {
    ['small'] = love.graphics.newFont('media/fonts/Dinomouse-Regular.ttf', 40),
    ['medium'] = love.graphics.newFont('media/fonts/Dinomouse-Regular.ttf', 64),
    ['large'] = love.graphics.newFont('media/fonts/Dinomouse-Regular.ttf', 128),
    ['title'] = love.graphics.newFont('media/fonts/Dinomouse-Regular.ttf', 256),
    ['default'] = love.graphics.newFont(12)
}