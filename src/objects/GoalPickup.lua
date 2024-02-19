--[[
    A pickup that is really just the goal.
]]

GoalPickup = Class{__includes = Pickup}

function GoalPickup:init(gridX, gridY, color, tileNum)
    Pickup.init(self, gridX, gridY, color, tileNum, 'goal', {value = 1})

    -- Goals have animations
    self.animation = anim8.newAnimation(
        {gTiles['tiles'][tileNum], gTiles['tiles'][tileNum+1]},
        0.4
    )
end

function GoalPickup:update(dt)
    self.animation:update(dt)
    Pickup.update(self, dt)
end

-- Render is different for goals since it has an animation
function GoalPickup:render(color, inWorld)
    -- If the color of the level doesn't match, it should be opaque
    if self.color ~= color then
        love.graphics.setColor(1, 1, 1, 0.4)
    end
    self.animation:draw(
        self.img, 
        self.x, self.y,
        0,
        self.width / TILE_IMG_WIDTH, self.height / TILE_IMG_HEIGHT
    )
    if self.color ~= color then
        ResetColor()
    end
end