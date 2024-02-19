--[[
    A green `Enemy` for animations
]]

EnemyGreen = Class{__includes = Enemy}

function EnemyGreen:init(x, y, color, defaults, textures, tiles, level)
    Enemy.init(self, x, y, color, defaults, textures, tiles, level)

    self.animations = {
        [IDLE] = {
            ['image'] = textures,
            ['animation'] = anim8.newAnimation(
                {tiles[13], tiles[2], tiles[22]},
                0.5
            )
        },
        [MOVE] = {
            ['image'] = textures,
            ['animation'] = anim8.newAnimation(
                {tiles[13], tiles[2], tiles[22]},
                0.5
            )
        },
        [FALL] = {
            ['image'] = textures,
            ['animation'] = anim8.newAnimation(
                {tiles[10]},
                0.5
            )
        },
        [HURT] = {
            ['image'] = textures,
            ['animation'] = anim8.newAnimation(
                {tiles[30]},
                0.5,
                'pauseAtEnd'
            )
        },
        [DEAD] = {
            ['image'] = textures,
            ['animation'] = anim8.newAnimation(
                {tiles[5]},
                0.5,
                function()
                    for i, en in pairs(self.level.enemies[self.color]) do
                        if en == self then
                            self.level.enemies[self.color][i] = nil
                        end
                    end
                end
            )
        },
    }
end
