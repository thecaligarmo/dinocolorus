--[[
    A touchable block is a block such that, when up is pressed,
    the user "touches" it and something happens.
]]

InteractableTile = Class{__includes = Tile}

function InteractableTile:init(gridX, gridY, color, tileNum, callback)
    Tile.init(self, gridX, gridY, color, tileNum)
    self.callback = callback
    self.interactable = true
    self.interacted = false
end


function InteractableTile:onInteract()
    self.callback()
    self.interacted = true
end