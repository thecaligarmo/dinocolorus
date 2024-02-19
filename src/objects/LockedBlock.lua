--[[
    A block that is collidable/untraversable until it gets unlocked  
]]

LockedBlock = Class{__includes = Block}

function LockedBlock:init(gridX, gridY, color, tileNum, lockColor)
    Block.init(self, gridX, gridY, color, tileNum)
    self.unlocked = false
    self.unlockable = true
    self.lockColor = lockColor
end

function LockedBlock:render(color)
    Block.render(self, color)
end

function LockedBlock:onCollide(obj)
end


function LockedBlock:unlock()
    self.unlocked = true
end