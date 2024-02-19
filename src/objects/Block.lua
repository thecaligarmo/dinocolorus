--[[
    A block is a collidable tile.
]]

Block = Class{__includes = Tile}


function Block:init(gridX, gridY, color, tileNum)
    Tile.init(self, gridX, gridY, color, tileNum)
    self.collidable = true
    self.walkThrough = false
end

function Block:update(dt)
    GameObject.update(self, dt)
end

function Block:onCollide(obj)
end
