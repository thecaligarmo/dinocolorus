--[[
    A tile that can be pickedup by running over it.
]]

Pickup = Class{__includes = Tile}

function Pickup:init(gridX, gridY, color, tileNum, ty, data)
    Tile.init(self, gridX, gridY, color, tileNum)
    self.pickupable = true
    self.collidable = true
    self.visible = false
    self.pickedUp = false
    self.type = ty 
    self.data = data
end

function Pickup:update(dt)
    Tile.update(self, dt)
end

function Pickup:onCollide()
end

function Pickup:setup(hideInBox)
    self.y = self.y + self.height
    
    self:show()
end

function Pickup:show()
    self.visible = true
end

function Pickup:pickup()
    if self.pickupable and not self.pickedUp then
        self.pickupable = false
        self.pickedUp = true
        return self
    end
    return nil
end

function Pickup:render(color)
    if self.visible then
        Tile.render(self, color)
    end
end