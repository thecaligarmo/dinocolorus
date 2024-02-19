--[[
    A set of global constants
]]

-- Debugging or not
DEBUG = false
DEBUG_BLOCKS = false

-- Scale of the full screen a window should have
WINDOW_SCALE = 0.7

-- Size we're trying to emulate for the game
GAME_WIDTH = 1920
GAME_HEIGHT = 1080
gGameWidth = GAME_WIDTH
gGameHeight = GAME_HEIGHT

-- Scroll speeds of game and background
BACKGROUND_SCROLL_SPEED = 1.5
CAMERA_SPEED = 600
CAMERA_OFFSET = 180

TILE_WIDTH = 48
TILE_HEIGHT = 48
TILE_IMG_WIDTH = 64
TILE_IMG_HEIGHT = 64
PLAYER_WIDTH = 60
PLAYER_HEIGHT = 60
ENEMY_WIDTH = 64
ENEMY_HEIGHT = 64

-- Movement related stuff
GRAVITY = 20
WALK_SPEED = 150
JUMP_VELOCITY = -800

-- Animation State Names (so we don't misspell)
IDLE = 'idle'
MOVE = 'move'
JUMP = 'jump'
HURT = 'hurt'
FALL = 'fall'
DEAD = 'dead'


-- Definitions of extra things
gEntityDefaults = {
    ['player'] = {
        ['walkSpeed'] = 240,
        ['width'] = PLAYER_WIDTH,
        ['height'] = PLAYER_HEIGHT,
        ['health'] = 1,
        ['lives'] = 3,
        ['offsetx'] = 2,
        ['offsety'] = 0,
        ['scale'] = 3,
        ['hitbox'] = {x = 6, y = 12, width = PLAYER_WIDTH - 12, height = PLAYER_HEIGHT - 12},
    },
    ['enemy'] = {
        ['width'] = ENEMY_WIDTH,
        ['height'] = ENEMY_HEIGHT,
        ['walkSpeed'] = WALK_SPEED,
        ['health'] = 1,
        ['lives'] = 1,
        ['hitbox'] = {x = 12, y = 12, width = ENEMY_WIDTH - 20, height = ENEMY_HEIGHT - 12},
    }
}

-- Audio
--[[
Background Music:
Daisy by Sakura Girl | https://soundcloud.com/sakuragirl_official
Music promoted by https://www.chosic.com/free-music/all/
Creative Commons CC BY 3.0
https://creativecommons.org/licenses/by/3.0/

All other music:
https://mixkit.co
]]

gSounds = {
    ['background'] = love.audio.newSource('media/audio/Sakura-Girl-Daisy.mp3', 'static'),
    ['game-over'] = love.audio.newSource('media/audio/game-over.wav', 'static'),
    ['die'] = love.audio.newSource('media/audio/die.wav', 'static'),
    ['hit'] = love.audio.newSource('media/audio/hit.wav', 'static'),
    ['box'] = love.audio.newSource('media/audio/box.wav', 'static'),
    ['coin'] = love.audio.newSource('media/audio/coin.wav', 'static'),
    ['win'] = love.audio.newSource('media/audio/win.wav', 'static'),
    ['land'] = love.audio.newSource('media/audio/land.wav', 'static'),
    ['portal'] = love.audio.newSource('media/audio/portal.wav', 'static'),
    ['unlock'] = love.audio.newSource('media/audio/unlock.wav', 'static'),
}

gOptions = {
    jumpIsSpace = true,
    sound = true
}