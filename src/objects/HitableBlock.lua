--[[
    A hitable block is a block that can be hit from underneath and contains a pickup inside.
]]
HitableBlock = Class{__includes = Block}


-- Initialise the block with appropriate settings
function HitableBlock:init(gridX, gridY, color, tileNum, pickup)
    Block.init(self, gridX, gridY, color, tileNum)
    self.hitable = true
    self.pickup = pickup
    self.alreadyHit = false
end


-- What to do if the box gets hit for the first time
function HitableBlock:hit(obj)
    if not self.alreadyHit then
        gSounds['box']:play()
        self.alreadyHit = true
        self.pickup:setup(true)
        newY = self.pickup.y - self.pickup.height
        Timer.tween(1, self.pickup, {y = newY}, 'linear', function () self.pickup.pickupable = true; self.pickup.collidable = true end)
    end
end