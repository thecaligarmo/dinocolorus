--[[
    A red `Enemy` for animations
]]

EnemyRed = Class{__includes = Enemy}

function EnemyRed:init(x, y, color, defaults, textures, tiles, level)
    Enemy.init(self, x, y, color, defaults, textures, tiles, level)

    self.animations = {
        [IDLE] = {
            ['image'] = textures,
            ['animation'] = anim8.newAnimation(
                {tiles[15], tiles[4], tiles[24]},
                0.5
            )
        },
        [MOVE] = {
            ['image'] = textures,
            ['animation'] = anim8.newAnimation(
                {tiles[15], tiles[4], tiles[24]},
                0.5
            )
        },
        [FALL] = {
            ['image'] = textures,
            ['animation'] = anim8.newAnimation(
                {tiles[12]},
                0.5
            )
        },
        [HURT] = {
            ['image'] = textures,
            ['animation'] = anim8.newAnimation(
                {tiles[32]},
                0.5,
                'pauseAtEnd'
            )
        },
        [DEAD] = {
            ['image'] = textures,
            ['animation'] = anim8.newAnimation(
                {tiles[7]},
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
