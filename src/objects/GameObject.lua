--[[
    The base class for all game objects.
]]
GameObject = Class{}

function GameObject:init(x, y, width, height, color)
    self.x = x 
    self.y = y

    self.width = width
    self.height = height

    -- Color is inate in this world
    -- Either red, green or both (both is not implemented)
    self.color = color or 'both'

    self.attackable = false
    
end

function GameObject:update(dt)
end

function GameObject:collides(obj)
    return not (
        self.x > obj.x + obj.width or
        obj.x > self.x + self.width or
        self.y > obj.y + obj.height or
        obj.y > self.y + self.height
    )
end