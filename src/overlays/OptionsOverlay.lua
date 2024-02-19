--[[
    In progress: Overlay for options/settings. Not implemented yet
]]
OptionsOverlay = Class{__includes = AbstractOverlay}

function OptionsOverlay:init()
    self.options = {
        [0] = {
            ['text'] = "Sound",
            ['optionname'] = 'sound',
            ['value'] = gOptions.sound,
            ['checkbox'] = HoverText(
                "Sound", 
                110,  45,
                function() SceneManager:setScene('char', {
                    ['levelNum'] = self.curOption
                }) end,
                'large', 'left',
                15, 15,
                gGameWidth - 155, nil,
                function() self.curOption = 0 end
            )
        },
        [1] = {
            ['text'] = "Jump",
            ['optionname'] = 'jumpIsSpace',
            ['value'] = gOptions.jumpIsSpace,
            ['options'] = {
                [0] = HoverText(
                    "Space", 
                    110,  45 + gFonts['large']:getHeight() + 10,
                    function() SceneManager:setScene('char', {
                        ['levelNum'] = self.curOption
                    }) end,
                    'large', 'left',
                    15, 15,
                    gGameWidth - 155, nil,
                    function() self.curOption = 1 end
                ),
                [1] = HoverText(
                    "W / Up", 
                    110,  45 + gFonts['large']:getHeight() + 10,
                    function() SceneManager:setScene('char', {
                        ['levelNum'] = self.curOption
                    }) end,
                    'large', 'left',
                    15, 15,
                    gGameWidth - 155, nil,
                    function() self.curOption = 1 end
                ),
            }
        },
        [2] = {
            ['text'] = "Interact",
            ['optionname'] = 'jumpIsSpace',
            ['value'] = gOptions.jumpIsSpace,
            ['options'] = {
                [0] = HoverText(
                    "W / Up", 
                    110,  45 + gFonts['large']:getHeight() + 10,
                    function() SceneManager:setScene('char', {
                        ['levelNum'] = self.curOption
                    }) end,
                    'large', 'left',
                    15, 15,
                    gGameWidth - 155, nil,
                    function() self.curOption = 1 end
                ),
                [1] = HoverText(
                    "Space", 
                    110,  45 + gFonts['large']:getHeight() + 10,
                    function() SceneManager:setScene('char', {
                        ['levelNum'] = self.curOption
                    }) end,
                    'large', 'left',
                    15, 15,
                    gGameWidth - 155, nil,
                    function() self.curOption = 1 end
                ),
            }
        }
    }

    self.curOption = 0
end

function OptionsOverlay:enter(params)
    self.curOption = (params and params.levelNum) or 0
end

function OptionsOverlay:update(dt)
    if pressedEscape() then
        SceneManager:setScene('start')
    end

    num = 0
    for name, opt in pairs(self.options) do
        opt['text']:update(dt)
        num = num + 1
    end
   
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


function OptionsOverlay:render()
    DrawBackground('main')

    -- print(self.curOption)

    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle('line', 30,  30, gGameWidth-60, gGameHeight-60, 15, 15)
    love.graphics.rectangle('line', 24,  24, gGameWidth-48, gGameHeight-48, 15, 15)
    ResetColor()

    for name, opt in pairs(self.options) do
        opt['text']:render()
    end

    love.graphics.draw(
        gImages['tiles'], gTiles['tiles'][41],
        45, 45 + (gFonts['large']:getHeight()/2 - 40) + self.curOption * (gFonts['large']:getHeight() + 10),
        0, 1, 1
    )
end