--[[
    An `Enemy` is an entity that is controlled through AI... and wants to kill you.
]]

Enemy = Class{__includes = Entity}

function Enemy:init(x, y, color, defaults, textures, tiles, level)
    Entity.init(self, x, y, color, defaults, textures, tiles, level)
    self.spawnLoc = { x = self.x, y = self.y }

    self.animationState = StateMachine.create({
        initial = IDLE,
        events = {
            { name = 'gethit', from = {IDLE, MOVE, JUMP}, to = HURT },
            { name = 'move', from = IDLE, to = MOVE },
            { name = 'fall', from = {MOVE, IDLE, JUMP}, to = FALL },
            { name = 'land', from = FALL, to = IDLE },
            { name = 'stop', from = MOVE, to = IDLE },
            { name = 'die', from = {IDLE, MOVE, JUMP, FALL, HURT}, to = DEAD},
            { name = 'jump', from = {IDLE, MOVE}, to = JUMP }
        },
        callbacks = {
            onjump = function(self, event, from, to, entity) entity.dy = entity.jumpVelocity end
        }
    })
end

function Enemy:update(dt)
    Entity.update(self, dt)
end


-- Should never be idle
function Enemy:updateIdle(dt)
    Entity.updateIdle(self, dt)
    self:move()
end


function Enemy:updateMove(dt)
    Entity.updateMove(self, dt)

    -- Collided with object
    collided = false
    if #self.collisions > 0 then
        for _, col in pairs(self.collisions) do
            if col.other.collidable then
                collided = true
                self:onCollide(col.other)
            end
        end
    end

    -- Change directions if we hit an edge
    if self.direction == 'E' then
        items, len = self.level:myWorld(self):queryPoint(self.x + self.width + 1, self.y + self.height + 1)
    elseif self.direction == 'W' then
        items, len = self.level:myWorld(self):queryPoint(self.x - 1, self.y + self.height + 1)
    end

    if len == 0 or collided then
        if self.direction == 'E' then
            self:changeDir('W')
        elseif self.direction == 'W' then
            self:changeDir('E')
        end
        Entity.updateMove(self, dt)
    end
end

-- Override as enemies can't jump
function Enemy:jump()
end

function Enemy:die()
    gSounds['hit']:play()
    Entity.die(self)
end

function Enemy:onCollide(obj)
    Entity.onCollide(self, obj)
    if obj.isPlayer then
        -- make sure player isn't above
        cc, ll = self:checkAbove()
        playerAbove = false
        for _, col in pairs(cc) do
            if col.isPlayer then
                playerAbove = true
            end
        end
        if not playerAbove then
            obj:takeDamage(1)
        end
    end
end

