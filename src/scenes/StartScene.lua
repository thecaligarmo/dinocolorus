--[[
    Start scene for when the game loads
]]

StartScene = Class{__includes = AbstractScene}

function StartScene:enter(additionalParams)
    self.dinoInfo = {}
    self.numDinos = 20

    -- Setup some random dinos
    for i = 1,self.numDinos do
        self.dinoInfo[i] = {
            ['num'] = math.random(12),
            ['angle'] = math.random(-10, 10) / 10,
            ['loc'] = {
                ['x'] = math.random(10, gGameWidth - (10 + 24)), -- 10 padding + size of image
                ['y'] = math.random(10, gGameHeight - (10 + 24)),
            }
        }
    end

    -- Start text
    self.startHover = HoverText(
        "Start", 
        0,  gGameHeight - 200 - 128,
        function() SceneManager:setScene('mainmenu', {}) end,
        'large', 'center',
        10, 0
    )
end

function StartScene:update(dt)
    if pressedEscape() then
        SceneManager:openOverlay('quit')
    end
    endx, endy = love.mouse.endCoords.x, love.mouse.endCoords.y
    if pressedEnter() then
        SceneManager:setScene('mainmenu')
    end
    self.startHover.y = gGameHeight - 200 * (gGameHeight / GAME_HEIGHT) - gFonts[self.startHover.fontSize]:getHeight()
    self.startHover:update(dt)
end

function StartScene:render()
    DrawBackground('main')
    for i = 1,self.numDinos do 
        dinoNum = self.dinoInfo[i]['num']
        dinoAngle = self.dinoInfo[i]['angle']
        love.graphics.draw(
            gImages['dinos'][dinoNames[dinoNum]]['male']['idle'],
            gTiles['dinos'][dinoNames[dinoNum]]['male']['idle'][1],
            self.dinoInfo[i]['loc']['x'], self.dinoInfo[i]['loc']['y'],
            dinoAngle,
            3, 3
        )
    end

    if gGameWidth < 700 then
        size = 'medium'
        self.startHover.fontSize = 'small'
    elseif gGameWidth < 1400 then
        size = 'large'
        self.startHover.fontSize = 'medium'
    else
        size = 'title'
    end

    
    love.graphics.setFont(gFonts[size])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(
        "Dinocolorus",
        0,  gGameHeight / 2 - 200 * (gGameHeight/GAME_HEIGHT) - (gFonts[size]:getHeight() / 2),
        gGameWidth, 'center'
    )

    self.startHover:render()
end