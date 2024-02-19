--[[
    This is the main playing scene.

    This scene handles the main game play from level and everything.
]]
PlayScene = Class{__includes = AbstractScene}


function PlayScene:enter(additionalParams)
    -- Level generation
    self.levelNum = additionalParams['levelNum'] or 0
    self.level = LevelMaker(self.levelNum)

    -- Title for level
    self.showTitle = true 

    -- Player generation
    playerx, playery = self.level:playerStartCoords()
    gender = additionalParams['gender']
    dinoName = additionalParams['dinoName']
    self.player = Player(
        playerx, playery, -- x, y
        'red',
        gEntityDefaults['player'],
        gImages['dinos'], -- texture
        gTiles['dinos'], -- tiles
        gender, dinoName,
        self.level -- level
    )
    self.player.lives = additionalParams['lives'] or self.player.lives
    self.player.score = additionalParams['score'] or self.player.score

    -- Camera information
    self.cameraChangeX = self.player.x
    self.cameraChangeY = self.player.y
    self.cameraOffset = {x = CAMERA_OFFSET, y = -CAMERA_OFFSET}
    cx, cy = self:cameraCoords()
    self.camera = Camera(cx, cy)
    
    -- Red world is always the first world
    self.level.world['red']:add(self.player, self.player.hitbox.x, self.player.hitbox.y, self.player.hitbox.width, self.player.hitbox.height)
    
    -- There is always a dialogue box for Tutorial set
    if self.levelNum == 0 then
        SceneManager:openOverlay('dialogue', {
            ['text'] = "Welcome to Dinocolorus! This is just a small prototype game to test out some features. First we'll run you through a tutorial and then we'll see if you can beat the next level.\n\n Hope you enjoy!\n <3 Cali",
            ['speaker'] = "Welcome!",
            ['callback'] = function() SceneManager:openOverlay('dialogue', {
                ['text'] = "To move around, you can either use the WASD keys or your arrows.\n\nGoal 1: Walk up to that sign post and press up to interact with it.",
                ['speaker'] = "Tutorial",
                ['callback'] = function() Timer.after(1.5, function() self.showTitle = false end) end
            }) end
        })
    else
        Timer.after(1.5, function() self.showTitle = false end)
    end
    
    
end

function PlayScene:update(dt)
    if pressedPause() then
		SceneManager:togglePause()
	end

    -- if player doesn't match the level's color, move player over
    if self.player.color ~= self.level.color then
        self.level.world[self.player.color]:remove(self.player)
        self.level.world[self.level.color]:add(self.player, self.player.hitbox.x, self.player.hitbox.y, self.player.hitbox.width, self.player.hitbox.height)
        self.player:toggleColor()
    end
    Timer.update(dt)
    self.level:update(dt)
    self.player:update(dt)
    
    cx, cy = self:cameraCoords()
    self.camera:lockPosition(cx, cy, Camera.smooth.linear(CAMERA_SPEED))
end

function PlayScene:pausedUpdate(dt)
    if self.player:isDead() and self.player.lives > 0 then
        cx, cy = self:cameraCoords()
        self.camera:lockPosition(cx, cy)
    end
end

-- Get the coordinates for the camera
function PlayScene:cameraCoords()
    if self.player.direction == 'E' then 
        self.cameraOffset.x = CAMERA_OFFSET
    else
        self.cameraOffset.x = -CAMERA_OFFSET
    end

    cx, cy = self.player.x + self.cameraOffset.x, self.player.y + self.cameraOffset.y    

    -- Don't go past 0
    ww, wh = love.graphics.getDimensions()
    if cx < ww / 2 then 
        cx = math.ceil(ww/2)
    end

    -- Don't go past the width of the screen
    w = self.level.width + TILE_WIDTH
    if cx + (ww / 2) > w then
        cx = math.floor(w - (ww / 2))
    end

     -- Don't go past the height of the screen
     h = self.level.height + 1
     if cy + (wh / 2) > h then
         cy = math.floor(h - (wh / 2))
     end
    return cx, cy 
end


function PlayScene:render()
    self.cameraChangeX, y = self.camera:position()
    DrawBackground(self.level.color, self.cameraChangeX, y - self.cameraChangeY)
    self.camera:attach()
    self.level:render()
    self.player:render()
    self.camera:detach()
    self:UI()
end

-- The user interface
function PlayScene:UI()
    for i = 1,self.player.lives do
        love.graphics.draw(
            gImages['dinos'][self.player.dinoName][self.player.gender]['idle'],
            gTiles['dinos'][self.player.dinoName][self.player.gender]['idle'][1],
            (PLAYER_WIDTH) * (i-1) + 10, 10,
            0,
            2, 2
        )
    end

    for i = 1,self.player.keys['red'] do
        love.graphics.draw(
            gImages['tiles'],
            gTiles['tiles'][80],
            (30) * (i-1) + 10, 10 + PLAYER_HEIGHT,
            0,
            0.75, 0.75
        )
    end

    for i = 1,self.player.keys['green'] do
        love.graphics.draw(
            gImages['tiles'],
            gTiles['tiles'][102],
            (30) * (i-1 + self.player.keys['red']) + 10, 10 + PLAYER_HEIGHT,
            0,
            0.75, 0.75
        )
    end


    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0,0,0,1)
    love.graphics.printf(
        "Score: " .. self.player.score,
        0, 10,
        gGameWidth,
        'center'
    )

    if self.levelNum == 0 then
        levelText = "Tutorial"
    else
        levelText = "Level " .. self.levelNum
    end
    if gGameWidth < 1000 then
        fontSize = 'large'
    else
        fontSize = 'title'
    end
    if self.showTitle then
        love.graphics.setFont(gFonts[fontSize])
        love.graphics.printf(
        levelText,
        0, math.floor( (gGameHeight/2 - gFonts[fontSize]:getHeight())),
        gGameWidth,
        'center'
    )
    end

    ResetColor()
end
