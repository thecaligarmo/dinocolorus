--[[
    Functions that are associated to mouse and keyboard inputs
]]

-- Keeps track of which keys are pressed
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        --xx, yy = push:toGame(x, y)
        love.mouse.startCoords.x = x
        love.mouse.startCoords.y = y
        love.mouse.dragging = true
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        --xx, yy  = push:toGame(x, y)
        love.mouse.endCoords.x = x
        love.mouse.endCoords.y = y
        love.mouse.dragging = false
        if love.mouse.startCoords.x == love.mouse.endCoords.x and love.mouse.startCoords.y == love.mouse.endCoords.y then
            love.mouse.clicked = true
        else
            love.mouse.dragged = true
        end
    end
end

function pressingLeft()
    return love.keyboard.isDown('left') or love.keyboard.isDown('a')
end

function pressingRight()
    return love.keyboard.isDown('right') or love.keyboard.isDown('d')
end

function pressedUp()
    return love.keyboard.wasPressed('w') or love.keyboard.wasPressed('up')
end

function pressedDown()
    return love.keyboard.wasPressed('s') or love.keyboard.wasPressed('down')
end

function pressedLeft()
    return love.keyboard.wasPressed('a') or love.keyboard.wasPressed('left')
end

function pressedRight()
    return love.keyboard.wasPressed('d') or love.keyboard.wasPressed('right')
end

function pressedSpace()
    return love.keyboard.wasPressed('space')
end

function pressedEscape()
    return love.keyboard.wasPressed('escape')
end

function pressedEnter()
    return love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('kpenter')
end

function resetKeysMouse(init)
    if init then 
        love.mouse.dragging = false
        love.mouse.startCoords = {
            x = 0,
            y = 0
        }
        love.mouse.endCoords = {
            x = 0,
            y = 0
        }
        love.mouse.curCoords = {
            x = 0,
            y = 0
        }
    end
    love.keyboard.keysPressed = {}
    love.mouse.clicked = false
    love.mouse.dragged = false
end

-- Will be useful later when options are enabled
function pressedPause()
    return pressedEscape()
end

function pressedJump()
    if gOptions.jumpIsSpace then 
        return pressedSpace()
    else
        return pressedUp()
    end
end

function pressedInteract()
    if gOptions.jumpIsSpace then 
        return pressedUp()
    else
        return pressedSpace()
    end
end