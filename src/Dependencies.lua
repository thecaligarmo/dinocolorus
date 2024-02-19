--[[
    All of the depndencies for the game.
]]


--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end



Class = require 'lib/class' -- https://github.com/HDictus/hump
Camera = require 'lib/camera'
Timer = require 'lib/timer' 
require 'lib/slam' -- https://github.com/vrld/slam
StateMachine = require 'lib/statemachine' -- https://github.com/kyleconroy/lua-state-machine/
anim8 = require 'lib/anim8' -- https://github.com/kikito/anim8
bump = require 'lib/bump' -- https://github.com/kikito/bump.lua

require 'src/Constants' -- Constants
require 'src/Graphics' -- Graphics (includes fonts)
require 'src/Inputs' -- keyboard/mouse inputs
require 'src/LevelMaker'

-- Classes
require 'src/objects/GameObject'

require 'src/objects/HoverBox'
require 'src/objects/HoverText'
require 'src/objects/HoverTile'

require 'src/objects/Tile'
require 'src/objects/InteractableTile'
require 'src/objects/Pickup'
require 'src/objects/GoalPickup'
require 'src/objects/Block'
require 'src/objects/HitableBlock'
require 'src/objects/LockedBlock'

require 'src/objects/Entity'
require 'src/objects/Player'
require 'src/objects/Enemy'
require 'src/objects/EnemyRed'
require 'src/objects/EnemyGreen'

-- Scenes
require 'lib/scenemanager' -- SceneManager (Amalgamation of the one from class, and ideas from paltze/scenery)
require 'src/scenes/AbstractScene'
require 'src/scenes/StartScene'
require 'src/scenes/MainMenuScene'
require 'src/scenes/CharSelectScene'
require 'src/scenes/PlayScene'

require 'src/overlays/AbstractOverlay'
require 'src/overlays/PauseOverlay'
require 'src/overlays/DialogueOverlay'
require 'src/overlays/TextOverlay'
require 'src/overlays/QuitOverlay'

-- Levels
require 'src/levels/level0'
require 'src/levels/level1'