--[[
    This is based off the original 'StateMachine' file that was given in class,
    but has been heavily edited to meet the needs of this program. Ideas have
	been combined with the Scenery github in: https://github.com/paltze/scenery
]]
SceneManager = Class{}

function SceneManager:init(states, overlays)
	-- Set empty scene for starting
	self.currentScene = SceneManager:defaultScene()
	self.currentOverlays = {}

	-- Need one or else things fail
	table.insert(self.currentOverlays, SceneManager:defaultOverlay())

	self.paused = false

	-- [key] = {name = "overlayName"}
	self.overlays = overlays or {}

	-- [key] = {name = "stateName", default = false}
	self.states = states or {}
	for key, val in pairs(self.states) do
		if val.default then
			SceneManager:setScene(key)
		end
	end
end

function SceneManager:setScene(stateName, additionalParams)
	assert(self.states[stateName])
	self.currentScene:exit()
	self.currentScene = _G[self.states[stateName].name]()
	self.currentScene:enter(additionalParams)
end

function SceneManager:openOverlay(overlayName, additionalParams)
	assert(self.overlays[overlayName])
	overlay = _G[self.overlays[overlayName].name]()
	table.insert(self.currentOverlays, overlay)
	overlay:enter(additionalParams)
	self.paused = true
end

function SceneManager:closeOverlay()
	overlay = self.currentOverlays[#self.currentOverlays]
	table.remove(self.currentOverlays)
	overlay:exit()
	if #self.currentOverlays == 1 then
		self.paused = false
	end
end

function SceneManager:update(dt)	
	if self.paused then
		self.currentScene:pausedUpdate(dt)
	else
		self.currentScene:update(dt)
	end
	self.currentOverlays[#self.currentOverlays]:update(dt)
end

function SceneManager:render()
	self.currentScene:render()
	for i, overlay in ipairs(self.currentOverlays) do
		overlay:render()
	end
end

function SceneManager:togglePause()
	if self.paused  then 
		self:closeOverlay()
	else
		self:openOverlay('pause')
	end
end


function SceneManager:defaultScene()
	return {
		render = function() end,
		update = function() end,
		pausedUpdate = function() end,
		enter = function() end,
		exit = function() end
	}
end

function SceneManager:defaultOverlay()
	return {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
end