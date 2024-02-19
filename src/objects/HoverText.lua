--[[
    A text that has a border on hover
]]
HoverText = Class{__includes = HoverBox}

function HoverText:init(text, x, y, selectCallback, fontSize, align, px, py, width, height, hoverCallback)
    self.text = text
    self.px = px or 0
    self.py = py or 0
    self.align = align or 'left'
    self.fontSize = fontSize or 'medium'

    self.updateHeight = false
    self.updateWidth = false

    if height == nil then
        self.updateHeight = true
        -- 0.8 because for some reason this font has space under it?
        height = gFonts[self.fontSize]:getHeight() * 0.8 + (self.py * 2)
    end
    if width == nil then
        self.updateWidth = true
        if x == 0 and align == 'center' then
            width = gFonts[self.fontSize]:getWidth(self.text) + (self.px * 2)
            x = math.floor(gGameWidth / 2 - width / 2)
        else
            width = gFonts[self.fontSize]:getWidth(self.text) + (self.px * 2)
        end
    end

    HoverBox.init(self, x, y, width, height, selectCallback, hoverCallback)
end

function HoverText:update(dt)
    self.width, self.height = self:updateDim()
    HoverBox.update(self, dt)
end

function HoverText:updateDim()
    height = self.height
    width = self.width
    if self.updateHeight then
        height = gFonts[self.fontSize]:getHeight() * 0.8 + (self.py * 2)
    end
    if self.updateWidth then
        if self.align == 'center' then
            width = gFonts[self.fontSize]:getWidth(self.text) + (self.px * 2)
            self.x = math.floor(gGameWidth / 2 - width / 2)
        else
            width = gFonts[self.fontSize]:getWidth(self.text) + (self.px * 2)
        end
    end
    return width, height
end

function HoverText:render()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts[self.fontSize])
    love.graphics.printf(
        self.text,
        self.x + self.px,  self.y + self.py,
        self.width - (self.px * 2),
        self.align
    )
    ResetColor()
    HoverBox.render(self)
end