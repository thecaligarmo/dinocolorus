--[[
    An `Entity` is an object that is able to move around, have animations, get
    hurt, etc.
]]
Entity = Class{__includes = GameObject}

function Entity:init(x, y, color, defaults, textures, tiles, level)
    GameObject.init(self, x, y, defaults.width, defaults.height, color)

    -- Entities have speed
    self.dx = 0
    self.dy = 0
    
    self.direction = 'E' -- NESW (cardinal)
    self.walkSpeed = defaults.walkSpeed or WALK_SPEED
    self.gravity = defaults.gravity or GRAVITY
    self.jumpVelocity = defaults.jumpVelocity or JUMP_VELOCITY
    self.collidable = true
    self.collisions = {}
    self.walk_through = false

    -- Entity rendering related stuff
    self.isPlayer = false
    self.textures = textures
    self.tiles = tiles
    self.offsetx = defaults.offsetx or 0
    self.offsety = defaults.offsety or 0
    self.scale = defaults.scale or 1
    self.level = level or {}

    -- Health stuff
    self.attackable = true
    self.health = defaults.health
    self.lives = defaults.lives

    -- Animations are set in the children
    self.animations = {}
    self.animationState = {}

    self.hitboxData = defaults.hitbox
    self:setHitbox()

    self.filter = function(item, other)
        if not other.walkThrough then return 'slide' end
    end
end

-- Shorthand for getting current state (easier to remember)
function Entity:getState()
    return self.animationState.current
end

-- Updates hitbox based on current x, y coordinates
function Entity:setHitbox()
    self.hitbox = {
        x = self.x + self.hitboxData.x,
        y = self.y + self.hitboxData.y,
        width = self.hitboxData.width,
        height = self.hitboxData.height,
    }
end

function Entity:update(dt)
    GameObject.update(self, dt)

    -- Update the animation
    local state = self:getState()
    local anim = self.animations[state]
    anim['animation']:update(dt)


    -- Only do updates if we're alive
    if self.lives > 0 then 
        -- Depending on animation, do a secondary update that is animation specific
        if state == IDLE then
            self:updateIdle(dt)
        elseif state == MOVE then
            self:updateMove(dt)
        elseif state == JUMP or state == FALL then
            self:updateJump(dt)
        elseif state == DEAD then
        else
            print("Received the state " .. state .. " which doesn't exist")
        end


        -- Now try and actually move
        self:setHitbox()
        actX, actY, cols, len = self.level:myWorld(self):move(self, self.hitbox.x, self.hitbox.y, self.filter)
        self.x = self.x - (self.hitbox.x - actX)
        self.y = self.y - (self.hitbox.y - actY )

        self:setHitbox()
        self.collisions = cols
        self:handleCollisions()
        -- if self.isPlayer then
        --     print(self.dy)
        -- end
    end
    
end

-- Update when entity is idle
function Entity:updateIdle(dt)
end

-- Update when entity is moving
function Entity:updateMove(dt)
    if self.direction == 'E' then
        self.x = self.x + self.walkSpeed * dt
    elseif self.direction == 'W' then
        self.x = self.x - self.walkSpeed * dt
    end
end

-- Update when character is jumping/falling
function Entity:updateJump(dt)
    self.dy = self.dy + self.gravity * dt * 100
    self.y = self.y + (self.dy * dt)
    if self.dy >= 0 then
        self:fall()
    end
end

-- For rendering the entity
function Entity:render()
    if self.color ~= self.level.color then
        love.graphics.setColor(1, 1, 1, 0.4)
    end

    local state = self:getState()
    local anim = self.animations[state]
    
    -- Show the animation
    anim['animation']:draw(
        anim['image'],
        self.x, self.y,
        0, self.scale, self.scale,
        self.offsetx, self.offsety
    )

    if self.color ~= self.level.color then
        ResetColor()
    end

    if DEBUG then
        love.graphics.setColor(1, 0, 1, 1)
        love.graphics.rectangle('line', self.x,  self.y, self.width, self.height)

        love.graphics.setColor(0, 0, 1, 1)
        love.graphics.rectangle('line', self.hitbox.x,  self.hitbox.y, self.hitbox.width, self.hitbox.height)
        
        ResetColor()
    end

end

-- If an entity stops moving
function Entity:stop()
    self.animationState:stop()
end

-- If an entity jumps
function Entity:jump()
    self.dy = self.jumpVelocity
    self.animationState:jump(self)
end

-- If an entity falls
function Entity:fall()
    if self.dy < 0 then
        self.dy = 0
    end
    self.animationState:fall()
end

-- If an entity lands after a fall
function Entity:land()
    self.dy = 0
    self.animationState:land(self)
end

-- If an entity moves
function Entity:move()
    self.animationState:move()
end

-- If an entity resets
function Entity:reset()
    self.animationState:reset()
end


-- Whether entity is idle or not
function Entity:isIdle()
    return self:getState() == IDLE
end

-- Whether or not an entity is jumping (either jumping or falling)
function Entity:isJumping()
    return self:getState() == JUMP or self:getState() == FALL
end

-- Whether entity is dead or not
function Entity:isDead()
    return self:getState() == DEAD
end

-- Changes direction entity is facing
-- Should only be E(ast) or W(est) (Cardinal)
function Entity:changeDir(direction)
    if self.direction ~= direction then
        for _, anim in pairs(self.animations) do
            anim['animation']:flipH()
        end
        self.direction = direction
    end
end

-- handle collisions of entity
function Entity:handleCollisions()
    if #self.collisions > 0 then
        for _, obj in pairs(self.collisions) do
            if obj.other.collidable then
                obj.other:onCollide(self)
            end
        end
    end
end

-- What to do when entity collides
function Entity:onCollide(obj)
end

-- Take given amount of damage
function Entity:takeDamage(dmg)
    self.animationState:gethit()
    self.health = self.health - dmg
    if self.health <= 0 then
        self:die()
    end
end

-- On death
function Entity:die()
    self.lives = self.lives - 1
    self.animationState:die()
    if self.lives <=0 then
        -- destory object
        -- drop things if they are carrying anything
        self.level:myWorld(self):remove(self)
    else
        self.x = self.spawnLoc.x 
        self.y = self.spawnLoc.y
        self:setHitbox()
        self.level:myWorld(self):update(self, self.hitbox.x, self.hitbox.y)
    end
end

-- Check items that are above
-- Gives items, #items
function Entity:checkAbove()
    return self.level:myWorld(self):queryRect(
        self.hitbox.x, self.hitbox.y - 1,
        self.hitbox.width, 1
    )
end

-- Check items that are below
-- Gives items, #items
function Entity:checkBelow()
    return self.level:myWorld(self):queryRect(
        self.hitbox.x, self.hitbox.y + self.hitbox.height + 1,
        self.hitbox.width, 1
    )
end

-- Check items that are right
-- Gives items, #items
function Entity:checkRight()
    return self.level:myWorld(self):queryRect(
        self.hitbox.x + self.hitbox.width + 1, self.hitbox.y,
        1, self.hhitbox.eight
    )
end

-- Check items that are left
-- Gives items, #items
function Entity:checkLeft()
    return self.level:myWorld(self):queryRect(
        self.hitbox.x - 1, self.hitbox.y,
        1, self.hitbox.height
    )
end