--[[
    A box that shows a border on hover.

    Todo: Make it so that boxes automatically resize based on width/height of window (new class?)
    Todo: Add a mousepress callback
]]
HoverBox = Class{__includes = GameObject}

function HoverBox:init(x, y, width, height, selectCallback, hoverCallback)
    GameObject.init(self, x, y, width, height)
    self.selectCallback = selectCallback or function() end
    self.hoverCallback = hoverCallback or function() end
    self.inside = false
end

function HoverBox:update(dt)
    xx, yy = love.mouse.curCoords.x, love.mouse.curCoords.y
    if xx and yy and love.mouse.clicked and self:withinBox(xx, yy) then
        self.selectCallback()
    end
end

function HoverBox:render()
    if DEBUG then
        love.graphics.setColor(1, 0, 1, 1)
        love.graphics.rectangle('line', self.x,  self.y, self.width, self.height)
        ResetColor()
    end

    xx, yy = love.mouse.curCoords.x, love.mouse.curCoords.y
    if xx and yy and self:withinBox(xx, yy) then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('line', self.x,  self.y, self.width, self.height, 15, 15)
        love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
        ResetColor()
        if not self.inside then
            self.hoverCallback()
        end
        self.inside = true
    else
        love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
        self.inside = false
    end
end

function HoverBox:withinBox(x, y)
    return (x >= self.x and x <= self.x + self.width and
        y >= self.y and y <= self.y + self.height)
end