--[[
    A tile is an arbitrary game object coming from our tile map.
]]

Tile = Class{__includes = GameObject}


function Tile:init(gridX, gridY, color, tileNum)
    -- Id for easy retrieval with previous contents
    self.id = {x = gridX, y = gridY}
    x, y = LevelMaker:gridToCoords(gridX, gridY)

    -- Setup the game object itself with some additional things
    GameObject.init(self, x, y, TILE_WIDTH, TILE_HEIGHT, color)
    self.tileNum = tileNum
    self.tile = gTiles['tiles'][tileNum]
    self.img = gImages['tiles']

    -- Default stats
    self.walkThrough = true
    self.interactable = false
    self.collidable = false
    self.pickupable = false
end

function Tile:update(dt)
    GameObject.update(self, dt)
end

function Tile:render(color, inWorld)
    -- If the color of the level doesn't match, it should be opaque
    if self.color ~= color then
        love.graphics.setColor(1, 1, 1, 0.4)
    end
    love.graphics.draw(self.img, self.tile, self.x, self.y, 0, self.width / TILE_IMG_WIDTH, self.height / TILE_IMG_HEIGHT)
    if self.color ~= color then
        ResetColor()
    end
    if DEBUG_BLOCKS then
        love.graphics.setColor(1, 0, 1, 1)
        love.graphics.rectangle('line', self.x,  self.y, self.width, self.height)
        ResetColor()
    end
end
