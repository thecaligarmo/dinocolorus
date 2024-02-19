--[[
    Character selection scene for choosing what type of character the user wants to play with.
]]
CharSelectScene = Class{__includes = AbstractScene}

function CharSelectScene:init()
    self.ht = gImages['dinos']['doux']['male']['idle']:getHeight()

    -- Either "male" or "female" styles
    self.styles = {
        [0] = {
            ['img'] = HoverTile(
                gImages['dinos']['doux']['male']['idle'],
                gTiles['dinos']['doux']['male']['idle'][1],
                gGameWidth / 2 - 400 - self.ht,  45,
                function() self.curStyle = 0; self.curOption = -1 end,
                15, 15,
                144, 144,
                function() self.curStyle = 0; self.curOption = -1 end
            )
        },
        [1] = {
            ['img'] = HoverTile(
                gImages['dinos']['doux']['female']['idle'],
                gTiles['dinos']['doux']['female']['idle'][1],
                gGameWidth / 2 + 400,  45,
                function() self.curStyle = 1; self.curOption = -1 end,
                15, 15,
                144, 144,
                function() self.curStyle = 1; self.curOption = -1 end
            )
        }
    }

    -- One option for each style for each dinoName
    self.options = {
        ['male'] = {},
        ['female'] = {}
    }
    for i, name in ipairs(dinoNames) do
        j = i - 1
        x = (j % 4) * 500
        y = math.floor(j / 4) * 300
        self.options['male'][i] = HoverTile(
            gImages['dinos'][name]['male']['idle'],
            gTiles['dinos'][name]['male']['idle'][1],
            120 + x, 200 + y,
            function()
                if self.curStyle == 0 then
                    gender = 'male'
                else
                    gender = 'female'
                end
                dinoName = dinoNames[self.curOption + 1]
                SceneManager:setScene('play', {
                    ['levelNum'] = self.levelNum,
                    ['gender'] = gender,
                    ['dinoName'] = dinoName
                })
            end,
            10, 10,
            240, 240,
            function() self:updateOption() end
        )
        self.options['female'][i] = HoverTile(
            gImages['dinos'][name]['female']['idle'],
            gTiles['dinos'][name]['female']['idle'][1],
            120 + x, 200 + y,
            function()
                if self.curStyle == 0 then
                    gender = 'male'
                else
                    gender = 'female'
                end
                dinoName = dinoNames[self.curOption + 1]
                SceneManager:setScene('play', {
                    ['levelNum'] = self.levelNum,
                    ['gender'] = gender,
                    ['dinoName'] = dinoName
                })
            end,
            10, 10,
            240, 240,
            function() self:updateOption() end
        )
    end

    -- 120
    self.curOption = -1
    self.curStyle = 0
end

function CharSelectScene:enter(params)
    self.levelNum = params.levelNum
end

-- Update option based on current mouse location
function CharSelectScene:updateOption()
    xx, yy = love.mouse.curCoords.x, love.mouse.curCoords.y
    xScale = gGameWidth / GAME_WIDTH
    yScale = gGameHeight / GAME_HEIGHT
    if xx >= 100 * xScale and xx <= 380 * xScale then
        x = 0
    elseif xx >= 600 * xScale and xx <= 880 * xScale then
        x = 1
    elseif xx >= 1100 * xScale and xx <= 1380 * xScale then
        x = 2
    elseif xx >= 1600 * xScale then
        x = 3
    end
    if yy >= 180 * yScale and yy <= 460 * yScale then
        y = 0
    elseif yy >= 480 * yScale and yy <= 760 * yScale then
        y = 1
    elseif yy >= 780 * yScale then
        y = 2
    end
    self.curOption = x + y * 4
end

-- Get name version of gender instead of 0/1
function CharSelectScene:getGender()
    if self.curStyle == 0 then
        return 'male'
    else
        return 'female'
    end
end

function CharSelectScene:update(dt)
    if pressedEscape() then
        SceneManager:setScene('mainmenu', {
            levelNum = self.levelNum
        })
    end


    -- Handle styles (gender)
    num = 0
    self.styles[0]['img'].x = gGameWidth / 2 - 400 - self.ht
    self.styles[1]['img'].x = gGameWidth / 2 + 400
    for name, opt in pairs(self.styles) do
        opt['img']:update(dt)
        num = num + 1
    end

    -- Handle options
    scale = math.min(gGameHeight / GAME_HEIGHT, gGameWidth / GAME_WIDTH)
    for i, name in ipairs(dinoNames) do
        self.options[self:getGender()][i].width = 240 * scale
        self.options[self:getGender()][i].height = 240 * scale
        self.options[self:getGender()][i]:update(dt)
    end
   
    -- Handle user input
    if pressedRight() then
        if self.curOption > -1 then
            self.curOption = (self.curOption + 1) % 12
        else
            self.curStyle = (self.curStyle + 1) % num
        end
    end
    if pressedLeft() then
        if self.curOption > -1 then
            self.curOption = (self.curOption - 1) % 12
        else
            self.curStyle = (self.curStyle - 1) % num
        end
    end
    if pressedEnter() then
        if self.curOption >= 0 then
            -- Submit
            if self.curStyle == 0 then
                gender = 'male'
            else
                gender = 'female'
            end
            self.options[gender][self.curOption + 1].selectCallback()
        end
    end
    if pressedDown() then
        if self.curOption == -1 then
            self.curOption = 0
        elseif self.curOption < 8 then
            self.curOption = self.curOption + 4
        end
    end
    if pressedUp() then
        if self.curOption < 4 then
            self.curOption = -1
        else
            self.curOption = self.curOption - 4
        end
    end
end


function CharSelectScene:render()
    DrawBackground('main')

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle('line', 30,  30, gGameWidth-60, gGameHeight-60, 15, 15)
    love.graphics.rectangle('line', 24,  24, gGameWidth-48, gGameHeight-48, 15, 15)
    ResetColor()

    for name, opt in pairs(self.styles) do
        opt['img']:render()
    end

    xScale = gGameWidth / GAME_WIDTH
    yScale = gGameHeight / GAME_HEIGHT
    if self.curOption == -1 then
        love.graphics.draw(
            gImages['tiles'], gTiles['tiles'][41],
            gGameWidth/2 + (-1)^(self.curStyle+1) * 412 - 80 * xScale, 80 * yScale,
            0, 1, 1
        )
    else
        j = self.curOption
        x = (j % 4) * 500 
        y = math.floor(j / 4) * 300 
        love.graphics.draw(
            gImages['tiles'], gTiles['tiles'][41],
            (55 + x) * xScale,
            (280 + y) * yScale,
            0, 1, 1
        )
    end

    for i, name in ipairs(dinoNames) do
        j = i - 1
        x = (j % 4) * 500 
        y = math.floor(j / 4) * 300 
        self.options[self:getGender()][i].x = (120 + x) * xScale
        self.options[self:getGender()][i].y = (200 + y) * yScale
        self.options[self:getGender()][i]:render()
    end
end