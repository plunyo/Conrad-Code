local Inputs = {}

function Inputs.system(key)
	if key == "escape" then
		love.event.quit()
	elseif key == "f11" then
		love.window.setFullscreen(not love.window.getFullscreen())
	end
end

return Inputs
