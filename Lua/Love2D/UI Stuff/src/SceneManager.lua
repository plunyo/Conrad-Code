local SceneManager = {
    currentScene = require("scenes.mainMenu"),
}

function SceneManager.changeSceneTo(newScene)
    if SceneManager.currentScene and SceneManager.currentScene.exit then
        SceneManager.currentScene.exit()
    end

    SceneManager.currentScene = require("scenes." .. newScene)
    SceneManager.currentScene.load()
end

return SceneManager
