--[[
    Handles making the level based off data in src/levels folder
]]
-- Global variable for all the levels
gLevels = {}

LevelMaker = Class {}

function LevelMaker:init(levelNum)
    self.levelNum = levelNum

    -- world
    self.color = 'red'
    self.world = {}
    self.world['red'] = bump.newWorld()
    self.world['green'] = bump.newWorld()

    self.levelInfo = gLevels[self.levelNum]
    self.height = 0
    self.width, _ = LevelMaker:gridToCoords(self.levelInfo['width'], 0)

    self.blocks = {}
    self.enemies = {}
    self:instantiateLevel()
end

-- Changes the color of the world
function LevelMaker:toggleColor()
    self.color = self:otherColor()
end


-- gets the other color
function LevelMaker:otherColor()
    if self.color == 'red' then
        return 'green'
    else
        return 'red'
    end
end
-- Returns the current world
function LevelMaker:curWorld()
    return self.world[self.color]
end

-- Returns the world with respect to an object
function LevelMaker:myWorld(obj)
    return self.world[obj.color]
end

-- Instantiates all the blocks
function LevelMaker:instantiateLevel()
    -- one instantiation for each color
    for _, color in pairs({'red', 'green'}) do
        self.blocks[color] = {}
        self.enemies[color] = {}
        inputstr = self.levelInfo[color]
        row = 0
        for str in string.gmatch(inputstr, "(.-)\n") do
            row = row + 1
            col = 0
            self.blocks[color][row] = {}
            for num in string.gmatch(str, "([^,]+)") do
                col = col + 1
                self:addFromNum(tonumber(num), col, row, color)
            end
        end

        -- Handles adding a column of collidable blocks at start/end of level
        -- so player can't just walk off the level.
        -- row/col should now contain max dimensions
        col = self.levelInfo['width'] + 1
        for i = 1, row do
            block = Block(0, i, color, 1)
            self.blocks[color][i][0] = block
            self.world[color]:add(block, block.x, block.y, block.width, block.height)

            block = Block(col, i, color, 1)
            self.blocks[color][i][col] = block
            self.world[color]:add(block, block.x, block.y, block.width, block.height)
        end
    end
    _, self.height = LevelMaker:gridToCoords(0, row + 1)
end

-- The starting coordinates of the player
function LevelMaker:playerStartCoords()
    xcoord, ycoord = self:gridToCoords(self.levelInfo['playerStartCoords'])
    return xcoord, ycoord + TILE_HEIGHT - PLAYER_HEIGHT
end

-- Converts grid coordinates to regular coordinates
function LevelMaker:gridToCoords(x, y)
    if y == nil then
        y = x.y 
        x = x.x 
    end
    return (x - 1) * TILE_WIDTH, (y - 1) * TILE_HEIGHT
end

-- removes an object from the current world
function LevelMaker:removeObj(obj)
    if self:curWorld():exists(obj) then
        self:curWorld():remove(obj)
    end
    self.blocks[self.color][obj.id.y][obj.id.x] = nil
end

function LevelMaker:update(dt)
    -- The other color is always in front
    for y, row in pairs(self.blocks[self:otherColor()]) do
        for x, bx in pairs(row) do
            if bx then
                bx:update(dt)
                if (self.world[self:otherColor()]:exists(bx)) then 
                    self.world[self:otherColor()]:move(bx, bx.x, bx.y, function (item, other) return nil end)
                end
            end
        end
    end
    for y, row in pairs(self.blocks[self.color]) do
        for x, bx in pairs(row) do
            if bx then
                bx:update(dt)
                if (self.world[self.color]:exists(bx)) then
                    self.world[self.color]:move(bx, bx.x, bx.y, function (item, other) return nil end)
                end
            end
        end
    end
    for _, enemy in pairs(self.enemies[self:otherColor()]) do
        if enemy then
            enemy:update(dt)
        end
    end
    for _, enemy in pairs(self.enemies[self.color]) do
        if enemy then
            enemy:update(dt)
        end
    end
end

function LevelMaker:render()
    -- The other color is always in front
    for y, row in pairs(self.blocks[self:otherColor()]) do
        for x, bx in pairs(row) do
            if bx then
                bx:render(self.color)
            end
        end
    end
    for y, row in pairs(self.blocks[self.color]) do
        for x, bx in pairs(row) do
            if bx then
                bx:render(self.color)
            end
        end
    end
    for _, enemy in pairs(self.enemies[self:otherColor()]) do
        if enemy then
            enemy:render()
        end
    end
    for _, enemy in pairs(self.enemies[self.color]) do
        if enemy then
            enemy:render()
        end
    end
end

-- Check for collisions with an entity
function LevelMaker:checkCollisions(entity)
    collisions = {}
    -- For blocks (that don't move) it's faster to just check "around" the entity
    -- Todo: fix this to be faster
    for y, row in pairs(self.blocks[self.color]) do
        for x, bx in pairs(row) do
            if bx and entity:collides(bx) then
                table.insert(collisions, bx)
            end
        end
    end
    return collisions
end

--[[
    Converts the id numbers into the appropriate data.
    Remember that in the program:
        - Id = 0 implies nothing placed
        - Id is one less than csv (id = 5 => csv = 6)
        - Enemies start at 265
]]
function LevelMaker:addFromNum(num, col, row, color)
    if num == 0 then
        return nil


    -- Blocks are in the first part of the sheet
    elseif num < 9 or
        (num >= 23 and num <= 30) or 
        (num >= 45 and num <= 53) or 
        (num >= 67 and num <= 75) or 
        (num >= 89 and num <= 97) or 
        (num >= 111 and num <= 119) or 
        (num >= 133 and num <= 141) or 
        (num >= 155 and num <= 163) or 
        (num >= 177 and num <= 185) or 
        (num >= 199 and num <= 207) or 
        (num >= 221 and num <= 229) or 
        (num >= 243 and num <= 251) or
        -- Or they are part of the key chain
        (num >= 123 and num <=127) or
        (num >= 144 and num <=148)
        then
        block = Block(col, row, color, num)
        self.blocks[color][row][col] = block
        self.world[color]:add(block, block.x, block.y, block.width, block.height)


    -- Hitable boxes
    elseif (num >= 217 and num <= 220) or (num >= 195 and num <= 198) then
        if num == 217 or num == 195 then
            ty = 'coin'
            data = {value = 1}
            if num == 217 then
                pickupNum = 39
            else
                pickupNum = 38
            end
        elseif num == 218 or num == 196 then
            ty = 'puzzle'
            data = {value = 1}
            if num == 218 then
                pickupNum = 103
            else
                pickupNum = 81
            end
        elseif num == 219 or num == 197 then
            ty = 'lock'
            data = {value = 1}
            if num == 219 then
                pickupNum = 102
            else
                pickupNum = 80
            end
        elseif num == 220 or num == 198 then
            ty = 'key'
            if num == 220 then
                data = {value = 1, color = 'green'}
            else
                data = {value = 1, color = 'red'}
            end
            if num == 220 then
                pickupNum = 102
            else
                pickupNum = 80
            end
        end
        pickup = Pickup(col, row - 1, color, pickupNum, ty, data)
        --pickup.y = pickup.y + pickup.height
        pickup.pickupable = false
        pickup.collidable = false
        if pickup then
            self.blocks[color][row-1][col] = pickup
            self.world[color]:add(pickup, pickup.x, pickup.y, pickup.width, pickup.height)
        end
        block = HitableBlock(
            col, row,
            color, num,
            pickup
        )
        self.blocks[color][row][col] = block
        self.world[color]:add(block, block.x, block.y, block.width, block.height)
        

    -- Locked tiles
    elseif num == 128 then
        block = LockedBlock(
            col, row,
            color, num,
            'green'
        )
        self.blocks[color][row][col] = block
        self.world[color]:add(block, block.x, block.y, block.width, block.height)
    elseif num == 150 then
        block = LockedBlock(
            col, row,
            color, num,
            'red'
        )
        self.blocks[color][row][col] = block
        self.world[color]:add(block, block.x, block.y, block.width, block.height)


    -- Doorway
    elseif num == 175 or num == 176 then
        self.blocks[color][row][col] = InteractableTile(
            col, row,
            color, num,
            function () self:toggleColor(); gSounds['portal']:play() end
        )

    -- Goal flag
    elseif num == 191 or num == 189 then
        pickup = GoalPickup(col, row, color, num)
        self.blocks[color][row][col] = pickup
        self.world[color]:add(pickup, pickup.x, pickup.y, pickup.width, pickup.height)


    -- Signpost
    elseif num == 264 then
        if not self:getSignpost(col, row, color) then
            print("Missing signpost data for " .. col .. ", " .. row .. " in " .. color .. ". Not adding signpost")
        else
            self.blocks[color][row][col] = InteractableTile(
                col, row,
                color, num,
                function () SceneManager:openOverlay('dialogue', self:getSignpost(col, row, color)) end
            )
        end


    -- Assume everything else is just a tile
    elseif num <= 264 then
        self.blocks[color][row][col] = Tile(col, row, color, num)
    -- enemies
    elseif num > 264 then
        coordX, coordY = self:gridToCoords(col, row)
        coordY = coordY + TILE_HEIGHT - ENEMY_HEIGHT
        -- Red enemy
        if num == 268 then
            enemy = EnemyRed(
                coordX, coordY,
                color,
                gEntityDefaults['enemy'],
                gImages['enemies'],
                gTiles['enemies'],
                self
            )
        -- Green enemy
        elseif num == 266 then
            enemy = EnemyGreen(
                coordX, coordY,
                color,
                gEntityDefaults['enemy'],
                gImages['enemies'],
                gTiles['enemies'],
                self
            )
        end
        table.insert(self.enemies[color], enemy)
        self.world[color]:add(enemy, enemy.hitbox.x, enemy.hitbox.y, enemy.hitbox.width, enemy.hitbox.height)
    else
        print("Number " .. tostring(num) .. " not found. Not adding.")
        return nil
    end
end


-- Get data for signpost interactables
function LevelMaker:getSignpost(x, y, color)
    for _, sp in pairs(self.levelInfo['signposts']) do
        if sp['id'].x == x and sp['id'].y == y and sp['id'].color == color then
            return sp
        end
    end
    return nil
end