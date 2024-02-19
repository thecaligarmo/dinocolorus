--[[
    The scene which ist he main menu. It shows all the possible levels a person can do.
]]
MainMenuScene = Class{__includes = AbstractScene}

function MainMenuScene:init()
    fontSize = MainMenuScene:fontSize()
    self.options = {
        [0] = {
            ['text'] = HoverText(
                "Tutorial", 
                110,  45,
                function() SceneManager:setScene('char', {
                    ['levelNum'] = self.curOption
                }) end,
                fontSize, 'left',
                15, 15,
                gGameWidth - 155, nil,
                function() self.curOption = 0 end
            )
        },
        [1] = {
            ['text'] = HoverText(
                "Start Game", 
                110,  45 + gFonts[fontSize]:getHeight() + 10,
                function() SceneManager:setScene('char', {
                    ['levelNum'] = self.curOption
                }) end,
                fontSize, 'left',
                15, 15,
                gGameWidth - 155, nil,
                function() self.curOption = 1 end
            )
        }
    }

    self.curOption = 0
end

function MainMenuScene:enter(params)
    self.curOption = (params and params.levelNum) or 0
end

function MainMenuScene:update(dt)
    if pressedEscape() then
        SceneManager:setScene('start')
    end

    fontSize = MainMenuScene:fontSize()
    num = 0
    for name, opt in pairs(self.options) do
        opt['text'].width = gGameWidth - 155
        opt['text'].fontSize = fontSize
        opt['text']:update(dt)
        num = num + 1
    end
   
    -- Handle inputs
    if pressedUp() then
        self.curOption = (self.curOption - 1) % num
    end
    if pressedDown() then
        self.curOption = (self.curOption + 1) % num
    end
    if pressedEnter() then
        self.options[self.curOption]['text'].selectCallback()
    end

end


function MainMenuScene:render()
    DrawBackground('main')

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle('line', 30,  30, gGameWidth-60, gGameHeight-60, 15, 15)
    love.graphics.rectangle('line', 24,  24, gGameWidth-48, gGameHeight-48, 15, 15)
    ResetColor()

    for name, opt in pairs(self.options) do
        opt['text']:render()
    end

    fontSize = MainMenuScene:fontSize()
    love.graphics.draw(
        gImages['tiles'], gTiles['tiles'][41],
        45, 45 + (gFonts[fontSize]:getHeight()/2 - 40) + self.curOption * (gFonts['large']:getHeight() + 10),
        0, 1, 1
    )
end

-- quick function to handle font sizes for the scene
function MainMenuScene:fontSize()
    if gGameWidth < 1000 then
        return 'medium'
    else 
        return 'large'
    end
end