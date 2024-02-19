--[[
    A `Player` is an entity that is controlled through the keyboard.
]]
Player = Class{__includes = Entity}

function Player:init(x, y, color, defaults, textures, tiles, gender, dinoName, level)
    -- setup texture/image which is based off gender and dinoName
    self.gender = gender
    self.dinoName = dinoName
    textures = textures[self.dinoName][self.gender]
    tiles = tiles[self.dinoName][self.gender]

    Entity.init(self, x, y, color, defaults, textures, tiles, level)
    self.spawnLoc = { x = self.x, y = self.y }

    -- setup properties for player specifically
    self.isPlayer = true
    self.keys = {['green'] = 0, ['red'] = 0}
    self.score = 0

    -- Needs to have all 6 animations
    -- anim8.newAnimation(frames, durations, onLoop)
    self.animations = {
        [IDLE] = {
            ['image'] = textures['idle'],
            ['animation'] = anim8.newAnimation(tiles['idle'], 0.5)
        },
        [MOVE] = {
            ['image'] = textures['move'],
            ['animation'] = anim8.newAnimation(tiles['move'], 0.2)
        },
        [JUMP] = {
            ['image'] = textures['jump'],
            ['animation'] = anim8.newAnimation(tiles['jump'], 0.5)
        },
        [FALL] = {
            ['image'] = textures['jump'],
            ['animation'] = anim8.newAnimation(tiles['jump'], 0.5)
        },
        [HURT] = {
            ['image'] = textures['hurt'],
            ['animation'] = anim8.newAnimation(tiles['hurt'], 0.5, 'pauseAtEnd')
        },
        [DEAD] = {
            ['image'] = textures['dead'],
            ['animation'] = anim8.newAnimation(tiles['dead'], 0.5, 'pauseAtEnd')
        },
    }

    self.animationState = StateMachine.create({
        initial = IDLE,
        events = {
            { name = 'gethit', from = {IDLE, MOVE, JUMP}, to = HURT },
            { name = 'move', from = IDLE, to = MOVE },
            { name = 'fall', from = {MOVE, IDLE, JUMP}, to = FALL },
            { name = 'land', from = FALL, to = IDLE },
            { name = 'stop', from = MOVE, to = IDLE },
            { name = 'die', from = {IDLE, MOVE, JUMP, FALL, HURT}, to = DEAD},
            { name = 'jump', from = {IDLE, MOVE}, to = JUMP },
            { name = 'bounce', from = FALL, to = JUMP },
            { name = 'reset', from = {IDLE, MOVE, JUMP, FALL, HURT, DEAD}, to = IDLE},
        }
    })

    self.filter = function(item, other)
        if not other.walkThrough then return 'slide' end
        if other.walkThrough and other.pickupable then return 'cross' end
    end

end

-- Toggle the color of the player
function Player:toggleColor()
    if self.color == 'red' then
        self.color = 'green'
    else
        self.color = 'red'
    end
end

function Player:update(dt)
    Entity.update(self, dt)

    if not self:isJumping() then 
        -- If there is nothing under us, then switch to fall
        cc, ll = self:checkBelow()

        if ll == 0 then
            self:fall()
        end
    end

    if self.y > self.level.height then
        self:die()
    end
end

function Player:updateIdle(dt)
    if pressingLeft() or pressingRight() then
        self:move()
    elseif pressedJump() then
        self:jump()
    end
    if pressedInteract() then
        self:interact()
    end
end

function Player:updateMove(dt)
    if not pressingLeft() and not pressingRight() then
        self:stop()
    else
        self:updateDir()
        Entity.updateMove(self, dt)
    end
    if not self:isJumping() and pressedJump() then
        self:jump()
    end    
end

function Player:updateDir()
    if pressingLeft() then
        self:changeDir('W')
    elseif pressingRight() then
        self:changeDir('E')
    end
end


function Player:updateJump(dt)
    if pressingLeft() or pressingRight() then
        self:updateDir()
        Entity.updateMove(self, dt)
    end
    Entity.updateJump(self, dt)
end

-- If an entity stops moving
function Player:bounce()
    if self:isJumping() then 
        self.dy = self.jumpVelocity
    end
    self.animationState:bounce(self)
end

function Player:land()
    gSounds['land']:play()
    Entity.land(self)
end

function Player:die()
    Entity.die(self)
    -- If we're in the green world, bring us back to red
    if self.color == 'green' then 
        self.color = 'red'
        self.level.world['red']:add(self, self.hitbox.x, self.hitbox.y, self.hitbox.width, self.hitbox.height)
        self.level.world['green']:remove(self)
    end

    -- Depending on number of lives, either restart level or game over
    if self.lives == 0 then
        gSounds['game-over']:play()
        SceneManager:openOverlay('text', {
            ['text'] = "Game Over",
            ['callback'] = function() SceneManager:setScene('start') end
        })
    else
        gSounds['die']:play()
        self.level.color = 'red'
        SceneManager:openOverlay('text', {
            ['text'] = "Died",
            ['callback'] = function() self:reset() end
        })
    end
end

-- When up is pressed interact with interactable objects in level
function Player:interact()
    cols = self.level:checkCollisions(self)
    if #cols > 0 then
        for _, obj in pairs(cols) do
            if obj.interactable then
                obj:onInteract()
            end
        end
    end
end

function Player:handleCollisions()
    Entity.handleCollisions(self)

    if #self.collisions > 0 then
        for _, obj in pairs(self.collisions) do
            if obj.other.pickupable then
                self:usePickup(obj.other:pickup())
            end
            if obj.other.unlockable then
                self:unlock(obj.other)
            end
        end


        if self:getState() == FALL then
            hitSomething = false
            for _, obj in pairs(self.collisions) do
                if obj.other.attackable then
                    obj.other:takeDamage(1)
                    hitSomething = true
                    self:bounce()
                end
            end
            if not hitSomething then 
                -- If there is something under us, then switch to land
                cc, ll = self:checkBelow()
                if ll > 0 then
                    self:land()
                end
            end
        end

        -- hit above
        cc, ll = self:checkAbove()
        if self:getState() == JUMP and ll > 0 then --and self:objectAbove() then
            for _, col in pairs(cc) do
                if col.hitable then
                    col:hit()
                end
            end
            
            self:fall()
        end
    end
end

function Player:onCollide(obj)
    Entity.onCollide(self)
end

-- Handle unlocking doors
function Player:unlock(door)
    if self.keys[door.lockColor] > 0 then
        self.keys[door.lockColor] = self.keys[door.lockColor] - 1
        door:unlock()
        gSounds['unlock']:play()
        self:unlockAbove(door)
        self:unlockBelow(door)
        self.level:removeObj(door)
    end
end

-- This doesn't check for a key
function Player:unlockAbove(door)
    cc, ll = self.level:myWorld(self):queryRect(
        door.x, door.y - 1,
        door.width, 1
    )
    for _, col in pairs(cc) do
        if col.unlockable and col.lockColor == door.lockColor then
            col:unlock()
            self:unlockAbove(col)
        end
    end
    self.level:removeObj(door)
end

-- This doesn't check for a key
function Player:unlockBelow(door)
    cc, ll = self.level:myWorld(self):queryRect(
        door.x, door.y + door.height + 1,
        door.width, 1
    )
    for _, col in pairs(cc) do
        if col.unlockable  and col.lockColor == door.lockColor then
            col:unlock()
            self:unlockBelow(col)
        end
    end
    self.level:removeObj(door)
end

-- Handles pickups as a pickup will affect only a player
function Player:usePickup(pickup)
    ty = pickup.type
    data = pickup.data
    if ty ~= "goal" then
        self.level:removeObj(pickup)
    end
    if ty == "key" then
        gSounds['coin']:play()
        self.keys[data.color] = self.keys[data.color] + data.value
    elseif ty == "health" then -- not implemented
        self.health = self.health + data.value
    elseif ty == "coin" then
        gSounds['coin']:play()
        self.score = self.score + data.value
    elseif ty == "goal" then
        gSounds['win']:play()
        if self.level.levelNum == 0 then
            SceneManager:setScene('play', {
                ['levelNum'] = self.level.levelNum + data.value,
                ['gender'] = self.gender,
                ['dinoName'] = self.dinoName,
                ['lives'] = self.lives,
                ['score'] = self.score,
            })
        else
            if self.score == 42 then
                text = "You Win!\n AND you got all 42 coins!\nCongrats!"
            else
                text = "You Win!\nBut looks like you're missing some coins?"
            end
            SceneManager:openOverlay('text', {
                ['text'] = text,
                ['callback'] = function() SceneManager:setScene('start') end
            })
        end
    end
end

-- Check items that are above
-- Gives items, #items
function Player:checkAbove()
    return self.level:myWorld(self):queryRect(
        self.hitbox.x, self.hitbox.y - 1,
        self.hitbox.width, 1,
        function(obj) if obj.isPlayer or not obj.collidable then return false else return true end end
    )
end

-- Check items that are below
-- Gives items, #items
function Player:checkBelow()
    return self.level:myWorld(self):queryRect(
        self.hitbox.x, self.hitbox.y + self.hitbox.height + 1,
        self.hitbox.width, 1,
        function(obj) if obj.isPlayer or not obj.collidable  then return false else return true end end
    )
end

-- Check items that are right
-- Gives items, #items
function Player:checkRight()
    return self.level:myWorld(self):queryRect(
        self.hitbox.x + self.hitbox.width + 1, self.hitbox.y,
        1, self.hhitbox.eight,
        function(obj) if obj.isPlayer or not obj.collidable  then return false else return true end end
    )
end

-- Check items that are left
-- Gives items, #items
function Player:checkLeft()
    return self.level:myWorld(self):queryRect(
        self.hitbox.x - 1, self.hitbox.y,
        1, self.hitbox.height,
        function(obj) if obj.isPlayer or not obj.collidable  then return false else return true end end
    )
end