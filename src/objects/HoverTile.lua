--[[
    A tile which displays a border on hover
]]
HoverTile = Class{__includes = HoverBox}

function HoverTile:init(img, tile, x, y, selectCallback,  px, py, width, height, hoverCallback)
    self.img = img
    self.tile = tile
    self.px = px or 0
    self.py = py or 0
    
    if height == nil then
        -- 0.8 because for some reason this font has space under it?
        height = self.tile:getHeight() * 0.8 + (self.py * 2)
    end
    if width == nil then
        if x == 0 and align == 'center' then
            width = self.tile:getWidth(self.text) + (self.px * 2)
            x = math.floor(gGameWidth / 2 - width / 2)
        else
            width = self.tile:getWidth(self.text) + (self.px * 2)
        end
    end
    HoverBox.init(self, x, y, width, height, selectCallback, hoverCallback)
end

function HoverTile:update(dt)
    HoverBox.update(self, dt)
end

function HoverTile:render()
    wScale = self.width / self.img:getHeight()
    hScale = self.height / self.img:getHeight()
    love.graphics.draw(
        self.img, self.tile,
        self.x, self.y,
        0,
        wScale, hScale
    )
    HoverBox.render(self)
end