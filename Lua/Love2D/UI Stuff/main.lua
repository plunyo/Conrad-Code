SceneManager = require("src.SceneManager")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
	SceneManager.changeSceneTo("mainMenu")
end

function love.update(dt)
	SceneManager.currentScene.update(dt)
end

function love.draw()
	SceneManager.currentScene.draw()
end
